const std = @import("std");
const print = std.debug.print;
const input = @embedFile("input.txt");
const dayinfo = @embedFile("dayinfo");

pub fn main() !void {
    print("Running solution for {s}\n", .{dayinfo});
    const parsed = parse(input);
    try part12(1, parsed, has5zeros);
    try part12(2, parsed, has6zeros);
}

fn parse(data: []const u8) []const u8 {
    if (data[data.len - 1] == '\n') return data[0 .. data.len - 1] else return data;
}

fn has5zeros(hash: [std.crypto.hash.Md5.digest_length]u8) bool {
    if (hash[0] != 0) return false;
    if (hash[1] != 0) return false;
    if (hash[2] >= 16) return false;
    return true;
}

fn has6zeros(hash: [std.crypto.hash.Md5.digest_length]u8) bool {
    if (hash[0] != 0) return false;
    if (hash[1] != 0) return false;
    if (hash[2] != 0) return false;
    return true;
}

fn part12(part: usize, data: []const u8, check_fn: fn ([std.crypto.hash.Md5.digest_length]u8) bool) !void {
    // buffer for formatted string input++i
    var buf = [_]u8{0} ** 32;

    // iterate over 0..
    const result = blk: for (0..std.math.maxInt(usize)) |i| {
        const formatted = try std.fmt.bufPrint(&buf, "{s}{d}", .{ data, i });
        var h: [std.crypto.hash.Md5.digest_length]u8 = undefined;
        // calculate md5 of string input ++ i
        std.crypto.hash.Md5.hash(formatted, &h, .{});
        // print("Formated string: {s}(len:{d}), hash: {x}\n", .{ formatted, formatted.len, h });
        // if res[0..5] = "00000" return i
        if (check_fn(h)) break :blk i;
    } else {
        @panic("Hash wasn't found");
    };
    print("Part{d} result: {}\n", .{ part, result });
}
