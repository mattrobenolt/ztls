/*
 * ztls — C ABI for the Sans-I/O TLS 1.3 library.
 *
 * This header defines the client-side C ABI surface (#30). The internal
 * layout of ztls_client is opaque: allocate ztls_client_size() bytes with
 * alignment ztls_client_align(), pass the pointer to ztls_client_init, and
 * do not access the memory directly. Layout is unstable between ztls
 * versions; pin a version and recompile on upgrade.
 *
 * Conventions:
 *   - All functions return ztls_result (ZTLS_OK or an error).
 *   - Pointer parameters must not be NULL unless explicitly documented.
 *   - event.data and out-parameter pointers are borrowed from ztls-internal
 *     or caller buffers; they are valid only until the next ztls call on the
 *     same handle or until ztls_client_complete_write is called.
 *   - The client handle is non-copyable. Do not memcpy or assign it; the
 *     internal state contains backend handles and secrets that must not be
 *     duplicated (#30 C ABI security review finding 1).
 *   - ztls_client_deinit must be called exactly once per handle.
 *
 * Scope: this is a partial C ABI (#30 PARTIAL). Only client lifecycle shims
 * are exported. Server-side shims, RecordBuffer C ABI, certificate
 * verification, KeyUpdate initiation, PSK/resumption, and dynamic linking
 * are deferred.
 */
#ifndef ZTLS_H
#define ZTLS_H

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>

#ifdef __cplusplus
extern "C" {
#endif

/* ── Result enum ─────────────────────────────────────────────── */

typedef enum {
    ZTLS_OK = 0,
    ZTLS_ERR_NULL_PARAMETER = 1,
    ZTLS_ERR_BUFFER_TOO_SHORT = 2,
    ZTLS_ERR_PENDING_WRITE = 3,
    ZTLS_ERR_NOT_CONNECTED = 4,
    ZTLS_ERR_HANDSHAKE_FAILURE = 5,
    ZTLS_ERR_PEER_ALERT = 6,
    ZTLS_ERR_IDENTITY_ELEMENT = 7,
    ZTLS_ERR_INVALID_STATE = 8,
    ZTLS_ERR_INTERNAL = 9,
} ztls_result;

/* ── Event types ─────────────────────────────────────────────── */

typedef enum {
    ZTLS_EVENT_NONE = 0,
    ZTLS_EVENT_APPLICATION_DATA = 1,
    ZTLS_EVENT_WRITE = 2,
    ZTLS_EVENT_CLOSED = 3,
} ztls_event_type;

typedef struct {
    ztls_event_type type;
    const uint8_t *data;
    size_t data_len;
} ztls_event;

/* ── Version ─────────────────────────────────────────────────── */

/* Returns a static C string with the ztls version, e.g. "0.1.0". */
const char *ztls_version(void);

/* ── Client size / alignment ─────────────────────────────────── */

/* Runtime query for the opaque client handle size. Allocate this many bytes
 * (with alignment ztls_client_align) and pass the pointer to ztls_client_init.
 * Layout is unstable; never hard-code the value. */
size_t ztls_client_size(void);
size_t ztls_client_align(void);

/* ── Client lifecycle ────────────────────────────────────────── */

/* Initialize a client in the caller-provided memory. The buffer must be
 * at least ztls_client_size() bytes and aligned to ztls_client_align().
 *
 * Parameters:
 *   client      — pointer to the allocated storage (non-NULL)
 *   x25519_pub  — 32-byte X25519 public key (non-NULL)
 *   x25519_sec  — 32-byte X25519 secret key (non-NULL)
 *   host_name   — NUL-terminated server name for SNI; empty string disables SNI
 *   random      — 32-byte ClientHello random (non-NULL, must not be all-zero)
 *
 * Certificate verification is deferred (#30): insecure_no_chain_anchor is
 * set, so the server certificate is accepted without chain validation.
 * Production callers must not use this without a separate verification step.
 */
ztls_result ztls_client_init(
    void *client,
    const uint8_t x25519_pub[32],
    const uint8_t x25519_sec[32],
    const char *host_name,
    const uint8_t random[32]
);

/* Secure-zero and tear down the client. Must be called exactly once.
 * Frees backend-owned cipher contexts. After this, the storage may be
 * reused or freed by the caller. */
ztls_result ztls_client_deinit(void *client);

/* Begin the handshake: encode a ClientHello record into out.
 * On success, *out_written is the number of bytes written.
 * After writing the bytes to the transport, call ztls_client_complete_write. */
ztls_result ztls_client_start(
    void *client,
    uint8_t *out,
    size_t out_len,
    size_t *out_written
);

/* Feed one complete TLS record to the engine. The record buffer is decrypted
 * in place. The event is filled in with the result:
 *   ZTLS_EVENT_APPLICATION_DATA — decrypted app data in event.data
 *   ZTLS_EVENT_WRITE — a record to send (in event.data); call complete_write after
 *   ZTLS_EVENT_CLOSED — peer sent close_notify
 *   ZTLS_EVENT_NONE — handled internally (e.g. CCS, or deferred event)
 *
 * KeyUpdate and NewSessionTicket events are currently mapped to
 * ZTLS_EVENT_NONE (deferred per #30 — honest partial). */
ztls_result ztls_client_handle_record(
    void *client,
    uint8_t *record,
    size_t record_len,
    uint8_t *out,
    size_t out_len,
    ztls_event *event
);

/* Acknowledge that the bytes from the last start/handle_record/send call
 * were written to the transport. Clears the pending-write latch. */
ztls_result ztls_client_complete_write(void *client);

/* Encrypt application data into a wire-ready record. On success,
 * *out_written is the number of bytes written. Call complete_write after
 * sending. Only valid when connected. */
ztls_result ztls_client_send_application_data(
    void *client,
    const uint8_t *plaintext,
    size_t plaintext_len,
    uint8_t *out,
    size_t out_len,
    size_t *out_written
);

/* Returns true if the handshake has completed and application keys are
 * installed. */
bool ztls_client_is_connected(void *client);

/* Query the ALPN protocol selected by the server, if any. Sets *out_ptr to
 * a pointer into the client's internal storage and *out_len to the length.
 * The pointer is valid until the next ztls call on this handle. Returns
 * ZTLS_ERR_NOT_CONNECTED if no ALPN was selected. */
ztls_result ztls_client_selected_alpn(
    void *client,
    const uint8_t **out_ptr,
    size_t *out_len
);

#ifdef __cplusplus
}
#endif

#endif /* ZTLS_H */
