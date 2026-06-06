#!/usr/bin/env nu

const suites = [
  TLS_AES_128_GCM_SHA256
  TLS_AES_256_GCM_SHA384
  TLS_CHACHA20_POLY1305_SHA256
]

const sizes = [16 128 1350 8192 16384]

const split_rows = [
  ztls_handshake_client_start
  ztls_handshake_server_accept
  ztls_handshake_client_server_hello
  ztls_handshake_server_flight
  ztls_handshake_client_flight
  ztls_handshake_server_finished
]

def latest [pattern: string] {
  let files = (glob $pattern | sort | reverse)
  if ($files | is-empty) {
    error make { msg: $"no files match ($pattern)" }
  }
  $files | first
}

def read-bench [path: path, source: string] {
  open --raw $path
  | lines
  | where {|line| ($line | str trim) != "" and not ($line | str starts-with "#") and not ($line | str starts-with "benchmark,") }
  | str join "\n"
  | from csv --noheaders
  | rename benchmark suite size iterations bytes elapsed_ns rate
  | insert source $source
  | update size {|r| $r.size | into int }
  | update iterations {|r| $r.iterations | into int }
  | update bytes {|r| $r.bytes | into int }
  | update elapsed_ns {|r| $r.elapsed_ns | into int }
  | update rate {|r| $r.rate | into float }
}

def find-row [rows: table, benchmark: string, suite: string, size: int] {
  let found = ($rows | where benchmark == $benchmark and suite == $suite and size == $size)
  if ($found | is-empty) { null } else { $found | first }
}

def app-vs-bio [rows: table] {
  mut out = []
  for suite in $suites {
    for size in $sizes {
      let ztls = (find-row $rows ztls_app_client_to_server $suite $size)
      let bio = (find-row $rows openssl_bio_app_client_to_server $suite $size)
      if $ztls != null and $bio != null {
        $out = ($out | append {
          suite: $suite
          size: $size
          ztls_mib_s: $ztls.rate
          bio_mib_s: $bio.rate
          ratio: ($ztls.rate / $bio.rate)
        })
      }
    }
  }
  $out
}

def record-vs-evp [rows: table] {
  mut out = []
  for suite in $suites {
    for size in $sizes {
      let ztls = (find-row $rows record_encrypt $suite $size)
      let evp = (find-row $rows openssl_evp_reuse_encrypt $suite $size)
      if $ztls != null and $evp != null {
        $out = ($out | append {
          suite: $suite
          size: $size
          ztls_mib_s: $ztls.rate
          evp_reuse_mib_s: $evp.rate
          ratio: ($ztls.rate / $evp.rate)
        })
      }
    }
  }
  $out
}

def handshake-vs-bio [rows: table] {
  mut out = []
  for suite in $suites {
    let ztls = (find-row $rows ztls_handshake $suite 1)
    let bio = (find-row $rows openssl_bio_handshake $suite 1)
    if $ztls != null and $bio != null {
      $out = ($out | append {
        suite: $suite
        ztls_ops_s: $ztls.rate
        bio_ops_s: $bio.rate
        ratio: ($ztls.rate / $bio.rate)
      })
    }
  }
  $out
}

def split-handshake [rows: table, suite: string] {
  mut out = []
  for benchmark in $split_rows {
    let row = (find-row $rows $benchmark $suite 1)
    if $row != null {
      $out = ($out | append {
        benchmark: $benchmark
        ops_s: $row.rate
        ns_per_op: ($row.elapsed_ns / $row.iterations)
      })
    }
  }
  $out
}

def main [
  --ztls: path
  --evp: path
  --bio: path
  --suite: string = "TLS_AES_128_GCM_SHA256"
  --json
] {
  let ztls_path = if $ztls == null { latest "zig-out/perf/ztls-all-*.csv" } else { $ztls }
  let evp_path = if $evp == null { latest "zig-out/perf/evp-all-*.csv" } else { $evp }
  let bio_path = if $bio == null { latest "zig-out/perf/bio-all-*.csv" } else { $bio }

  let rows = (
    read-bench $ztls_path ztls
    | append (read-bench $evp_path evp)
    | append (read-bench $bio_path bio)
  )

  let report = {
    inputs: {
      ztls: ($ztls_path | path expand)
      evp: ($evp_path | path expand)
      bio: ($bio_path | path expand)
    }
    app_vs_bio: (app-vs-bio $rows)
    record_vs_evp_reuse: (record-vs-evp $rows)
    handshake_vs_bio: (handshake-vs-bio $rows)
    split_handshake: (split-handshake $rows $suite)
  }

  if $json { $report | to json } else { $report }
}
