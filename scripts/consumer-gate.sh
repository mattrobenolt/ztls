#!/usr/bin/env bash
# Consumer compatibility gate (#119).
#
# Qualifies one immutable ztls candidate against the active consumers
# (handoff, z53). The candidate is a ztls git revision; the gate archives it,
# clones each consumer at an exact revision into an isolated checkout, replaces
# the consumer's ztls pin with the candidate package, and replays the commands
# that consumer already runs in its own CI.
#
# Ownership split: ztls owns candidate provenance, isolation, the pin override,
# and the run record. Consumer build/test internals stay in consumer-owned
# workflows or recipes -- this script only invokes them. The command provenance
# table lives in docs/research/CONSUMER_GATE.md.
#
# Exit codes: 0 = every requested consumer passed, 1 = a consumer failed,
# 2 = harness error (bad input, missing tool, candidate/pin override failure).
set -euo pipefail

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
readonly script_dir
script_repo=$(git -C "$script_dir" rev-parse --show-toplevel)
readonly script_repo

# Run-level state, assigned by main().
ztls_repo=""
ztls_rev=""
out_dir=""
cache_root=""
keep_work=0
require_fixed=0
selftest_only=0
consumers_arg=""
handoff_repo="${CONSUMER_GATE_HANDOFF_REPO:-}"
handoff_rev="${CONSUMER_GATE_HANDOFF_REV:-}"
z53_repo="${CONSUMER_GATE_Z53_REPO:-}"
z53_rev="${CONSUMER_GATE_Z53_REV:-}"

# Set by main() once the record directory exists, so die() can leave a trace.
out_dir_ready=0

# selftest counters (top level so the check helper can update them).
selftest_checks=0
selftest_failures=0

usage() {
    cat <<'USAGE'
usage: consumer-gate.sh [options]

  --ztls-repo <path>     ztls checkout to archive (default: this repo)
  --ztls-rev <rev>       candidate revision (default: HEAD; 40-hex SHA for a
                         production qualification)
  --consumer <name>      handoff or z53; repeatable
  --consumers "<names>"  space-separated consumer list (default: handoff z53)
  --handoff-repo <path|url>   consumer checkout or clone URL
  --handoff-rev <rev>         exact consumer revision (default: HEAD)
  --z53-repo <path|url>       consumer checkout or clone URL
  --z53-rev <rev>             exact consumer revision (default: HEAD)
  --out-dir <dir>        run record directory
                         (default: zig-out/consumer-gate/<utc>-<host>)
  --cache-dir <dir>      persistent gate cache root
                         (default: zig-out/consumer-gate/cache)
  --keep-work            keep the scratch work tree (clones, archive, local caches)
  --require-fixed-revisions  reject symbolic revisions; use for qualification runs
  --selftest             exercise the gate's parsing/provenance helpers offline
  -h, --help             this text

Consumer repos come from the flags or CONSUMER_GATE_HANDOFF_REPO /
CONSUMER_GATE_Z53_REPO. The gate never writes to a consumer's original
checkout: it clones into a private work tree and edits only the clone.
USAGE
}

die() {
    printf 'consumer-gate: %s\n' "$*" >&2
    if [ "$out_dir_ready" -eq 1 ]; then
        printf '%s\n' "$*" > "$out_dir/ERROR.txt"
    fi
    exit 2
}

# ---------------------------------------------------------------------------
# Consumer-owned delegation table. Commands are the consumer's own recipes or
# CI commands verbatim; see docs/research/CONSUMER_GATE.md for the source of
# each line. Nothing here rebuilds a consumer's internals.
# ---------------------------------------------------------------------------

consumer_names() {
    printf '%s\n' handoff z53
}

consumer_devshell() {
    case "$1" in
    handoff | z53) printf 'default\n' ;;
    *) die "unknown consumer: $1" ;;
    esac
}

consumer_commands() {
    case "$1" in
    handoff)
        # Justfile `test` recipe (live gates); then the four build modes from
        # .github/workflows/handoff.yaml job `build`, verbatim.
        printf '%s\n' "just test"
        printf '%s\n' "zig build && zig build -Doptimize=ReleaseFast && zig build -Dmode=plaintext && zig build -Doptimize=ReleaseFast -Dmode=plaintext"
        ;;
    z53)
        # Justfile `test` recipe: test-portable plus the native runtime suite,
        # which carries the TLS client paths (z53 .github/workflows/ci.yml).
        printf '%s\n' "just test"
        ;;
    *) die "unknown consumer: $1" ;;
    esac
}

consumer_repo() {
    case "$1" in
    handoff) printf '%s\n' "$handoff_repo" ;;
    z53) printf '%s\n' "$z53_repo" ;;
    *) die "unknown consumer: $1" ;;
    esac
}

consumer_requested_rev() {
    case "$1" in
    handoff) printf '%s\n' "$handoff_rev" ;;
    z53) printf '%s\n' "$z53_rev" ;;
    *) die "unknown consumer: $1" ;;
    esac
}

# ---------------------------------------------------------------------------
# Small pure helpers (covered by --selftest).
# ---------------------------------------------------------------------------

json_escape() {
    printf '%s' "$1" | jq -Rrs '@json | .[1:-1]'
}

# Strip credentials from a clone URL before it reaches a log or the record.
redact_url() {
    printf '%s' "$1" | sed -E 's#(://)[^/@]*@#\1***@#'
}

is_full_sha() {
    [[ $1 =~ ^[0-9a-f]{40}$ ]]
}

count_pin_blocks() {
    grep -cE "^[[:space:]]*\\.$2 = \\.\\{" "$1" || true
}

# Print "url<TAB>hash" for one dependency block in a build.zig.zon, or fail
# when the block or a field is absent. Deliberately strict: a silent empty
# result would let the gate run the consumer's default pin, which is the exact
# substitution this gate exists to prevent.
extract_pin() {
    awk -v dep="$2" '
        $0 ~ "^[[:space:]]*\\." dep " = \\.\\{" { in_block = 1; next }
        in_block && /^[[:space:]]*}/ { in_block = 0 }
        in_block && /\.url = / { url = $0; sub(/.*\.url = /, "", url); gsub(/[",]/, "", url) }
        in_block && /\.hash = / { hash = $0; sub(/.*\.hash = /, "", hash); gsub(/[",]/, "", hash) }
        END {
            if (url != "" && hash != "") printf "%s\t%s\n", url, hash
            else exit 1
        }
    ' "$1"
}

sha256_file() {
    if command -v sha256sum >/dev/null 2>&1; then
        sha256sum "$1" | cut -d' ' -f1
    else
        shasum -a 256 "$1" | cut -d' ' -f1
    fi
}

# ---------------------------------------------------------------------------
# selftest: the parsing and provenance helpers, offline and fast.
# ---------------------------------------------------------------------------

check() {
    selftest_checks=$((selftest_checks + 1))
    if [ "$2" = "$3" ]; then
        return 0
    fi
    selftest_failures=$((selftest_failures + 1))
    printf 'selftest FAIL: %s: expected [%s] got [%s]\n' "$1" "$2" "$3" >&2
}

check_guard() {
    local expected=$1 output status=0
    shift
    output=$(bash "$script_dir/consumer-gate.sh" "$@" 2>&1) || status=$?
    check "$expected exit" "2" "$status"
    case "$output" in
    *"$expected"*) check "$expected diagnostic" "yes" "yes" ;;
    *) check "$expected diagnostic" "$expected" "$output" ;;
    esac
}

run_selftest() {
    local tmp
    tmp=$(mktemp -d "${TMPDIR:-/tmp}/consumer-gate-selftest.XXXXXX")

    cat > "$tmp/zon" <<'ZON'
.{
    .name = .probe,
    .version = "0.0.0",
    .dependencies = .{
        .ztls = .{
            .url = "git+https://github.com/mattrobenolt/ztls?ref=main#960ab943f41aad4c0ffaaf32cf26ef35cca137b1",
            .hash = "ztls-0.0.0-SHHDXoSkIABMcZtLWfUFFHipeZyv0ycyfEZBL31sQ9Sd",
        },
        .ztest = .{
            .url = "https://example.invalid/ztest.tar.gz",
            .hash = "ztest-0.2.0-AAAA",
            .lazy = true,
        },
    },
    .paths = .{ "src" },
}
ZON

    check "pin url" \
        "git+https://github.com/mattrobenolt/ztls?ref=main#960ab943f41aad4c0ffaaf32cf26ef35cca137b1" \
        "$(extract_pin "$tmp/zon" ztls | cut -f1)"
    check "pin hash" \
        "ztls-0.0.0-SHHDXoSkIABMcZtLWfUFFHipeZyv0ycyfEZBL31sQ9Sd" \
        "$(extract_pin "$tmp/zon" ztls | cut -f2)"
    check "pin block count" "1" "$(count_pin_blocks "$tmp/zon" ztls)"
    check "absent pin block" "0" "$(count_pin_blocks "$tmp/zon" kafka)"
    check "json escape" 'a\"b\\c' "$(json_escape 'a"b\c')"
    check "json controls" 'a\tb\nc\r' "$(json_escape $'a\tb\nc\r')"
    check "redact url" "https://***@github.com/org/repo" \
        "$(redact_url 'https://x-access-token:sekret@github.com/org/repo')"
    check "handoff devshell" "default" "$(consumer_devshell handoff)"
    check "z53 devshell" "default" "$(consumer_devshell z53)"
    check "handoff command count" "2" "$(consumer_commands handoff | grep -c .)"
    check "z53 command count" "1" "$(consumer_commands z53 | grep -c .)"
    check "z53 first command" "just test" "$(consumer_commands z53 | head -1)"
    check "full sha accepts" "yes" \
        "$(is_full_sha 960ab943f41aad4c0ffaaf32cf26ef35cca137b1 && printf yes || printf no)"
    check "full sha rejects" "no" "$(is_full_sha HEAD && printf yes || printf no)"

    printf 'src/x.zig:1:2: error: boom\n' > "$tmp/fail.log"
    printf 'Build Summary: 7/7 steps succeeded; 63/63 tests passed\n' > "$tmp/ok.log"
    check "evidence error line" "src/x.zig:1:2: error: boom" "$(extract_evidence "$tmp/fail.log")"
    check "evidence summary line" "Build Summary: 7/7 steps succeeded; 63/63 tests passed" \
        "$(extract_evidence "$tmp/ok.log")"

    check_guard "fixed ztls SHA" --ztls-rev HEAD --require-fixed-revisions
    check_guard "duplicate consumer" --consumers "handoff handoff" \
        --handoff-repo "$script_repo" --cache-dir "$tmp/cache" --out-dir "$tmp/duplicate"
    mkdir "$tmp/existing"
    printf 'preserve this record\n' > "$tmp/existing/run.json"
    check_guard "output directory already exists" --consumer handoff \
        --handoff-repo "$script_repo" --cache-dir "$tmp/cache" --out-dir "$tmp/existing"
    check "existing record remains unchanged" "preserve this record" "$(cat "$tmp/existing/run.json")"

    rm -rf "$tmp"
    if [ "$selftest_failures" -ne 0 ]; then
        die "selftest: $selftest_failures of $selftest_checks checks failed"
    fi
    printf 'consumer-gate selftest: %s checks passed\n' "$selftest_checks"
}

# ---------------------------------------------------------------------------
# Argument parsing and preconditions.
# ---------------------------------------------------------------------------

opt_value() {
    [ "$#" -ge 2 ] || die "$1 needs a value"
    printf '%s' "$2"
}

parse_args() {
    while [ "$#" -gt 0 ]; do
        case "$1" in
        --ztls-repo) ztls_repo=$(opt_value "$@"); shift 2 ;;
        --ztls-rev) ztls_rev=$(opt_value "$@"); shift 2 ;;
        --consumer) consumers_arg="${consumers_arg:+$consumers_arg }$(opt_value "$@")"; shift 2 ;;
        --consumers) consumers_arg=$(opt_value "$@"); shift 2 ;;
        --handoff-repo) handoff_repo=$(opt_value "$@"); shift 2 ;;
        --handoff-rev) handoff_rev=$(opt_value "$@"); shift 2 ;;
        --z53-repo) z53_repo=$(opt_value "$@"); shift 2 ;;
        --z53-rev) z53_rev=$(opt_value "$@"); shift 2 ;;
        --out-dir) out_dir=$(opt_value "$@"); shift 2 ;;
        --cache-dir) cache_root=$(opt_value "$@"); shift 2 ;;
        --keep-work) keep_work=1; shift ;;
        --require-fixed-revisions) require_fixed=1; shift ;;
        --selftest) selftest_only=1; shift ;;
        -h | --help) usage; exit 0 ;;
        *) die "unknown argument: $1 (see --help)" ;;
        esac
    done
    : "${consumers_arg:=handoff z53}"
    : "${ztls_rev:=HEAD}"
    : "${handoff_rev:=HEAD}"
    : "${z53_rev:=HEAD}"
}

require_tools() {
    local tool
    for tool in git nix hostname jq; do
        command -v "$tool" >/dev/null 2>&1 || die "required tool missing: $tool"
    done
    if ! command -v sha256sum >/dev/null 2>&1 && ! command -v shasum >/dev/null 2>&1; then
        die "required tool missing: sha256sum or shasum"
    fi
}

# Validate the requested consumers and fill the global `selected` array.
select_consumers() {
    read -ra selected <<< "$consumers_arg" || true
    [ "${#selected[@]}" -gt 0 ] || die "no consumers requested"
    local consumer known candidate env_name seen=" "
    for consumer in "${selected[@]}"; do
        case "$seen" in
        *" $consumer "*) die "duplicate consumer: $consumer" ;;
        esac
        seen="$seen$consumer "
        known=0
        while IFS= read -r candidate; do
            if [ "$candidate" = "$consumer" ]; then known=1; fi
        done < <(consumer_names)
        [ "$known" -eq 1 ] || die "unknown consumer: $consumer"
        if [ -z "$(consumer_repo "$consumer")" ]; then
            env_name="CONSUMER_GATE_$(printf '%s' "$consumer" | tr '[:lower:]' '[:upper:]')_REPO"
            die "$consumer repository is unset; pass --$consumer-repo or $env_name"
        fi
        if [ "$require_fixed" -eq 1 ] && ! is_full_sha "$(consumer_requested_rev "$consumer")"; then
            die "qualification requires a fixed $consumer SHA, got $(consumer_requested_rev "$consumer")"
        fi
    done
}

# ---------------------------------------------------------------------------
# Isolation and the candidate package.
# ---------------------------------------------------------------------------

# Print "status seconds" for one logged command. Runs "$@" with output
# captured to $logfile.
run_logged() { # logfile argv...
    local logfile=$1
    shift
    local start=$SECONDS
    local status=0
    set +e
    "$@" >"$logfile" 2>&1
    status=$?
    set -e
    printf '%d %d\n' "$status" "$((SECONDS - start))"
}

# Run argv in a directory. Every consumer command runs through this so no
# consumer recipe, shell hook, or zig command can resolve against the ztls
# worktree that invoked the gate.
run_here() { # dir argv...
    local dir=$1
    shift
    (cd "$dir" && "$@")
}

# Run a setup command, dying with $2 on failure.
run_setup() { # logfile message argv...
    local logfile=$1 message=$2
    shift 2
    local fields status
    fields=$(run_logged "$logfile" "$@")
    status=${fields%% *}
    if [ "$status" -ne 0 ]; then
        die "$message (exit $status; see $logfile)"
    fi
}

clone_consumer() { # consumer: prints the isolated checkout path
    local consumer=$1 source
    source=$(consumer_repo "$consumer")
    local clone="$work/$consumer"
    if ! git clone --no-hardlinks --quiet "$source" "$clone" >/dev/null 2>&1; then
        die "$consumer: git clone failed: $(redact_url "$source")"
    fi
    printf '%s\n' "$clone"
}

# Replace the clone's ztls pin with the candidate package and verify the
# result. zig fetch owns the zon rewrite; the assertions below make a silent
# fallback to the consumer's committed pin impossible (URL and hash must both
# be the candidate's).
override_pin() { # consumer clone archive_url logfile: prints the package hash
    local consumer=$1 clone=$2 archive_url=$3 logfile=$4
    run_setup "$logfile" \
        "$consumer: zig fetch of the candidate package failed; refusing to run the consumer's default pin" \
        run_here "$clone" nix develop ".#$(consumer_devshell "$consumer")" \
        --command zig fetch --save=ztls "$archive_url"
    local blocks
    blocks=$(count_pin_blocks "$clone/build.zig.zon" ztls)
    [ "$blocks" = "1" ] ||
        die "$consumer: expected exactly one .ztls dependency block after the override, found $blocks"
    local pin
    if ! pin=$(extract_pin "$clone/build.zig.zon" ztls); then
        die "$consumer: ztls pin missing from the clone's build.zig.zon after the override"
    fi
    local url=${pin%%$'\t'*} hash=${pin##*$'\t'}
    [ "$url" = "$archive_url" ] ||
        die "$consumer: clone pin URL is not the candidate archive after the override ($url)"
    case "$hash" in
    ztls-*) ;;
    *) die "$consumer: clone pin hash is not a ztls package hash after the override: $hash" ;;
    esac
    printf '%s\n' "$hash"
}

# Result-bearing lines from a consumer log. Logs are the primary evidence; this
# extract is what the record carries so a reader does not have to open every
# log to see whether the consumer compiled or failed.
extract_evidence() { # logfile
    local logfile=$1 lines
    lines=$(grep -E '^[^ ]+\.zig:[0-9]+:[0-9]+: error:|^error: ' "$logfile" | head -2)
    if [ -z "$lines" ]; then
        lines=$(grep -E 'Build Summary:|ztest: [0-9]+ passed|[0-9]+/[0-9]+ tests passed' "$logfile" | tail -2)
    fi
    if [ -z "$lines" ]; then
        lines=$(tail -2 "$logfile")
    fi
    printf '%s' "$lines" | tr -d '\r' | tr '\n' '|' | sed 's/|$//'
}

write_probe() { # path
    cat > "$1" <<'PROBE'
set -eu
printf 'zig=%s\n' "$(zig version)"
printf 'libcrypto_version=%s\n' "$(pkg-config --modversion libcrypto 2>/dev/null || printf unknown)"
printf 'libcrypto_libdir=%s\n' "$(pkg-config --variable=libdir libcrypto 2>/dev/null || printf unknown)"
printf 'os=%s\n' "$(uname -s)"
printf 'arch=%s\n' "$(uname -m)"
printf 'kernel=%s\n' "$(uname -r)"
PROBE
}

# ---------------------------------------------------------------------------
# Running one consumer.
# ---------------------------------------------------------------------------

run_consumer() { # consumer
    local consumer=$1 clone source source_kind source_dirty requested rev checked_out
    local pin pin_url pin_hash candidate_hash changed_hash commands_json=""
    local consumer_status=green status_word=green
    local failure_reason="" failure_log="" evidence="" last_log="" index command fields status seconds

    source=$(consumer_repo "$consumer")
    if [ -d "$source" ]; then
        source_kind=path
        source_dirty=no
        if [ -n "$(git -C "$source" status --porcelain 2>/dev/null)" ]; then
            source_dirty=yes
        fi
    else
        source_kind=url
        source_dirty=unknown
    fi
    requested=$(consumer_requested_rev "$consumer")
    clone=$(clone_consumer "$consumer")
    if ! rev=$(git -C "$clone" rev-parse --verify --quiet "$requested^{commit}"); then
        die "$consumer: revision not found: $requested"
    fi
    git -C "$clone" checkout --quiet --detach "$rev"
    checked_out=$(git -C "$clone" rev-parse HEAD)
    [ "$checked_out" = "$rev" ] || die "$consumer: clone HEAD $checked_out is not the requested $rev"

    local cwork="$out_dir/consumers/$consumer"
    mkdir -p "$cwork"
    local logs="$out_dir/logs"

    # Isolate Zig state from the operator's caches. The global cache is the
    # gate's own content-addressed package/download store; the local cache is
    # fresh per run so the consumer really recompiles against the candidate
    # instead of replaying cached artifacts.
    export ZIG_GLOBAL_CACHE_DIR="$cache_root/$consumer-global"
    export ZIG_LOCAL_CACHE_DIR="$work/local-cache-$consumer"
    mkdir -p "$ZIG_GLOBAL_CACHE_DIR" "$ZIG_LOCAL_CACHE_DIR"

    if ! pin=$(extract_pin "$clone/build.zig.zon" ztls); then
        die "$consumer: the committed build.zig.zon has no ztls dependency to gate"
    fi
    pin_url=${pin%%$'\t'*}
    pin_hash=${pin##*$'\t'}

    candidate_hash=$(override_pin "$consumer" "$clone" "$archive_url" "$logs/$consumer-00-override.log")

    write_probe "$work/probe.sh"
    run_setup "$logs/$consumer-01-toolchain.log" \
        "$consumer: toolchain probe failed" \
        run_here "$clone" nix develop ".#$(consumer_devshell "$consumer")" --command bash "$work/probe.sh"
    local probe_zig probe_libcrypto probe_libcrypto_dir probe_os probe_arch probe_kernel
    probe_zig=$(sed -n 's/^zig=//p' "$logs/$consumer-01-toolchain.log" | tail -1)
    probe_libcrypto=$(sed -n 's/^libcrypto_version=//p' "$logs/$consumer-01-toolchain.log" | tail -1)
    probe_libcrypto_dir=$(sed -n 's/^libcrypto_libdir=//p' "$logs/$consumer-01-toolchain.log" | tail -1)
    probe_os=$(sed -n 's/^os=//p' "$logs/$consumer-01-toolchain.log" | tail -1)
    probe_arch=$(sed -n 's/^arch=//p' "$logs/$consumer-01-toolchain.log" | tail -1)
    probe_kernel=$(sed -n 's/^kernel=//p' "$logs/$consumer-01-toolchain.log" | tail -1)

    index=2
    while IFS= read -r command; do
        last_log=$(printf '%s/%s-%02d-cmd.log' "$logs" "$consumer" "$index")
        fields=$(run_logged "$last_log" \
            run_here "$clone" nix develop ".#$(consumer_devshell "$consumer")" \
            --command bash -euo pipefail -c "$command")
        status=${fields%% *}
        seconds=${fields##* }
        if [ "$status" -eq 0 ]; then
            status_word=passed
        else
            status_word=failed
            consumer_status=red
            if [ -z "$failure_log" ]; then
                failure_log=$last_log
                failure_reason=$(tail -3 "$last_log" | tr -d '\r' | tr '\n' ' ')
            fi
        fi
        if [ -n "$commands_json" ]; then commands_json="$commands_json,"; fi
        commands_json="$commands_json{\"command\":\"$(json_escape "$command")\",\"status\":\"$status_word\",\"exit\":$status,\"seconds\":$seconds,\"log\":\"logs/$(basename "$last_log")\"}"
        index=$((index + 1))
    done < <(consumer_commands "$consumer")

    if [ -n "$last_log" ]; then
        evidence=$(extract_evidence "${failure_log:-$last_log}")
    fi
    changed_hash=no
    if [ "$candidate_hash" != "$pin_hash" ]; then changed_hash=yes; fi
    if [ "$changed_hash" = "no" ]; then
        gaps+=("$consumer: candidate package hash equals the committed pin; this run revalidates the pin, it does not exercise a pin change")
    fi
    if ! is_full_sha "$requested"; then
        gaps+=("$consumer: symbolic revision '$requested' resolved to $rev")
    fi

    cat > "$cwork/record.json" <<EOF
{
  "name": "$consumer",
  "source": "$(json_escape "$(redact_url "$source")")",
  "source_kind": "$source_kind",
  "source_dirty": "$source_dirty",
  "requested_revision": "$(json_escape "$requested")",
  "revision": "$rev",
  "subject": "$(json_escape "$(git -C "$clone" log -1 --format=%s "$rev")")",
  "devshell": "$(consumer_devshell "$consumer")",
  "rollback_pin": {
    "url": "$(json_escape "$(redact_url "$pin_url")")",
    "hash": "$(json_escape "$pin_hash")"
  },
  "candidate_pin": {
    "url": "$(json_escape "$archive_url")",
    "hash": "$(json_escape "$candidate_hash")"
  },
  "candidate_changed_pin": "$changed_hash",
  "toolchain": {
    "zig": "$(json_escape "$probe_zig")",
    "libcrypto_version": "$(json_escape "$probe_libcrypto")",
    "libcrypto_libdir": "$(json_escape "$probe_libcrypto_dir")",
    "os": "$(json_escape "$probe_os")",
    "arch": "$(json_escape "$probe_arch")",
    "kernel": "$(json_escape "$probe_kernel")"
  },
  "commands": [$commands_json],
  "evidence": "$(json_escape "$evidence")",
  "status": "$consumer_status"
}
EOF
    printf '%s\n' "$candidate_hash" > "$cwork/hash"
    printf '%s\n' "$consumer_status" > "$cwork/status"
    printf '%s\n' "$rev" > "$cwork/rev"
    if [ -n "$failure_reason" ]; then
        printf '%s\n' "$failure_reason" > "$cwork/failure_reason"
    fi
}

# ---------------------------------------------------------------------------
# Run record.
# ---------------------------------------------------------------------------

write_record() { # result: green|red
    local result=$1 consumer first_hash hash_consistent=yes
    local consumer_hashes=()
    for consumer in "${selected[@]}"; do
        consumer_hashes+=("$(cat "$out_dir/consumers/$consumer/hash")")
    done
    first_hash=${consumer_hashes[0]}
    for consumer in "${consumer_hashes[@]}"; do
        [ "$consumer" = "$first_hash" ] || hash_consistent=no
    done
    [ "$hash_consistent" = yes ] ||
        die "consumers disagreed on the candidate package hash: ${consumer_hashes[*]}"

    {
        printf '{\n'
        printf '  "schema": "ztls.consumer-gate/1",\n'
        printf '  "generated_at": "%s",\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
        printf '  "host": "%s",\n' "$(json_escape "$(uname -a)")"
        printf '  "invocation": "%s",\n' "$(json_escape "$invocation")"
        printf '  "nix_version": "%s",\n' "$(json_escape "$(nix --version)")"
        printf '  "candidate": {\n'
        printf '    "repo": "%s",\n' "$(json_escape "$ztls_root")"
        printf '    "revision": "%s",\n' "$ztls_sha"
        printf '    "requested_revision": "%s",\n' "$(json_escape "$ztls_rev")"
        printf '    "subject": "%s",\n' "$(json_escape "$(git -C "$ztls_root" log -1 --format=%s "$ztls_sha")")"
        printf '    "worktree_dirty": "%s",\n' "$ztls_dirty"
        printf '    "archive": "%s",\n' "$(json_escape "$archive_url")"
        printf '    "archive_command": "git archive --format=tar.gz --prefix=ztls/ -o candidate.tar.gz %s",\n' "$ztls_sha"
        printf '    "archive_sha256": "%s",\n' "$archive_sha"
        printf '    "package_hash": "%s",\n' "$first_hash"
        printf '    "id": "%s/%s"\n' "$ztls_sha" "$first_hash"
        printf '  },\n'
        printf '  "consumers": [\n'
        local sep=""
        for consumer in "${selected[@]}"; do
            printf '%s' "$sep"
            cat "$out_dir/consumers/$consumer/record.json"
            sep=$',\n'
        done
        printf '\n  ],\n'
        printf '  "result": "%s",\n' "$result"
        printf '  "qualification": "%s",\n' "$( [ "$result" = green ] && [ "${#gaps[@]}" -eq 0 ] && printf full || printf partial )"
        printf '  "qualification_gaps": ['
        local gap_sep=""
        local gap
        for gap in "${gaps[@]}"; do
            printf '%s"%s"' "$gap_sep" "$(json_escape "$gap")"
            gap_sep=', '
        done
        printf ']\n'
        printf '}\n'
    } > "$out_dir/run.json"
}

write_summary() { # result
    local result=$1 consumer
    {
        printf 'ztls consumer gate: %s\n' "$result"
        printf 'candidate: %s\n' "$candidate_id"
        printf 'record: %s\n' "$out_dir/run.json"
        for consumer in "${selected[@]}"; do
            printf '%s: %s (%s)\n' "$consumer" \
                "$(cat "$out_dir/consumers/$consumer/status")" \
                "$(cat "$out_dir/consumers/$consumer/rev")"
        done
        if [ "${#gaps[@]}" -gt 0 ]; then
            printf 'qualification gaps:\n'
            local gap
            for gap in "${gaps[@]}"; do
                printf '  - %s\n' "$gap"
            done
        fi
    } | tee "$out_dir/summary.txt"
}

# ---------------------------------------------------------------------------
# main
# ---------------------------------------------------------------------------

main() {
    parse_args "$@"
    if [ "$selftest_only" -eq 1 ]; then
        run_selftest
        return 0
    fi
    require_tools

    ztls_root=$(git -C "${ztls_repo:-$script_repo}" rev-parse --show-toplevel 2>/dev/null) ||
        die "not a git checkout: ${ztls_repo:-$script_repo}"
    ztls_sha=$(git -C "$ztls_root" rev-parse --verify --quiet "$ztls_rev^{commit}") ||
        die "ztls revision not found: $ztls_rev"
    if [ "$require_fixed" -eq 1 ] && ! is_full_sha "$ztls_rev"; then
        die "qualification requires a fixed ztls SHA, got $ztls_rev"
    fi
    ztls_dirty=no
    if [ -n "$(git -C "$ztls_root" status --porcelain)" ]; then
        ztls_dirty=yes
    fi

    selected=()
    select_consumers

    local run_id host
    run_id=$(date -u +%Y%m%d-%H%M%S)
    host=$(hostname)
    : "${out_dir:=$ztls_root/zig-out/consumer-gate/$run_id-$host}"
    : "${cache_root:=$ztls_root/zig-out/consumer-gate/cache}"
    mkdir -p "$(dirname -- "$out_dir")" "$cache_root"
    mkdir -- "$out_dir" || die "output directory already exists or cannot be created: $out_dir"
    mkdir -p "$out_dir/consumers" "$out_dir/logs"
    out_dir=$(cd "$out_dir" && pwd)
    cache_root=$(cd "$cache_root" && pwd)
    out_dir_ready=1

    work=$(mktemp -d "${TMPDIR:-/tmp}/ztls-consumer-gate.XXXXXX")
    if [ "$keep_work" -eq 0 ]; then
        trap 'rm -rf "$work"' EXIT
    else
        printf 'consumer-gate: keeping work tree %s\n' "$work"
    fi

    archive="$work/candidate.tar.gz"
    archive_url="file://$archive"
    gaps=()
    invocation=""
    local arg
    for arg in "$@"; do
        if [ -n "$invocation" ]; then invocation="$invocation "; fi
        invocation="$invocation$(redact_url "$arg")"
    done

    printf 'consumer-gate: archiving ztls %s (worktree dirty: %s)\n' "$ztls_sha" "$ztls_dirty" >&2
    git -C "$ztls_root" archive --format=tar.gz --prefix=ztls/ -o "$archive" "$ztls_sha" ||
        die "git archive failed for $ztls_sha"
    archive_sha=$(sha256_file "$archive")

    if ! is_full_sha "$ztls_rev"; then
        gaps+=("ztls: symbolic revision '$ztls_rev' resolved to $ztls_sha")
    fi
    if [ "${#selected[@]}" -lt 2 ]; then
        gaps+=("consumer subset requested: ${selected[*]}")
    fi

    local result=green current
    for current in "${selected[@]}"; do
        run_consumer "$current"
        if [ "$(cat "$out_dir/consumers/$current/status")" = "red" ]; then
            result=red
        fi
    done

    write_record "$result"
    candidate_id="$ztls_sha/$(cat "$out_dir/consumers/${selected[0]}/hash")"
    write_summary "$result"

    if [ "$result" = red ]; then
        return 1
    fi
    return 0
}

main "$@"
