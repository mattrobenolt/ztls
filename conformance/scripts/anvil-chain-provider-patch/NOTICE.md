# NOTICE — vendored and modified TLS-Anvil / TLS-Test-Framework Java artifact

The ztls conformance tools build installs and **locally modifies** a Java
artifact from the pinned zig dependency `tlsanvil`
(TLS-Anvil v1.5.3 release zip,
https://github.com/tls-attacker/TLS-Anvil/releases/download/v1.5.3/TLS-Anvil-v1.5.3.zip,
upstream repository https://github.com/tls-attacker/TLS-Anvil).

- Upstream license: **Apache License, Version 2.0** (`LICENSE-2.0.txt` in this
  directory; also declared in the vendored jar at
  `META-INF/maven/de.rub.nds.tls.anvil/tls-test-framework/pom.xml`).
- Upstream copyright: Copyright the TLS-Anvil / TLS-Attacker authors
  (Ruhr-Universität Bochum / Paderborn University, Chair for Systems Security;
  see the upstream repository and the jar's pom `developers` section).
- No upstream NOTICE file ships inside the v1.5.3 jars (verified: no
  META-INF/LICENSE* or META-INF/NOTICE* entries in tls-test-framework-1.5.3
  or x509-attacker-4.3.10).

## Local modifications (#91, #146)

`apply.sh` replaces or adds classes inside the installed copy of one jar:

### `lib/x509-attacker-4.3.10.jar`

- `de/rub/nds/x509attacker/config/DateTimeAdapter.class` and
  `de/rub/nds/x509attacker/config/package-info.class` — compiled from
  `DateTimeAdapter.java` and `package-info.java` in this directory. Upstream
  has no `package-info` for the config package, so JAXB marshals the config's
  joda-time `DateTime` validity fields (`notBefore`/`notAfter`) as EMPTY XML
  elements; TLS-Attacker's `Config.createCopy()` and `ConfigIO` round trips
  then replace the configured validity dates with the copy's current time.
  See upstream https://github.com/tls-attacker/X509-Attacker/issues/67. The package-level `@XmlJavaTypeAdapter(DateTimeAdapter)`
  marshals `DateTime` as its ISO string and parses it back, preserving the
  configured instants exactly (default 2026–2028 window, non-default windows
  with milliseconds and UTC offsets, and deliberately expired/future
  windows). No ztls-side certificate validation is relaxed; only the
  conformance tool's fixture serialization is fixed.

### `lib/tls-test-framework-1.5.3.jar` — unmodified

TLS-Anvil v1.5.3 adopted the #91 chain fix upstream:
`X509CertificateChainProvider` now adds a critical basicConstraints
cA=true to every chain signing certificate (RFC 5280 §4.2.1.9). The local
fork of that class (`X509CertificateChainProvider.java`) and its patch block
in `apply.sh` were removed with the v1.5.3 bump (#146); between the v1.5.0
pin and that removal, the installed `tls-test-framework-1.5.0.jar` carried a
rebuilt `X509CertificateChainProvider.class` from the fork. The jar installed
from the v1.5.3 zip is byte-identical to upstream.

The pinned zig dependency artifact itself is never modified; only the
installed copy under `conformance/zig-out/tools/lib/` is patched, at build
time, reproducibly from this source. The full Apache-2.0 license text is
carried alongside this notice in this directory.

Per Apache-2.0 §4(b)/(d): this file marks that the distributed jars contain
modified third-party object code; the complete modifications are
`DateTimeAdapter.java` and `package-info.java` (both entirely new files)
against upstream x509-attacker 4.3.10, which carries neither class.
