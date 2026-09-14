#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 2 ]]; then
    echo "usage: $0 <label> <zoxy-binary>" >&2
    exit 64
fi

label=$1
zoxy=$2
connections=${CONNECTIONS:-700}
zrk=${ZRK_BIN:-/tmp/zrk-release-1.4.1/zrk}
work=/tmp/ztls-88-retest-$label
rm -rf "$work"
mkdir -p "$work/origin"
dd if=/dev/urandom of="$work/origin/1k" bs=1024 count=1 status=none
cp /tmp/zoxy-88-6e/src/tls/testdata/cert.pem "$work/cert.pem"
cp /tmp/zoxy-88-6e/src/tls/testdata/key.pem "$work/key.pem"

cat >"$work/zoxy.json" <<JSON
{
  "listeners": [
    { "bind": "127.0.0.1:18080", "cluster": "origin", "protocol": "http" },
    { "bind": "127.0.0.1:18443", "cluster": "origin", "protocol": "http",
      "tls": { "cert": "$work/cert.pem", "key": "$work/key.pem" } }
  ],
  "clusters": {
    "origin": { "endpoints": ["127.0.0.1:19000", "127.0.0.1:19001", "127.0.0.1:19002", "127.0.0.1:19003"], "pick": "rr" }
  },
  "access_log": { "sink": "file", "path": "$work/access.log" },
  "admin": { "bind": "127.0.0.1:19101" },
  "timeouts": { "connect_ms": 5000, "idle_ms": 60000, "drain_deadline_ms": 10000 },
  "limits": { "access_log_buffer_bytes": 1048576, "conn_slots": 1386, "upstream_slots": 5544, "tls_engines": 1024 }
}
JSON

pids=()
cleanup() {
    set +e
    if [[ ${#pids[@]} -gt 0 ]]; then
        kill -TERM "${pids[@]}" 2>/dev/null || true
        sleep 1
        kill -KILL "${pids[@]}" 2>/dev/null || true
        wait "${pids[@]}" 2>/dev/null || true
    fi
}
trap cleanup EXIT INT TERM

for port in 19000 19001 19002 19003; do
    python3 -m http.server "$port" --bind 127.0.0.1 --protocol HTTP/1.1 \
        --directory "$work/origin" >"$work/origin-$port.log" 2>&1 &
    pids+=("$!")
done

allowed=$(taskset -pc $$ | awk -F: '{gsub(/ /, "", $2); print $2}')
cpu=${allowed%%,*}
cpu=${cpu%%-*}

echo "label=$label"
echo "started_utc=$(date -u +%Y-%m-%dT%H:%M:%SZ)"
echo "host=$(uname -a)"
echo "cpu_allowed=$allowed zoxy_cpu=$cpu"
echo "zoxy_sha256=$(sha256sum "$zoxy" | awk '{print $1}')"
echo "zrk_sha256=$(sha256sum "$zrk" | awk '{print $1}')"
echo "connections=$connections rate=5000 duration=15s threads=4 wire_timeout=1s"
"$zoxy" --version
a=$("$zrk" --version)
echo "$a"

taskset -c "$cpu" "$zoxy" "$work/zoxy.json" >"$work/zoxy.stdout.log" 2>"$work/zoxy.stderr.log" &
zoxy_pid=$!
pids+=("$zoxy_pid")

ready=0
for _ in $(seq 1 50); do
    if curl -fsS --max-time 1 http://127.0.0.1:19101/metrics >"$work/metrics-before.txt"; then
        ready=1
        break
    fi
    sleep 0.1
done
if [[ $ready -ne 1 ]]; then
    echo "zoxy did not become ready" >&2
    exit 1
fi

printf 'before http='; curl -sS -o /dev/null -w '%{http_code}\n' --max-time 2 http://127.0.0.1:18080/1k
printf 'before tls='; curl -ksS -o /dev/null -w '%{http_code}\n' --max-time 2 https://127.0.0.1:18443/1k
printf 'before admin='; curl -sS -o /dev/null -w '%{http_code}\n' --max-time 2 http://127.0.0.1:19101/metrics

echo 'load-start'
set +e
timeout --signal=TERM --kill-after=5 30 "$zrk" -k -c "$connections" -t 4 -d 15s -R 5000 --timeout 1s --plain \
    "https://127.0.0.1:18443/1k" >"$work/zrk.log" 2>&1
zrk_status=$?
set -e
echo "load-end status=$zrk_status"

for delay in 6 15 30; do
    sleep "$delay"
    now=$(date -u +%Y-%m-%dT%H:%M:%SZ)
    http=$(curl -sS -o /dev/null -w '%{http_code}' --max-time 2 http://127.0.0.1:18080/1k || true)
    tls=$(curl -ksS -o /dev/null -w '%{http_code}' --max-time 2 https://127.0.0.1:18443/1k || true)
    admin=$(curl -sS -o "$work/metrics-$delay.txt" -w '%{http_code}' --max-time 2 http://127.0.0.1:19101/metrics || true)
    fds=$(find "/proc/$zoxy_pid/fd" -mindepth 1 -maxdepth 1 2>/dev/null | wc -l)
    cpu_now=$(ps -p "$zoxy_pid" -o %cpu= | xargs || true)
    shed=$(awk '$1 ~ /shed_tls_crypto/ {print $2}' "$work/metrics-$delay.txt" 2>/dev/null | tail -n 1)
    conn_slots=$(awk '$1 ~ /conn_slots/ {print $2}' "$work/metrics-$delay.txt" 2>/dev/null | tail -n 1)
    echo "poll delay=$delay utc=$now http=${http:-000} tls=${tls:-000} admin=${admin:-000} fds=$fds cpu=${cpu_now:-unknown} shed_tls_crypto=${shed:-unknown} conn_slots=${conn_slots:-unknown}"
done

kill -USR1 "$zoxy_pid" 2>/dev/null || true
sleep 1
kill -TERM "$zoxy_pid" 2>/dev/null || true
for _ in $(seq 1 100); do
    if ! kill -0 "$zoxy_pid" 2>/dev/null; then
        break
    fi
    sleep 0.1
done
if kill -0 "$zoxy_pid" 2>/dev/null; then
    echo "zoxy drain timed out" >&2
    exit 1
fi
wait "$zoxy_pid"
zoxy_status=$?
echo "zoxy_exit=$zoxy_status"
pids=("${pids[@]:0:4}")
echo "finished_utc=$(date -u +%Y-%m-%dT%H:%M:%SZ)"
