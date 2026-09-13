# TLS-Anvil #91 chain-fixture evidence (missing basicConstraints on generated roots)

Raw evidence for the #91 diagnosis slice (2026-09-12, worktree at `0c4c219`).
The two PEM files are the exact certificate chain TLS-Anvil presented to the
ztls client for the reproduced failing case. Status claims live in
`PRODUCTION_READINESS.md`; this directory is evidence only.

## Reproduced case

- Test: `de.rub.nds.tlstest.suite.tests.both.tls13.rfc8446.HappyFlow.happyFlow`
  (`8446-jVohiUKi4u`), case uuid
  `9048F8E8B5F37E20435921B75DBC571484CEED77549BF69E79FDF8F6950E3DC9`
- Parameters: `CERTIFICATE={ROOT: RSA, LEAF: {keyType: RSA, keySize: 1024}}`,
  `SIG_HASH_ALGORIHTM=RSA_PSS_RSAE_SHA384`, `NAMED_GROUP=SECP256R1`,
  `CIPHER_SUITE=TLS_AES_256_GCM_SHA384`, `TCP_FRAGMENTATION=true`,
  `INCLUDE_CHANGE_CIPHER_SPEC=false`, `RECORD_LENGTH=16384`
- Client error (per-case stderr, spawn pid 3344435 @ 2026-09-13T00:03:21.034Z):
  `error.CertificateIssuerNotCa` (`src/certificate_policy.zig:148`), fatal
  `internal_error` alert, case FULLY_FAILED.

## Chain (pre-patch, as presented)

- `happyflow-rsa-root-leaf.pem` — `CN=tls-attacker.com, O=TLS-Attacker`,
  RSA-1024, sha256WithRSAEncryption, X.509v3, no extensions.
- `happyflow-rsa-root-root.pem` — self-signed
  `CN=Attacker CA - Global Insecurity Provider, C=DE, O=TLS-Attacker`,
  RSA-2048, sha256WithRSAEncryption, X.509v3, **no extensions — in particular
  no basicConstraints cA=true** (RFC 5280 §4.2.1.9 violation for a CA cert).

## Root cause

Pinned `lib/tls-test-framework-1.5.0.jar` class
`de.rub.nds.tlstest.framework.utils.X509CertificateChainProvider`
(`getRsaSignedChainConfigs` / `getEcdsaSignedChainConfigs` /
`getDsaSignedChainConfigs`) builds each chain's self-signed signing
`X509CertificateConfig` with only subject / publicKeyType / signatureAlgorithm
and never adds a basicConstraints extension. Identical in upstream v1.5.2 and
`main` as of 2026-09-12 (no upstream fix or config option; verified against
`tls-attacker/TLS-Anvil` tags v1.5.0/v1.5.2 and main).

## Fix (in-repo, conformance tools build)

`conformance/scripts/anvil-chain-provider-patch/` holds the patched upstream
v1.5.0 source (`X509CertificateChainProvider.java`, adds a critical
basicConstraints cA=true to the signing certs only) and `apply.sh`, wired into
`conformance/build.zig` to compile and replace the class inside the installed
`zig-out/tools/lib/tls-test-framework-1.5.0.jar` after the jars are installed.
Leaf configs and all other chain diversity are untouched.

Red→green proof (same test, same RSA chain parameters): pre-patch
`-tags happyflow13` run — 16/16 cases FULLY_FAILED (RSA/ECDH_ECDSA roots →
`Alert(FATAL,INTERNAL_ERROR)`); post-patch run — 0 FULLY_FAILED, RSA-root and
ECDH_ECDSA-root cases STRICTLY_SUCCEEDED (including the exact ROOT=RSA /
RSA-1024 leaf case above), DSA-root cases still FULLY_FAILED with the
pre-existing `CertificateHasUnrecognizedObjectId` error (the #52 class,
unchanged). `error.CertificateIssuerNotCa` disappeared from client stderr.

Raw run artifacts (also persisted here as text): `probe-red.txt` /
`probe-green.txt` / `probe-mutation-check.txt` (executable CONFIG-level
regression — it asserts on the generated X509CertificateConfig objects, not
encoded certificates; the single-case HappyFlow run above is the behavioral
DER-level proof. Effective-class assertion, critical basicConstraints cA=true
with includeCA=ENCODE on RSA/ECDSA/DSA signing certs, leaf configs untouched,
exact upstream counts 38 per builder, exact leaf key-type set and RSA modulus
bits {1024, 2048, 4096}; red exit 1 against the pristine upstream class, green
exit 0 against the installed patched jar, mutation exit 1 when leaf diversity
is collapsed), `happyflow-red-testRun.json` / `happyflow-green-testRun.json`
(actual TLS-Anvil per-case results before/after), and
`happyflow-red-client-stderr-3344435.txt` (the attributed client error block).
Live run dirs (regenerable): `conformance/zig-out/anvil/client/single-repro-happyflow{,-instr,-patched}/`.

Provenance and license: `conformance/scripts/anvil-chain-provider-patch/NOTICE.md`
(Apache-2.0 attribution + local modification notice, `LICENSE-2.0.txt` carried
alongside). Client and server `run_metadata.json` now record live sha256
digests of the installed tls-test-framework jar, the effective
`X509CertificateChainProvider` class bytes inside it, the patch source, and
the digests stamped by `apply.sh` at patch time (`patch_status`: patched /
stale / unpatched / jar_missing). The regression is CI-gated via
`just anvil-chain-patch-test` inside `just ci`.
