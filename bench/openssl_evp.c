#include <openssl/evp.h>
#include <openssl/crypto.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <strings.h>
#include <time.h>

static const size_t sizes[] = {16, 128, 1350, 8192, 16384};
static const size_t target_bytes = 16u * 1024u * 1024u;
static const uint8_t aad[5] = {0x17, 0x03, 0x03, 0x00, 0x00};

typedef struct {
    const char *name;
    const EVP_CIPHER *(*cipher)(void);
    size_t key_len;
} suite_t;

static const suite_t suites[] = {
    {"TLS_AES_128_GCM_SHA256", EVP_aes_128_gcm, 16},
    {"TLS_AES_256_GCM_SHA384", EVP_aes_256_gcm, 32},
    {"TLS_CHACHA20_POLY1305_SHA256", EVP_chacha20_poly1305, 32},
};

typedef struct {
    const char *filter;
    int list;
} args_t;

static uint64_t now_ns(void) {
    struct timespec ts;
    clock_gettime(CLOCK_MONOTONIC, &ts);
    return (uint64_t)ts.tv_sec * 1000000000ull + (uint64_t)ts.tv_nsec;
}

static int contains_ignore_case(const char *haystack, const char *needle) {
    if (needle == NULL) return 1;
    if (*needle == '\0') return 1;
    size_t n = strlen(needle);
    for (const char *p = haystack; *p; p++) {
        if (strncasecmp(p, needle, n) == 0) return 1;
    }
    return 0;
}

static int matches(const args_t *args, const char *bench, const char *suite) {
    return args->filter == NULL || contains_ignore_case(bench, args->filter) || contains_ignore_case(suite, args->filter);
}

static args_t parse_args(int argc, char **argv) {
    args_t args = {0};
    for (int i = 1; i < argc; i++) {
        if (strcmp(argv[i], "--list") == 0) {
            args.list = 1;
        } else if (strcmp(argv[i], "--filter") == 0) {
            if (++i >= argc) { fprintf(stderr, "missing --filter value\n"); exit(2); }
            args.filter = argv[i];
        } else if (strncmp(argv[i], "--filter=", 9) == 0) {
            args.filter = argv[i] + 9;
        } else {
            fprintf(stderr, "unknown argument: %s\n", argv[i]);
            exit(2);
        }
    }
    return args;
}

static void fill(uint8_t *buf, size_t len, uint8_t seed) {
    for (size_t i = 0; i < len; i++) buf[i] = (uint8_t)(seed + i);
}

static int evp_encrypt_once(EVP_CIPHER_CTX *ctx, const suite_t *suite, const uint8_t *key, const uint8_t *iv, const uint8_t *in, uint8_t *out, size_t size, uint8_t tag[16]) {
    int len = 0;
    int out_len = 0;
    if (EVP_EncryptInit_ex(ctx, suite->cipher(), NULL, NULL, NULL) != 1) return 0;
    if (EVP_CIPHER_CTX_ctrl(ctx, EVP_CTRL_AEAD_SET_IVLEN, 12, NULL) != 1) return 0;
    if (EVP_EncryptInit_ex(ctx, NULL, NULL, key, iv) != 1) return 0;
    if (EVP_EncryptUpdate(ctx, NULL, &len, aad, sizeof(aad)) != 1) return 0;
    if (EVP_EncryptUpdate(ctx, out, &len, in, (int)size) != 1) return 0;
    out_len += len;
    if (EVP_EncryptFinal_ex(ctx, out + out_len, &len) != 1) return 0;
    if (EVP_CIPHER_CTX_ctrl(ctx, EVP_CTRL_AEAD_GET_TAG, 16, tag) != 1) return 0;
    return 1;
}

static int evp_decrypt_once(EVP_CIPHER_CTX *ctx, const suite_t *suite, const uint8_t *key, const uint8_t *iv, const uint8_t *in, uint8_t *out, size_t size, const uint8_t tag[16]) {
    int len = 0;
    int out_len = 0;
    if (EVP_DecryptInit_ex(ctx, suite->cipher(), NULL, NULL, NULL) != 1) return 0;
    if (EVP_CIPHER_CTX_ctrl(ctx, EVP_CTRL_AEAD_SET_IVLEN, 12, NULL) != 1) return 0;
    if (EVP_DecryptInit_ex(ctx, NULL, NULL, key, iv) != 1) return 0;
    if (EVP_DecryptUpdate(ctx, NULL, &len, aad, sizeof(aad)) != 1) return 0;
    if (EVP_DecryptUpdate(ctx, out, &len, in, (int)size) != 1) return 0;
    out_len += len;
    if (EVP_CIPHER_CTX_ctrl(ctx, EVP_CTRL_AEAD_SET_TAG, 16, (void *)tag) != 1) return 0;
    if (EVP_DecryptFinal_ex(ctx, out + out_len, &len) != 1) return 0;
    return 1;
}

static uint64_t bench_encrypt(const suite_t *suite, size_t size, size_t iterations, uint8_t *in, uint8_t *out, uint8_t *key, uint8_t *iv) {
    EVP_CIPHER_CTX *ctx = EVP_CIPHER_CTX_new();
    if (ctx == NULL) abort();
    uint8_t tag[16];
    for (size_t i = 0; i < 32; i++) if (!evp_encrypt_once(ctx, suite, key, iv, in, out, size, tag)) abort();
    uint64_t start = now_ns();
    for (size_t i = 0; i < iterations; i++) {
        if (!evp_encrypt_once(ctx, suite, key, iv, in, out, size, tag)) abort();
        OPENSSL_cleanse(tag, sizeof(tag));
    }
    uint64_t elapsed = now_ns() - start;
    EVP_CIPHER_CTX_free(ctx);
    return elapsed;
}

static uint64_t bench_decrypt(const suite_t *suite, size_t size, size_t iterations, uint8_t *plain, uint8_t *ciphertext, uint8_t *out, uint8_t *key, uint8_t *iv) {
    EVP_CIPHER_CTX *ctx = EVP_CIPHER_CTX_new();
    if (ctx == NULL) abort();
    uint8_t tag[16];
    if (!evp_encrypt_once(ctx, suite, key, iv, plain, ciphertext, size, tag)) abort();
    for (size_t i = 0; i < 32; i++) if (!evp_decrypt_once(ctx, suite, key, iv, ciphertext, out, size, tag)) abort();
    uint64_t start = now_ns();
    for (size_t i = 0; i < iterations; i++) {
        if (!evp_decrypt_once(ctx, suite, key, iv, ciphertext, out, size, tag)) abort();
    }
    uint64_t elapsed = now_ns() - start;
    EVP_CIPHER_CTX_free(ctx);
    return elapsed;
}

static double mib_per_sec(size_t bytes, uint64_t ns) {
    double mib = (double)bytes / (1024.0 * 1024.0);
    double sec = (double)ns / 1000000000.0;
    return mib / sec;
}

int main(int argc, char **argv) {
    args_t args = parse_args(argc, argv);

    if (args.list) {
        for (size_t i = 0; i < sizeof(suites) / sizeof(suites[0]); i++) {
            printf("openssl_evp_encrypt,%s\n", suites[i].name);
            printf("openssl_evp_decrypt,%s\n", suites[i].name);
        }
        return 0;
    }

    printf("# OpenSSL EVP AEAD benchmark\n");
    printf("# openssl %s\n", OpenSSL_version(OPENSSL_VERSION));
    printf("benchmark,suite,size,iterations,bytes,elapsed_ns,mib_per_sec\n");

    uint8_t *plain = malloc(16384);
    uint8_t *ciphertext = malloc(16384);
    uint8_t *out = malloc(16384);
    uint8_t key[32];
    uint8_t iv[12];
    if (!plain || !ciphertext || !out) abort();
    fill(plain, 16384, 0xa5);
    fill(key, sizeof(key), 0x11);
    fill(iv, sizeof(iv), 0x22);

    for (size_t s = 0; s < sizeof(suites) / sizeof(suites[0]); s++) {
        for (size_t z = 0; z < sizeof(sizes) / sizeof(sizes[0]); z++) {
            size_t size = sizes[z];
            size_t iterations = target_bytes / size;
            if (iterations < 256) iterations = 256;
            size_t bytes = iterations * size;

            if (matches(&args, "openssl_evp_encrypt", suites[s].name)) {
                uint64_t ns = bench_encrypt(&suites[s], size, iterations, plain, ciphertext, key, iv);
                printf("openssl_evp_encrypt,%s,%zu,%zu,%zu,%llu,%.2f\n", suites[s].name, size, iterations, bytes, (unsigned long long)ns, mib_per_sec(bytes, ns));
                fflush(stdout);
            }
            if (matches(&args, "openssl_evp_decrypt", suites[s].name)) {
                uint64_t ns = bench_decrypt(&suites[s], size, iterations, plain, ciphertext, out, key, iv);
                printf("openssl_evp_decrypt,%s,%zu,%zu,%zu,%llu,%.2f\n", suites[s].name, size, iterations, bytes, (unsigned long long)ns, mib_per_sec(bytes, ns));
                fflush(stdout);
            }
        }
    }

    free(plain);
    free(ciphertext);
    free(out);
    return 0;
}
