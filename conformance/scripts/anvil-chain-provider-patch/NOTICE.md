# NOTICE — vendored and modified TLS-Anvil / TLS-Test-Framework Java artifact

The ztls conformance tools build installs and **locally modifies** Java
artifacts from the pinned zig dependency `tlsanvil`
(TLS-Anvil v1.5.0 release zip,
https://github.com/tls-attacker/TLS-Anvil/releases/download/v1.5.0/TLS-Anvil-v1.5.0.zip,
upstream repository https://github.com/tls-attacker/TLS-Anvil).

- Upstream license: **Apache License, Version 2.0** (`LICENSE-2.0.txt` in this
  directory; also declared in the vendored jar at
  `META-INF/maven/de.rub.nds.tls.anvil/tls-test-framework/pom.xml`).
- Upstream copyright: Copyright the TLS-Anvil / TLS-Attacker authors
  (Ruhr-Universität Bochum / Paderborn University, Chair for Systems Security;
  see the upstream repository and the jar's pom `developers` section).
- No upstream NOTICE file ships inside the v1.5.0 jars (verified: no
  META-INF/LICENSE* or META-INF/NOTICE* entries).

## Local modifications (#91)

`apply.sh` replaces exactly one class inside the installed copy of
`lib/tls-test-framework-1.5.0.jar`:

- `de/rub/nds/tlstest/framework/utils/X509CertificateChainProvider.class` —
  rebuilt from the patched source `X509CertificateChainProvider.java` in this
  directory (upstream v1.5.0 source plus a critical basicConstraints cA=true
  extension on the chain signing certificates, per RFC 5280 §4.2.1.9).

The pinned zig dependency artifact itself is never modified; only the
installed copy under `conformance/zig-out/tools/lib/` is patched, at build
time, reproducibly from this source. The full Apache-2.0 license text is
carried alongside this notice in this directory.

Per Apache-2.0 §4(b)/(d): this file marks that the distributed jar contains
modified third-party object code; the complete modification is the diff of
`X509CertificateChainProvider.java` against upstream tag v1.5.0.
