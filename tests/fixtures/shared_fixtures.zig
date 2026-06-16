//! Shared TLS test certificate fixtures, base64-encoded text.
//! DER/scalar bytes are fixture data, not production credentials.

const std = @import("std");

fn decode(
    comptime b64: []const u8,
) [std.base64.standard.Decoder.calcSizeForSlice(b64) catch unreachable]u8 {
    const len = std.base64.standard.Decoder.calcSizeForSlice(b64) catch unreachable;
    var decoded: [len]u8 = undefined;
    _ = std.base64.standard.Decoder.decode(&decoded, b64) catch unreachable;
    return decoded;
}

pub const server_cert_der = decode("MIIBfzCCASWgAwIBAgIUPpCfJzgbUglYnrYT0qoD85WC/9EwCgYIKoZIzj0EAwIwFTETMBEGA1UE" ++
    "AwwKdGVzdC5sb2NhbDAeFw0yNjA1MjkwNDI3MDlaFw0zNjA1MjYwNDI3MDlaMBUxEzARBgNVBAMM" ++
    "CnRlc3QubG9jYWwwWTATBgcqhkjOPQIBBggqhkjOPQMBBwNCAATrYVeHQ4iEtR++Tj7IgIGfAm/K" ++
    "0eTrDka3c8sWMSlKJ97SGgVkt3CGKkOgCsG5TrPNfjXqbREnCRMwLWHlkePbo1MwUTAdBgNVHQ4E" ++
    "FgQUwru+XOXYwSdjOfcjeMBjG1gOJAAwHwYDVR0jBBgwFoAUwru+XOXYwSdjOfcjeMBjG1gOJAAw" ++
    "DwYDVR0TAQH/BAUwAwEB/zAKBggqhkjOPQQDAgNIADBFAiAdNc9qkYGtAbFSo+425fQgT2dSL4lP" ++
    "v3KBAltv9NApnwIhAMlQHmxaPupXwQQeNR76f3TFO/gcyXLcjKvs+ba/4t6w");

pub const server_ecdsa_cert_der = decode("MIIByzCCAXKgAwIBAgIUbmarzBd+vWR/mRLY6OMXZSPvVQQwCgYIKoZIzj0EAwIwGzEZMBcGA1UE" ++
    "AwwQenRscy5zZXJ2ZXIudGVzdDAeFw0yNjA2MDEwMTA3MzFaFw0zNjA1MjkwMTA3MzFaMBsxGTAX" ++
    "BgNVBAMMEHp0bHMuc2VydmVyLnRlc3QwWTATBgcqhkjOPQIBBggqhkjOPQMBBwNCAATKaYKPBZrI" ++
    "1VlFanyJm97M16XUgwbBJkpHVern9TQuuQmG35VDsVMFA0FvUT6cigFaiHvB6NSZWczKYURvdTIl" ++
    "o4GTMIGQMB0GA1UdDgQWBBQVmks0H0iMK08RcQYrOzH1jLnV0jAfBgNVHSMEGDAWgBQVmks0H0iM" ++
    "K08RcQYrOzH1jLnV0jAMBgNVHRMBAf8EAjAAMA4GA1UdDwEB/wQEAwIHgDATBgNVHSUEDDAKBggr" ++
    "BgEFBQcDATAbBgNVHREEFDASghB6dGxzLnNlcnZlci50ZXN0MAoGCCqGSM49BAMCA0cAMEQCIE7r" ++
    "vZ4pcB7M69DXnXztJ3RKJzHRMZg/jvjL7Ad2t9wZAiB7s3wziFsMpfnXGN05V/q29wgFLilNG8YQ" ++
    "X6ssYxwWog==");

pub const server_ecdsa_scalar = decode("139HGdxmRe2N5F69cAY4IgK8B4ybwx0hgPE0siIOaeY=");
