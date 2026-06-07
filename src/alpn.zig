//! ALPN protocol-list types shared by ClientHello and handshake state.
//!
//! RFC 7301

pub const Protocols = []const []const u8;

pub const Error = error{ TooManyAlpnBytes, EmptyAlpnProtocol, AlpnProtocolTooLong };
