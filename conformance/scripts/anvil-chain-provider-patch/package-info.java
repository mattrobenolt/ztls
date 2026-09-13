// ztls #91 conformance patch: bind every joda-time DateTime field in this
// package (X509CertificateConfig.notBefore/notAfter) to DateTimeAdapter so
// JAXB round trips preserve the configured instants instead of writing empty
// elements and losing the validity window (see DateTimeAdapter.java).
@jakarta.xml.bind.annotation.adapters.XmlJavaTypeAdapter(
        type = org.joda.time.DateTime.class,
        value = de.rub.nds.x509attacker.config.DateTimeAdapter.class)
package de.rub.nds.x509attacker.config;
