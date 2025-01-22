const std = @import("std");
const print = std.debug.print;
const input = @embedFile("input.txt");

pub fn main() !void {
    std.debug.print("Hi! {s}\n", .{input});
}
