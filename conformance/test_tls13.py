from tlsfuzzer.expect import (
    ExpectAlert,
    ExpectApplicationData,
    ExpectCertificate,
    ExpectCertificateVerify,
    ExpectChangeCipherSpec,
    ExpectClose,
    ExpectEncryptedExtensions,
    ExpectFinished,
    ExpectServerHello,
)
from tlsfuzzer.helpers import key_share_gen
from tlsfuzzer.messages import (
    AlertGenerator,
    ApplicationDataGenerator,
    ClientHelloGenerator,
    Connect,
    FinishedGenerator,
)
from tlsfuzzer.runner import Runner
from tlslite.constants import (
    TLS_1_3_DRAFT,
    AlertDescription,
    AlertLevel,
    CipherSuite,
    ExtensionType,
    GroupName,
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
        ExtensionType.key_share: ClientKeyShareExtension().create([key_share_gen(GroupName.x25519)]),
        ExtensionType.supported_versions: SupportedVersionsExtension().create([TLS_1_3_DRAFT, (3, 3)]),
        ExtensionType.supported_groups: SupportedGroupsExtension().create([GroupName.x25519]),
        ExtensionType.signature_algorithms: SignatureAlgorithmsExtension().create([
            SignatureScheme.ecdsa_secp256r1_sha256,
            SignatureScheme.rsa_pss_rsae_sha256,
        ]),
        ExtensionType.signature_algorithms_cert: SignatureAlgorithmsCertExtension().create([
            SignatureScheme.ecdsa_secp256r1_sha256,
            SignatureScheme.rsa_pss_rsae_sha256,
        ]),
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


def close_notify(node):
    send = node.add_child(AlertGenerator(AlertLevel.warning, AlertDescription.close_notify))
    alert = send.add_child(ExpectAlert())
    alert.next_sibling = ExpectClose()
    alert.add_child(ExpectClose())
    send.next_sibling = ExpectClose()


def test_tls13_handshake_and_application_echo(ztls_server):
    conversation = Connect(ztls_server["host"], ztls_server["port"])
    node = conversation.add_child(ClientHelloGenerator(CIPHERS, extensions=tls13_extensions()))
    node = tls13_handshake(node)
    node = node.add_child(ApplicationDataGenerator(bytearray(b"ztls tlsfuzzer smoke\n")))
    node = node.add_child(ExpectApplicationData())
    close_notify(node)
    Runner(conversation).run()
