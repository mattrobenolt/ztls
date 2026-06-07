const std = @import("std");
const mem = std.mem;
const doNotOptimizeAway = mem.doNotOptimizeAway;

const bench = @import("bench_harness.zig");
const aead = @import("aead.zig");
const frame = @import("frame.zig");
const memx = @import("memx.zig");
const wire = @import("wire.zig");
const NewSessionTicket = @import("NewSessionTicket.zig");

pub fn main() !void {
    try bench.run(.{
        .pkg = "ztls/bench/micro",
        .cases = &.{
            bench.case("BenchmarkLastIndexNonZero/no_padding_16", lastIndexNoPadding16),
            bench.case("BenchmarkLastIndexNonZero/padding_1_16", lastIndexPadding1_16),
            bench.case("BenchmarkLastIndexNonZero/padding_16_128", lastIndexPadding16_128),
            bench.case("BenchmarkLastIndexNonZero/padding_128_1350", lastIndexPadding128_1350),
            bench.case("BenchmarkLastIndexNonZero/all_zero_1350", lastIndexAllZero1350),
            bench.case("BenchmarkNonceConstruct/vector", nonceConstruct),
            bench.case("BenchmarkParseHeader/current", parseHeader),
            bench.case("BenchmarkWireReader/u8", wireReaderU8),
            bench.case("BenchmarkWireReader/u16", wireReaderU16),
            bench.case("BenchmarkWireReader/u24", wireReaderU24),
            bench.case("BenchmarkWireReader/safe_sequence", wireReaderSafeSequence),
            bench.case("BenchmarkWireReader/assume_sequence", wireReaderAssumeSequence),
            bench.case("BenchmarkNewSessionTicket/parse_current", newSessionTicketParseCurrent),
        },
    });
}

fn lastIndexNoPadding16(b: *bench.B) void {
    var buf: [16]u8 = @splat(0);
    buf[15] = 23;
    b.resetTimer();
    while (b.next()) {
        buf[0] = @truncate(b.i);
        doNotOptimizeAway(memx.lastIndexOfNonZero(&buf));
    }
}

fn lastIndexPadding1_16(b: *bench.B) void {
    var buf: [16]u8 = @splat(0);
    buf[14] = 23;
    b.resetTimer();
    while (b.next()) {
        buf[0] = @truncate(b.i);
        doNotOptimizeAway(memx.lastIndexOfNonZero(&buf));
    }
}

fn lastIndexPadding16_128(b: *bench.B) void {
    var buf: [128]u8 = @splat(0);
    buf[111] = 23;
    b.resetTimer();
    while (b.next()) {
        buf[0] = @truncate(b.i);
        doNotOptimizeAway(memx.lastIndexOfNonZero(&buf));
    }
}

fn lastIndexPadding128_1350(b: *bench.B) void {
    var buf: [1350]u8 = @splat(0);
    buf[1221] = 23;
    b.resetTimer();
    while (b.next()) {
        buf[0] = @truncate(b.i);
        doNotOptimizeAway(memx.lastIndexOfNonZero(&buf));
    }
}

fn lastIndexAllZero1350(b: *bench.B) void {
    var buf: [1350]u8 = @splat(0);
    b.resetTimer();
    while (b.next()) {
        buf[0] = @truncate(b.i);
        buf[0] = 0;
        doNotOptimizeAway(memx.lastIndexOfNonZero(&buf));
    }
}

fn nonceConstruct(b: *bench.B) void {
    const iv: aead.Iv = .init(@splat(0xab));
    var seq: u64 = 0;
    b.resetTimer();
    while (b.next()) {
        doNotOptimizeAway(aead.construct(&iv, seq));
        seq +%= 1;
    }
}

fn parseHeader(b: *bench.B) void {
    var input = [_]u8{ 23, 0x03, 0x03, 0x40, 0x00 };
    b.resetTimer();
    while (b.next()) {
        input[4] = @truncate(b.i);
        doNotOptimizeAway(frame.parseHeader(&input) catch unreachable);
    }
}

fn wireReaderU8(b: *bench.B) void {
    var input = [_]u8{0xab};
    b.resetTimer();
    while (b.next()) {
        input[0] = @truncate(b.i);
        var r: wire.Reader = .init(&input);
        doNotOptimizeAway(r.read(u8) catch unreachable);
    }
}

fn wireReaderU16(b: *bench.B) void {
    var input = [_]u8{ 0x12, 0x34 };
    b.resetTimer();
    while (b.next()) {
        input[1] = @truncate(b.i);
        var r: wire.Reader = .init(&input);
        doNotOptimizeAway(r.read(u16) catch unreachable);
    }
}

fn wireReaderU24(b: *bench.B) void {
    var input = [_]u8{ 0x12, 0x34, 0x56 };
    b.resetTimer();
    while (b.next()) {
        input[2] = @truncate(b.i);
        var r: wire.Reader = .init(&input);
        doNotOptimizeAway(r.read(u24) catch unreachable);
    }
}

fn wireReaderSafeSequence(b: *bench.B) void {
    var input = [_]u8{
        0x02, 0x00, 0x00, 0x26, 0x03, 0x03,
    } ++ [_]u8{0xaa} ** 32 ++ [_]u8{
        0x00, 0x13, 0x01, 0x00, 0x04, 0x00, 0xff, 0xff,
    };
    b.resetTimer();
    while (b.next()) {
        input[1] = @truncate(b.i);
        var r: wire.Reader = .init(input[0 .. input.len - (b.i & 1)]);
        var sum: usize = 0;
        sum +%= tryRead(u8, &r);
        sum +%= tryRead(u24, &r);
        r.skip(2) catch unreachable;
        sum +%= (r.readSlice(32) catch unreachable)[b.i & 31];
        sum +%= tryRead(u8, &r);
        sum +%= tryRead(u16, &r);
        r.skip(1) catch unreachable;
        sum +%= tryRead(u16, &r);
        doNotOptimizeAway(sum);
    }
}

fn wireReaderAssumeSequence(b: *bench.B) void {
    var input = [_]u8{
        0x02, 0x00, 0x00, 0x26, 0x03, 0x03,
    } ++ [_]u8{0xaa} ** 32 ++ [_]u8{
        0x00, 0x13, 0x01, 0x00, 0x04, 0x00, 0xff, 0xff,
    };
    b.resetTimer();
    while (b.next()) {
        input[1] = @truncate(b.i);
        var r: wire.Reader = .init(input[0 .. input.len - (b.i & 1)]);
        if (r.remaining().len < input.len - 1) unreachable;
        var sum: usize = 0;
        sum +%= r.assumeRead(u8);
        sum +%= r.assumeRead(u24);
        r.assumeSkip(2);
        sum +%= r.assumeReadSlice(32)[b.i & 31];
        sum +%= r.assumeRead(u8);
        sum +%= r.assumeRead(u16);
        r.assumeSkip(1);
        sum +%= r.assumeRead(u16);
        doNotOptimizeAway(sum);
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

fn newSessionTicketParseCurrent(b: *bench.B) void {
    var corpus = makeTicketCorpus();
    b.resetTimer();
    while (b.next()) {
        const slot = b.i & (ticket_corpus_len - 1);
        corpus.bufs[slot][13] = @truncate(b.i);
        const input = corpus.bufs[slot][0..corpus.lens[slot]];
        doNotOptimizeAway(input.ptr);
        doNotOptimizeAway(consumeTicket(parseNewSessionTicketNoInline(input) catch unreachable));
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

noinline fn parseNewSessionTicketNoInline(msg: []const u8) NewSessionTicket.ParseError!NewSessionTicket {
    return NewSessionTicket.parse(msg);
}

fn consumeTicket(ticket: NewSessionTicket) usize {
    return ticket.ticket_lifetime +% ticket.ticket_age_add +%
        ticket.ticket_nonce[0] +% ticket.ticket[ticket.ticket.len - 1] +%
        (ticket.max_early_data_size orelse 0);
}

fn tryRead(comptime T: type, r: *wire.Reader) usize {
    return r.read(T) catch unreachable;
}

export fn ztls_bench_nonce_construct() void {
    const iv: aead.Iv = .init(@splat(0xab));
    doNotOptimizeAway(aead.construct(&iv, 0x12345678));
}

export fn ztls_bench_last_index_non_zero() void {
    var buf: [128]u8 = @splat(0);
    buf[111] = 23;
    doNotOptimizeAway(memx.lastIndexOfNonZero(&buf));
}

export fn ztls_bench_parse_header() void {
    const input = [_]u8{ 23, 0x03, 0x03, 0x40, 0x00 };
    doNotOptimizeAway(frame.parseHeader(&input) catch unreachable);
}
