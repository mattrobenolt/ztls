import de.rub.nds.tlstest.framework.utils.X509CertificateChainProvider;
import de.rub.nds.x509attacker.config.X509CertificateConfig;
import de.rub.nds.x509attacker.config.extension.BasicConstraintsConfig;
import de.rub.nds.x509attacker.constants.DefaultEncodingRule;
import java.util.List;
import java.util.Locale;
import java.util.Set;
import java.util.TreeSet;

/**
 * ztls #91 regression probe (CONFIG level: it asserts on the generated
 * X509CertificateConfig objects, not on encoded certificates; the single-case
 * HappyFlow run is the behavioral DER-level proof). Loads the effective class
 * through the classpath TLS-Anvil itself uses and asserts: signing-cert
 * configs carry a present, critical basicConstraints cA=true with the cA field
 * explicitly encoded; leaf configs stay untouched; per-builder chain counts
 * and leaf key-type / modulus diversity stay exactly at the upstream v1.5.0
 * baseline. Exits non-zero on any violation.
 */
public class AnvilChainProviderProbe {
    // Upstream v1.5.0 baseline (unchanged by the patch).
    private static final int EXPECTED_CHAINS_PER_BUILDER = 38;
    private static final Set<String> EXPECTED_LEAF_TYPES =
            Set.of("dsa", "ecdh_ecdsa", "rsa", "rsaes_oaep", "rsassa_pss");
    private static final Set<String> EXPECTED_RSA_MODULUS_BITS = Set.of("1024", "2048", "4096");

    private static int failures = 0;

    public static void main(String[] args) {
        // Shadowing check: the effective class must come from a
        // tls-test-framework jar, not another artifact on the classpath.
        String codeSource =
                X509CertificateChainProvider.class
                        .getProtectionDomain()
                        .getCodeSource()
                        .getLocation()
                        .toString();
        System.out.println("code_source=" + codeSource);
        if (!codeSource.contains("tls-test-framework")) {
            System.out.println("FAIL: effective class is not loaded from a tls-test-framework jar");
            failures++;
        }

        TreeSet<String> leafTypes = new TreeSet<>();
        TreeSet<String> leafRsaModuli = new TreeSet<>();
        checkBuilder("RSA", X509CertificateChainProvider.getRsaSignedChainConfigs(), leafTypes, leafRsaModuli);
        checkBuilder("ECDSA", X509CertificateChainProvider.getEcdsaSignedChainConfigs(), leafTypes, leafRsaModuli);
        checkBuilder("DSA", X509CertificateChainProvider.getDsaSignedChainConfigs(), leafTypes, leafRsaModuli);

        System.out.println("leaf_public_key_types=" + leafTypes);
        System.out.println("leaf_rsa_modulus_bits=" + leafRsaModuli);
        if (!leafTypes.equals(EXPECTED_LEAF_TYPES)) {
            System.out.println("FAIL: leaf key types " + leafTypes + " != " + EXPECTED_LEAF_TYPES);
            failures++;
        }
        if (!leafRsaModuli.equals(EXPECTED_RSA_MODULUS_BITS)) {
            System.out.println(
                    "FAIL: leaf RSA modulus bits " + leafRsaModuli + " != " + EXPECTED_RSA_MODULUS_BITS);
            failures++;
        }
        if (failures > 0) {
            System.out.println("PROBE_FAILED failures=" + failures);
            System.exit(1);
        }
        System.out.println("PROBE_OK signing-cert configs carry critical basicConstraints cA=true");
    }

    private static void checkBuilder(
            String label,
            List<List<X509CertificateConfig>> chains,
            TreeSet<String> leafTypes,
            TreeSet<String> leafRsaModuli) {
        if (chains.size() != EXPECTED_CHAINS_PER_BUILDER) {
            System.out.println(
                    "FAIL " + label + ": chain count " + chains.size() + " != " + EXPECTED_CHAINS_PER_BUILDER);
            failures++;
        }
        for (List<X509CertificateConfig> chain : chains) {
            if (chain.size() != 2) {
                System.out.println("FAIL " + label + ": chain size " + chain.size());
                failures++;
                continue;
            }
            X509CertificateConfig leaf = chain.get(X509CertificateChainProvider.LEAF_CERT_INDEX);
            X509CertificateConfig signing = chain.get(1);
            if (!leaf.getExtensions().isEmpty()) {
                System.out.println("FAIL " + label + ": leaf extensions were modified");
                failures++;
            }
            BasicConstraintsConfig bc = null;
            for (de.rub.nds.x509attacker.config.extension.ExtensionConfig ext :
                    signing.getExtensions()) {
                if (ext instanceof BasicConstraintsConfig found) {
                    bc = found;
                }
            }
            if (bc == null
                    || !bc.isPresent()
                    || !bc.isCritical()
                    || !bc.isCa()
                    || bc.getIncludeCA() != DefaultEncodingRule.ENCODE) {
                System.out.println(
                        "FAIL "
                                + label
                                + ": signing config basicConstraints missing or not "
                                + "present/critical/cA/includeCA=ENCODE (found="
                                + (bc != null)
                                + ")");
                failures++;
            }
            leafTypes.add(leaf.getPublicKeyType().toString().toLowerCase(Locale.ROOT));
            if (leaf.getDefaultSubjectRsaModulus() != null) {
                leafRsaModuli.add(Integer.toString(leaf.getDefaultSubjectRsaModulus().bitLength()));
            }
        }
    }
}
