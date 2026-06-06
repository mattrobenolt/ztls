#include <openssl/ssl.h>
#include <openssl/err.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <strings.h>
#include <time.h>

static const size_t sizes[] = {16, 128, 1350, 8192, 16384};
static const size_t target_bytes = 16u * 1024u * 1024u;
static const size_t handshake_iterations = 256;
static const char *cert_path = "tests/fixtures/server.crt";
static const char *key_path = "tests/fixtures/server.key";

typedef struct { const char *name; } suite_t;
static const suite_t suites[] = {
    {"TLS_AES_128_GCM_SHA256"},
    {"TLS_AES_256_GCM_SHA384"},
    {"TLS_CHACHA20_POLY1305_SHA256"},
};

typedef struct { const char *filter; const char *bench; const char *suite; size_t size; int has_size; int list; } args_t;
typedef struct { SSL_CTX *client_ctx; SSL_CTX *server_ctx; } ctx_pair_t;
typedef struct { SSL *client; SSL *server; } conn_t;

static uint64_t now_ns(void) {
    struct timespec ts;
    clock_gettime(CLOCK_MONOTONIC, &ts);
    return (uint64_t)ts.tv_sec * 1000000000ull + (uint64_t)ts.tv_nsec;
}

static int contains_ignore_case(const char *haystack, const char *needle) {
    if (!needle || !*needle) return 1;
    size_t n = strlen(needle);
    for (const char *p = haystack; *p; p++) if (strncasecmp(p, needle, n) == 0) return 1;
    return 0;
}

static int matches(const args_t *args, const char *bench, const char *suite, size_t size) {
    if (args->bench && !contains_ignore_case(bench, args->bench)) return 0;
    if (args->suite && !contains_ignore_case(suite, args->suite)) return 0;
    if (args->has_size && args->size != size) return 0;
    return !args->filter || contains_ignore_case(bench, args->filter) || contains_ignore_case(suite, args->filter);
}

static args_t parse_args(int argc, char **argv) {
    args_t args = {0};
    for (int i = 1; i < argc; i++) {
        if (strcmp(argv[i], "--list") == 0) args.list = 1;
        else if (strcmp(argv[i], "--filter") == 0) {
            if (++i >= argc) { fprintf(stderr, "missing --filter value\n"); exit(2); }
            args.filter = argv[i];
        } else if (strncmp(argv[i], "--filter=", 9) == 0) args.filter = argv[i] + 9;
        else if (strcmp(argv[i], "--bench") == 0) {
            if (++i >= argc) { fprintf(stderr, "missing --bench value\n"); exit(2); }
            args.bench = argv[i];
        } else if (strncmp(argv[i], "--bench=", 8) == 0) args.bench = argv[i] + 8;
        else if (strcmp(argv[i], "--suite") == 0) {
            if (++i >= argc) { fprintf(stderr, "missing --suite value\n"); exit(2); }
            args.suite = argv[i];
        } else if (strncmp(argv[i], "--suite=", 8) == 0) args.suite = argv[i] + 8;
        else if (strcmp(argv[i], "--size") == 0) {
            if (++i >= argc) { fprintf(stderr, "missing --size value\n"); exit(2); }
            args.size = strtoull(argv[i], NULL, 10);
            args.has_size = 1;
        } else if (strncmp(argv[i], "--size=", 7) == 0) {
            args.size = strtoull(argv[i] + 7, NULL, 10);
            args.has_size = 1;
        } else { fprintf(stderr, "unknown argument: %s\n", argv[i]); exit(2); }
    }
    return args;
}

static void check_ssl(int ok, const char *what) {
    if (ok == 1) return;
    fprintf(stderr, "%s failed\n", what);
    ERR_print_errors_fp(stderr);
    abort();
}

static ctx_pair_t make_contexts(const char *suite) {
    ctx_pair_t p = {0};
    p.client_ctx = SSL_CTX_new(TLS_method());
    p.server_ctx = SSL_CTX_new(TLS_method());
    if (!p.client_ctx || !p.server_ctx) abort();

    SSL_CTX_set_min_proto_version(p.client_ctx, TLS1_3_VERSION);
    SSL_CTX_set_max_proto_version(p.client_ctx, TLS1_3_VERSION);
    SSL_CTX_set_min_proto_version(p.server_ctx, TLS1_3_VERSION);
    SSL_CTX_set_max_proto_version(p.server_ctx, TLS1_3_VERSION);
    check_ssl(SSL_CTX_set_ciphersuites(p.client_ctx, suite), "client ciphersuites");
    check_ssl(SSL_CTX_set_ciphersuites(p.server_ctx, suite), "server ciphersuites");
    SSL_CTX_set_verify(p.client_ctx, SSL_VERIFY_NONE, NULL);
    SSL_CTX_set_verify(p.server_ctx, SSL_VERIFY_NONE, NULL);
    SSL_CTX_set_num_tickets(p.server_ctx, 0);

    check_ssl(SSL_CTX_use_certificate_file(p.server_ctx, cert_path, SSL_FILETYPE_PEM), "load cert");
    check_ssl(SSL_CTX_use_PrivateKey_file(p.server_ctx, key_path, SSL_FILETYPE_PEM), "load key");
    check_ssl(SSL_CTX_check_private_key(p.server_ctx), "check key");
    return p;
}

static void free_contexts(ctx_pair_t *p) {
    SSL_CTX_free(p->client_ctx);
    SSL_CTX_free(p->server_ctx);
}

static conn_t make_conn(ctx_pair_t *ctx) {
    conn_t c = {0};
    c.client = SSL_new(ctx->client_ctx);
    c.server = SSL_new(ctx->server_ctx);
    if (!c.client || !c.server) abort();

    BIO *client_read = NULL, *server_write = NULL, *server_read = NULL, *client_write = NULL;
    check_ssl(BIO_new_bio_pair(&client_read, 0, &server_write, 0), "bio pair 1");
    check_ssl(BIO_new_bio_pair(&server_read, 0, &client_write, 0), "bio pair 2");
    SSL_set_bio(c.client, client_read, client_write);
    SSL_set_bio(c.server, server_read, server_write);
    SSL_set_connect_state(c.client);
    SSL_set_accept_state(c.server);
    return c;
}

static void free_conn(conn_t *c) {
    SSL_free(c->client);
    SSL_free(c->server);
}

static int step_handshake(SSL *ssl) {
    int rc = SSL_do_handshake(ssl);
    if (rc == 1) return 1;
    int err = SSL_get_error(ssl, rc);
    if (err == SSL_ERROR_WANT_READ || err == SSL_ERROR_WANT_WRITE) return 0;
    ERR_print_errors_fp(stderr);
    abort();
}

static void handshake(conn_t *c) {
    for (int i = 0; i < 10000; i++) {
        int cd = SSL_is_init_finished(c->client) || step_handshake(c->client);
        int sd = SSL_is_init_finished(c->server) || step_handshake(c->server);
        if (cd && sd) return;
    }
    fprintf(stderr, "handshake did not converge\n");
    abort();
}

static conn_t connected(ctx_pair_t *ctx) {
    conn_t c = make_conn(ctx);
    handshake(&c);
    return c;
}

static void fill(uint8_t *buf, size_t len, uint8_t seed) {
    for (size_t i = 0; i < len; i++) buf[i] = (uint8_t)(seed + i);
}

static void ssl_write_all(SSL *ssl, const uint8_t *buf, size_t len) {
    size_t done = 0;
    while (done < len) {
        int rc = SSL_write(ssl, buf + done, (int)(len - done));
        if (rc > 0) { done += (size_t)rc; continue; }
        int err = SSL_get_error(ssl, rc);
        if (err == SSL_ERROR_WANT_READ || err == SSL_ERROR_WANT_WRITE) continue;
        ERR_print_errors_fp(stderr);
        abort();
    }
}

static void ssl_read_exact(SSL *ssl, uint8_t *buf, size_t len) {
    size_t done = 0;
    while (done < len) {
        int rc = SSL_read(ssl, buf + done, (int)(len - done));
        if (rc > 0) { done += (size_t)rc; continue; }
        int err = SSL_get_error(ssl, rc);
        if (err == SSL_ERROR_WANT_READ || err == SSL_ERROR_WANT_WRITE) continue;
        ERR_print_errors_fp(stderr);
        abort();
    }
}

static double mib_per_sec(size_t bytes, uint64_t ns) {
    double mib = (double)bytes / (1024.0 * 1024.0);
    double sec = (double)ns / 1000000000.0;
    return mib / sec;
}

static double ops_per_sec(size_t iterations, uint64_t ns) {
    return (double)iterations / ((double)ns / 1000000000.0);
}

static uint64_t bench_handshake(ctx_pair_t *ctx) {
    conn_t warm = connected(ctx);
    free_conn(&warm);
    uint64_t start = now_ns();
    for (size_t i = 0; i < handshake_iterations; i++) {
        conn_t c = connected(ctx);
        free_conn(&c);
    }
    return now_ns() - start;
}

typedef enum { C2S, S2C, PINGPONG } direction_t;

static uint64_t bench_app(ctx_pair_t *ctx, size_t size, size_t iterations, direction_t dir, uint8_t *payload, uint8_t *recvbuf) {
    conn_t c = connected(ctx);
    ssl_write_all(c.client, payload, size);
    ssl_read_exact(c.server, recvbuf, size);

    uint64_t start = now_ns();
    for (size_t i = 0; i < iterations; i++) {
        switch (dir) {
        case C2S:
            ssl_write_all(c.client, payload, size);
            ssl_read_exact(c.server, recvbuf, size);
            break;
        case S2C:
            ssl_write_all(c.server, payload, size);
            ssl_read_exact(c.client, recvbuf, size);
            break;
        case PINGPONG:
            ssl_write_all(c.client, payload, size);
            ssl_read_exact(c.server, recvbuf, size);
            ssl_write_all(c.server, payload, size);
            ssl_read_exact(c.client, recvbuf, size);
            break;
        }
    }
    uint64_t elapsed = now_ns() - start;
    free_conn(&c);
    return elapsed;
}

int main(int argc, char **argv) {
    args_t args = parse_args(argc, argv);
    if (args.list) {
        for (size_t i = 0; i < sizeof(suites) / sizeof(suites[0]); i++) {
            printf("openssl_bio_handshake,%s\n", suites[i].name);
            printf("openssl_bio_app_client_to_server,%s\n", suites[i].name);
            printf("openssl_bio_app_server_to_client,%s\n", suites[i].name);
            printf("openssl_bio_app_ping_pong,%s\n", suites[i].name);
        }
        return 0;
    }

    SSL_library_init();
    SSL_load_error_strings();

    printf("# OpenSSL libssl memory BIO benchmark\n");
    printf("# openssl %s\n", OpenSSL_version(OPENSSL_VERSION));
    printf("benchmark,suite,size,iterations,bytes,elapsed_ns,mib_per_sec\n");

    uint8_t *payload = malloc(16384);
    uint8_t *recvbuf = malloc(16384);
    if (!payload || !recvbuf) abort();
    fill(payload, 16384, 0x42);

    for (size_t s = 0; s < sizeof(suites) / sizeof(suites[0]); s++) {
        ctx_pair_t ctx = make_contexts(suites[s].name);
        if (matches(&args, "openssl_bio_handshake", suites[s].name, 1)) {
            uint64_t ns = bench_handshake(&ctx);
            printf("openssl_bio_handshake,%s,1,%zu,%zu,%llu,%.2f\n", suites[s].name, handshake_iterations, handshake_iterations, (unsigned long long)ns, ops_per_sec(handshake_iterations, ns));
            fflush(stdout);
        }
        for (size_t z = 0; z < sizeof(sizes) / sizeof(sizes[0]); z++) {
            size_t size = sizes[z];
            size_t iterations = target_bytes / size;
            if (iterations < 256) iterations = 256;
            size_t bytes = iterations * size;
            if (matches(&args, "openssl_bio_app_client_to_server", suites[s].name, size)) {
                uint64_t ns = bench_app(&ctx, size, iterations, C2S, payload, recvbuf);
                printf("openssl_bio_app_client_to_server,%s,%zu,%zu,%zu,%llu,%.2f\n", suites[s].name, size, iterations, bytes, (unsigned long long)ns, mib_per_sec(bytes, ns));
                fflush(stdout);
            }
            if (matches(&args, "openssl_bio_app_server_to_client", suites[s].name, size)) {
                uint64_t ns = bench_app(&ctx, size, iterations, S2C, payload, recvbuf);
                printf("openssl_bio_app_server_to_client,%s,%zu,%zu,%zu,%llu,%.2f\n", suites[s].name, size, iterations, bytes, (unsigned long long)ns, mib_per_sec(bytes, ns));
                fflush(stdout);
            }
            if (matches(&args, "openssl_bio_app_ping_pong", suites[s].name, size)) {
                uint64_t ns = bench_app(&ctx, size, iterations, PINGPONG, payload, recvbuf);
                printf("openssl_bio_app_ping_pong,%s,%zu,%zu,%zu,%llu,%.2f\n", suites[s].name, size, iterations, bytes * 2, (unsigned long long)ns, mib_per_sec(bytes * 2, ns));
                fflush(stdout);
            }
        }
        free_contexts(&ctx);
    }
    free(payload);
    free(recvbuf);
    return 0;
}
