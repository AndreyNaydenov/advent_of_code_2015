const std = @import("std");
const print = std.debug.print;
const input = @embedFile("input.txt");
const dayinfo = @embedFile("dayinfo");

pub fn main() !void {
    print("Running solution for {s}\n", .{dayinfo});
    const parsed = parse(input);
    try part1();
    try part2();
}

fn parse(data: []const u8) []const u8 {
    return data;
}

fn part1() !void {
    var result: isize = 0;
    print("Part1 result: {}\n", .{result});
}

fn part2() !void {
    var result: isize = 0;
    print("Part2 result: {}\n", .{result});
}
