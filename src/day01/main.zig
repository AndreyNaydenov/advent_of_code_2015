const std = @import("std");
const print = std.debug.print;
const input = @embedFile("input.txt");

pub fn main() void {
    part1();
    part2();
}

fn part1() void {
    var resulting_floor: isize = 0;
    for (input) |char| {
        if (char == '(') resulting_floor += 1;
        if (char == ')') resulting_floor -= 1;
    }
    print("Part1 result: {}\n", .{resulting_floor});
}

fn part2() void {
    var resulting_floor: isize = 0;
    var resulting_index: usize = undefined;
    for (input, 1..) |char, i| {
        if (char == '(') resulting_floor += 1;
        if (char == ')') resulting_floor -= 1;
        if (resulting_floor == -1) {
            resulting_index = i;
            break;
        }
    }
    print("Part2 result: {}\n", .{resulting_index});
}
