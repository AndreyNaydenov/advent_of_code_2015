const std = @import("std");
const print = std.debug.print;
const input = @embedFile("input.txt");
const dayinfo = @embedFile("dayinfo");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer std.debug.assert(gpa.deinit() == .ok);

    const parsed = try parse(allocator, input);
    defer {
        for (parsed) |s| allocator.free(s);
        allocator.free(parsed);
    }

    print("Running solution for {s}\n", .{dayinfo});
    try part1(parsed);
    try part2(parsed);
}

fn parse(allocator: std.mem.Allocator, data: []const u8) ![][]const u8 {
    var array = std.ArrayList([]const u8).init(allocator);
    // split to lines
    var iter = std.mem.splitScalar(u8, data, '\n');
    while (iter.next()) |line| {
        if (line.len == 0) continue;
        // append each line to array
        var string = std.ArrayList(u8).init(allocator);
        try string.appendSlice(line);
        try array.append(try string.toOwnedSlice());
    }
    // return slice of strings
    return try array.toOwnedSlice();
}

fn checkString1(string: []const u8) bool {
    // condition 2
    var prev_c: u8 = string[0];
    for (string[1..]) |c| {
        if (c == prev_c) break;
        prev_c = c;
    } else {
        return false;
    }

    // condition 1
    const vowels = "aeiou";
    var count: usize = 0;
    for (string) |c| {
        for (vowels) |v| {
            if (v == c) {
                count += 1;
                break;
            }
        }
    }
    if (count < 3) return false;

    // condition 3
    const forbidden = [_][]const u8{
        "ab",
        "cd",
        "pq",
        "xy",
    };
    for (forbidden) |s| {
        const maybe_index = std.mem.indexOf(u8, string, s);
        if (maybe_index) |_| {
            return false;
        }
    }

    // if all conditions passed
    return true;
}

fn checkString2(string: []const u8) bool {
    // condition 2
    for (string[2..], 2..) |c, i| {
        const prev = string[i - 2];
        if (prev == c) break;
    } else {
        return false;
    }

    // condition 1
    var pair: [2]u8 = undefined;
    for (string[2..], 2..) |_, i| {
        pair[0] = string[i - 2];
        pair[1] = string[i - 1];
        _ = std.mem.indexOfPos(u8, string, i, &pair) orelse continue;
        return true;
    } else {
        return false;
    }
}

fn part1(data: [][]const u8) !void {
    var count: usize = 0;
    for (data) |l| {
        if (checkString1(l)) count += 1;
    }
    print("Part1 result: {}\n", .{count});
}

fn part2(data: [][]const u8) !void {
    var count: usize = 0;
    for (data) |l| {
        if (checkString2(l)) count += 1;
    }
    print("Part2 result: {}\n", .{count});
}
