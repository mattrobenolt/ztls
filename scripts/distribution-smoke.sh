#!/usr/bin/env bash
set -euo pipefail

case "$(zig version)" in
    0.16.*) ;;
    *)
        echo "distribution smoke requires Zig 0.16, found $(zig version)" >&2
        exit 1
        ;;
esac

repo_root=$(git rev-parse --show-toplevel)
cd "$repo_root"

untracked=$(git ls-files --others --exclude-standard)
if [ -n "$untracked" ]; then
    printf 'distribution smoke cannot archive untracked files; stage them first:\n%s\n' "$untracked" >&2
    exit 1
fi

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
archive="$tmp/ztls.tar.gz"
consumer="$tmp/consumer"
global_cache="$tmp/global-cache"
local_cache="$tmp/local-cache"
mkdir -p "$consumer" "$global_cache" "$local_cache"

snapshot=$(git stash create "ztls distribution smoke")
git archive --format=tar.gz --prefix=ztls/ -o "$archive" "${snapshot:-HEAD}"
cp -R "$repo_root/tests/distribution-consumer/." "$consumer/"
(
    cd "$consumer"
    zig fetch --global-cache-dir "$global_cache" --save=ztls "file://$archive"
)
if ! grep -F '.url = "file://' "$consumer/build.zig.zon" >/dev/null; then
    echo "distribution consumer is not pinned to the fetched archive" >&2
    exit 1
fi
if ! grep -F '.hash = "ztls-' "$consumer/build.zig.zon" >/dev/null; then
    echo "distribution consumer is missing the fetched package hash" >&2
    exit 1
fi
if grep -F '.path = ' "$consumer/build.zig.zon" >/dev/null; then
    echo "distribution consumer unexpectedly uses a path dependency" >&2
    exit 1
fi
rm "$archive"

ztls_package=
for entry in "$global_cache"/p/ztls-*; do
    [ -e "$entry" ] || continue
    ztls_package=$entry
done
if [ -z "$ztls_package" ]; then
    echo "fetched ztls package is absent from the isolated cache" >&2
    exit 1
fi
for license in LICENSE LICENSE-ZIG; do
    if [ -d "$ztls_package" ]; then
        [ -f "$ztls_package/$license" ] || {
            echo "fetched ztls package is missing $license" >&2
            exit 1
        }
    elif ! tar -tzf "$ztls_package" | grep -E "/$license\$" >/dev/null; then
        echo "fetched ztls package is missing $license" >&2
        exit 1
    fi
done

cache_contains() {
    local package=$1
    local entry name
    for entry in "$global_cache"/p/*; do
        [ -e "$entry" ] || continue
        name=${entry##*/}
        case "$name" in
            "$package"-*) return 0 ;;
        esac
    done
    return 1
}

assert_not_cached() {
    local package
    for package in "$@"; do
        if cache_contains "$package"; then
            echo "unexpected distribution dependency in cache: $package" >&2
            exit 1
        fi
    done
}

build_consumer() {
    local selected=$1
    (
        cd "$consumer"
        zig build \
            --global-cache-dir "$global_cache" \
            --cache-dir "$local_cache" \
            -Dmode="$selected" \
            --summary all
    )
}

build_consumer core
assert_not_cached benchmark txtar ztest libxev

build_consumer std
assert_not_cached benchmark txtar ztest libxev

xev_guard_log="$tmp/xev-option-guard.log"
if build_consumer xev_without_option >"$xev_guard_log" 2>&1; then
    echo "ztls_xev unexpectedly compiled without the xev dependency option" >&2
    exit 1
fi
if ! grep -F "ztls_xev is opt-in" "$xev_guard_log" >/dev/null; then
    cat "$xev_guard_log" >&2
    echo "ztls_xev failure did not use the opt-in diagnostic" >&2
    exit 1
fi

if [ "$(uname -s)" = Linux ]; then
    build_consumer ktls
else
    echo "ztls_ktls: Linux-only distribution smoke skipped"
fi

build_consumer xev
cache_contains libxev || {
    echo "ztls_xev did not fetch its declared libxev dependency" >&2
    exit 1
}
assert_not_cached benchmark txtar ztest

echo "ztls distribution smoke passed from an isolated fetched package"
