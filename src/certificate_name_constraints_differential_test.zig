//! RFC 5280 §4.2.1.10 name-constraint enforcement — differential coverage
//! against OpenSSL 3.6.3 ground truth, plus a crash-safety fuzz target for the
//! NameConstraints DER walk. Attack class: a name-constrained sub-CA escaping
//! its constraints. RFC 8446 §4.4.2 carries the chain whose intermediate CAs
//! this enforces.
//!
//! First fuzz/differential harness for the Sans-I/O name-constraint surface:
//! verifyNameConstraints -> checkNameConstraintSubtrees -> nameMatchesConstraint
//! (dnsNameInSubtree / emailNameInSubtree / uriNameInSubtree / ipAddressInSubtree)
//! had ZERO fuzz coverage while every other major parser had one.
//!
//! Corpus provenance: chains generated with OpenSSL 3.6.3 (EC P-256). Each is an
//! intermediate CA carrying a critical NameConstraints extension over one
//! GeneralName form (dNSName / rfc822Name / URI / iPAddress, permitted and
//! excluded), plus a leaf whose SAN sits inside, on, or outside the subtree.
//! Ground truth is `openssl verify -CAfile root -untrusted inter leaf`; ztls's
//! verdict is `intermediate.verifyNameConstraints(leaf)` on the same DER.
//!
//! ztls now agrees with OpenSSL on every case. The former rfc822Name/URI
//! bare-host subtree divergence (#75) was fixed: bare-host constraints now do
//! exact host matching per RFC 5280 §4.2.1.10.

const std = @import("std");
const testing = std.testing;
const cert = @import("certificate_parser.zig");
const fuzz_compat = @import("fuzz_compat.zig");

const Certificate = cert;
const Parsed = cert.Parsed;

const Case = struct {
    name: []const u8,
    /// `openssl verify` accepted the chain (name constraints satisfied).
    openssl_ok: bool,
    /// ztls verifyNameConstraints currently accepts. Regression anchor.
    ztls_ok: bool,
    inter_b64: []const u8,
    leaf_b64: []const u8,
};

const cases = [_]Case{
    .{
        .name = "dns_in__dns_perm",
        .openssl_ok = true,
        .ztls_ok = true,
        .inter_b64 = "MIIBtDCCAVqgAwIBAgIUfIXDd6WpQ1DRce6dL3A/5kNomr8wCgYIKoZIzj0EAwIwEjEQMA4G" ++
            "A1UEAwwHbmMtcm9vdDAeFw0yNjA3MTUyMDEyMTRaFw0zNjA3MTIyMDEyMTRaMBwxGjAYBgNV" ++
            "BAMMEW5jLWludGVyLWRuc19wZXJtMFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAEsp5mzksa" ++
            "UCpHOustkB56DpChRGNLgouCxUKGnXYQCZUJ5uHmhQqeK+KzG57JhEnF5v3T6p20FbT+H6AO" ++
            "fwJgtaOBgzCBgDAPBgNVHRMBAf8EBTADAQH/MA4GA1UdDwEB/wQEAwIBBjAdBgNVHR4BAf8E" ++
            "EzARoA8wDYILZXhhbXBsZS5jb20wHQYDVR0OBBYEFMktf33SdZ4OvT0lPta764XaPqnrMB8G" ++
            "A1UdIwQYMBaAFCb2STBUHk0PqNT/on45/kUfTf17MAoGCCqGSM49BAMCA0gAMEUCIQCtH56o" ++
            "4LcFj+cYou5pvTYWyodDce4te6ATvaU4s/hwwQIgcrWTjWu4JFwWZ/tIBQ+L0Am5e2sm3ZX6" ++
            "KK+MjzZPgsk=",
        .leaf_b64 = "MIIBsDCCAVegAwIBAgIUTUvSmO8FnqVlJJ25xGALm71aSr4wCgYIKoZIzj0EAwIwHDEaMBgG" ++
            "A1UEAwwRbmMtaW50ZXItZG5zX3Blcm0wHhcNMjYwNzE1MjAxMjE1WhcNMzYwNzEyMjAxMjE1" ++
            "WjAWMRQwEgYDVQQDDAtsZWFmLWRuc19pbjBZMBMGByqGSM49AgEGCCqGSM49AwEHA0IABCyt" ++
            "B4Vd/69VstthyxJvcAjYQ0esmB9G4uTmKtwrW5TpO6axZeIpFXrx88sMFj9ITvNh9aSj1U22" ++
            "ZLyCZz8FaKejfTB7MAwGA1UdEwEB/wQCMAAwDgYDVR0PAQH/BAQDAgeAMBsGA1UdEQQUMBKC" ++
            "EGhvc3QuZXhhbXBsZS5jb20wHQYDVR0OBBYEFDZ9J7Wy3pzqZZXFIvwwCw1eUqqfMB8GA1Ud" ++
            "IwQYMBaAFMktf33SdZ4OvT0lPta764XaPqnrMAoGCCqGSM49BAMCA0cAMEQCICVJ9WnT+hb+" ++
            "lOC1/k4XIvLyGo14UvOp45x+RO6D0IAlAiAlP6cJZEesmPfV0wXaaWR/wohjRurzB/dq7hAj" ++
            "lfDt+A==",
    },
    .{
        .name = "dns_exact__dns_perm",
        .openssl_ok = true,
        .ztls_ok = true,
        .inter_b64 = "MIIBtDCCAVqgAwIBAgIUfIXDd6WpQ1DRce6dL3A/5kNomr8wCgYIKoZIzj0EAwIwEjEQMA4G" ++
            "A1UEAwwHbmMtcm9vdDAeFw0yNjA3MTUyMDEyMTRaFw0zNjA3MTIyMDEyMTRaMBwxGjAYBgNV" ++
            "BAMMEW5jLWludGVyLWRuc19wZXJtMFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAEsp5mzksa" ++
            "UCpHOustkB56DpChRGNLgouCxUKGnXYQCZUJ5uHmhQqeK+KzG57JhEnF5v3T6p20FbT+H6AO" ++
            "fwJgtaOBgzCBgDAPBgNVHRMBAf8EBTADAQH/MA4GA1UdDwEB/wQEAwIBBjAdBgNVHR4BAf8E" ++
            "EzARoA8wDYILZXhhbXBsZS5jb20wHQYDVR0OBBYEFMktf33SdZ4OvT0lPta764XaPqnrMB8G" ++
            "A1UdIwQYMBaAFCb2STBUHk0PqNT/on45/kUfTf17MAoGCCqGSM49BAMCA0gAMEUCIQCtH56o" ++
            "4LcFj+cYou5pvTYWyodDce4te6ATvaU4s/hwwQIgcrWTjWu4JFwWZ/tIBQ+L0Am5e2sm3ZX6" ++
            "KK+MjzZPgsk=",
        .leaf_b64 = "MIIBrzCCAVWgAwIBAgIUTUvSmO8FnqVlJJ25xGALm71aSr8wCgYIKoZIzj0EAwIwHDEaMBgG" ++
            "A1UEAwwRbmMtaW50ZXItZG5zX3Blcm0wHhcNMjYwNzE1MjAxMjE1WhcNMzYwNzEyMjAxMjE1" ++
            "WjAZMRcwFQYDVQQDDA5sZWFmLWRuc19leGFjdDBZMBMGByqGSM49AgEGCCqGSM49AwEHA0IA" ++
            "BEGyaB+wGdjSSSK8Q0EafCz8C8Gv/fKHlj2UxLd2bppA9ehFSWEb9Bri4xQw9WabxYho8K5i" ++
            "SAUcLT42OjofTayjeDB2MAwGA1UdEwEB/wQCMAAwDgYDVR0PAQH/BAQDAgeAMBYGA1UdEQQP" ++
            "MA2CC2V4YW1wbGUuY29tMB0GA1UdDgQWBBQeR9JE0oo7zElt+EQXGMMgdUiZIDAfBgNVHSME" ++
            "GDAWgBTJLX990nWeDr09JT7Wu+uF2j6p6zAKBggqhkjOPQQDAgNIADBFAiAltALTKfdboYzR" ++
            "vDpYKH5gV6MwFcugqFS93dQihXErxAIhANxpfRUtoAcWuIJ7UFZUvb3koonarFYBC3XXwl4g" ++
            "g1GO",
    },
    .{
        .name = "dns_out__dns_perm",
        .openssl_ok = false,
        .ztls_ok = false,
        .inter_b64 = "MIIBtDCCAVqgAwIBAgIUfIXDd6WpQ1DRce6dL3A/5kNomr8wCgYIKoZIzj0EAwIwEjEQMA4G" ++
            "A1UEAwwHbmMtcm9vdDAeFw0yNjA3MTUyMDEyMTRaFw0zNjA3MTIyMDEyMTRaMBwxGjAYBgNV" ++
            "BAMMEW5jLWludGVyLWRuc19wZXJtMFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAEsp5mzksa" ++
            "UCpHOustkB56DpChRGNLgouCxUKGnXYQCZUJ5uHmhQqeK+KzG57JhEnF5v3T6p20FbT+H6AO" ++
            "fwJgtaOBgzCBgDAPBgNVHRMBAf8EBTADAQH/MA4GA1UdDwEB/wQEAwIBBjAdBgNVHR4BAf8E" ++
            "EzARoA8wDYILZXhhbXBsZS5jb20wHQYDVR0OBBYEFMktf33SdZ4OvT0lPta764XaPqnrMB8G" ++
            "A1UdIwQYMBaAFCb2STBUHk0PqNT/on45/kUfTf17MAoGCCqGSM49BAMCA0gAMEUCIQCtH56o" ++
            "4LcFj+cYou5pvTYWyodDce4te6ATvaU4s/hwwQIgcrWTjWu4JFwWZ/tIBQ+L0Am5e2sm3ZX6" ++
            "KK+MjzZPgsk=",
        .leaf_b64 = "MIIBrDCCAVKgAwIBAgIUTUvSmO8FnqVlJJ25xGALm71aSsAwCgYIKoZIzj0EAwIwHDEaMBgG" ++
            "A1UEAwwRbmMtaW50ZXItZG5zX3Blcm0wHhcNMjYwNzE1MjAxMjE1WhcNMzYwNzEyMjAxMjE1" ++
            "WjAXMRUwEwYDVQQDDAxsZWFmLWRuc19vdXQwWTATBgcqhkjOPQIBBggqhkjOPQMBBwNCAARs" ++
            "6CNmv9W+F089AX8ptHEYBEBFjlyZE7Z/o9vRc55CtWvzH3sv/gmCGcaiKQgw1mm7jGkFnVAd" ++
            "1lxOFbABbmO/o3cwdTAMBgNVHRMBAf8EAjAAMA4GA1UdDwEB/wQEAwIHgDAVBgNVHREEDjAM" ++
            "ggpvdGhlci50ZXN0MB0GA1UdDgQWBBStcexptJVB9k0c5Jwmz5GchYAFwTAfBgNVHSMEGDAW" ++
            "gBTJLX990nWeDr09JT7Wu+uF2j6p6zAKBggqhkjOPQQDAgNIADBFAiEA6p5TDaLPOvyhphV9" ++
            "TROIlw8ApoLbgMNrdfQ7vfHYzakCIH6zRvmorP9fzjm4ZAhMG71A3ilkRDrGL5yT1f3Pw9aA",
    },
    .{
        .name = "dns_suffix_trk__dns_perm",
        .openssl_ok = false,
        .ztls_ok = false,
        .inter_b64 = "MIIBtDCCAVqgAwIBAgIUfIXDd6WpQ1DRce6dL3A/5kNomr8wCgYIKoZIzj0EAwIwEjEQMA4G" ++
            "A1UEAwwHbmMtcm9vdDAeFw0yNjA3MTUyMDEyMTRaFw0zNjA3MTIyMDEyMTRaMBwxGjAYBgNV" ++
            "BAMMEW5jLWludGVyLWRuc19wZXJtMFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAEsp5mzksa" ++
            "UCpHOustkB56DpChRGNLgouCxUKGnXYQCZUJ5uHmhQqeK+KzG57JhEnF5v3T6p20FbT+H6AO" ++
            "fwJgtaOBgzCBgDAPBgNVHRMBAf8EBTADAQH/MA4GA1UdDwEB/wQEAwIBBjAdBgNVHR4BAf8E" ++
            "EzARoA8wDYILZXhhbXBsZS5jb20wHQYDVR0OBBYEFMktf33SdZ4OvT0lPta764XaPqnrMB8G" ++
            "A1UdIwQYMBaAFCb2STBUHk0PqNT/on45/kUfTf17MAoGCCqGSM49BAMCA0gAMEUCIQCtH56o" ++
            "4LcFj+cYou5pvTYWyodDce4te6ATvaU4s/hwwQIgcrWTjWu4JFwWZ/tIBQ+L0Am5e2sm3ZX6" ++
            "KK+MjzZPgsk=",
        .leaf_b64 = "MIIBuDCCAV2gAwIBAgIUTUvSmO8FnqVlJJ25xGALm71aSsEwCgYIKoZIzj0EAwIwHDEaMBgG" ++
            "A1UEAwwRbmMtaW50ZXItZG5zX3Blcm0wHhcNMjYwNzE1MjAxMjE2WhcNMzYwNzEyMjAxMjE2" ++
            "WjAeMRwwGgYDVQQDDBNsZWFmLWRuc19zdWZmaXhfdHJrMFkwEwYHKoZIzj0CAQYIKoZIzj0D" ++
            "AQcDQgAEduH1tORyMM9iSAqy4xwoNv2hHrRSIOns3ZviPCHlUEPFZJfv1Rn/lctw1y5kp9LU" ++
            "g6YglSariCdo/EnXuOPvUaN7MHkwDAYDVR0TAQH/BAIwADAOBgNVHQ8BAf8EBAMCB4AwGQYD" ++
            "VR0RBBIwEIIObm90ZXhhbXBsZS5jb20wHQYDVR0OBBYEFO98ALbUGjXOoeiROSBHwM2TnL7K" ++
            "MB8GA1UdIwQYMBaAFMktf33SdZ4OvT0lPta764XaPqnrMAoGCCqGSM49BAMCA0kAMEYCIQDG" ++
            "yBJLa1XHQ05fnLcqL+igdV+SF4vJCQ30K9l+cmI8HQIhAOmwD8NEJXo+G/XcDQvu8IDMB3rc" ++
            "GMrsacuAkTIcMa4G",
    },
    .{
        .name = "dns_in__dns_dotperm",
        .openssl_ok = true,
        .ztls_ok = true,
        .inter_b64 = "MIIBuDCCAV6gAwIBAgIUfIXDd6WpQ1DRce6dL3A/5kNomsEwCgYIKoZIzj0EAwIwEjEQMA4G" ++
            "A1UEAwwHbmMtcm9vdDAeFw0yNjA3MTUyMDEyMTRaFw0zNjA3MTIyMDEyMTRaMB8xHTAbBgNV" ++
            "BAMMFG5jLWludGVyLWRuc19kb3RwZXJtMFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAEr+IK" ++
            "6uFq0h7BMC9vt+q0scayqPurGjub6kBe8mzUylZq7+s1Wc739C0ge59XkE4f6ejiUC1NIFgx" ++
            "xScCT/0XzqOBhDCBgTAPBgNVHRMBAf8EBTADAQH/MA4GA1UdDwEB/wQEAwIBBjAeBgNVHR4B" ++
            "Af8EFDASoBAwDoIMLmV4YW1wbGUuY29tMB0GA1UdDgQWBBT+5Lg51v6gnlMTr1e3Hmv4RN7m" ++
            "nzAfBgNVHSMEGDAWgBQm9kkwVB5ND6jU/6J+Of5FH039ezAKBggqhkjOPQQDAgNIADBFAiEA" ++
            "nCktg91hVfwstjo8fa115KuMw63OX7BQZNdO8+er3zACIBKnh3D6SWyWceqU0voSPiosu6Ha" ++
            "BTPzbnHdhCNY0BGd",
        .leaf_b64 = "MIIBszCCAVqgAwIBAgIUIBVQDt3JN3cmBFyl5/KfHXyLlIAwCgYIKoZIzj0EAwIwHzEdMBsG" ++
            "A1UEAwwUbmMtaW50ZXItZG5zX2RvdHBlcm0wHhcNMjYwNzE1MjAxMjE2WhcNMzYwNzEyMjAx" ++
            "MjE2WjAWMRQwEgYDVQQDDAtsZWFmLWRuc19pbjBZMBMGByqGSM49AgEGCCqGSM49AwEHA0IA" ++
            "BCytB4Vd/69VstthyxJvcAjYQ0esmB9G4uTmKtwrW5TpO6axZeIpFXrx88sMFj9ITvNh9aSj" ++
            "1U22ZLyCZz8FaKejfTB7MAwGA1UdEwEB/wQCMAAwDgYDVR0PAQH/BAQDAgeAMBsGA1UdEQQU" ++
            "MBKCEGhvc3QuZXhhbXBsZS5jb20wHQYDVR0OBBYEFDZ9J7Wy3pzqZZXFIvwwCw1eUqqfMB8G" ++
            "A1UdIwQYMBaAFP7kuDnW/qCeUxOvV7cea/hE3uafMAoGCCqGSM49BAMCA0cAMEQCIH1HYO5t" ++
            "rLqBivaSOUgE2bbZ90g/6zEYz6H9pYhKrRiuAiAv4xjp+YlV4eC3rraRSYEIcQtlAGBTsW+j" ++
            "1/sKhQnjQg==",
    },
    .{
        .name = "dns_exact__dns_dotperm",
        .openssl_ok = false,
        .ztls_ok = false,
        .inter_b64 = "MIIBuDCCAV6gAwIBAgIUfIXDd6WpQ1DRce6dL3A/5kNomsEwCgYIKoZIzj0EAwIwEjEQMA4G" ++
            "A1UEAwwHbmMtcm9vdDAeFw0yNjA3MTUyMDEyMTRaFw0zNjA3MTIyMDEyMTRaMB8xHTAbBgNV" ++
            "BAMMFG5jLWludGVyLWRuc19kb3RwZXJtMFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAEr+IK" ++
            "6uFq0h7BMC9vt+q0scayqPurGjub6kBe8mzUylZq7+s1Wc739C0ge59XkE4f6ejiUC1NIFgx" ++
            "xScCT/0XzqOBhDCBgTAPBgNVHRMBAf8EBTADAQH/MA4GA1UdDwEB/wQEAwIBBjAeBgNVHR4B" ++
            "Af8EFDASoBAwDoIMLmV4YW1wbGUuY29tMB0GA1UdDgQWBBT+5Lg51v6gnlMTr1e3Hmv4RN7m" ++
            "nzAfBgNVHSMEGDAWgBQm9kkwVB5ND6jU/6J+Of5FH039ezAKBggqhkjOPQQDAgNIADBFAiEA" ++
            "nCktg91hVfwstjo8fa115KuMw63OX7BQZNdO8+er3zACIBKnh3D6SWyWceqU0voSPiosu6Ha" ++
            "BTPzbnHdhCNY0BGd",
        .leaf_b64 = "MIIBsjCCAVigAwIBAgIUIBVQDt3JN3cmBFyl5/KfHXyLlIEwCgYIKoZIzj0EAwIwHzEdMBsG" ++
            "A1UEAwwUbmMtaW50ZXItZG5zX2RvdHBlcm0wHhcNMjYwNzE1MjAxMjE2WhcNMzYwNzEyMjAx" ++
            "MjE2WjAZMRcwFQYDVQQDDA5sZWFmLWRuc19leGFjdDBZMBMGByqGSM49AgEGCCqGSM49AwEH" ++
            "A0IABEGyaB+wGdjSSSK8Q0EafCz8C8Gv/fKHlj2UxLd2bppA9ehFSWEb9Bri4xQw9WabxYho" ++
            "8K5iSAUcLT42OjofTayjeDB2MAwGA1UdEwEB/wQCMAAwDgYDVR0PAQH/BAQDAgeAMBYGA1Ud" ++
            "EQQPMA2CC2V4YW1wbGUuY29tMB0GA1UdDgQWBBQeR9JE0oo7zElt+EQXGMMgdUiZIDAfBgNV" ++
            "HSMEGDAWgBT+5Lg51v6gnlMTr1e3Hmv4RN7mnzAKBggqhkjOPQQDAgNIADBFAiEA/kGg2ZM1" ++
            "LHC5JDhzuI8AKI/p1+WVX513tn5GCOuGQ3MCICWoDsaHQ1r2PSiIX3mwW3buQfuKAe4RWESo" ++
            "pP/IN8/F",
    },
    .{
        .name = "dns_bad__dns_excl",
        .openssl_ok = false,
        .ztls_ok = false,
        .inter_b64 = "MIIBtzCCAV6gAwIBAgIUfIXDd6WpQ1DRce6dL3A/5kNomsAwCgYIKoZIzj0EAwIwEjEQMA4G" ++
            "A1UEAwwHbmMtcm9vdDAeFw0yNjA3MTUyMDEyMTRaFw0zNjA3MTIyMDEyMTRaMBwxGjAYBgNV" ++
            "BAMMEW5jLWludGVyLWRuc19leGNsMFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAECilgeP1s" ++
            "f/Q9wUy07aJXmzT3d6Ytlc3C2BTUk5fietUIte3tJyKPMzgzuDnkXYOKCMouaA4t5AKQiwL0" ++
            "IQJWNqOBhzCBhDAPBgNVHRMBAf8EBTADAQH/MA4GA1UdDwEB/wQEAwIBBjAhBgNVHR4BAf8E" ++
            "FzAVoRMwEYIPYmFkLmV4YW1wbGUuY29tMB0GA1UdDgQWBBTc5D+gxynT/qlwj80QVB/48tR7" ++
            "ZDAfBgNVHSMEGDAWgBQm9kkwVB5ND6jU/6J+Of5FH039ezAKBggqhkjOPQQDAgNHADBEAiAb" ++
            "hwL4VwNvytVFfoyG3TiAIr/JretN/uqTUUWyc+N3PQIgPAfyL1bPdkImXl5cjVdBRZOif7XA" ++
            "V6aqZt5FJV67tpM=",
        .leaf_b64 = "MIIBsDCCAVegAwIBAgIUTU/Hz3zh5HQGW0LWUzLOafQlokowCgYIKoZIzj0EAwIwHDEaMBgG" ++
            "A1UEAwwRbmMtaW50ZXItZG5zX2V4Y2wwHhcNMjYwNzE1MjAxMjE2WhcNMzYwNzEyMjAxMjE2" ++
            "WjAXMRUwEwYDVQQDDAxsZWFmLWRuc19iYWQwWTATBgcqhkjOPQIBBggqhkjOPQMBBwNCAASB" ++
            "a2RgEPgGz1QuM6rAI/lH7lcWJq6cCySe8U5EmPvaTpuL1OEh4Oq61COkdVloaeWdU0PDsXhB" ++
            "wq84+7hDCP/7o3wwejAMBgNVHRMBAf8EAjAAMA4GA1UdDwEB/wQEAwIHgDAaBgNVHREEEzAR" ++
            "gg9iYWQuZXhhbXBsZS5jb20wHQYDVR0OBBYEFCPldYfCgYJr4qTU9ZP8VU9+pY5iMB8GA1Ud" ++
            "IwQYMBaAFNzkP6DHKdP+qXCPzRBUH/jy1HtkMAoGCCqGSM49BAMCA0cAMEQCIEDRT7TXN9/7" ++
            "emG985TLMlW8MyAt2m2oyfcKtiltqST9AiBG0mo9Vf58oGhyvhcTP49C1WtgtZA7tGlo70EN" ++
            "xoWWqg==",
    },
    .{
        .name = "dns_subbad__dns_excl",
        .openssl_ok = false,
        .ztls_ok = false,
        .inter_b64 = "MIIBtzCCAV6gAwIBAgIUfIXDd6WpQ1DRce6dL3A/5kNomsAwCgYIKoZIzj0EAwIwEjEQMA4G" ++
            "A1UEAwwHbmMtcm9vdDAeFw0yNjA3MTUyMDEyMTRaFw0zNjA3MTIyMDEyMTRaMBwxGjAYBgNV" ++
            "BAMMEW5jLWludGVyLWRuc19leGNsMFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAECilgeP1s" ++
            "f/Q9wUy07aJXmzT3d6Ytlc3C2BTUk5fietUIte3tJyKPMzgzuDnkXYOKCMouaA4t5AKQiwL0" ++
            "IQJWNqOBhzCBhDAPBgNVHRMBAf8EBTADAQH/MA4GA1UdDwEB/wQEAwIBBjAhBgNVHR4BAf8E" ++
            "FzAVoRMwEYIPYmFkLmV4YW1wbGUuY29tMB0GA1UdDgQWBBTc5D+gxynT/qlwj80QVB/48tR7" ++
            "ZDAfBgNVHSMEGDAWgBQm9kkwVB5ND6jU/6J+Of5FH039ezAKBggqhkjOPQQDAgNHADBEAiAb" ++
            "hwL4VwNvytVFfoyG3TiAIr/JretN/uqTUUWyc+N3PQIgPAfyL1bPdkImXl5cjVdBRZOif7XA" ++
            "V6aqZt5FJV67tpM=",
        .leaf_b64 = "MIIBtTCCAVygAwIBAgIUTU/Hz3zh5HQGW0LWUzLOafQlokswCgYIKoZIzj0EAwIwHDEaMBgG" ++
            "A1UEAwwRbmMtaW50ZXItZG5zX2V4Y2wwHhcNMjYwNzE1MjAxMjE2WhcNMzYwNzEyMjAxMjE2" ++
            "WjAaMRgwFgYDVQQDDA9sZWFmLWRuc19zdWJiYWQwWTATBgcqhkjOPQIBBggqhkjOPQMBBwNC" ++
            "AAR9MgtIDWW7kFNNu5OC+nqJMvJnNf+kt33AOyTTpUVWrFMjWiDp4/5+1EDxNlk0P/Jod0mV" ++
            "oUyFe9kN9B1nS4/wo34wfDAMBgNVHRMBAf8EAjAAMA4GA1UdDwEB/wQEAwIHgDAcBgNVHREE" ++
            "FTATghF4LmJhZC5leGFtcGxlLmNvbTAdBgNVHQ4EFgQUuK6CvebUBhTCHA7BJ4i7BpZs0yEw" ++
            "HwYDVR0jBBgwFoAU3OQ/oMcp0/6pcI/NEFQf+PLUe2QwCgYIKoZIzj0EAwIDRwAwRAIgcBeM" ++
            "rvQ/nKohRS0SOs216ww+WToO1UDHGJnBBMVQ8d0CICy/2PRUisZlpmB4QT3FZSwffNEd3XdL" ++
            "ymYtReO72qt/",
    },
    .{
        .name = "dns_in__dns_excl",
        .openssl_ok = true,
        .ztls_ok = true,
        .inter_b64 = "MIIBtzCCAV6gAwIBAgIUfIXDd6WpQ1DRce6dL3A/5kNomsAwCgYIKoZIzj0EAwIwEjEQMA4G" ++
            "A1UEAwwHbmMtcm9vdDAeFw0yNjA3MTUyMDEyMTRaFw0zNjA3MTIyMDEyMTRaMBwxGjAYBgNV" ++
            "BAMMEW5jLWludGVyLWRuc19leGNsMFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAECilgeP1s" ++
            "f/Q9wUy07aJXmzT3d6Ytlc3C2BTUk5fietUIte3tJyKPMzgzuDnkXYOKCMouaA4t5AKQiwL0" ++
            "IQJWNqOBhzCBhDAPBgNVHRMBAf8EBTADAQH/MA4GA1UdDwEB/wQEAwIBBjAhBgNVHR4BAf8E" ++
            "FzAVoRMwEYIPYmFkLmV4YW1wbGUuY29tMB0GA1UdDgQWBBTc5D+gxynT/qlwj80QVB/48tR7" ++
            "ZDAfBgNVHSMEGDAWgBQm9kkwVB5ND6jU/6J+Of5FH039ezAKBggqhkjOPQQDAgNHADBEAiAb" ++
            "hwL4VwNvytVFfoyG3TiAIr/JretN/uqTUUWyc+N3PQIgPAfyL1bPdkImXl5cjVdBRZOif7XA" ++
            "V6aqZt5FJV67tpM=",
        .leaf_b64 = "MIIBsDCCAVegAwIBAgIUTU/Hz3zh5HQGW0LWUzLOafQlokwwCgYIKoZIzj0EAwIwHDEaMBgG" ++
            "A1UEAwwRbmMtaW50ZXItZG5zX2V4Y2wwHhcNMjYwNzE1MjAxMjE2WhcNMzYwNzEyMjAxMjE2" ++
            "WjAWMRQwEgYDVQQDDAtsZWFmLWRuc19pbjBZMBMGByqGSM49AgEGCCqGSM49AwEHA0IABCyt" ++
            "B4Vd/69VstthyxJvcAjYQ0esmB9G4uTmKtwrW5TpO6axZeIpFXrx88sMFj9ITvNh9aSj1U22" ++
            "ZLyCZz8FaKejfTB7MAwGA1UdEwEB/wQCMAAwDgYDVR0PAQH/BAQDAgeAMBsGA1UdEQQUMBKC" ++
            "EGhvc3QuZXhhbXBsZS5jb20wHQYDVR0OBBYEFDZ9J7Wy3pzqZZXFIvwwCw1eUqqfMB8GA1Ud" ++
            "IwQYMBaAFNzkP6DHKdP+qXCPzRBUH/jy1HtkMAoGCCqGSM49BAMCA0cAMEQCIBVYon8lFBuP" ++
            "mq6+ofUQ+bniJB+ubR9M/azNhdF2ANF1AiAkjwOqniLqaHGaYl3dAbfmM5hxsSiy/Ko0itVJ" ++
            "VunHMg==",
    },
    .{
        .name = "email_host__email_hostperm",
        .openssl_ok = true,
        .ztls_ok = true,
        .inter_b64 = "MIIBujCCAWCgAwIBAgIUfIXDd6WpQ1DRce6dL3A/5kNomsIwCgYIKoZIzj0EAwIwEjEQMA4G" ++
            "A1UEAwwHbmMtcm9vdDAeFw0yNjA3MTUyMDEyMTRaFw0zNjA3MTIyMDEyMTRaMCIxIDAeBgNV" ++
            "BAMMF25jLWludGVyLWVtYWlsX2hvc3RwZXJtMFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAE" ++
            "+0wb5vhajI8p3jgBY1jWneitcRBAxGdndEzxoE+9EvU5q01Z+vYgYW0TmPk/EqZEuVBgGMrc" ++
            "xOGlU5B2WdA2u6OBgzCBgDAPBgNVHRMBAf8EBTADAQH/MA4GA1UdDwEB/wQEAwIBBjAdBgNV" ++
            "HR4BAf8EEzARoA8wDYELZXhhbXBsZS5jb20wHQYDVR0OBBYEFDI4FX/e+6GhUrWQvpdYeRQV" ++
            "1UD/MB8GA1UdIwQYMBaAFCb2STBUHk0PqNT/on45/kUfTf17MAoGCCqGSM49BAMCA0gAMEUC" ++
            "IADJUYoAf4U/VbfkSgSxSsRqbpqW11x1TpBMQsDyCXs1AiEAhMSicheNmlwaAUFV4g9K3F1K" ++
            "rT40QC/ipnVX9QXN+SU=",
        .leaf_b64 = "MIIBujCCAWGgAwIBAgIUJ7k8wBPxpnlLtNOz9coTK51rfJowCgYIKoZIzj0EAwIwIjEgMB4G" ++
            "A1UEAwwXbmMtaW50ZXItZW1haWxfaG9zdHBlcm0wHhcNMjYwNzE1MjAxMjE2WhcNMzYwNzEy" ++
            "MjAxMjE2WjAaMRgwFgYDVQQDDA9sZWFmLWVtYWlsX2hvc3QwWTATBgcqhkjOPQIBBggqhkjO" ++
            "PQMBBwNCAARx5CCA3UzHKIEGjp7JWyp4jCa95+axH65Njsr96+EHttbOcHmgQzmYnhyydhmE" ++
            "V3Stxt08Mt+PtJvqfPeOTkuho30wezAMBgNVHRMBAf8EAjAAMA4GA1UdDwEB/wQEAwIHgDAb" ++
            "BgNVHREEFDASgRB1c2VyQGV4YW1wbGUuY29tMB0GA1UdDgQWBBS64W/Cz1N7rmncmm/zwwWe" ++
            "gJ1x0jAfBgNVHSMEGDAWgBQyOBV/3vuhoVK1kL6XWHkUFdVA/zAKBggqhkjOPQQDAgNHADBE" ++
            "AiBICjoRWC494LvJTxMlQ4Qpfxa5Q1pXjq6xLeeLZaOEOAIgRiERt5GPW3+AJMqrEBQQVVzr" ++
            "JwyeaicLBommv4U4DZM=",
    },
    .{
        .name = "email_sub__email_hostperm",
        .openssl_ok = false,
        .ztls_ok = false,
        .inter_b64 = "MIIBujCCAWCgAwIBAgIUfIXDd6WpQ1DRce6dL3A/5kNomsIwCgYIKoZIzj0EAwIwEjEQMA4G" ++
            "A1UEAwwHbmMtcm9vdDAeFw0yNjA3MTUyMDEyMTRaFw0zNjA3MTIyMDEyMTRaMCIxIDAeBgNV" ++
            "BAMMF25jLWludGVyLWVtYWlsX2hvc3RwZXJtMFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAE" ++
            "+0wb5vhajI8p3jgBY1jWneitcRBAxGdndEzxoE+9EvU5q01Z+vYgYW0TmPk/EqZEuVBgGMrc" ++
            "xOGlU5B2WdA2u6OBgzCBgDAPBgNVHRMBAf8EBTADAQH/MA4GA1UdDwEB/wQEAwIBBjAdBgNV" ++
            "HR4BAf8EEzARoA8wDYELZXhhbXBsZS5jb20wHQYDVR0OBBYEFDI4FX/e+6GhUrWQvpdYeRQV" ++
            "1UD/MB8GA1UdIwQYMBaAFCb2STBUHk0PqNT/on45/kUfTf17MAoGCCqGSM49BAMCA0gAMEUC" ++
            "IADJUYoAf4U/VbfkSgSxSsRqbpqW11x1TpBMQsDyCXs1AiEAhMSicheNmlwaAUFV4g9K3F1K" ++
            "rT40QC/ipnVX9QXN+SU=",
        .leaf_b64 = "MIIBwjCCAWegAwIBAgIUJ7k8wBPxpnlLtNOz9coTK51rfJswCgYIKoZIzj0EAwIwIjEgMB4G" ++
            "A1UEAwwXbmMtaW50ZXItZW1haWxfaG9zdHBlcm0wHhcNMjYwNzE1MjAxMjE2WhcNMzYwNzEy" ++
            "MjAxMjE2WjAZMRcwFQYDVQQDDA5sZWFmLWVtYWlsX3N1YjBZMBMGByqGSM49AgEGCCqGSM49" ++
            "AwEHA0IABF6VoXYbaspFBjLCA0Zc9UrBlDWJQ3gQiZ2mt+FuSuUCSiQh83dPUBAGeXVVIWNJ" ++
            "3LgLH6fPa6avad13sFBUvjKjgYMwgYAwDAYDVR0TAQH/BAIwADAOBgNVHQ8BAf8EBAMCB4Aw" ++
            "IAYDVR0RBBkwF4EVdXNlckBob3N0LmV4YW1wbGUuY29tMB0GA1UdDgQWBBQ307Qr4MeN1Maj" ++
            "CxS4UloPLf/InTAfBgNVHSMEGDAWgBQyOBV/3vuhoVK1kL6XWHkUFdVA/zAKBggqhkjOPQQD" ++
            "AgNJADBGAiEA5hqbxKEUPsjK2soKx9wqQ99fRcJvmwN4+Hscdw5YyM4CIQCll0ci5Imy0YIU" ++
            "Rvyr6VIAqYnqLt1mfc7dp6LWt8OKNg==",
    },
    .{
        .name = "email_host__email_dotperm",
        .openssl_ok = false,
        .ztls_ok = false,
        .inter_b64 = "MIIBujCCAWCgAwIBAgIUfIXDd6WpQ1DRce6dL3A/5kNomsMwCgYIKoZIzj0EAwIwEjEQMA4G" ++
            "A1UEAwwHbmMtcm9vdDAeFw0yNjA3MTUyMDEyMTRaFw0zNjA3MTIyMDEyMTRaMCExHzAdBgNV" ++
            "BAMMFm5jLWludGVyLWVtYWlsX2RvdHBlcm0wWTATBgcqhkjOPQIBBggqhkjOPQMBBwNCAARH" ++
            "AjnWW4oA6T9t6JEIl/miXs9tAwctnV6cqzjSK2SPcbUZld6CbU0juMAIxgk/FBO6PFc2fQX5" ++
            "WrtAdp315ZOdo4GEMIGBMA8GA1UdEwEB/wQFMAMBAf8wDgYDVR0PAQH/BAQDAgEGMB4GA1Ud" ++
            "HgEB/wQUMBKgEDAOgQwuZXhhbXBsZS5jb20wHQYDVR0OBBYEFNsCQlIms1L2HLQkLZ3nP3LR" ++
            "jfUeMB8GA1UdIwQYMBaAFCb2STBUHk0PqNT/on45/kUfTf17MAoGCCqGSM49BAMCA0gAMEUC" ++
            "IQD4j2QvCY7vR3PQ22Q3geTK3m/ORFicJQzPcbMV4oMungIgOjn/RQcGGYFSIwp3OKbATxrQ" ++
            "9NnsOhEUh9im+Vg7EZo=",
        .leaf_b64 = "MIIBuzCCAWCgAwIBAgIUVdQqyJ5Z5p2pTSG9ANrENnTANK4wCgYIKoZIzj0EAwIwITEfMB0G" ++
            "A1UEAwwWbmMtaW50ZXItZW1haWxfZG90cGVybTAeFw0yNjA3MTUyMDEyMTZaFw0zNjA3MTIy" ++
            "MDEyMTZaMBoxGDAWBgNVBAMMD2xlYWYtZW1haWxfaG9zdDBZMBMGByqGSM49AgEGCCqGSM49" ++
            "AwEHA0IABHHkIIDdTMcogQaOnslbKniMJr3n5rEfrk2Oyv3r4Qe21s5weaBDOZieHLJ2GYRX" ++
            "dK3G3Twy34+0m+p8945OS6GjfTB7MAwGA1UdEwEB/wQCMAAwDgYDVR0PAQH/BAQDAgeAMBsG" ++
            "A1UdEQQUMBKBEHVzZXJAZXhhbXBsZS5jb20wHQYDVR0OBBYEFLrhb8LPU3uuadyab/PDBZ6A" ++
            "nXHSMB8GA1UdIwQYMBaAFNsCQlIms1L2HLQkLZ3nP3LRjfUeMAoGCCqGSM49BAMCA0kAMEYC" ++
            "IQCBQ4luke6Nw522PcLLy60paXtrznb8UJwhyFpaob//kwIhAL2A+w2kGF4Kj6G7wNDwKwIo" ++
            "qTKWQw5ZqOl8qfshFFdQ",
    },
    .{
        .name = "email_sub__email_dotperm",
        .openssl_ok = true,
        .ztls_ok = true,
        .inter_b64 = "MIIBujCCAWCgAwIBAgIUfIXDd6WpQ1DRce6dL3A/5kNomsMwCgYIKoZIzj0EAwIwEjEQMA4G" ++
            "A1UEAwwHbmMtcm9vdDAeFw0yNjA3MTUyMDEyMTRaFw0zNjA3MTIyMDEyMTRaMCExHzAdBgNV" ++
            "BAMMFm5jLWludGVyLWVtYWlsX2RvdHBlcm0wWTATBgcqhkjOPQIBBggqhkjOPQMBBwNCAARH" ++
            "AjnWW4oA6T9t6JEIl/miXs9tAwctnV6cqzjSK2SPcbUZld6CbU0juMAIxgk/FBO6PFc2fQX5" ++
            "WrtAdp315ZOdo4GEMIGBMA8GA1UdEwEB/wQFMAMBAf8wDgYDVR0PAQH/BAQDAgEGMB4GA1Ud" ++
            "HgEB/wQUMBKgEDAOgQwuZXhhbXBsZS5jb20wHQYDVR0OBBYEFNsCQlIms1L2HLQkLZ3nP3LR" ++
            "jfUeMB8GA1UdIwQYMBaAFCb2STBUHk0PqNT/on45/kUfTf17MAoGCCqGSM49BAMCA0gAMEUC" ++
            "IQD4j2QvCY7vR3PQ22Q3geTK3m/ORFicJQzPcbMV4oMungIgOjn/RQcGGYFSIwp3OKbATxrQ" ++
            "9NnsOhEUh9im+Vg7EZo=",
        .leaf_b64 = "MIIBwTCCAWagAwIBAgIUVdQqyJ5Z5p2pTSG9ANrENnTANK8wCgYIKoZIzj0EAwIwITEfMB0G" ++
            "A1UEAwwWbmMtaW50ZXItZW1haWxfZG90cGVybTAeFw0yNjA3MTUyMDEyMTZaFw0zNjA3MTIy" ++
            "MDEyMTZaMBkxFzAVBgNVBAMMDmxlYWYtZW1haWxfc3ViMFkwEwYHKoZIzj0CAQYIKoZIzj0D" ++
            "AQcDQgAEXpWhdhtqykUGMsIDRlz1SsGUNYlDeBCJnaa34W5K5QJKJCHzd09QEAZ5dVUhY0nc" ++
            "uAsfp89rpq9p3XewUFS+MqOBgzCBgDAMBgNVHRMBAf8EAjAAMA4GA1UdDwEB/wQEAwIHgDAg" ++
            "BgNVHREEGTAXgRV1c2VyQGhvc3QuZXhhbXBsZS5jb20wHQYDVR0OBBYEFDfTtCvgx43UxqML" ++
            "FLhSWg8t/8idMB8GA1UdIwQYMBaAFNsCQlIms1L2HLQkLZ3nP3LRjfUeMAoGCCqGSM49BAMC" ++
            "A0kAMEYCIQDhc9etzhzcuuqMz8yDl48DDIB1Aq0XdSBxe74zAs63lAIhAMOdCaEl1p/qrfkE" ++
            "aOHnIWwbFZL8xQYNhhRcCHGkDEqz",
    },
    .{
        .name = "email_admin__email_mbxperm",
        .openssl_ok = true,
        .ztls_ok = true,
        .inter_b64 = "MIIBvjCCAWWgAwIBAgIUfIXDd6WpQ1DRce6dL3A/5kNomsQwCgYIKoZIzj0EAwIwEjEQMA4G" ++
            "A1UEAwwHbmMtcm9vdDAeFw0yNjA3MTUyMDEyMTRaFw0zNjA3MTIyMDEyMTRaMCExHzAdBgNV" ++
            "BAMMFm5jLWludGVyLWVtYWlsX21ieHBlcm0wWTATBgcqhkjOPQIBBggqhkjOPQMBBwNCAATj" ++
            "Bok9+u0SL66WvZbeyl5lFgmQh95yMn+JHDE6gq2u2MSO/8InI+i9wh5kbXBDwzkDn9HahZLE" ++
            "oZWhkuOI+LVvo4GJMIGGMA8GA1UdEwEB/wQFMAMBAf8wDgYDVR0PAQH/BAQDAgEGMCMGA1Ud" ++
            "HgEB/wQZMBegFTATgRFhZG1pbkBleGFtcGxlLmNvbTAdBgNVHQ4EFgQUs1yiG2uUXHZGx/mK" ++
            "qzdG/z0Puo4wHwYDVR0jBBgwFoAUJvZJMFQeTQ+o1P+ifjn+RR9N/XswCgYIKoZIzj0EAwID" ++
            "RwAwRAIgIg0aUl9HjLLLnzDQlrfSNfb277VDKXLLnJN9rk6YpjMCIBGCrmbcJ71vC2nZ45bT" ++
            "KGV0U8En73s+OKFyGkT/0KYI",
        .leaf_b64 = "MIIBuzCCAWKgAwIBAgIUcFgHtSmb+uRIavXyVSOwiTOcRBwwCgYIKoZIzj0EAwIwITEfMB0G" ++
            "A1UEAwwWbmMtaW50ZXItZW1haWxfbWJ4cGVybTAeFw0yNjA3MTUyMDEyMTZaFw0zNjA3MTIy" ++
            "MDEyMTZaMBsxGTAXBgNVBAMMEGxlYWYtZW1haWxfYWRtaW4wWTATBgcqhkjOPQIBBggqhkjO" ++
            "PQMBBwNCAARf4QP8n1MVRQWsL1EUQX1MA5Qs07BX4N9rVFTcXJoHz4sXCg3Yptr/FQplzx/M" ++
            "WU7oa8uHmHxs9851uwtQkBs4o34wfDAMBgNVHRMBAf8EAjAAMA4GA1UdDwEB/wQEAwIHgDAc" ++
            "BgNVHREEFTATgRFhZG1pbkBleGFtcGxlLmNvbTAdBgNVHQ4EFgQUzjQC4qqllxhKKKf8jcRP" ++
            "NXYsHVwwHwYDVR0jBBgwFoAUs1yiG2uUXHZGx/mKqzdG/z0Puo4wCgYIKoZIzj0EAwIDRwAw" ++
            "RAIgN38uNQO0pU3Bke5BckiH2Dky809J8pqb1EWzaKpH7AYCIFzu4xWAwlNGqGhw0MSNLF2/" ++
            "Gb4j9ibj8biV3L7Z+P6p",
    },
    .{
        .name = "email_host__email_mbxperm",
        .openssl_ok = false,
        .ztls_ok = false,
        .inter_b64 = "MIIBvjCCAWWgAwIBAgIUfIXDd6WpQ1DRce6dL3A/5kNomsQwCgYIKoZIzj0EAwIwEjEQMA4G" ++
            "A1UEAwwHbmMtcm9vdDAeFw0yNjA3MTUyMDEyMTRaFw0zNjA3MTIyMDEyMTRaMCExHzAdBgNV" ++
            "BAMMFm5jLWludGVyLWVtYWlsX21ieHBlcm0wWTATBgcqhkjOPQIBBggqhkjOPQMBBwNCAATj" ++
            "Bok9+u0SL66WvZbeyl5lFgmQh95yMn+JHDE6gq2u2MSO/8InI+i9wh5kbXBDwzkDn9HahZLE" ++
            "oZWhkuOI+LVvo4GJMIGGMA8GA1UdEwEB/wQFMAMBAf8wDgYDVR0PAQH/BAQDAgEGMCMGA1Ud" ++
            "HgEB/wQZMBegFTATgRFhZG1pbkBleGFtcGxlLmNvbTAdBgNVHQ4EFgQUs1yiG2uUXHZGx/mK" ++
            "qzdG/z0Puo4wHwYDVR0jBBgwFoAUJvZJMFQeTQ+o1P+ifjn+RR9N/XswCgYIKoZIzj0EAwID" ++
            "RwAwRAIgIg0aUl9HjLLLnzDQlrfSNfb277VDKXLLnJN9rk6YpjMCIBGCrmbcJ71vC2nZ45bT" ++
            "KGV0U8En73s+OKFyGkT/0KYI",
        .leaf_b64 = "MIIBuzCCAWCgAwIBAgIUcFgHtSmb+uRIavXyVSOwiTOcRB0wCgYIKoZIzj0EAwIwITEfMB0G" ++
            "A1UEAwwWbmMtaW50ZXItZW1haWxfbWJ4cGVybTAeFw0yNjA3MTUyMDEyMTdaFw0zNjA3MTIy" ++
            "MDEyMTdaMBoxGDAWBgNVBAMMD2xlYWYtZW1haWxfaG9zdDBZMBMGByqGSM49AgEGCCqGSM49" ++
            "AwEHA0IABHHkIIDdTMcogQaOnslbKniMJr3n5rEfrk2Oyv3r4Qe21s5weaBDOZieHLJ2GYRX" ++
            "dK3G3Twy34+0m+p8945OS6GjfTB7MAwGA1UdEwEB/wQCMAAwDgYDVR0PAQH/BAQDAgeAMBsG" ++
            "A1UdEQQUMBKBEHVzZXJAZXhhbXBsZS5jb20wHQYDVR0OBBYEFLrhb8LPU3uuadyab/PDBZ6A" ++
            "nXHSMB8GA1UdIwQYMBaAFLNcohtrlFx2Rsf5iqs3Rv89D7qOMAoGCCqGSM49BAMCA0kAMEYC" ++
            "IQDGh08XdzzkjHYcCFOhe5/ZNp9KnrMVBP4kRDUtWfX9sAIhAJ70MppxPGvdPdn7ypaVV6qm" ++
            "cg+psgqBt0QYpuHz9fPR",
    },
    .{
        .name = "email_host__email_hostexcl",
        .openssl_ok = false,
        .ztls_ok = false,
        .inter_b64 = "MIIBujCCAWCgAwIBAgIUfIXDd6WpQ1DRce6dL3A/5kNomsUwCgYIKoZIzj0EAwIwEjEQMA4G" ++
            "A1UEAwwHbmMtcm9vdDAeFw0yNjA3MTUyMDEyMTRaFw0zNjA3MTIyMDEyMTRaMCIxIDAeBgNV" ++
            "BAMMF25jLWludGVyLWVtYWlsX2hvc3RleGNsMFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAE" ++
            "wVmdtMA5DeTZN4jmMI+M1vmNV3k0jOeidaQHFXny5RawFWtNUt2MPQcf+cr+DwxATP9wgrpZ" ++
            "WzWJ94T4o9Ue8aOBgzCBgDAPBgNVHRMBAf8EBTADAQH/MA4GA1UdDwEB/wQEAwIBBjAdBgNV" ++
            "HR4BAf8EEzARoQ8wDYELZXhhbXBsZS5jb20wHQYDVR0OBBYEFCTda1TCl5NkT44rWXx9WyVG" ++
            "PfD9MB8GA1UdIwQYMBaAFCb2STBUHk0PqNT/on45/kUfTf17MAoGCCqGSM49BAMCA0gAMEUC" ++
            "IEaZtrYH1RQgNd2mHzGOD1URknW/SA1MQHBDuYd5Jk8dAiEA3LHqnFTX/bpwM1z8bK3QZYgd" ++
            "A7+bO+PI2HGB8JOzu2k=",
        .leaf_b64 = "MIIBujCCAWGgAwIBAgIUczScBR4LrjKsJgGfvm6pJvx27i0wCgYIKoZIzj0EAwIwIjEgMB4G" ++
            "A1UEAwwXbmMtaW50ZXItZW1haWxfaG9zdGV4Y2wwHhcNMjYwNzE1MjAxMjE3WhcNMzYwNzEy" ++
            "MjAxMjE3WjAaMRgwFgYDVQQDDA9sZWFmLWVtYWlsX2hvc3QwWTATBgcqhkjOPQIBBggqhkjO" ++
            "PQMBBwNCAARx5CCA3UzHKIEGjp7JWyp4jCa95+axH65Njsr96+EHttbOcHmgQzmYnhyydhmE" ++
            "V3Stxt08Mt+PtJvqfPeOTkuho30wezAMBgNVHRMBAf8EAjAAMA4GA1UdDwEB/wQEAwIHgDAb" ++
            "BgNVHREEFDASgRB1c2VyQGV4YW1wbGUuY29tMB0GA1UdDgQWBBS64W/Cz1N7rmncmm/zwwWe" ++
            "gJ1x0jAfBgNVHSMEGDAWgBQk3WtUwpeTZE+OK1l8fVslRj3w/TAKBggqhkjOPQQDAgNHADBE" ++
            "AiBG1HA9RJBDQIQsDtEyLN62aqzFJ/FVXHB5E/h0JyWP/wIgJUWOTHTeWZMFi8cvpHXy3xQG" ++
            "UIRecgk3Ez60MaPT87A=",
    },
    .{
        .name = "email_sub__email_hostexcl",
        .openssl_ok = true,
        .ztls_ok = true,
        .inter_b64 = "MIIBujCCAWCgAwIBAgIUfIXDd6WpQ1DRce6dL3A/5kNomsUwCgYIKoZIzj0EAwIwEjEQMA4G" ++
            "A1UEAwwHbmMtcm9vdDAeFw0yNjA3MTUyMDEyMTRaFw0zNjA3MTIyMDEyMTRaMCIxIDAeBgNV" ++
            "BAMMF25jLWludGVyLWVtYWlsX2hvc3RleGNsMFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAE" ++
            "wVmdtMA5DeTZN4jmMI+M1vmNV3k0jOeidaQHFXny5RawFWtNUt2MPQcf+cr+DwxATP9wgrpZ" ++
            "WzWJ94T4o9Ue8aOBgzCBgDAPBgNVHRMBAf8EBTADAQH/MA4GA1UdDwEB/wQEAwIBBjAdBgNV" ++
            "HR4BAf8EEzARoQ8wDYELZXhhbXBsZS5jb20wHQYDVR0OBBYEFCTda1TCl5NkT44rWXx9WyVG" ++
            "PfD9MB8GA1UdIwQYMBaAFCb2STBUHk0PqNT/on45/kUfTf17MAoGCCqGSM49BAMCA0gAMEUC" ++
            "IEaZtrYH1RQgNd2mHzGOD1URknW/SA1MQHBDuYd5Jk8dAiEA3LHqnFTX/bpwM1z8bK3QZYgd" ++
            "A7+bO+PI2HGB8JOzu2k=",
        .leaf_b64 = "MIIBwTCCAWegAwIBAgIUczScBR4LrjKsJgGfvm6pJvx27i4wCgYIKoZIzj0EAwIwIjEgMB4G" ++
            "A1UEAwwXbmMtaW50ZXItZW1haWxfaG9zdGV4Y2wwHhcNMjYwNzE1MjAxMjE3WhcNMzYwNzEy" ++
            "MjAxMjE3WjAZMRcwFQYDVQQDDA5sZWFmLWVtYWlsX3N1YjBZMBMGByqGSM49AgEGCCqGSM49" ++
            "AwEHA0IABF6VoXYbaspFBjLCA0Zc9UrBlDWJQ3gQiZ2mt+FuSuUCSiQh83dPUBAGeXVVIWNJ" ++
            "3LgLH6fPa6avad13sFBUvjKjgYMwgYAwDAYDVR0TAQH/BAIwADAOBgNVHQ8BAf8EBAMCB4Aw" ++
            "IAYDVR0RBBkwF4EVdXNlckBob3N0LmV4YW1wbGUuY29tMB0GA1UdDgQWBBQ307Qr4MeN1Maj" ++
            "CxS4UloPLf/InTAfBgNVHSMEGDAWgBQk3WtUwpeTZE+OK1l8fVslRj3w/TAKBggqhkjOPQQD" ++
            "AgNIADBFAiEAwQ8oJPL6tWx7uPT7Do4F68ENFsL2s5e+9L3rPzeX61wCIHbbmeN2blmXIIx5" ++
            "U0PSQfvifgtWVH7yNk7MZpgtLX4H",
    },
    .{
        .name = "email_other__email_hostexcl",
        .openssl_ok = true,
        .ztls_ok = true,
        .inter_b64 = "MIIBujCCAWCgAwIBAgIUfIXDd6WpQ1DRce6dL3A/5kNomsUwCgYIKoZIzj0EAwIwEjEQMA4G" ++
            "A1UEAwwHbmMtcm9vdDAeFw0yNjA3MTUyMDEyMTRaFw0zNjA3MTIyMDEyMTRaMCIxIDAeBgNV" ++
            "BAMMF25jLWludGVyLWVtYWlsX2hvc3RleGNsMFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAE" ++
            "wVmdtMA5DeTZN4jmMI+M1vmNV3k0jOeidaQHFXny5RawFWtNUt2MPQcf+cr+DwxATP9wgrpZ" ++
            "WzWJ94T4o9Ue8aOBgzCBgDAPBgNVHRMBAf8EBTADAQH/MA4GA1UdDwEB/wQEAwIBBjAdBgNV" ++
            "HR4BAf8EEzARoQ8wDYELZXhhbXBsZS5jb20wHQYDVR0OBBYEFCTda1TCl5NkT44rWXx9WyVG" ++
            "PfD9MB8GA1UdIwQYMBaAFCb2STBUHk0PqNT/on45/kUfTf17MAoGCCqGSM49BAMCA0gAMEUC" ++
            "IEaZtrYH1RQgNd2mHzGOD1URknW/SA1MQHBDuYd5Jk8dAiEA3LHqnFTX/bpwM1z8bK3QZYgd" ++
            "A7+bO+PI2HGB8JOzu2k=",
        .leaf_b64 = "MIIBvDCCAWKgAwIBAgIUczScBR4LrjKsJgGfvm6pJvx27i8wCgYIKoZIzj0EAwIwIjEgMB4G" ++
            "A1UEAwwXbmMtaW50ZXItZW1haWxfaG9zdGV4Y2wwHhcNMjYwNzE1MjAxMjE3WhcNMzYwNzEy" ++
            "MjAxMjE3WjAbMRkwFwYDVQQDDBBsZWFmLWVtYWlsX290aGVyMFkwEwYHKoZIzj0CAQYIKoZI" ++
            "zj0DAQcDQgAEXPOlPRfluDlrddhTPBFpMzOTActO4frNAqL/ksI+GhLpopRPbUAFCiXbPIUS" ++
            "G9xPTpCXbGPYLdF6kfe7YfaBhqN9MHswDAYDVR0TAQH/BAIwADAOBgNVHQ8BAf8EBAMCB4Aw" ++
            "GwYDVR0RBBQwEoEQYWRtaW5Ab3RoZXIudGVzdDAdBgNVHQ4EFgQU5PKc1U4TLQSgLj3uUiZ2" ++
            "yM1YCdIwHwYDVR0jBBgwFoAUJN1rVMKXk2RPjitZfH1bJUY98P0wCgYIKoZIzj0EAwIDSAAw" ++
            "RQIgfxJlqBd7mR/h6y1NGV4isK4ywC//C5nD+n1jGp6yL/ICIQCPeFZCUkBQFrdrcHVToJRB" ++
            "/7s1v3XM3ezTRkfBBT67RA==",
    },
    .{
        .name = "uri_sub__uri_perm",
        .openssl_ok = true,
        .ztls_ok = true,
        .inter_b64 = "MIIBtTCCAVugAwIBAgIUfIXDd6WpQ1DRce6dL3A/5kNomsYwCgYIKoZIzj0EAwIwEjEQMA4G" ++
            "A1UEAwwHbmMtcm9vdDAeFw0yNjA3MTUyMDEyMTRaFw0zNjA3MTIyMDEyMTRaMBwxGjAYBgNV" ++
            "BAMMEW5jLWludGVyLXVyaV9wZXJtMFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAEsk9O/4y7" ++
            "glBP/J2AXj+5xai7FyibXsDNbsLVJyB2IQU8Ih/Oyim1zRcpv/TFmL8fahvj+LgVOkUrNkfO" ++
            "Ttke7KOBhDCBgTAPBgNVHRMBAf8EBTADAQH/MA4GA1UdDwEB/wQEAwIBBjAeBgNVHR4BAf8E" ++
            "FDASoBAwDoYMLmV4YW1wbGUuY29tMB0GA1UdDgQWBBR7OiRPQegXNd3yS/EonIa52n1yCTAf" ++
            "BgNVHSMEGDAWgBQm9kkwVB5ND6jU/6J+Of5FH039ezAKBggqhkjOPQQDAgNIADBFAiBXZE2t" ++
            "OcAqpZO0Jmpe0LSqOrN+0/ADZSZKcHt5/syRdAIhAI6pr5gw3zsSJ2NpuDaJ4WfT+sAepNDg" ++
            "udEPNVUhGlp+",
        .leaf_b64 = "MIIBwjCCAWegAwIBAgIUGAYWfA9SFPN8ddjZ8zSAtHmS9MIwCgYIKoZIzj0EAwIwHDEaMBgG" ++
            "A1UEAwwRbmMtaW50ZXItdXJpX3Blcm0wHhcNMjYwNzE1MjAxMjE3WhcNMzYwNzEyMjAxMjE3" ++
            "WjAXMRUwEwYDVQQDDAxsZWFmLXVyaV9zdWIwWTATBgcqhkjOPQIBBggqhkjOPQMBBwNCAAQv" ++
            "UtzIH4iZ60vrKalXoVTONZhRR59WqXtFdC0nsO5CeXeT7jgB1kP/f06mPsi0V3xMbBQiajnI" ++
            "RZAE1yRu3MfJo4GLMIGIMAwGA1UdEwEB/wQCMAAwDgYDVR0PAQH/BAQDAgeAMCgGA1UdEQQh" ++
            "MB+GHWh0dHBzOi8vaG9zdC5leGFtcGxlLmNvbS9wYXRoMB0GA1UdDgQWBBSLQAVYReIsETLl" ++
            "PNzimyhlPX3M0TAfBgNVHSMEGDAWgBR7OiRPQegXNd3yS/EonIa52n1yCTAKBggqhkjOPQQD" ++
            "AgNJADBGAiEAlQK+74WSHh5DQiRBHHacSUmbErRwT3NWMvoU5MNhC+QCIQDsQ1QHY+kbD0UM" ++
            "xqD4rm1oEKr/wiLN+yX5Wk6Vozl+IQ==",
    },
    .{
        .name = "uri_exact__uri_perm",
        .openssl_ok = false,
        .ztls_ok = false,
        .inter_b64 = "MIIBtTCCAVugAwIBAgIUfIXDd6WpQ1DRce6dL3A/5kNomsYwCgYIKoZIzj0EAwIwEjEQMA4G" ++
            "A1UEAwwHbmMtcm9vdDAeFw0yNjA3MTUyMDEyMTRaFw0zNjA3MTIyMDEyMTRaMBwxGjAYBgNV" ++
            "BAMMEW5jLWludGVyLXVyaV9wZXJtMFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAEsk9O/4y7" ++
            "glBP/J2AXj+5xai7FyibXsDNbsLVJyB2IQU8Ih/Oyim1zRcpv/TFmL8fahvj+LgVOkUrNkfO" ++
            "Ttke7KOBhDCBgTAPBgNVHRMBAf8EBTADAQH/MA4GA1UdDwEB/wQEAwIBBjAeBgNVHR4BAf8E" ++
            "FDASoBAwDoYMLmV4YW1wbGUuY29tMB0GA1UdDgQWBBR7OiRPQegXNd3yS/EonIa52n1yCTAf" ++
            "BgNVHSMEGDAWgBQm9kkwVB5ND6jU/6J+Of5FH039ezAKBggqhkjOPQQDAgNIADBFAiBXZE2t" ++
            "OcAqpZO0Jmpe0LSqOrN+0/ADZSZKcHt5/syRdAIhAI6pr5gw3zsSJ2NpuDaJ4WfT+sAepNDg" ++
            "udEPNVUhGlp+",
        .leaf_b64 = "MIIBuzCCAWGgAwIBAgIUGAYWfA9SFPN8ddjZ8zSAtHmS9MMwCgYIKoZIzj0EAwIwHDEaMBgG" ++
            "A1UEAwwRbmMtaW50ZXItdXJpX3Blcm0wHhcNMjYwNzE1MjAxMjE3WhcNMzYwNzEyMjAxMjE3" ++
            "WjAZMRcwFQYDVQQDDA5sZWFmLXVyaV9leGFjdDBZMBMGByqGSM49AgEGCCqGSM49AwEHA0IA" ++
            "BDbqguzNsWmj73Ohx+5lejpJZIwfmf7ESQJK4AY0r3SDCW763S6qPolVpRd79HT40I+L9P/V" ++
            "enRaOPjIVlDs8emjgYMwgYAwDAYDVR0TAQH/BAIwADAOBgNVHQ8BAf8EBAMCB4AwIAYDVR0R" ++
            "BBkwF4YVaHR0cHM6Ly9leGFtcGxlLmNvbS94MB0GA1UdDgQWBBQN3suPYK9y5To+sMu276C/" ++
            "lNlwjzAfBgNVHSMEGDAWgBR7OiRPQegXNd3yS/EonIa52n1yCTAKBggqhkjOPQQDAgNIADBF" ++
            "AiBLwEno0QXmM0PMzJNkxxPVdFqW5JTwzOhNOOhI20n/rgIhALNa/rL7RxUQl/R9xbLKg8Yt" ++
            "6xZzQg/YMthmq91ROLLj",
    },
    .{
        .name = "uri_sub__uri_hostperm",
        .openssl_ok = false,
        .ztls_ok = false,
        .inter_b64 = "MIIBtzCCAV6gAwIBAgIUfIXDd6WpQ1DRce6dL3A/5kNomscwCgYIKoZIzj0EAwIwEjEQMA4G" ++
            "A1UEAwwHbmMtcm9vdDAeFw0yNjA3MTUyMDEyMTRaFw0zNjA3MTIyMDEyMTRaMCAxHjAcBgNV" ++
            "BAMMFW5jLWludGVyLXVyaV9ob3N0cGVybTBZMBMGByqGSM49AgEGCCqGSM49AwEHA0IABFS0" ++
            "5RZ3B+ogyM4FvapSClkWiBYfHi/7xrkCvawLDUsGjMPdN2pfx+8gbHdKN6L91sfEc8tYhsOV" ++
            "yroK3bE4UaijgYMwgYAwDwYDVR0TAQH/BAUwAwEB/zAOBgNVHQ8BAf8EBAMCAQYwHQYDVR0e" ++
            "AQH/BBMwEaAPMA2GC2V4YW1wbGUuY29tMB0GA1UdDgQWBBSpNi77wXxB2onXlKbrxbKLx9i7" ++
            "BTAfBgNVHSMEGDAWgBQm9kkwVB5ND6jU/6J+Of5FH039ezAKBggqhkjOPQQDAgNHADBEAiAv" ++
            "E9UyaszpuzFmyoLJxo9qMn8B70h2x5jYTKLJUl8JqgIga08LzhWfx3zt8VxEZ4yQHray4D7z" ++
            "f8qakHv3ji2qKYE=",
        .leaf_b64 = "MIIBxTCCAWugAwIBAgIUe6M4tHcsu9BKuwAOD7ONeh2BsQIwCgYIKoZIzj0EAwIwIDEeMBwG" ++
            "A1UEAwwVbmMtaW50ZXItdXJpX2hvc3RwZXJtMB4XDTI2MDcxNTIwMTIxN1oXDTM2MDcxMjIw" ++
            "MTIxN1owFzEVMBMGA1UEAwwMbGVhZi11cmlfc3ViMFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcD" ++
            "QgAEL1LcyB+ImetL6ympV6FUzjWYUUefVql7RXQtJ7DuQnl3k+44AdZD/39Opj7ItFd8TGwU" ++
            "Imo5yEWQBNckbtzHyaOBizCBiDAMBgNVHRMBAf8EAjAAMA4GA1UdDwEB/wQEAwIHgDAoBgNV" ++
            "HREEITAfhh1odHRwczovL2hvc3QuZXhhbXBsZS5jb20vcGF0aDAdBgNVHQ4EFgQUi0AFWEXi" ++
            "LBEy5Tzc4psoZT19zNEwHwYDVR0jBBgwFoAUqTYu+8F8QdqJ15Sm68Wyi8fYuwUwCgYIKoZI" ++
            "zj0EAwIDSAAwRQIgXWOwTe4kyiaQNaDwdci4NZ5bociGwE24g6pt2ckgpI4CIQCVZl+KDs+v" ++
            "/ZmC/XcxG2gfGJDLy5Ycn+qkvp2hIAjCPg==",
    },
    .{
        .name = "uri_exact__uri_hostperm",
        .openssl_ok = true,
        .ztls_ok = true,
        .inter_b64 = "MIIBtzCCAV6gAwIBAgIUfIXDd6WpQ1DRce6dL3A/5kNomscwCgYIKoZIzj0EAwIwEjEQMA4G" ++
            "A1UEAwwHbmMtcm9vdDAeFw0yNjA3MTUyMDEyMTRaFw0zNjA3MTIyMDEyMTRaMCAxHjAcBgNV" ++
            "BAMMFW5jLWludGVyLXVyaV9ob3N0cGVybTBZMBMGByqGSM49AgEGCCqGSM49AwEHA0IABFS0" ++
            "5RZ3B+ogyM4FvapSClkWiBYfHi/7xrkCvawLDUsGjMPdN2pfx+8gbHdKN6L91sfEc8tYhsOV" ++
            "yroK3bE4UaijgYMwgYAwDwYDVR0TAQH/BAUwAwEB/zAOBgNVHQ8BAf8EBAMCAQYwHQYDVR0e" ++
            "AQH/BBMwEaAPMA2GC2V4YW1wbGUuY29tMB0GA1UdDgQWBBSpNi77wXxB2onXlKbrxbKLx9i7" ++
            "BTAfBgNVHSMEGDAWgBQm9kkwVB5ND6jU/6J+Of5FH039ezAKBggqhkjOPQQDAgNHADBEAiAv" ++
            "E9UyaszpuzFmyoLJxo9qMn8B70h2x5jYTKLJUl8JqgIga08LzhWfx3zt8VxEZ4yQHray4D7z" ++
            "f8qakHv3ji2qKYE=",
        .leaf_b64 = "MIIBvzCCAWWgAwIBAgIUe6M4tHcsu9BKuwAOD7ONeh2BsQMwCgYIKoZIzj0EAwIwIDEeMBwG" ++
            "A1UEAwwVbmMtaW50ZXItdXJpX2hvc3RwZXJtMB4XDTI2MDcxNTIwMTIxN1oXDTM2MDcxMjIw" ++
            "MTIxN1owGTEXMBUGA1UEAwwObGVhZi11cmlfZXhhY3QwWTATBgcqhkjOPQIBBggqhkjOPQMB" ++
            "BwNCAAQ26oLszbFpo+9zocfuZXo6SWSMH5n+xEkCSuAGNK90gwlu+t0uqj6JVaUXe/R0+NCP" ++
            "i/T/1Xp0Wjj4yFZQ7PHpo4GDMIGAMAwGA1UdEwEB/wQCMAAwDgYDVR0PAQH/BAQDAgeAMCAG" ++
            "A1UdEQQZMBeGFWh0dHBzOi8vZXhhbXBsZS5jb20veDAdBgNVHQ4EFgQUDd7Lj2CvcuU6PrDL" ++
            "tu+gv5TZcI8wHwYDVR0jBBgwFoAUqTYu+8F8QdqJ15Sm68Wyi8fYuwUwCgYIKoZIzj0EAwID" ++
            "SAAwRQIgWOOSYe75MKHp+6l06U9N8TCCUvtlKbqTFapcP037Ry4CIQDiLf/5txwAv/yc2/p0" ++
            "DoPvIY1vlQfL0PsVvdbf0HPrQQ==",
    },
    .{
        .name = "uri_userport__uri_hostperm",
        .openssl_ok = false,
        .ztls_ok = false,
        .inter_b64 = "MIIBtzCCAV6gAwIBAgIUfIXDd6WpQ1DRce6dL3A/5kNomscwCgYIKoZIzj0EAwIwEjEQMA4G" ++
            "A1UEAwwHbmMtcm9vdDAeFw0yNjA3MTUyMDEyMTRaFw0zNjA3MTIyMDEyMTRaMCAxHjAcBgNV" ++
            "BAMMFW5jLWludGVyLXVyaV9ob3N0cGVybTBZMBMGByqGSM49AgEGCCqGSM49AwEHA0IABFS0" ++
            "5RZ3B+ogyM4FvapSClkWiBYfHi/7xrkCvawLDUsGjMPdN2pfx+8gbHdKN6L91sfEc8tYhsOV" ++
            "yroK3bE4UaijgYMwgYAwDwYDVR0TAQH/BAUwAwEB/zAOBgNVHQ8BAf8EBAMCAQYwHQYDVR0e" ++
            "AQH/BBMwEaAPMA2GC2V4YW1wbGUuY29tMB0GA1UdDgQWBBSpNi77wXxB2onXlKbrxbKLx9i7" ++
            "BTAfBgNVHSMEGDAWgBQm9kkwVB5ND6jU/6J+Of5FH039ezAKBggqhkjOPQQDAgNHADBEAiAv" ++
            "E9UyaszpuzFmyoLJxo9qMn8B70h2x5jYTKLJUl8JqgIga08LzhWfx3zt8VxEZ4yQHray4D7z" ++
            "f8qakHv3ji2qKYE=",
        .leaf_b64 = "MIIB0TCCAXagAwIBAgIUe6M4tHcsu9BKuwAOD7ONeh2BsQQwCgYIKoZIzj0EAwIwIDEeMBwG" ++
            "A1UEAwwVbmMtaW50ZXItdXJpX2hvc3RwZXJtMB4XDTI2MDcxNTIwMTIxN1oXDTM2MDcxMjIw" ++
            "MTIxN1owHDEaMBgGA1UEAwwRbGVhZi11cmlfdXNlcnBvcnQwWTATBgcqhkjOPQIBBggqhkjO" ++
            "PQMBBwNCAATlMIKhPYHFX57EeAikBL0DfN7Eg9UmeI9neMJhBQjDI7vyouAw82KScj5Upir7" ++
            "bPNXcLTmzJodXJhpDye7vosno4GRMIGOMAwGA1UdEwEB/wQCMAAwDgYDVR0PAQH/BAQDAgeA" ++
            "MC4GA1UdEQQnMCWGI2h0dHBzOi8vdTpwQGhvc3QuZXhhbXBsZS5jb206ODQ0My94MB0GA1Ud" ++
            "DgQWBBRi8k3wz44BcHzX4KZTqGmNilmkATAfBgNVHSMEGDAWgBSpNi77wXxB2onXlKbrxbKL" ++
            "x9i7BTAKBggqhkjOPQQDAgNJADBGAiEA2CKBnOZ194RUPz0kOuvPv9OpEnsrbd0OVfG1RCsM" ++
            "YnwCIQDigvncGBx6kEH7FaaT/BLI66j3AvnXEubgNk/D5nWCkA==",
    },
    .{
        .name = "ip_in__ip_perm",
        .openssl_ok = true,
        .ztls_ok = true,
        .inter_b64 = "MIIBrzCCAVSgAwIBAgIUfIXDd6WpQ1DRce6dL3A/5kNomsgwCgYIKoZIzj0EAwIwEjEQMA4G" ++
            "A1UEAwwHbmMtcm9vdDAeFw0yNjA3MTUyMDEyMTVaFw0zNjA3MTIyMDEyMTVaMBsxGTAXBgNV" ++
            "BAMMEG5jLWludGVyLWlwX3Blcm0wWTATBgcqhkjOPQIBBggqhkjOPQMBBwNCAARX8OAPRfHZ" ++
            "v10ajOJgaBB4l2EBxB4xM+czK9tOVJnRZkRGvPgiQ9OLeDZv4DfN+DcWX0pf+Inbex8+0JZ7" ++
            "L0i9o38wfTAPBgNVHRMBAf8EBTADAQH/MA4GA1UdDwEB/wQEAwIBBjAaBgNVHR4BAf8EEDAO" ++
            "oAwwCocIwKgAAP//AAAwHQYDVR0OBBYEFCThxV2pAg6X8HeyBesE3dHBZER7MB8GA1UdIwQY" ++
            "MBaAFCb2STBUHk0PqNT/on45/kUfTf17MAoGCCqGSM49BAMCA0kAMEYCIQCn7NfYJwLe15Kb" ++
            "9LyxhUmlfUeTtDqeInSfvc4luvewRQIhAKE8FHnjCB6DWiI6RfHc0++bckONEsKwBV/tdXHT" ++
            "ZNQz",
        .leaf_b64 = "MIIBozCCAUmgAwIBAgIUAWWlhmTFg5PCpUG/XbOg+l4+lYYwCgYIKoZIzj0EAwIwGzEZMBcG" ++
            "A1UEAwwQbmMtaW50ZXItaXBfcGVybTAeFw0yNjA3MTUyMDEyMTdaFw0zNjA3MTIyMDEyMTda" ++
            "MBUxEzARBgNVBAMMCmxlYWYtaXBfaW4wWTATBgcqhkjOPQIBBggqhkjOPQMBBwNCAASeeJT0" ++
            "THVlCoBMNmUevbr5CASjtd15ZJvbKToiIDlO4WAWHSPTFXoO2nSJJSKle1jn5o8Yzau1IgKI" ++
            "5L5axb77o3EwbzAMBgNVHRMBAf8EAjAAMA4GA1UdDwEB/wQEAwIHgDAPBgNVHREECDAGhwTA" ++
            "qAUFMB0GA1UdDgQWBBS4OsnsApgE8tmqgvKghL/U/NzWXDAfBgNVHSMEGDAWgBQk4cVdqQIO" ++
            "l/B3sgXrBN3RwWREezAKBggqhkjOPQQDAgNIADBFAiEAn1qfMsxZYQazsHGdCbta9lT0iUrt" ++
            "MdKeAxqNz5YyMC4CIBKAvgR5yWbcqSYqdDBJye2d6CDOiTN6cK16yBQ/h+Nx",
    },
    .{
        .name = "ip_out__ip_perm",
        .openssl_ok = false,
        .ztls_ok = false,
        .inter_b64 = "MIIBrzCCAVSgAwIBAgIUfIXDd6WpQ1DRce6dL3A/5kNomsgwCgYIKoZIzj0EAwIwEjEQMA4G" ++
            "A1UEAwwHbmMtcm9vdDAeFw0yNjA3MTUyMDEyMTVaFw0zNjA3MTIyMDEyMTVaMBsxGTAXBgNV" ++
            "BAMMEG5jLWludGVyLWlwX3Blcm0wWTATBgcqhkjOPQIBBggqhkjOPQMBBwNCAARX8OAPRfHZ" ++
            "v10ajOJgaBB4l2EBxB4xM+czK9tOVJnRZkRGvPgiQ9OLeDZv4DfN+DcWX0pf+Inbex8+0JZ7" ++
            "L0i9o38wfTAPBgNVHRMBAf8EBTADAQH/MA4GA1UdDwEB/wQEAwIBBjAaBgNVHR4BAf8EEDAO" ++
            "oAwwCocIwKgAAP//AAAwHQYDVR0OBBYEFCThxV2pAg6X8HeyBesE3dHBZER7MB8GA1UdIwQY" ++
            "MBaAFCb2STBUHk0PqNT/on45/kUfTf17MAoGCCqGSM49BAMCA0kAMEYCIQCn7NfYJwLe15Kb" ++
            "9LyxhUmlfUeTtDqeInSfvc4luvewRQIhAKE8FHnjCB6DWiI6RfHc0++bckONEsKwBV/tdXHT" ++
            "ZNQz",
        .leaf_b64 = "MIIBpTCCAUqgAwIBAgIUAWWlhmTFg5PCpUG/XbOg+l4+lYcwCgYIKoZIzj0EAwIwGzEZMBcG" ++
            "A1UEAwwQbmMtaW50ZXItaXBfcGVybTAeFw0yNjA3MTUyMDEyMTdaFw0zNjA3MTIyMDEyMTda" ++
            "MBYxFDASBgNVBAMMC2xlYWYtaXBfb3V0MFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAEp3p/" ++
            "RwARR0G7vYq4+xQMQbK+GLNauuV17ADEBa1VALTo3uRywdoo5Pv3YIDYBM3muectcX03j7uq" ++
            "64Qjygo9R6NxMG8wDAYDVR0TAQH/BAIwADAOBgNVHQ8BAf8EBAMCB4AwDwYDVR0RBAgwBocE" ++
            "CgECAzAdBgNVHQ4EFgQUgTd8ortxTm26DLssQovOqCB+TtUwHwYDVR0jBBgwFoAUJOHFXakC" ++
            "Dpfwd7IF6wTd0cFkRHswCgYIKoZIzj0EAwIDSQAwRgIhAIDjxL8frSsLv7EyHyU2Q7T0gNBA" ++
            "XoSaX+dZqcK6nXqFAiEA6MWsiSzCud75vZ6tf4z28JzAIwXHHZsYdiMKgknELpM=",
    },
    .{
        .name = "ip6_in__ip_perm",
        .openssl_ok = false,
        .ztls_ok = false,
        .inter_b64 = "MIIBrzCCAVSgAwIBAgIUfIXDd6WpQ1DRce6dL3A/5kNomsgwCgYIKoZIzj0EAwIwEjEQMA4G" ++
            "A1UEAwwHbmMtcm9vdDAeFw0yNjA3MTUyMDEyMTVaFw0zNjA3MTIyMDEyMTVaMBsxGTAXBgNV" ++
            "BAMMEG5jLWludGVyLWlwX3Blcm0wWTATBgcqhkjOPQIBBggqhkjOPQMBBwNCAARX8OAPRfHZ" ++
            "v10ajOJgaBB4l2EBxB4xM+czK9tOVJnRZkRGvPgiQ9OLeDZv4DfN+DcWX0pf+Inbex8+0JZ7" ++
            "L0i9o38wfTAPBgNVHRMBAf8EBTADAQH/MA4GA1UdDwEB/wQEAwIBBjAaBgNVHR4BAf8EEDAO" ++
            "oAwwCocIwKgAAP//AAAwHQYDVR0OBBYEFCThxV2pAg6X8HeyBesE3dHBZER7MB8GA1UdIwQY" ++
            "MBaAFCb2STBUHk0PqNT/on45/kUfTf17MAoGCCqGSM49BAMCA0kAMEYCIQCn7NfYJwLe15Kb" ++
            "9LyxhUmlfUeTtDqeInSfvc4luvewRQIhAKE8FHnjCB6DWiI6RfHc0++bckONEsKwBV/tdXHT" ++
            "ZNQz",
        .leaf_b64 = "MIIBrzCCAVagAwIBAgIUAWWlhmTFg5PCpUG/XbOg+l4+lYgwCgYIKoZIzj0EAwIwGzEZMBcG" ++
            "A1UEAwwQbmMtaW50ZXItaXBfcGVybTAeFw0yNjA3MTUyMDEyMThaFw0zNjA3MTIyMDEyMTha" ++
            "MBYxFDASBgNVBAMMC2xlYWYtaXA2X2luMFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAEFDo5" ++
            "Rfu9LOj/fJxsTbMJol+XbhcYgFC7pkvUiSpK2rxMVzJlUBsHg2t66X38rwEmlITWji1ADaU2" ++
            "rEmSlk2nHKN9MHswDAYDVR0TAQH/BAIwADAOBgNVHQ8BAf8EBAMCB4AwGwYDVR0RBBQwEocQ" ++
            "/oAAAAAAAAAAAAAAAAAAATAdBgNVHQ4EFgQUvPL9g5Z3krsUKNfuTnbe0ga+oA4wHwYDVR0j" ++
            "BBgwFoAUJOHFXakCDpfwd7IF6wTd0cFkRHswCgYIKoZIzj0EAwIDRwAwRAIgZ8X/hqoo7J+W" ++
            "nOvFu4RfTgBJLlbXROUmQYxAgQhHArQCIE79w6QrgXU3IIH2Nm8KPqFOcU7209DPsppQgBTA" ++
            "8g74",
    },
    .{
        .name = "ip_out__ip_excl",
        .openssl_ok = false,
        .ztls_ok = false,
        .inter_b64 = "MIIBrjCCAVSgAwIBAgIUfIXDd6WpQ1DRce6dL3A/5kNomskwCgYIKoZIzj0EAwIwEjEQMA4G" ++
            "A1UEAwwHbmMtcm9vdDAeFw0yNjA3MTUyMDEyMTVaFw0zNjA3MTIyMDEyMTVaMBsxGTAXBgNV" ++
            "BAMMEG5jLWludGVyLWlwX2V4Y2wwWTATBgcqhkjOPQIBBggqhkjOPQMBBwNCAARB1DjG3rt3" ++
            "SIz9OE7AtmcJFrd26YbN1ug9Tq0Dq1od7i/KAevYGUzU7QSlinvutvnOSCyg6SFqUPxHqzwu" ++
            "LQizo38wfTAPBgNVHRMBAf8EBTADAQH/MA4GA1UdDwEB/wQEAwIBBjAaBgNVHR4BAf8EEDAO" ++
            "oQwwCocICgAAAP8AAAAwHQYDVR0OBBYEFOIs8QBRdcQFU8Yr5r20CXiKkTY9MB8GA1UdIwQY" ++
            "MBaAFCb2STBUHk0PqNT/on45/kUfTf17MAoGCCqGSM49BAMCA0gAMEUCIQCRlG5iH0Zon+9Z" ++
            "eWRbZscYrz4H7OHFkaas0k/NZFX32gIgF8IAe2wYZOz/aUeWJWvEDLHEF7xI59Sjghv8/eIK" ++
            "VMc=",
        .leaf_b64 = "MIIBpDCCAUqgAwIBAgIUHNj5lOQrzcakzhXd4TCeSvPiGdMwCgYIKoZIzj0EAwIwGzEZMBcG" ++
            "A1UEAwwQbmMtaW50ZXItaXBfZXhjbDAeFw0yNjA3MTUyMDEyMThaFw0zNjA3MTIyMDEyMTha" ++
            "MBYxFDASBgNVBAMMC2xlYWYtaXBfb3V0MFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAEp3p/" ++
            "RwARR0G7vYq4+xQMQbK+GLNauuV17ADEBa1VALTo3uRywdoo5Pv3YIDYBM3muectcX03j7uq" ++
            "64Qjygo9R6NxMG8wDAYDVR0TAQH/BAIwADAOBgNVHQ8BAf8EBAMCB4AwDwYDVR0RBAgwBocE" ++
            "CgECAzAdBgNVHQ4EFgQUgTd8ortxTm26DLssQovOqCB+TtUwHwYDVR0jBBgwFoAU4izxAFF1" ++
            "xAVTxivmvbQJeIqRNj0wCgYIKoZIzj0EAwIDSAAwRQIga3giS8a9VTdE5GSZGVB4YTaARN+e" ++
            "PkWm0HwXMOFDULMCIQCYnAW+Rob/MU7ixFr7r87aZQC6UczxK6ASVP9YT5d6fg==",
    },
    .{
        .name = "ip_in__ip_excl",
        .openssl_ok = true,
        .ztls_ok = true,
        .inter_b64 = "MIIBrjCCAVSgAwIBAgIUfIXDd6WpQ1DRce6dL3A/5kNomskwCgYIKoZIzj0EAwIwEjEQMA4G" ++
            "A1UEAwwHbmMtcm9vdDAeFw0yNjA3MTUyMDEyMTVaFw0zNjA3MTIyMDEyMTVaMBsxGTAXBgNV" ++
            "BAMMEG5jLWludGVyLWlwX2V4Y2wwWTATBgcqhkjOPQIBBggqhkjOPQMBBwNCAARB1DjG3rt3" ++
            "SIz9OE7AtmcJFrd26YbN1ug9Tq0Dq1od7i/KAevYGUzU7QSlinvutvnOSCyg6SFqUPxHqzwu" ++
            "LQizo38wfTAPBgNVHRMBAf8EBTADAQH/MA4GA1UdDwEB/wQEAwIBBjAaBgNVHR4BAf8EEDAO" ++
            "oQwwCocICgAAAP8AAAAwHQYDVR0OBBYEFOIs8QBRdcQFU8Yr5r20CXiKkTY9MB8GA1UdIwQY" ++
            "MBaAFCb2STBUHk0PqNT/on45/kUfTf17MAoGCCqGSM49BAMCA0gAMEUCIQCRlG5iH0Zon+9Z" ++
            "eWRbZscYrz4H7OHFkaas0k/NZFX32gIgF8IAe2wYZOz/aUeWJWvEDLHEF7xI59Sjghv8/eIK" ++
            "VMc=",
        .leaf_b64 = "MIIBozCCAUmgAwIBAgIUHNj5lOQrzcakzhXd4TCeSvPiGdQwCgYIKoZIzj0EAwIwGzEZMBcG" ++
            "A1UEAwwQbmMtaW50ZXItaXBfZXhjbDAeFw0yNjA3MTUyMDEyMThaFw0zNjA3MTIyMDEyMTha" ++
            "MBUxEzARBgNVBAMMCmxlYWYtaXBfaW4wWTATBgcqhkjOPQIBBggqhkjOPQMBBwNCAASeeJT0" ++
            "THVlCoBMNmUevbr5CASjtd15ZJvbKToiIDlO4WAWHSPTFXoO2nSJJSKle1jn5o8Yzau1IgKI" ++
            "5L5axb77o3EwbzAMBgNVHRMBAf8EAjAAMA4GA1UdDwEB/wQEAwIHgDAPBgNVHREECDAGhwTA" ++
            "qAUFMB0GA1UdDgQWBBS4OsnsApgE8tmqgvKghL/U/NzWXDAfBgNVHSMEGDAWgBTiLPEAUXXE" ++
            "BVPGK+a9tAl4ipE2PTAKBggqhkjOPQQDAgNIADBFAiEAgt6PNr5xrNHLJkc7aJzrXbzklXZj" ++
            "SnToOSSapQ2nINACIH+e/CszE/KgbJiZC9reC4WrYGDo1v52tUVerqiRHzEQ",
    },
};

// All rfc822Name/URI host-constraint divergences resolved (#75): bare-host
// constraints now do exact host matching per RFC 5280 §4.2.1.10.

fn decode(buf: []u8, b64: []const u8) []const u8 {
    const n = std.base64.standard.Decoder.calcSizeForSlice(b64) catch unreachable;
    std.base64.standard.Decoder.decode(buf[0..n], b64) catch unreachable;
    return buf[0..n];
}

// RFC 5280 §4.2.1.10 / RFC 8446 §4.4.2 — verifyNameConstraints must match the
// verdict OpenSSL reaches on the same DER. Any disagreement trips this test.
test "RFC 5280 §4.2.1.10 name-constraint verdicts vs OpenSSL 3.6.3 ground truth" {
    var ibuf: [4096]u8 = undefined;
    var lbuf: [4096]u8 = undefined;
    for (cases) |c| {
        const inter_cert: Certificate = .{ .buffer = decode(&ibuf, c.inter_b64), .index = 0 };
        const leaf_cert: Certificate = .{ .buffer = decode(&lbuf, c.leaf_b64), .index = 0 };
        const inter = try inter_cert.parse();
        const leaf = try leaf_cert.parse();

        const ztls_ok = if (inter.verifyNameConstraints(leaf)) true else |_| false;

        // Regression anchor: ztls verdict must not drift silently.
        testing.expectEqual(c.ztls_ok, ztls_ok) catch |e| {
            std.debug.print("verdict drift for {s}\n", .{c.name});
            return e;
        };

        // ztls must agree with OpenSSL on every case (#75 resolved).
        testing.expectEqual(c.openssl_ok, ztls_ok) catch |e| {
            std.debug.print("DISAGREEMENT with OpenSSL: {s}\n", .{c.name});
            return e;
        };
    }
}

// Fuzz target: verifyNameConstraints must never crash on hostile DER in the
// NameConstraints extension or the subject SAN. Both the CA constraint buffer
// and the subordinate SAN buffer are attacker-controlled, exercising
// nameConstraintSubtrees / parseGeneralSubtree / supportedGeneralName and every
// matcher. Watches the #72 narrow-type arithmetic class in the DER length walk.
// verifyNameConstraints never allocates.
fn fuzzNameConstraints(_: void, input: []const u8) anyerror!void {
    const split = input.len / 2;
    const nc = input[0..split];
    const san = input[split..];

    const nc_slice: Parsed.Slice = .{ .start = 0, .end = @intCast(nc.len) };
    const san_slice: Parsed.Slice = .{ .start = 0, .end = @intCast(san.len) };
    const ca: Parsed = makeParsed(nc, nc_slice, .empty, .empty, true);
    const leaf_san: Parsed = makeParsed(san, .empty, san_slice, .empty, false);
    // SAN-absent common-name fallback path.
    const leaf_cn: Parsed = makeParsed(san, .empty, .empty, san_slice, false);

    _ = ca.verifyNameConstraints(leaf_san) catch {
        _ = ca.verifyNameConstraints(leaf_cn) catch return;
        return;
    };
    _ = ca.verifyNameConstraints(leaf_cn) catch return;
}

fn makeParsed(
    buffer: []const u8,
    name_constraints: Parsed.Slice,
    subject_alt_name: Parsed.Slice,
    common_name: Parsed.Slice,
    critical: bool,
) Parsed {
    return .{
        .certificate = .{ .buffer = buffer, .index = 0 },
        .issuer_slice = .empty,
        .subject_slice = .empty,
        .common_name_slice = common_name,
        .signature_slice = .empty,
        .signature_algorithm = .ecdsa_with_SHA256,
        .pub_key_algo = .{ .curveEd25519 = {} },
        .pub_key_slice = .empty,
        .message_slice = .empty,
        .subject_alt_name_slice = subject_alt_name,
        .key_usage_slice = .empty,
        .ext_key_usage_slice = .empty,
        .name_constraints_slice = name_constraints,
        .name_constraints_critical = critical,
        .validity = .{ .not_before = 0, .not_after = 0 },
        .version = .v3,
    };
}

test "fuzz: verifyNameConstraints handles arbitrary NameConstraints and SAN DER" {
    try fuzz_compat.fuzzBytes(fuzzNameConstraints, {}, .{
        .corpus = &.{
            // permitted;DNS:example.com  ++  SAN dNSName ok.example.com
            "\x30\x11\xA0\x0F\x30\x0D\x82\x0Bexample.com" ++
                "\x30\x10\x82\x0Eok.example.com",
            // excluded;DNS:bad.example.com twice
            "\x30\x15\xA1\x13\x30\x11\x82\x0Fbad.example.com" ++
                "\x30\x11\x82\x0Fbad.example.com",
            // IP permitted subtree ++ IP SAN
            "\x30\x0E\xA0\x0C\x30\x0A\x87\x08\x7F\x00\x00\x00\xFF\xFF\xFF\x00" ++
                "\x30\x06\x87\x04\x7F\x00\x00\x01",
        },
    });
}
