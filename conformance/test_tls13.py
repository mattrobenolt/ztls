import socket

from tlsfuzzer.expect import (
    ExpectAlert,
    ExpectApplicationData,
    ExpectCertificate,
    ExpectCertificateVerify,
    ExpectChangeCipherSpec,
    ExpectClose,
    ExpectEncryptedExtensions,
    ExpectFinished,
    ExpectKeyUpdate,
    ExpectServerHello,
)
from tlsfuzzer.helpers import key_share_gen
from tlsfuzzer.messages import (
    AlertGenerator,
    ApplicationDataGenerator,
    ClientHelloGenerator,
    Connect,
    FinishedGenerator,
    KeyUpdateGenerator,
    RawSocketWriteGenerator,
)
from tlsfuzzer.runner import Runner
from tlslite.constants import (
    TLS_1_3_DRAFT,
    AlertDescription,
    AlertLevel,
    CipherSuite,
    ExtensionType,
    ContentType,
    GroupName,
    KeyUpdateMessageType,
    SignatureScheme,
)
from tlslite.extensions import (
    ClientKeyShareExtension,
    SignatureAlgorithmsCertExtension,
    SignatureAlgorithmsExtension,
    SupportedGroupsExtension,
    SupportedVersionsExtension,
)

CIPHERS = [
    CipherSuite.TLS_AES_128_GCM_SHA256,
    CipherSuite.TLS_AES_256_GCM_SHA384,
    CipherSuite.TLS_CHACHA20_POLY1305_SHA256,
    CipherSuite.TLS_EMPTY_RENEGOTIATION_INFO_SCSV,
]


def tls13_extensions():
    return {
        ExtensionType.key_share: ClientKeyShareExtension().create(
            [key_share_gen(GroupName.x25519)]
        ),
        ExtensionType.supported_versions: SupportedVersionsExtension().create(
            [TLS_1_3_DRAFT, (3, 3)]
        ),
        ExtensionType.supported_groups: SupportedGroupsExtension().create([GroupName.x25519]),
        ExtensionType.signature_algorithms: SignatureAlgorithmsExtension().create(
            [
                SignatureScheme.ecdsa_secp256r1_sha256,
                SignatureScheme.rsa_pss_rsae_sha256,
            ]
        ),
        ExtensionType.signature_algorithms_cert: SignatureAlgorithmsCertExtension().create(
            [
                SignatureScheme.ecdsa_secp256r1_sha256,
                SignatureScheme.rsa_pss_rsae_sha256,
            ]
        ),
    }


def tls13_handshake(node):
    node = node.add_child(ExpectServerHello())
    ccs = node.add_child(ExpectChangeCipherSpec())
    ee = ExpectEncryptedExtensions()
    ccs.add_child(ee)
    ccs.next_sibling = ee
    node = ee
    node = node.add_child(ExpectCertificate())
    node = node.add_child(ExpectCertificateVerify())
    node = node.add_child(ExpectFinished())
    node = node.add_child(FinishedGenerator())
    return node


def expect_alert_or_close(node, level, description):
    alert = node.add_child(ExpectAlert(level, description))
    alert.next_sibling = ExpectClose()
    alert.add_child(ExpectClose())


def close_notify(node):
    send = node.add_child(AlertGenerator(AlertLevel.warning, AlertDescription.close_notify))
    alert = send.add_child(ExpectAlert())
    alert.next_sibling = ExpectClose()
    alert.add_child(ExpectClose())
    send.next_sibling = ExpectClose()


def raw_connect(ztls_server):
    sock = socket.create_connection((ztls_server["host"], ztls_server["port"]), timeout=2)
    sock.settimeout(1)
    return sock


def expect_closed_or_alert(sock):
    try:
        data = sock.recv(1)
        assert data in (b"", b"\x15"), f"expected close or alert, got {data!r}"
    except (ConnectionResetError, TimeoutError, socket.timeout):
        pass


def record(content_type: int, body: bytes, version: bytes = b"\x03\x03") -> bytes:
    return bytes([content_type]) + version + len(body).to_bytes(2, "big") + body


def minimal_client_hello_with_ext(ext_type: int, ext_body: bytes) -> bytes:
    extensions = ext_type.to_bytes(2, "big") + len(ext_body).to_bytes(2, "big") + ext_body
    body = (
        b"\x03\x03"
        + (b"\x11" * 32)
        + b"\x00"
        + b"\x00\x02"
        + CipherSuite.TLS_AES_128_GCM_SHA256.to_bytes(2, "big")
        + b"\x01\x00"
        + len(extensions).to_bytes(2, "big")
        + extensions
    )
    handshake = b"\x01" + len(body).to_bytes(3, "big") + body
    return record(ContentType.handshake, handshake)


def run_echo_conversation(ztls_server, ciphers):
    conversation = Connect(ztls_server["host"], ztls_server["port"])
    node = conversation.add_child(ClientHelloGenerator(ciphers, extensions=tls13_extensions()))
    node = tls13_handshake(node)
    node = node.add_child(ApplicationDataGenerator(bytearray(b"ztls tlsfuzzer smoke\n")))
    node = node.add_child(ExpectApplicationData())
    close_notify(node)
    Runner(conversation).run()


def test_tls13_handshake_and_application_echo(ztls_server):
    run_echo_conversation(ztls_server, CIPHERS)


def test_tls13_aes256_gcm_echo(ztls_server):
    run_echo_conversation(
        ztls_server,
        [
            CipherSuite.TLS_AES_256_GCM_SHA384,
            CipherSuite.TLS_EMPTY_RENEGOTIATION_INFO_SCSV,
        ],
    )


def test_tls13_chacha20_poly1305_echo(ztls_server):
    run_echo_conversation(
        ztls_server,
        [
            CipherSuite.TLS_CHACHA20_POLY1305_SHA256,
            CipherSuite.TLS_EMPTY_RENEGOTIATION_INFO_SCSV,
        ],
    )


def test_tls13_keyupdate_update_requested(ztls_server):
    conversation = Connect(ztls_server["host"], ztls_server["port"])
    node = conversation.add_child(ClientHelloGenerator(CIPHERS, extensions=tls13_extensions()))
    node = tls13_handshake(node)
    node = node.add_child(KeyUpdateGenerator(message_type=KeyUpdateMessageType.update_requested))
    node = node.add_child(ApplicationDataGenerator(bytearray(b"after key update\n")))
    node = node.add_child(ExpectKeyUpdate(message_type=KeyUpdateMessageType.update_not_requested))
    node = node.add_child(ExpectApplicationData())
    close_notify(node)
    Runner(conversation).run()


def test_tls13_corrupted_app_data_record_is_rejected(ztls_server):
    conversation = Connect(ztls_server["host"], ztls_server["port"])
    node = conversation.add_child(ClientHelloGenerator(CIPHERS, extensions=tls13_extensions()))
    node = tls13_handshake(node)
    node = node.add_child(
        RawSocketWriteGenerator(data=bytearray(b"\x17\x03\x03\x00\x20" + b"\xaa" * 32))
    )
    expect_alert_or_close(node, AlertLevel.fatal, AlertDescription.bad_record_mac)
    Runner(conversation).run()


def test_tls13_oversized_record_is_rejected(ztls_server):
    oversized_len = 0x4101
    oversized_record = bytearray(bytes([ContentType.application_data]) + b"\x03\x03")
    oversized_record.extend(oversized_len.to_bytes(2, "big"))
    oversized_record.extend(b"\x00" * 16)
    conversation = Connect(ztls_server["host"], ztls_server["port"])
    node = conversation.add_child(ClientHelloGenerator(CIPHERS, extensions=tls13_extensions()))
    node = tls13_handshake(node)
    node = node.add_child(RawSocketWriteGenerator(data=oversized_record))
    expect_alert_or_close(
        node,
        AlertLevel.fatal,
        (AlertDescription.record_overflow, AlertDescription.decode_error),
    )
    Runner(conversation).run()


def test_tls13_rejects_garbage_pre_handshake(ztls_server):
    sock = raw_connect(ztls_server)
    try:
        sock.sendall(b"this is not a TLS record\r\n")
        expect_closed_or_alert(sock)
    finally:
        sock.close()


def test_tls13_rejects_finished_before_handshake(ztls_server):
    sock = raw_connect(ztls_server)
    try:
        sock.sendall(record(ContentType.handshake, b"\x14\x00\x00\x20" + b"\x00" * 32))
        expect_closed_or_alert(sock)
    finally:
        sock.close()


def test_tls13_rejects_truncated_client_hello_record(ztls_server):
    sock = raw_connect(ztls_server)
    try:
        sock.sendall(b"\x16\x03\x03\x00\xc8")
        sock.close()
    finally:
        sock.close()


def test_tls13_rejects_empty_client_hello_record(ztls_server):
    sock = raw_connect(ztls_server)
    try:
        sock.sendall(record(ContentType.handshake, b""))
        expect_closed_or_alert(sock)
    finally:
        sock.close()


def test_tls13_rejects_truncated_key_share_extension(ztls_server):
    sock = raw_connect(ztls_server)
    try:
        sock.sendall(minimal_client_hello_with_ext(ExtensionType.key_share, b"\x00\x04\x00\x1d"))
        expect_closed_or_alert(sock)
    finally:
        sock.close()


def test_tls13_rejects_unsupported_cipher_suite(ztls_server):
    conversation = Connect(ztls_server["host"], ztls_server["port"])
    node = conversation.add_child(
        ClientHelloGenerator(
            [
                CipherSuite.TLS_AES_128_CCM_SHA256,
                CipherSuite.TLS_EMPTY_RENEGOTIATION_INFO_SCSV,
            ],
            extensions=tls13_extensions(),
        )
    )
    alert = node.add_child(ExpectAlert(AlertLevel.fatal, AlertDescription.handshake_failure))
    alert.add_child(ExpectClose())
    Runner(conversation).run()
