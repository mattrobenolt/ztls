//! CertificateVerify signature fixtures, base64-encoded text.
//! Generated with: scripts/gen-fixtures.sh
//! Transcript hash: SHA-256("test transcript")

const std = @import("std");

fn decode(
    comptime b64: []const u8,
) [std.base64.standard.Decoder.calcSizeForSlice(b64) catch unreachable]u8 {
    const len = std.base64.standard.Decoder.calcSizeForSlice(b64) catch unreachable;
    var decoded: [len]u8 = undefined;
    _ = std.base64.standard.Decoder.decode(&decoded, b64) catch unreachable;
    return decoded;
}

pub const cv_sig = decode("MEUCIQCmCWp7UkRuFt7caroq6tx16oKZOK82/j+V8ucwyGneeQIgIht02UI6VlBkvdA2kspSNswn" ++
    "j7Qo6LDdVqHT3t2YqLo=");

pub const rsa_pss_cv_sig = decode("Yp19vKPWzKrRSoKrv9RwxXh7HKrjxc4cSsblPTo8HX+oLjsZmJDILjWx6Qb1Ev4YWINuG11wiYe0" ++
    "2a/Z91PTEMakBDx/tK15AwTOz3UnmLrKZn1MVNRbEVKBOKcc23wNJgAwIxcFwwUWOIdd7TkLdpRY" ++
    "zo8cDtAsjT9hf4MzH62YIN7lZfWE9vgKeMyC0stebosBTBhf6OiO6R2vCvJ4Qy+yQ93gze1XoOdK" ++
    "kL/Z57SaXMoh+sGk2RU+F/Ixxuo7ySw0B7dHOKaCE/M9XmeMm9f2UuhGO5qy/qJrOfgh/AvN7yJC" ++
    "c8Fijkt3VXCwMS/5C4edhAHBDW2nxAr4v4azDQ==");

pub const rsa_pss_cv_salt20_sig = decode("BIV05EaMVT2LnmmLOUQoI9sKfmhaJHOMPu27WVs4i2ZD21q6SnB1vvL2Om58UzvGxFeKDtMeM312" ++
    "sI+5P+7aFj+RFZkPwh/EjqnsaZPFvUhk3k2BVZdFhtIiy0GsYb6yBZD8CGDs78p4S177UjowiNMt" ++
    "WDUc4K1LWxYDsRZV/bgoxiO5QtRLS6JNnfuILLFy7SPj7s5Siv9fr85fhGrYL/CpKTCBleyi8GPF" ++
    "PlloLjS7kJuwLXc7zJni4loipFkuW7FVh4u6jdTScOJFtFuKNoZhRdqG7hSHh6GVGns/ZEnVZgvb" ++
    "A9tDNzA4Yl4vyknl/fbQ4gZAy33OT9AhjIhRjA==");
