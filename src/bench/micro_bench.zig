const std = @import("std");
const mem = std.mem;
const doNotOptimizeAway = mem.doNotOptimizeAway;

const bench = @import("benchmark");

const aead = @import("../aead.zig");
const frame = @import("../frame.zig");
const memx = @import("../memx.zig");
const NewSessionTicket = @import("../NewSessionTicket.zig");
const wire = @import("../wire.zig");

pub fn benchmarkLastIndexNonZeroNoPadding16(b: *bench.B) !void {
    var buf: [16]u8 = @splat(0);
    buf[15] = 23;
    while (try b.loop()) {
        buf[0] = @truncate(b.n);
        b.keepAlive(memx.lastIndexOfNonZero(&buf));
    }
}

pub fn benchmarkLastIndexNonZeroPadding1To16(b: *bench.B) !void {
    var buf: [16]u8 = @splat(0);
    buf[14] = 23;
    while (try b.loop()) {
        buf[0] = @truncate(b.n);
        b.keepAlive(memx.lastIndexOfNonZero(&buf));
    }
}

pub fn benchmarkLastIndexNonZeroPadding16To128(b: *bench.B) !void {
    var buf: [128]u8 = @splat(0);
    buf[111] = 23;
    while (try b.loop()) {
        buf[0] = @truncate(b.n);
        b.keepAlive(memx.lastIndexOfNonZero(&buf));
    }
}

pub fn benchmarkLastIndexNonZeroPadding128To1350(b: *bench.B) !void {
    var buf: [1350]u8 = @splat(0);
    buf[1221] = 23;
    while (try b.loop()) {
        buf[0] = @truncate(b.n);
        b.keepAlive(memx.lastIndexOfNonZero(&buf));
    }
}

pub fn benchmarkLastIndexNonZeroAllZero1350(b: *bench.B) !void {
    var buf: [1350]u8 = @splat(0);
    while (try b.loop()) {
        buf[0] = @truncate(b.n);
        buf[0] = 0;
        b.keepAlive(memx.lastIndexOfNonZero(&buf));
    }
}

pub fn benchmarkNonceConstructVector(b: *bench.B) !void {
    const iv: aead.Iv = .init(@splat(0xab));
    var seq: u64 = 0;
    while (try b.loop()) {
        b.keepAlive(aead.construct(&iv, seq));
        seq +%= 1;
    }
}

pub fn benchmarkParseHeaderCurrent(b: *bench.B) !void {
    var input = [_]u8{ 23, 0x03, 0x03, 0x40, 0x00 };
    while (try b.loop()) {
        input[4] = @truncate(b.n);
        b.keepAlive(frame.parseHeader(&input) catch unreachable);
    }
}

pub fn benchmarkWireReaderU8(b: *bench.B) !void {
    var input = [_]u8{0xab};
    while (try b.loop()) {
        input[0] = @truncate(b.n);
        var r: wire.Reader = .init(&input);
        b.keepAlive(r.read(u8) catch unreachable);
    }
}

pub fn benchmarkWireReaderU16(b: *bench.B) !void {
    var input = [_]u8{ 0x12, 0x34 };
    while (try b.loop()) {
        input[1] = @truncate(b.n);
        var r: wire.Reader = .init(&input);
        b.keepAlive(r.read(u16) catch unreachable);
    }
}

pub fn benchmarkWireReaderU24(b: *bench.B) !void {
    var input = [_]u8{ 0x12, 0x34, 0x56 };
    while (try b.loop()) {
        input[2] = @truncate(b.n);
        var r: wire.Reader = .init(&input);
        b.keepAlive(r.read(u24) catch unreachable);
    }
}

pub fn benchmarkWireReaderSafeSequence(b: *bench.B) !void {
    var input = [_]u8{
        0x02, 0x00, 0x00, 0x26, 0x03, 0x03,
    } ++ [_]u8{0xaa} ** 32 ++ [_]u8{
        0x00, 0x13, 0x01, 0x00, 0x04, 0x00, 0xff, 0xff,
    };
    while (try b.loop()) {
        input[1] = @truncate(b.n);
        var reader: wire.Reader = .init(input[0 .. input.len - (b.n & 1)]);
        var sum: usize = 0;
        sum +%= tryRead(u8, &reader);
        sum +%= tryRead(u24, &reader);
        reader.skip(2) catch unreachable;
        sum +%= (reader.readSlice(32) catch unreachable)[b.n & 31];
        sum +%= tryRead(u8, &reader);
        sum +%= tryRead(u16, &reader);
        reader.skip(1) catch unreachable;
        sum +%= tryRead(u16, &reader);
        b.keepAlive(sum);
    }
}

pub fn benchmarkWireReaderAssumeSequence(b: *bench.B) !void {
    var input = [_]u8{
        0x02, 0x00, 0x00, 0x26, 0x03, 0x03,
    } ++ [_]u8{0xaa} ** 32 ++ [_]u8{
        0x00, 0x13, 0x01, 0x00, 0x04, 0x00, 0xff, 0xff,
    };
    while (try b.loop()) {
        input[1] = @truncate(b.n);
        var reader: wire.Reader = .init(input[0 .. input.len - (b.n & 1)]);
        if (reader.remaining().len < input.len - 1) unreachable;
        var sum: usize = 0;
        sum +%= reader.assumeRead(u8);
        sum +%= reader.assumeRead(u24);
        reader.assumeSkip(2);
        sum +%= reader.assumeReadSlice(32)[b.n & 31];
        sum +%= reader.assumeRead(u8);
        sum +%= reader.assumeRead(u16);
        reader.assumeSkip(1);
        sum +%= reader.assumeRead(u16);
        b.keepAlive(sum);
    }
}

const ticket_corpus_len = 16;
const ticket_buf_len = 256;

const TicketCorpus = struct {
    bufs: [ticket_corpus_len][ticket_buf_len]u8,
    lens: [ticket_corpus_len]usize,
};

fn makeTicketCorpus() TicketCorpus {
    var corpus: TicketCorpus = undefined;
    for (0..ticket_corpus_len) |i| {
        const nonce_len = 1 + (i % 13);
        const ticket_len = 8 + i * 7;
        const unknown_extensions = i % 4;
        const early_data = (i & 1) == 0;
        corpus.lens[i] = writeTicket(
            &corpus.bufs[i],
            @intCast(nonce_len),
            ticket_len,
            unknown_extensions,
            early_data,
            @truncate(i),
        );
    }
    return corpus;
}

pub fn benchmarkNewSessionTicketParseCurrent(b: *bench.B) !void {
    var corpus = makeTicketCorpus();
    while (try b.loop()) {
        const slot = b.n & (ticket_corpus_len - 1);
        corpus.bufs[slot][13] = @truncate(b.n);
        const input = corpus.bufs[slot][0..corpus.lens[slot]];
        b.keepAlive(input.ptr);
        b.keepAlive(consumeTicket(parseNewSessionTicketNoInline(input) catch unreachable));
    }
}

fn writeTicket(
    out: *[ticket_buf_len]u8,
    nonce_len: u8,
    ticket_len: usize,
    unknown_extensions: usize,
    early_data: bool,
    seed: u8,
) usize {
    var w: wire.Writer = .init(out);
    w.append(u8, 0x04);
    const body_len_slot = w.reserve(3);
    w.append(u32, 3600 + @as(u32, seed));
    w.append(u32, 0x12345678 + @as(u32, seed));
    w.append(u8, nonce_len);
    for (0..nonce_len) |i| w.append(u8, seed +% @as(u8, @truncate(i)));
    w.append(u16, @intCast(ticket_len));
    for (0..ticket_len) |i| w.append(u8, 0x40 +% seed +% @as(u8, @truncate(i)));

    const extensions_len_slot = w.reserve(2);
    const extensions_start = w.pos;
    if (early_data) {
        w.append(u16, 0x002a);
        w.append(u16, 4);
        w.append(u32, 0x4000 + @as(u32, seed));
    }
    for (0..unknown_extensions) |i| {
        w.append(u16, 0xbe00 + @as(u16, @intCast(i)));
        w.append(u16, 3);
        w.append(u8, seed +% @as(u8, @truncate(i)));
        w.append(u8, seed +% @as(u8, @truncate(i + 1)));
        w.append(u8, seed +% @as(u8, @truncate(i + 2)));
    }

    const extensions_len = w.pos - extensions_start;
    extensions_len_slot.* = memx.toBytes(u16, @intCast(extensions_len));
    const body_len: u24 = @intCast(w.pos - 4);
    body_len_slot.* = .{
        @truncate(body_len >> 16),
        @truncate(body_len >> 8),
        @truncate(body_len),
    };
    return w.pos;
}

noinline fn parseNewSessionTicketNoInline(
    msg: []const u8,
) NewSessionTicket.ParseError!NewSessionTicket {
    return .parse(msg);
}

fn consumeTicket(ticket: NewSessionTicket) usize {
    return ticket.ticket_lifetime +% ticket.ticket_age_add +%
        ticket.ticket_nonce[0] +% ticket.ticket[ticket.ticket.len - 1] +%
        (ticket.max_early_data_size orelse 0);
}

fn tryRead(comptime T: type, r: *wire.Reader) usize {
    return r.read(T) catch unreachable;
}

export fn ztlsBenchNonceConstruct() void {
    const iv: aead.Iv = .init(@splat(0xab));
    doNotOptimizeAway(aead.construct(&iv, 0x12345678));
}

export fn ztlsBenchLastIndexNonZero() void {
    var buf: [128]u8 = @splat(0);
    buf[111] = 23;
    doNotOptimizeAway(memx.lastIndexOfNonZero(&buf));
}

export fn ztlsBenchParseHeader() void {
    const input = [_]u8{ 23, 0x03, 0x03, 0x40, 0x00 };
    doNotOptimizeAway(frame.parseHeader(&input) catch unreachable);
}
