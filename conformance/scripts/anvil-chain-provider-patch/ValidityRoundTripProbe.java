import de.rub.nds.tlsattacker.core.config.Config;
import de.rub.nds.tlsattacker.core.config.ConfigIO;
import de.rub.nds.tlstest.framework.model.derivationParameter.helper.CertificateConfigChainValue;
import de.rub.nds.tlstest.framework.utils.X509CertificateChainProvider;
import de.rub.nds.x509attacker.config.DateTimeAdapter;
import de.rub.nds.x509attacker.config.X509CertificateConfig;
import de.rub.nds.x509attacker.x509.X509CertificateChainBuilder;
import de.rub.nds.x509attacker.x509.X509ChainCreationResult;
import jakarta.xml.bind.annotation.adapters.XmlJavaTypeAdapter;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.net.URL;
import java.security.cert.CertificateFactory;
import java.security.cert.X509Certificate;
import java.util.LinkedList;
import java.util.List;
import org.joda.time.DateTime;
import org.joda.time.DateTimeZone;

/**
 * ztls #91 regression probe: TLS-Anvil's Config.createCopy() and ConfigIO
 * (both JAXB round trips) must preserve the configured X.509 validity window
 * — the provider default 2026-01-01..2028-01-01, non-default windows with
 * milliseconds and UTC offsets, and deliberately expired windows — through
 * repeated copy round trips AND into the actually built chain DER, decoded
 * here with the JDK CertificateFactory (model dates alone prove nothing).
 *
 * <p>Red state: upstream x509-attacker 4.3.10 marshals the config's joda
 * DateTime validity fields as empty XML elements, so copies lose the
 * configured dates and instead contain the copy's current time.
 *
 * <p>Exits 0 only when every check passes; exits 1 on any failure or probe
 * crash (e.g. NoClassDefFoundError against a pristine x509-attacker jar).
 */
public class ValidityRoundTripProbe {
    private static final String X509_JAR = "x509-attacker-4.3.10.jar";
    private static final int COPY_ROUNDS = 3;
    // RFC 5280 §4.1.2.5 encodes validity at second precision (the config's
    // default notBefore/notAfterAccurracy is SECONDS), so DER comparison
    // requires truncation to the exact second — never a different second.

    private static int failures = 0;

    private static void check(boolean ok, String what) {
        System.out.println((ok ? "ok   " : "FAIL ") + what);
        if (!ok) {
            failures++;
        }
    }

    public static void main(String[] args) {
        try {
            run();
        } catch (Throwable t) {
            System.out.println("FAIL probe crashed: " + t);
            System.exit(1);
        }
        System.out.println(failures == 0 ? "PASS validity round trip" : "FAILURES=" + failures);
        System.exit(failures == 0 ? 0 : 1);
    }

    private static void run() throws Exception {
        checkAdapterInstalled();
        checkAdapterSemantics();
        CertificateFactory cf = CertificateFactory.getInstance("X.509");
        checkDefaultWindow(cf);
        checkCustomWindows(cf);
    }

    /** The patched classes must be the effective ones, loaded from the jar. */
    private static void checkAdapterInstalled() {
        // Against a pristine jar the adapter class does not exist at all; that
        // is itself a failure, but must not abort the probe — the round-trip
        // checks below then show the actual damage (dates replaced by now).
        try {
            URL configSource =
                    X509CertificateConfig.class.getProtectionDomain().getCodeSource().getLocation();
            System.out.println("config_code_source=" + configSource);
            check(configSource.getProtocol().equals("file")
                    && configSource.getPath().endsWith(X509_JAR),
                    "X509CertificateConfig loaded from installed " + X509_JAR);
            URL adapterSource =
                    DateTimeAdapter.class.getProtectionDomain().getCodeSource().getLocation();
            System.out.println("adapter_code_source=" + adapterSource);
            check(adapterSource.getProtocol().equals("file")
                    && adapterSource.getPath().endsWith(X509_JAR),
                    "DateTimeAdapter loaded from installed " + X509_JAR);
            XmlJavaTypeAdapter binding =
                    X509CertificateConfig.class.getPackage().getAnnotation(XmlJavaTypeAdapter.class);
            check(binding != null && binding.value() == DateTimeAdapter.class,
                    "package-level @XmlJavaTypeAdapter(DateTimeAdapter) is effective");
        } catch (Throwable t) {
            System.out.println("FAIL DateTimeAdapter not loadable: " + t);
            failures++;
        }
    }

    /** Adapter contract: null-safe both ways, exact instant round trip. */
    private static void checkAdapterSemantics() {
        try {
            DateTimeAdapter adapter = new DateTimeAdapter();
            check(adapter.unmarshal(null) == null, "unmarshal(null) returns null");
            check(adapter.marshal(null) == null, "marshal(null) returns null");
            DateTime custom =
                    new DateTime(2019, 7, 6, 5, 6, 7, 891, DateTimeZone.forOffsetHours(3));
            DateTime parsed = adapter.unmarshal(adapter.marshal(custom));
            check(parsed != null && parsed.equals(custom)
                    && parsed.toString().equals(custom.toString()),
                    "adapter round trip preserves millis and +03:00 offset: " + parsed);
            boolean threw = false;
            try {
                adapter.unmarshal("not-a-date");
            } catch (IllegalArgumentException expected) {
                threw = true;
            }
            check(threw, "unmarshal(malformed string) throws IllegalArgumentException");
        } catch (Throwable t) {
            System.out.println("FAIL adapter semantics not checkable: " + t);
            failures++;
        }
    }

    /** Provider default window: 2026-01-01..2028-01-01 on every chain cert. */
    private static void checkDefaultWindow(CertificateFactory cf) throws Exception {
        List<X509CertificateConfig> baseline = providerChain();
        check(baseline.size() >= 2, "provider chain has leaf and signing configs");
        for (int i = 0; i < baseline.size(); i++) {
            DateTime nb = baseline.get(i).getNotBefore();
            DateTime na = baseline.get(i).getNotAfter();
            check(nb != null && nb.getYear() == 2026,
                    "baseline cert " + i + " notBefore is 2026: " + nb);
            check(na != null && na.getYear() == 2028,
                    "baseline cert " + i + " notAfter is 2028: " + na);
        }
        List<X509CertificateConfig> copy = repeatedCreateCopy(baseline);
        checkModelMatches("createCopy x" + COPY_ROUNDS + " default window", baseline, copy);
        checkDerMatches(cf, "createCopy default window", copy);
        List<X509CertificateConfig> jaxb = configIoRoundTrip(baseline);
        checkModelMatches("ConfigIO default window", baseline, jaxb);
        checkDerMatches(cf, "ConfigIO default window", jaxb);
    }

    /**
     * Non-default windows: leaf gets a past-notBefore/future-notAfter window
     * with milliseconds and a non-UTC offset; the signing certs get a
     * deliberately expired window. None may be overwritten with "now".
     */
    private static void checkCustomWindows(CertificateFactory cf) throws Exception {
        List<X509CertificateConfig> custom = providerChain();
        custom.get(0).setNotBefore(
                new DateTime(2019, 7, 6, 5, 6, 7, 891, DateTimeZone.forOffsetHours(3)));
        custom.get(0).setNotAfter(
                new DateTime(2031, 2, 3, 4, 5, 6, 789, DateTimeZone.forOffsetHoursMinutes(-9, -30)));
        for (int i = 1; i < custom.size(); i++) {
            custom.get(i).setNotBefore(new DateTime(2018, 3, 4, 5, 6, 7, DateTimeZone.UTC));
            custom.get(i).setNotAfter(new DateTime(2019, 12, 31, 23, 59, 59, DateTimeZone.UTC));
        }
        List<X509CertificateConfig> copy = repeatedCreateCopy(custom);
        checkModelMatches("createCopy x" + COPY_ROUNDS + " custom windows", custom, copy);
        checkDerMatches(cf, "createCopy custom windows", copy);
        List<X509CertificateConfig> jaxb = configIoRoundTrip(custom);
        checkModelMatches("ConfigIO custom windows", custom, jaxb);
        checkDerMatches(cf, "ConfigIO custom windows", jaxb);

        custom.get(0).setNotBefore(new DateTime(2040, 1, 1, 0, 0, DateTimeZone.UTC));
        custom.get(0).setNotAfter(new DateTime(2041, 1, 1, 0, 0, DateTimeZone.UTC));
        List<X509CertificateConfig> future = repeatedCreateCopy(custom);
        checkModelMatches("future window", custom, future);
        checkDerMatches(cf, "future window", future);
    }

    @SuppressWarnings("unchecked")
    private static List<X509CertificateConfig> providerChain() {
        List<CertificateConfigChainValue> chains = X509CertificateChainProvider.getCertificateChainConfigs();
        return (List<X509CertificateConfig>) chains.get(0);
    }

    private static List<X509CertificateConfig> repeatedCreateCopy(List<X509CertificateConfig> chain) {
        Config config = Config.createConfig();
        config.setAutoAdjustCertificate(false);
        config.setCertificateChainConfig(new LinkedList<>(chain));
        for (int i = 0; i < COPY_ROUNDS; i++) {
            config = config.createCopy();
        }
        return config.getCertificateChainConfig();
    }

    private static List<X509CertificateConfig> configIoRoundTrip(List<X509CertificateConfig> chain)
            throws Exception {
        Config config = Config.createConfig();
        config.setAutoAdjustCertificate(false);
        config.setCertificateChainConfig(new LinkedList<>(chain));
        File file = File.createTempFile("validityprobe", ".xml");
        file.deleteOnExit();
        ConfigIO.write(config, file);
        return ConfigIO.read(file).getCertificateChainConfig();
    }

    /** Config-level dates must survive the round trip exactly (millis+offset). */
    private static void checkModelMatches(
            String label, List<X509CertificateConfig> expected, List<X509CertificateConfig> actual) {
        check(actual != null && actual.size() == expected.size(),
                label + ": all chain configs survive");
        if (actual == null || actual.size() != expected.size()) {
            return;
        }
        for (int i = 0; i < expected.size(); i++) {
            DateTime nb = actual.get(i).getNotBefore();
            DateTime na = actual.get(i).getNotAfter();
            check(nb != null && nb.toString().equals(expected.get(i).getNotBefore().toString()),
                    label + ": cert " + i + " notBefore preserved: " + nb);
            check(na != null && na.toString().equals(expected.get(i).getNotAfter().toString()),
                    label + ": cert " + i + " notAfter preserved: " + na);
        }
    }

    /** DER-level: each built cert's decoded validity must match its config. */
    private static void checkDerMatches(
            CertificateFactory cf, String label, List<X509CertificateConfig> chain) throws Exception {
        X509ChainCreationResult result = new X509CertificateChainBuilder().buildChain(chain);
        List<?> certs = result.getCertificateChain().getCertificateList();
        check(certs.size() == chain.size(), label + ": built both chain certificates");
        for (int i = 0; i < certs.size(); i++) {
            de.rub.nds.x509attacker.x509.model.X509Certificate asn =
                    (de.rub.nds.x509attacker.x509.model.X509Certificate) certs.get(i);
            ByteArrayOutputStream bytes = new ByteArrayOutputStream();
            bytes.write(asn.getTagOctets().getValue());
            bytes.write(asn.getLengthOctets().getValue());
            bytes.write(asn.getContent().getValue());
            X509Certificate decoded =
                    (X509Certificate) cf.generateCertificate(new ByteArrayInputStream(bytes.toByteArray()));
            DateTime nb = chain.get(i).getNotBefore();
            DateTime na = chain.get(i).getNotAfter();
            check(decoded.getNotBefore().getTime() == Math.floorDiv(nb.getMillis(), 1000) * 1000,
                    label + ": DER cert " + i + " notBefore=" + decoded.getNotBefore()
                            + " matches config " + nb);
            check(decoded.getNotAfter().getTime() == Math.floorDiv(na.getMillis(), 1000) * 1000,
                    label + ": DER cert " + i + " notAfter=" + decoded.getNotAfter()
                            + " matches config " + na);
        }
    }
}
