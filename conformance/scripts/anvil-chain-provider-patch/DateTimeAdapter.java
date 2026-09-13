// ztls #91 conformance patch: JAXB adapter for joda-time DateTime fields in
// the de.rub.nds.x509attacker.config package.
//
// Upstream x509-attacker 4.3.10 has no package-info for this package, so
// JAXB's default DateTime marshaling writes EMPTY <notBefore/>/<notAfter/>
// elements. TLS-Attacker's Config.createCopy() (a JAXB write/read round trip
// used per test run) then re-reads those fields as null and the certificate
// chain builder substitutes the CURRENT time, silently discarding the
// configured 2026-01-01..2028-01-01 validity window — and any deliberately
// expired or future window. This adapter marshals DateTime as its ISO string
// and parses it back verbatim, so copy round trips preserve the configured
// instants exactly (milliseconds and UTC offset included). The package-level
// binding that makes JAXB use it lives in package-info.java.
package de.rub.nds.x509attacker.config;

import jakarta.xml.bind.annotation.adapters.XmlAdapter;
import org.joda.time.DateTime;

public final class DateTimeAdapter extends XmlAdapter<String, DateTime> {
    @Override
    public DateTime unmarshal(String value) {
        return value == null ? null : DateTime.parse(value);
    }

    @Override
    public String marshal(DateTime value) {
        return value == null ? null : value.toString();
    }
}
