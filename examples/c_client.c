/*
 * ztls C ABI example — minimal client lifecycle.
 *
 * Queries size/alignment, allocates an aligned buffer, initializes the client
 * with a test keypair + host name + zero random, starts the handshake, and
 * checks that the ClientHello output begins with 0x16 0x03 0x03 (TLS 1.3
 * handshake record) and has a sane length.
 *
 * Build: see just/check.just capi-ci recipe.
 */
#include "ztls.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

int main(void) {
    /* Query the opaque size/alignment at runtime. */
    size_t sz = ztls_client_size();
    size_t al = ztls_client_align();
    if (sz == 0 || al == 0) {
        fprintf(stderr, "ztls_client_size/align returned 0\n");
        return 1;
    }

    /* Allocate aligned storage. We over-allocate to satisfy the runtime
     * alignment requirement (ztls_client_align may exceed max_align_t on
     * platforms with SIMD types). */
    size_t total = sz + al;
    unsigned char *raw = malloc(total);
    if (!raw) {
        fprintf(stderr, "malloc failed for %zu bytes\n", total);
        return 1;
    }
    /* Align the pointer within the raw allocation. */
    uintptr_t addr = (uintptr_t)raw;
    uintptr_t aligned = (addr + al - 1) & ~(uintptr_t)(al - 1);
    unsigned char *client = (unsigned char *)aligned;
    memset(client, 0, sz);

    /* Test X25519 keypair (deterministic, not secure — demo only). */
    unsigned char pub[32];
    unsigned char sec[32];
    for (int i = 0; i < 32; i++) {
        pub[i] = (unsigned char)(i + 1);
        sec[i] = (unsigned char)(i + 100);
    }

    /* ClientHello random — all 0x42 (not all-zero, which RFC 8446 §4.1.2
     * forbids, though the C ABI does not enforce this in this slice). */
    unsigned char random[32];
    memset(random, 0x42, sizeof(random));

    /* This demo explicitly uses the insecure initializer because trust-anchor
     * plumbing is deferred to #30. It does not authenticate the server. */
    ztls_result r = ztls_client_init_insecure(client, pub, sec,
                                              "ztls.server.test", random);
    if (r != ZTLS_OK) {
        fprintf(stderr, "ztls_client_init_insecure failed: %d\n", (int)r);
        free(raw);
        return 1;
    }

    /* Start the handshake — encode ClientHello into out. */
    unsigned char out[16645];
    size_t out_written = 0;
    r = ztls_client_start(client, out, sizeof(out), &out_written);
    if (r != ZTLS_OK) {
        fprintf(stderr, "ztls_client_start failed: %d\n", (int)r);
        ztls_client_deinit(client);
        free(raw);
        return 1;
    }

    /* Verify the ClientHello record header:
     * RFC 8446 §5.1 — content_type=handshake(0x16), legacy_version=0x0303. */
    if (out_written < 5) {
        fprintf(stderr, "ClientHello too short: %zu bytes\n", out_written);
        ztls_client_deinit(client);
        free(raw);
        return 1;
    }
    if (out[0] != 0x16) {
        fprintf(stderr, "expected content_type 0x16, got 0x%02x\n", out[0]);
        ztls_client_deinit(client);
        free(raw);
        return 1;
    }
    if (out[1] != 0x03 || out[2] != 0x03) {
        fprintf(stderr, "expected legacy_version 0x0303, got 0x%02x%02x\n",
                out[1], out[2]);
        ztls_client_deinit(client);
        free(raw);
        return 1;
    }

    printf("ClientHello: %zu bytes, header 0x16 0x03 0x03 — OK\n", out_written);

    /* Check the record length field (bytes 3-4, big-endian u16).
     * RFC 8446 §5.1 — record header is content_type(1) + version(2) + length(2). */
    size_t record_len = ((size_t)out[3] << 8) | (size_t)out[4];
    if (record_len + 5 != out_written) {
        fprintf(stderr, "record length mismatch: header says %zu, got %zu\n",
                record_len + 5, out_written);
        ztls_client_deinit(client);
        free(raw);
        return 1;
    }
    printf("record length field: %zu — OK\n", record_len);

    /* Clean up. */
    ztls_client_deinit(client);
    free(raw);

    printf("ztls C ABI example: OK\n");
    return 0;
}
