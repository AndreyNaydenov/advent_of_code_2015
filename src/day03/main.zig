const std = @import("std");
const print = std.debug.print;
const input = @embedFile("input.txt");
const dayinfo = @embedFile("dayinfo");

const Point = struct {
    x: i32,
    y: i32,
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer std.debug.assert(gpa.deinit() == .ok);

    print("Running solution for {s}\n", .{dayinfo});

    const parsed = parse(input);

    try part1(allocator, parsed);

    try part2(allocator, parsed);
}

fn parse(data: []const u8) []const u8 {
    return data;
}

fn part1(allocator: std.mem.Allocator, data: []const u8) !void {
    // create hash set (HashMap with void Value) {} - void type value
    var set = std.AutoHashMap(Point, void).init(allocator);
    defer set.deinit();

    // init staring pos and add it to the set
    var current_pos = Point{ .x = 0, .y = 0 };
    try set.put(current_pos, {});

    // iterate over input keep track of current coors and append coord to the set each step
    for (data) |char| {
        // modify coord depending on direction
        switch (char) {
            '<' => current_pos.x -= 1,
            '>' => current_pos.x += 1,
            '^' => current_pos.y -= 1,
            'v' => current_pos.y += 1,
            else => continue,
        }
        // add new pos to set
        try set.put(current_pos, {});
    }
    const result = set.count();
    print("Part1 result: {}\n", .{result});
}

fn part2(allocator: std.mem.Allocator, data: []const u8) !void {
    // create hash set (HashMap with void Value) {} - void type value
    var set = std.AutoHashMap(Point, void).init(allocator);
    defer set.deinit();

    // init staring pos and add it to the set
    var current_santa_pos = Point{ .x = 0, .y = 0 };
    var current_robot_pos = Point{ .x = 0, .y = 0 };
    var pos: *Point = undefined;
    try set.put(current_santa_pos, {});

    // iterate over input keep track of current coors and append coord to the set each step
    for (data, 0..) |char, i| {
        // if step is even its santa's turn, else robot's
        if (i % 2 == 0) {
            pos = &current_santa_pos;
        } else {
            pos = &current_robot_pos;
        }
        // modify coord depending on direction
        switch (char) {
            '<' => pos.x -= 1,
            '>' => pos.x += 1,
            '^' => pos.y -= 1,
            'v' => pos.y += 1,
            else => continue,
        }
        // add new pos to set
        try set.put(pos.*, {});
    }
    const result = set.count();
    print("Part2 result: {}\n", .{result});
}
