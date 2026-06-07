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
const TARGET_BYTES: usize = 16 * 1024 * 1024;
const HANDSHAKE_ITERATIONS: usize = 256;

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

#[derive(Default)]
struct Args {
    filter: Option<String>,
    bench: Option<String>,
    suite: Option<String>,
    size: Option<usize>,
    list: bool,
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
    let mut it = env::args().skip(1);
    while let Some(arg) = it.next() {
        let (key, inline) = arg
            .split_once('=')
            .map_or((arg.as_str(), None), |(k, v)| (k, Some(v.to_string())));
        match key {
            "--list" => args.list = true,
            "--filter" => {
                args.filter =
                    Some(inline.unwrap_or_else(|| it.next().expect("missing --filter value")))
            }
            "--bench" => {
                args.bench =
                    Some(inline.unwrap_or_else(|| it.next().expect("missing --bench value")))
            }
            "--suite" => {
                args.suite =
                    Some(inline.unwrap_or_else(|| it.next().expect("missing --suite value")))
            }
            "--size" => {
                args.size = Some(
                    inline
                        .unwrap_or_else(|| it.next().expect("missing --size value"))
                        .parse()
                        .expect("invalid --size"),
                )
            }
            _ => panic!("unknown argument: {arg}"),
        }
    }
    args
}

fn contains(h: &str, n: &str) -> bool {
    h.to_ascii_lowercase().contains(&n.to_ascii_lowercase())
}
fn matches(args: &Args, bench: &str, suite: &str, size: usize) -> bool {
    if args
        .bench
        .as_ref()
        .is_some_and(|b| !bench.eq_ignore_ascii_case(b))
    {
        return false;
    }
    if args.suite.as_ref().is_some_and(|s| !contains(suite, s)) {
        return false;
    }
    if args.size.is_some_and(|s| s != size) {
        return false;
    }
    args.filter
        .as_ref()
        .map_or(true, |f| contains(bench, f) || contains(suite, f))
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
/// Returns true if any work was done (bytes written or delivered) so callers
/// can drive convergence by looping until false.
fn transfer_step(conn: &mut Conn) -> bool {
    let mut progress = false;
    // Each side writes whatever it has queued internally onto the wire buffer.
    if conn.client.write_tls(&mut conn.c2s).unwrap() > 0 {
        progress = true;
    }
    if conn.server.write_tls(&mut conn.s2c).unwrap() > 0 {
        progress = true;
    }
    // Deliver client→server bytes. read_tls may consume only one TLS record,
    // so keep the cursor alive until every queued wire byte has been handed to
    // rustls instead of dropping unread tail bytes on large writes.
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
    // Deliver server→client bytes.
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

/// Like transfer_step but accumulates wall time spent on client-side work
/// and server-side work separately. Used to produce the side-specific
/// handshake timing rows.
fn transfer_step_timed(conn: &mut Conn, client_ns: &mut u128, server_ns: &mut u128) -> bool {
    let mut progress = false;

    let t = Instant::now();
    let w = conn.client.write_tls(&mut conn.c2s).unwrap();
    *client_ns += t.elapsed().as_nanos();
    if w > 0 {
        progress = true;
    }

    let t = Instant::now();
    let w = conn.server.write_tls(&mut conn.s2c).unwrap();
    *server_ns += t.elapsed().as_nanos();
    if w > 0 {
        progress = true;
    }

    if !conn.c2s.is_empty() {
        let t = Instant::now();
        let wire = std::mem::take(&mut conn.c2s);
        let wire_len = wire.len() as u64;
        let mut cursor = Cursor::new(wire);
        while cursor.position() < wire_len {
            if conn.server.read_tls(&mut cursor).unwrap() == 0 {
                break;
            }
            conn.server.process_new_packets().unwrap();
        }
        *server_ns += t.elapsed().as_nanos();
        progress = true;
    }

    if !conn.s2c.is_empty() {
        let t = Instant::now();
        let wire = std::mem::take(&mut conn.s2c);
        let wire_len = wire.len() as u64;
        let mut cursor = Cursor::new(wire);
        while cursor.position() < wire_len {
            if conn.client.read_tls(&mut cursor).unwrap() == 0 {
                break;
            }
            conn.client.process_new_packets().unwrap();
        }
        *client_ns += t.elapsed().as_nanos();
        progress = true;
    }

    progress
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

/// Run one full handshake and return (client_ns, server_ns): cumulative wall
/// time attributed to client-side work and server-side work respectively.
fn handshake_split(c: &Arc<ClientConfig>, s: &Arc<ServerConfig>) -> (u128, u128) {
    let mut conn = make_conn(c, s);
    let mut client_ns = 0u128;
    let mut server_ns = 0u128;
    while transfer_step_timed(&mut conn, &mut client_ns, &mut server_ns) {}
    assert!(
        !conn.client.is_handshaking() && !conn.server.is_handshaking(),
        "handshake did not converge"
    );
    (client_ns, server_ns)
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

fn bench_app(
    c: &Arc<ClientConfig>,
    s: &Arc<ServerConfig>,
    size: usize,
    iters: usize,
    dir: u8,
    payload: &[u8],
    recv: &mut [u8],
) -> u128 {
    let mut conn = connected(c, s);
    let start = Instant::now();
    for _ in 0..iters {
        match dir {
            0 => {
                conn.client.writer().write_all(&payload[..size]).unwrap();
                transfer(&mut conn);
                read_exact_app(conn.server.reader(), size, recv);
            }
            1 => {
                conn.server.writer().write_all(&payload[..size]).unwrap();
                transfer(&mut conn);
                read_exact_app(conn.client.reader(), size, recv);
            }
            _ => {
                conn.client.writer().write_all(&payload[..size]).unwrap();
                transfer(&mut conn);
                read_exact_app(conn.server.reader(), size, recv);
                conn.server.writer().write_all(&payload[..size]).unwrap();
                transfer(&mut conn);
                read_exact_app(conn.client.reader(), size, recv);
            }
        }
        black_box(&recv[..size]);
    }
    start.elapsed().as_nanos()
}

fn mib_per_sec(bytes: usize, ns: u128) -> f64 {
    bytes as f64 / 1048576.0 / (ns as f64 / 1e9)
}
fn ops_per_sec(iters: usize, ns: u128) -> f64 {
    iters as f64 / (ns as f64 / 1e9)
}

fn main() {
    let args = parse_args();
    if args.list {
        for (suite, _) in SUITES {
            for row in [
                "rustls_handshake",
                "rustls_handshake_client_total",
                "rustls_handshake_server_total",
                "rustls_app_client_to_server",
                "rustls_app_server_to_client",
                "rustls_app_ping_pong",
            ] {
                println!("{row},{suite}");
            }
        }
        return;
    }
    println!("# rustls in-memory benchmark");
    println!("benchmark,suite,size,iterations,bytes,elapsed_ns,mib_per_sec");
    let payload = (0..16384)
        .map(|i| (0x42u8).wrapping_add(i as u8))
        .collect::<Vec<_>>();
    let mut recv = vec![0u8; 16384];
    for (suite_name, suite) in SUITES {
        let (client, server) = load_config(*suite);

        // Full handshake elapsed time (wall clock, both sides together).
        if matches(&args, "rustls_handshake", suite_name, 1) {
            let start = Instant::now();
            for _ in 0..HANDSHAKE_ITERATIONS {
                black_box(connected(&client, &server));
            }
            let ns = start.elapsed().as_nanos();
            println!(
                "rustls_handshake,{suite_name},1,{HANDSHAKE_ITERATIONS},{HANDSHAKE_ITERATIONS},{ns},{:.2}",
                ops_per_sec(HANDSHAKE_ITERATIONS, ns)
            );
        }

        // Side-specific handshake timing: measure cumulative time attributed
        // to client-side vs server-side work across all iterations, using
        // transfer_step_timed to partition each step's cost.
        let want_client = matches(&args, "rustls_handshake_client_total", suite_name, 1);
        let want_server = matches(&args, "rustls_handshake_server_total", suite_name, 1);
        if want_client || want_server {
            let mut total_client_ns = 0u128;
            let mut total_server_ns = 0u128;
            for _ in 0..HANDSHAKE_ITERATIONS {
                let (c, s) = handshake_split(&client, &server);
                total_client_ns += c;
                total_server_ns += s;
            }
            if want_client {
                println!(
                    "rustls_handshake_client_total,{suite_name},1,{HANDSHAKE_ITERATIONS},{HANDSHAKE_ITERATIONS},{total_client_ns},{:.2}",
                    ops_per_sec(HANDSHAKE_ITERATIONS, total_client_ns)
                );
            }
            if want_server {
                println!(
                    "rustls_handshake_server_total,{suite_name},1,{HANDSHAKE_ITERATIONS},{HANDSHAKE_ITERATIONS},{total_server_ns},{:.2}",
                    ops_per_sec(HANDSHAKE_ITERATIONS, total_server_ns)
                );
            }
        }

        for &size in SIZES {
            let iters = (TARGET_BYTES / size).max(256);
            if matches(&args, "rustls_app_client_to_server", suite_name, size) {
                let ns = bench_app(&client, &server, size, iters, 0, &payload, &mut recv);
                println!(
                    "rustls_app_client_to_server,{suite_name},{size},{iters},{},{ns},{:.2}",
                    iters * size,
                    mib_per_sec(iters * size, ns)
                );
            }
            if matches(&args, "rustls_app_server_to_client", suite_name, size) {
                let ns = bench_app(&client, &server, size, iters, 1, &payload, &mut recv);
                println!(
                    "rustls_app_server_to_client,{suite_name},{size},{iters},{},{ns},{:.2}",
                    iters * size,
                    mib_per_sec(iters * size, ns)
                );
            }
            if matches(&args, "rustls_app_ping_pong", suite_name, size) {
                let ns = bench_app(&client, &server, size, iters, 2, &payload, &mut recv);
                println!(
                    "rustls_app_ping_pong,{suite_name},{size},{iters},{},{ns},{:.2}",
                    iters * size * 2,
                    mib_per_sec(iters * size * 2, ns)
                );
            }
        }
    }
}
