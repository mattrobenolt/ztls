//! rustls in-memory benchmark.
//!
//! Emits Go-testing-style benchmark output so it flows through the same
//! `normalize_go` path as the ztls/EVP/libssl benchmarks:
//!
//!     Benchmark<Name>/impl=rustls/suite=<suite>/size=<size>\t<iters>\t<ns/op>[\t<MB/s>]
//!
//! Iteration counts are auto-calibrated to `--benchtime` (duration or `Nx`),
//! matching the `benchmark` package's `predictN` growth loop, so each sample
//! runs comparable work to the Zig-side benchmarks rather than a fixed byte
//! budget. `--count` controls the number of independent calibrated samples.
//!
//! Session tickets are disabled (`send_tls13_tickets = 0`) and client
//! resumption is disabled, matching `bench/bio.zig`'s
//! `SSL_CTX_set_num_tickets(server_ctx, 0)` so the handshake row measures a
//! clean full 1-RTT handshake without NewSessionTicket issuance cost. This
//! equivalence is load-bearing — rustls-ffi cannot do this, which is why the
//! benchmark stays a Rust program rather than driving rustls from Zig.

use rustls::client::danger::{HandshakeSignatureValid, ServerCertVerified, ServerCertVerifier};
use rustls::crypto::ring;
use rustls::pki_types::{CertificateDer, ServerName, UnixTime};
use rustls::{
    ClientConfig, ClientConnection, DigitallySignedStruct, ServerConfig, ServerConnection,
    SignatureScheme,
};
use std::env;
use std::fs::File;
use std::hint::black_box;
use std::io::{BufReader, Cursor, Read, Write};
use std::sync::Arc;
use std::time::Instant;

const SIZES: &[usize] = &[16, 128, 1350, 8192, 16384];
const HANDSHAKE_SIZE: usize = 1;
const MAX_PREDICT_ITERS: u64 = 1_000_000_000;
const DEFAULT_BENCHTIME_NS: u64 = 1_000_000_000;

const SUITES: &[(&str, rustls::SupportedCipherSuite)] = &[
    (
        "TLS_AES_128_GCM_SHA256",
        rustls::crypto::ring::cipher_suite::TLS13_AES_128_GCM_SHA256,
    ),
    (
        "TLS_AES_256_GCM_SHA384",
        rustls::crypto::ring::cipher_suite::TLS13_AES_256_GCM_SHA384,
    ),
    (
        "TLS_CHACHA20_POLY1305_SHA256",
        rustls::crypto::ring::cipher_suite::TLS13_CHACHA20_POLY1305_SHA256,
    ),
];

const ROWS: &[&str] = &[
    "Handshake",
    "HandshakeClientStart",
    "HandshakeServerAccept",
    "HandshakeServerFlight",
    "HandshakeClientFlight",
    "HandshakeServerFinished",
    "AppClientToServer",
    "AppServerToClient",
    "AppPingPong",
];

#[derive(Clone, Copy)]
enum Benchtime {
    Duration(u64),
    Count(u64),
}

struct Args {
    filter: Option<String>,
    bench: Option<String>,
    suite: Option<String>,
    size: Option<usize>,
    count: usize,
    benchtime: Benchtime,
    list: bool,
}

impl Default for Args {
    fn default() -> Self {
        Self {
            filter: None,
            bench: None,
            suite: None,
            size: None,
            count: 1,
            benchtime: Benchtime::Duration(DEFAULT_BENCHTIME_NS),
            list: false,
        }
    }
}

#[derive(Debug)]
struct NoVerifier;

impl ServerCertVerifier for NoVerifier {
    fn verify_server_cert(
        &self,
        _: &CertificateDer<'_>,
        _: &[CertificateDer<'_>],
        _: &ServerName<'_>,
        _: &[u8],
        _: UnixTime,
    ) -> Result<ServerCertVerified, rustls::Error> {
        Ok(ServerCertVerified::assertion())
    }
    fn verify_tls12_signature(
        &self,
        _: &[u8],
        _: &CertificateDer<'_>,
        _: &DigitallySignedStruct,
    ) -> Result<HandshakeSignatureValid, rustls::Error> {
        Ok(HandshakeSignatureValid::assertion())
    }
    fn verify_tls13_signature(
        &self,
        _: &[u8],
        _: &CertificateDer<'_>,
        _: &DigitallySignedStruct,
    ) -> Result<HandshakeSignatureValid, rustls::Error> {
        Ok(HandshakeSignatureValid::assertion())
    }
    fn supported_verify_schemes(&self) -> Vec<SignatureScheme> {
        vec![SignatureScheme::ECDSA_NISTP256_SHA256]
    }
}

fn parse_args() -> Args {
    let mut args = Args::default();
    let raw: Vec<String> = env::args().skip(1).collect();
    let mut it = raw.into_iter();
    while let Some(arg) = it.next() {
        let (key, inline) = arg
            .split_once('=')
            .map_or((arg.as_str(), None), |(k, v)| (k, Some(v.to_string())));
        let value = || inline.unwrap_or_else(|| it.next().expect("missing flag value"));
        match key {
            "--list" => args.list = true,
            "--filter" => args.filter = Some(value()),
            "--bench" => args.bench = Some(value()),
            "--suite" => args.suite = Some(value()),
            "--size" => args.size = Some(value().parse().expect("invalid --size")),
            "--count" => args.count = value().parse().expect("invalid --count"),
            "--benchtime" => args.benchtime = parse_benchtime(&value()),
            // Zig benchmark-package flags with no meaning here; accept as
            // no-ops so a shared arg string works across all four benchmarks.
            "--no-env" | "--parallelism" => {
                let _ = it.next();
            }
            "--benchmem" => {}
            _ => panic!("unknown argument: {arg}"),
        }
    }
    args
}

fn parse_benchtime(s: &str) -> Benchtime {
    // `Nx` form: exactly N iterations, no calibration.
    if let Some(rest) = s.strip_suffix('x').or_else(|| s.strip_suffix('X')) {
        let n: u64 = rest.parse().expect("invalid --benchtime count");
        if n == 0 {
            panic!("--benchtime count must be > 0");
        }
        return Benchtime::Count(n);
    }
    Benchtime::Duration(parse_duration_ns(s))
}

fn parse_duration_ns(s: &str) -> u64 {
    const UNITS: &[(&str, u64)] = &[
        ("ns", 1),
        ("us", 1_000),
        ("µs", 1_000),
        ("ms", 1_000_000),
        ("s", 1_000_000_000),
        ("m", 60_000_000_000),
        ("h", 3_600_000_000_000),
    ];
    for (suffix, scale) in UNITS {
        if let Some(num) = s.strip_suffix(suffix) {
            let v: f64 = num.parse().expect("invalid --benchtime duration");
            if v <= 0.0 {
                panic!("--benchtime duration must be > 0");
            }
            return (v * *scale as f64) as u64;
        }
    }
    panic!("invalid --benchtime: {s}");
}

fn contains(haystack: &str, needle: &str) -> bool {
    haystack
        .to_ascii_lowercase()
        .contains(&needle.to_ascii_lowercase())
}

/// Match a single filter pattern against `name`. Mirrors the `benchmark`
/// package's filter semantics: plain substring by default, `^`/`$` anchors,
/// `*` glob wildcard.
fn pattern_matches(pattern: &str, name: &str) -> bool {
    let mut glob = pattern;
    let anchor_start = glob.starts_with('^');
    if anchor_start {
        glob = &glob[1..];
    }
    let anchor_end = glob.ends_with('$') && !glob.ends_with("\\$");
    if anchor_end {
        glob = &glob[..glob.len() - 1];
    }
    if !glob.contains('*') {
        return match (anchor_start, anchor_end) {
            (true, true) => name == glob,
            (true, false) => name.starts_with(glob),
            (false, true) => name.ends_with(glob),
            (false, false) => name.contains(glob),
        };
    }
    match (anchor_start, anchor_end) {
        (true, true) => glob_match(glob, name),
        (true, false) => (0..=name.len()).any(|end| glob_match(glob, &name[..end])),
        (false, true) => (0..=name.len()).any(|start| glob_match(glob, &name[start..])),
        (false, false) => (0..=name.len())
            .flat_map(|start| (start..=name.len()).map(move |end| (start, end)))
            .any(|(start, end)| glob_match(glob, &name[start..end])),
    }
}

fn matches_any(patterns: &str, name: &str) -> bool {
    patterns
        .split(',')
        .map(str::trim)
        .filter(|p| !p.is_empty())
        .any(|p| pattern_matches(p, name))
}

fn glob_match(pattern: &str, text: &str) -> bool {
    let p: Vec<char> = pattern.chars().collect();
    let t: Vec<char> = text.chars().collect();
    let mut pi = 0;
    let mut ti = 0;
    let mut star: Option<usize> = None;
    let mut retry = 0;
    while ti < t.len() {
        if pi < p.len() && (p[pi] == '*' || p[pi] == t[ti]) {
            if p[pi] == '*' {
                star = Some(pi);
                retry = ti;
                pi += 1;
            } else {
                pi += 1;
                ti += 1;
            }
        } else if let Some(s) = star {
            pi = s + 1;
            retry += 1;
            ti = retry;
        } else {
            return false;
        }
    }
    while pi < p.len() && p[pi] == '*' {
        pi += 1;
    }
    pi == p.len()
}

fn full_name(row: &str, suite: &str, size: usize) -> String {
    format!("Benchmark{row}/impl=rustls/suite={suite}/size={size}")
}

fn row_selected(args: &Args, row: &str, suite: &str, size: usize) -> bool {
    if let Some(b) = &args.bench
        && !row.eq_ignore_ascii_case(b)
    {
        return false;
    }
    if let Some(s) = &args.suite
        && !contains(suite, s)
    {
        return false;
    }
    if let Some(want) = args.size
        && want != size
    {
        return false;
    }
    if let Some(f) = &args.filter {
        let full = full_name(row, suite, size);
        return matches_any(f, &full) || matches_any(f, row);
    }
    true
}

fn load_config(suite: rustls::SupportedCipherSuite) -> (Arc<ClientConfig>, Arc<ServerConfig>) {
    let certs = rustls_pemfile::certs(&mut BufReader::new(
        File::open("tests/fixtures/server.crt").unwrap(),
    ))
    .collect::<Result<Vec<_>, _>>()
    .unwrap();
    let key = rustls_pemfile::private_key(&mut BufReader::new(
        File::open("tests/fixtures/server.key").unwrap(),
    ))
    .unwrap()
    .unwrap();
    let provider = Arc::new(rustls::crypto::CryptoProvider {
        cipher_suites: vec![suite],
        ..ring::default_provider()
    });
    let versions = &[&rustls::version::TLS13];
    let mut client = ClientConfig::builder_with_provider(provider.clone())
        .with_protocol_versions(versions)
        .unwrap()
        .dangerous()
        .with_custom_certificate_verifier(Arc::new(NoVerifier))
        .with_no_client_auth();
    let mut server = ServerConfig::builder_with_provider(provider)
        .with_protocol_versions(versions)
        .unwrap()
        .with_no_client_auth()
        .with_single_cert(certs, key)
        .unwrap();
    client.alpn_protocols.clear();
    client.resumption = rustls::client::Resumption::disabled();
    server.send_tls13_tickets = 0;
    (Arc::new(client), Arc::new(server))
}

struct Conn {
    client: ClientConnection,
    server: ServerConnection,
    c2s: Vec<u8>,
    s2c: Vec<u8>,
}

/// One exchange step: each endpoint flushes pending TLS bytes to the other,
/// then delivers any queued wire bytes to the peer.
///
/// Returns true if any work was done so callers can drive convergence by
/// looping until false. `read_tls` may consume only one TLS record, so the
/// cursor is kept alive until every queued wire byte has been handed to rustls
/// instead of dropping unread tail bytes on large writes.
fn transfer_step(conn: &mut Conn) -> bool {
    let mut progress = false;
    if conn.client.write_tls(&mut conn.c2s).unwrap() > 0 {
        progress = true;
    }
    if conn.server.write_tls(&mut conn.s2c).unwrap() > 0 {
        progress = true;
    }
    if !conn.c2s.is_empty() {
        let wire = std::mem::take(&mut conn.c2s);
        let wire_len = wire.len() as u64;
        let mut cursor = Cursor::new(wire);
        while cursor.position() < wire_len {
            if conn.server.read_tls(&mut cursor).unwrap() == 0 {
                break;
            }
            conn.server.process_new_packets().unwrap();
        }
        progress = true;
    }
    if !conn.s2c.is_empty() {
        let wire = std::mem::take(&mut conn.s2c);
        let wire_len = wire.len() as u64;
        let mut cursor = Cursor::new(wire);
        while cursor.position() < wire_len {
            if conn.client.read_tls(&mut cursor).unwrap() == 0 {
                break;
            }
            conn.client.process_new_packets().unwrap();
        }
        progress = true;
    }
    progress
}

/// Drain all pending TLS bytes between client and server until both sides
/// have nothing left to send or deliver.
fn transfer(conn: &mut Conn) {
    while transfer_step(conn) {}
}

fn deliver_to_server(conn: &mut Conn) {
    let wire = std::mem::take(&mut conn.c2s);
    let wire_len = wire.len() as u64;
    let mut cursor = Cursor::new(wire);
    while cursor.position() < wire_len {
        if conn.server.read_tls(&mut cursor).unwrap() == 0 {
            break;
        }
        conn.server.process_new_packets().unwrap();
    }
}

fn deliver_to_client(conn: &mut Conn) {
    let wire = std::mem::take(&mut conn.s2c);
    let wire_len = wire.len() as u64;
    let mut cursor = Cursor::new(wire);
    while cursor.position() < wire_len {
        if conn.client.read_tls(&mut cursor).unwrap() == 0 {
            break;
        }
        conn.client.process_new_packets().unwrap();
    }
}

fn make_conn(c: &Arc<ClientConfig>, s: &Arc<ServerConfig>) -> Conn {
    let name = ServerName::try_from("test.local").unwrap();
    Conn {
        client: ClientConnection::new(c.clone(), name).unwrap(),
        server: ServerConnection::new(s.clone()).unwrap(),
        c2s: Vec::new(),
        s2c: Vec::new(),
    }
}

fn connected(c: &Arc<ClientConfig>, s: &Arc<ServerConfig>) -> Conn {
    let mut conn = make_conn(c, s);
    transfer(&mut conn);
    assert!(
        !conn.client.is_handshaking() && !conn.server.is_handshaking(),
        "handshake did not converge"
    );
    conn
}

#[derive(Default, Clone, Copy)]
struct HandshakeSplit {
    client_start_ns: u128,
    server_accept_ns: u128,
    server_flight_ns: u128,
    client_flight_ns: u128,
    server_finished_ns: u128,
}

/// Run one full handshake with rustls' public no-I/O API and split timing at
/// observable flight boundaries. rustls processes ServerHello through Finished
/// as one client read/process step, so there is no honest separate
/// client_server_hello row here.
fn handshake_split(c: &Arc<ClientConfig>, s: &Arc<ServerConfig>) -> HandshakeSplit {
    let mut conn = make_conn(c, s);
    let mut split = HandshakeSplit::default();

    let t = Instant::now();
    conn.client.write_tls(&mut conn.c2s).unwrap();
    split.client_start_ns += t.elapsed().as_nanos();

    let t = Instant::now();
    deliver_to_server(&mut conn);
    split.server_accept_ns += t.elapsed().as_nanos();

    let t = Instant::now();
    conn.server.write_tls(&mut conn.s2c).unwrap();
    split.server_flight_ns += t.elapsed().as_nanos();

    let t = Instant::now();
    deliver_to_client(&mut conn);
    conn.client.write_tls(&mut conn.c2s).unwrap();
    split.client_flight_ns += t.elapsed().as_nanos();

    let t = Instant::now();
    deliver_to_server(&mut conn);
    split.server_finished_ns += t.elapsed().as_nanos();

    transfer(&mut conn);
    assert!(
        !conn.client.is_handshaking() && !conn.server.is_handshaking(),
        "handshake did not converge"
    );
    split
}

fn read_exact_app<R: Read>(mut r: R, mut len: usize, buf: &mut [u8]) {
    while len > 0 {
        let n = r.read(&mut buf[..len]).unwrap();
        if n == 0 {
            panic!("short app read");
        }
        len -= n;
    }
}

/// One app-data iteration: write `size` bytes in `dir`, transfer, read them
/// back on the peer. `dir`: 0 = c2s, 1 = s2c, 2 = ping-pong (both).
fn app_iter(conn: &mut Conn, dir: u8, size: usize, payload: &[u8], recv: &mut [u8]) {
    match dir {
        0 => {
            conn.client.writer().write_all(&payload[..size]).unwrap();
            transfer(conn);
            read_exact_app(conn.server.reader(), size, recv);
        }
        1 => {
            conn.server.writer().write_all(&payload[..size]).unwrap();
            transfer(conn);
            read_exact_app(conn.client.reader(), size, recv);
        }
        _ => {
            conn.client.writer().write_all(&payload[..size]).unwrap();
            transfer(conn);
            read_exact_app(conn.server.reader(), size, recv);
            conn.server.writer().write_all(&payload[..size]).unwrap();
            transfer(conn);
            read_exact_app(conn.client.reader(), size, recv);
        }
    }
    black_box(&recv[..size]);
}

/// Predict the next iteration count to reach `goal_ns`, mirroring the
/// `benchmark` package's `predictN`: scale by observed throughput, add 20%
/// headroom, clamp to [last+1, 100*last] and the global cap.
fn predict_n(goal_ns: u64, prev_iters: u64, prev_ns: u64, last: u64) -> u64 {
    let prev_ns = if prev_ns == 0 { 1 } else { prev_ns };
    let mut n = goal_ns.saturating_mul(prev_iters) / prev_ns;
    n += n / 5;
    n = n.min(100 * last);
    n = n.max(last + 1);
    n.min(MAX_PREDICT_ITERS)
}

/// Run `n` iterations of `body`, returning total elapsed nanoseconds.
fn time_batch<F: FnMut()>(n: u64, mut body: F) -> u64 {
    let start = Instant::now();
    for _ in 0..n {
        body();
    }
    start.elapsed().as_nanos() as u64
}

/// Calibrate iteration count to `benchtime` and return `(n, total_ns)` for the
/// final batch. Matches the `benchmark` package's launch loop: run 1, then
/// grow n via `predict_n` until a batch reaches the goal duration.
fn calibrate<F: FnMut()>(benchtime: Benchtime, mut body: F) -> (u64, u64) {
    match benchtime {
        Benchtime::Count(n) => {
            let t = time_batch(n, &mut body);
            (n, t)
        }
        Benchtime::Duration(goal) => {
            let mut n: u64 = 1;
            let mut t = time_batch(1, &mut body);
            while t < goal && n < MAX_PREDICT_ITERS {
                let last = n;
                n = predict_n(goal, n, t, last);
                t = time_batch(n, &mut body);
            }
            (n, t)
        }
    }
}

/// Format `ns_per_op` with the same width tiers as the `benchmark` package's
/// `prettyPrint`, so columns line up with the Zig-side output.
fn pretty_ns_per_op(ns: f64) -> String {
    let y = ns.abs();
    if y == 0.0 || y >= 999.95 {
        format!("{ns:>10.0} ns/op")
    } else if y >= 99.995 {
        format!("{ns:>12.1} ns/op")
    } else if y >= 9.9995 {
        format!("{ns:>13.2} ns/op")
    } else if y >= 0.99995 {
        format!("{ns:>14.3} ns/op")
    } else if y >= 0.099995 {
        format!("{ns:>15.4} ns/op")
    } else if y >= 0.0099995 {
        format!("{ns:>16.5} ns/op")
    } else if y >= 0.00099995 {
        format!("{ns:>17.6} ns/op")
    } else {
        format!("{ns:>18.7} ns/op")
    }
}

/// Throughput in decimal MB/s, matching the `benchmark` package's `mbPerSec`:
/// `(bytes * n / 1e6) / seconds`.
fn mb_per_sec(bytes_per_op: u64, n: u64, total_ns: u64) -> f64 {
    if bytes_per_op == 0 || total_ns == 0 || n == 0 {
        return 0.0;
    }
    let bytes = bytes_per_op as f64;
    let n = n as f64;
    let seconds = total_ns as f64 / 1e9;
    (bytes * n / 1e6) / seconds
}

/// Emit one Go-testing-style benchmark line for a sample.
fn emit_sample(row: &str, suite: &str, size: usize, n: u64, total_ns: u64, bytes_per_op: u64) {
    let name = full_name(row, suite, size);
    let ns_per_op = total_ns as f64 / n as f64;
    let mut line = format!("{}\t{n:>8}\t{}", name, pretty_ns_per_op(ns_per_op));
    let mbs = mb_per_sec(bytes_per_op, n, total_ns);
    if mbs != 0.0 {
        line.push_str(&format!("\t{mbs:>7.2} MB/s"));
    }
    println!("{line}");
}

/// Run `count` calibrated samples of a benchmark body and emit one line each.
/// Use this when each iteration is self-contained (e.g. a full handshake).
fn run_samples<F: FnMut()>(
    args: &Args,
    row: &str,
    suite: &str,
    size: usize,
    bytes_per_op: u64,
    mut body: F,
) {
    for _ in 0..args.count {
        let (n, total_ns) = calibrate(args.benchtime, &mut body);
        emit_sample(row, suite, size, n, total_ns, bytes_per_op);
    }
}

/// Run `count` calibrated samples where each sample establishes shared state
/// once (e.g. a connected TLS session) and reuses it across the timed
/// iterations. `setup` runs once per sample outside the timed region; `body`
/// runs per iteration with `&mut` access to the state. This is what keeps
/// connection/handshake cost out of the steady-state app-data measurement.
fn run_samples_setup<S, Setup, Body>(
    args: &Args,
    row: &str,
    suite: &str,
    size: usize,
    bytes_per_op: u64,
    mut setup: Setup,
    mut body: Body,
) where
    Setup: FnMut() -> S,
    Body: FnMut(&mut S),
{
    for _ in 0..args.count {
        let mut state = setup();
        let (n, total_ns) = calibrate(args.benchtime, || body(&mut state));
        emit_sample(row, suite, size, n, total_ns, bytes_per_op);
    }
}

fn list_rows() {
    for (suite, _) in SUITES {
        for row in ROWS {
            if row.starts_with("App") {
                for &size in SIZES {
                    println!("{}", full_name(row, suite, size));
                }
            } else {
                println!("{}", full_name(row, suite, HANDSHAKE_SIZE));
            }
        }
    }
}

fn main() {
    let args = parse_args();
    if args.list {
        list_rows();
        return;
    }
    println!("# rustls in-memory benchmark");
    let payload = (0..16384)
        .map(|i| (0x42u8).wrapping_add(i as u8))
        .collect::<Vec<_>>();
    let mut recv = vec![0u8; 16384];
    for (suite_name, suite) in SUITES {
        let (client, server) = load_config(*suite);

        // Full handshake, wall clock, both sides together. One iteration =
        // one complete handshake from fresh connections to converged.
        if row_selected(&args, "Handshake", suite_name, HANDSHAKE_SIZE) {
            run_samples(&args, "Handshake", suite_name, HANDSHAKE_SIZE, 0, || {
                black_box(connected(&client, &server));
            });
        }

        // Split handshake rows. Not comparable to the ztls/libssl Handshake
        // row (different measurement boundary) and excluded from the
        // comparable benchstat set, but share the same calibration/sampling.
        // Calibrate the split bundle as a unit: one iteration runs all five
        // split timings, so the batch length tracks a full handshake.
        let split_rows = [
            "HandshakeClientStart",
            "HandshakeServerAccept",
            "HandshakeServerFlight",
            "HandshakeClientFlight",
            "HandshakeServerFinished",
        ];
        if split_rows
            .iter()
            .any(|row| row_selected(&args, row, suite_name, HANDSHAKE_SIZE))
        {
            for _ in 0..args.count {
                let mut total = HandshakeSplit::default();
                let (n, _total_ns) = calibrate(args.benchtime, || {
                    let s = handshake_split(&client, &server);
                    total.client_start_ns += s.client_start_ns;
                    total.server_accept_ns += s.server_accept_ns;
                    total.server_flight_ns += s.server_flight_ns;
                    total.client_flight_ns += s.client_flight_ns;
                    total.server_finished_ns += s.server_finished_ns;
                });
                let splits = [
                    ("HandshakeClientStart", total.client_start_ns),
                    ("HandshakeServerAccept", total.server_accept_ns),
                    ("HandshakeServerFlight", total.server_flight_ns),
                    ("HandshakeClientFlight", total.client_flight_ns),
                    ("HandshakeServerFinished", total.server_finished_ns),
                ];
                for (row, ns) in splits {
                    if row_selected(&args, row, suite_name, HANDSHAKE_SIZE) {
                        emit_sample(row, suite_name, HANDSHAKE_SIZE, n, ns as u64, 0);
                    }
                }
            }
        }

        for &size in SIZES {
            if row_selected(&args, "AppClientToServer", suite_name, size) {
                run_samples_setup(
                    &args,
                    "AppClientToServer",
                    suite_name,
                    size,
                    size as u64,
                    || connected(&client, &server),
                    |conn| app_iter(conn, 0, size, &payload, &mut recv),
                );
            }
            if row_selected(&args, "AppServerToClient", suite_name, size) {
                run_samples_setup(
                    &args,
                    "AppServerToClient",
                    suite_name,
                    size,
                    size as u64,
                    || connected(&client, &server),
                    |conn| app_iter(conn, 1, size, &payload, &mut recv),
                );
            }
            if row_selected(&args, "AppPingPong", suite_name, size) {
                let bytes = (size * 2) as u64;
                run_samples_setup(
                    &args,
                    "AppPingPong",
                    suite_name,
                    size,
                    bytes,
                    || connected(&client, &server),
                    |conn| app_iter(conn, 2, size, &payload, &mut recv),
                );
            }
        }
    }
}
