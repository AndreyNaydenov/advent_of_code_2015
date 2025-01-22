const std = @import("std");
const print = std.debug.print;
const input = @embedFile("input.txt");
const dayinfo = @embedFile("dayinfo");

const Present = struct {
    dimensions: [3]u32,

    pub fn getSurfaces(p: @This()) [3]u32 {
        return [_]u32{
            p.dimensions[0] * p.dimensions[1],
            p.dimensions[1] * p.dimensions[2],
            p.dimensions[2] * p.dimensions[0],
        };
    }

    pub fn getNeededPackingSurface(p: @This()) u32 {
        const smallest = p.getSmallestSideSurface();
        const surfaces = p.getSurfaces();
        var sum: u32 = 0;
        for (surfaces) |s| sum += (2 * s);
        sum += smallest;
        return sum;
    }

    pub fn getSmallestSideSurface(p: @This()) u32 {
        const surfaces = p.getSurfaces();
        var min = surfaces[0];
        if (surfaces[1] < min) min = surfaces[1];
        if (surfaces[2] < min) min = surfaces[2];
        return min;
    }

    pub fn getRibbonLen(p: @This()) u32 {
        var max_dim_i: usize = 0;
        var max_dim: u32 = 0;
        for (p.dimensions, 0..) |d, i| {
            if (d > max_dim) {
                max_dim = d;
                max_dim_i = i;
            }
        }
        var perimiter: u32 = 0;
        for (p.dimensions, 0..) |d, i| {
            if (i == max_dim_i) continue;
            perimiter += (2 * d);
        }
        const ribbon = p.dimensions[0] * p.dimensions[1] * p.dimensions[2];
        return perimiter + ribbon;
    }
};

pub fn main() !void {
    print("Running solution for {s}\n", .{dayinfo});
    const num_of_lines = comptime blk: {
        @setEvalBranchQuota(100_000);
        var count: usize = 0;
        for (input) |char| {
            if (char == '\n') count += 1;
        }
        break :blk count;
    };
    var presents: [num_of_lines]Present = undefined;

    parse(input, presents[0..presents.len]);
    try part1(&presents);
    try part2(&presents);
}

fn parse(comptime data: []const u8, presents: []Present) void {
    var it = std.mem.splitScalar(u8, data, '\n');
    var j: usize = 0;
    while (it.next()) |line| {
        if (line.len == 0) continue;
        var val_it = std.mem.splitScalar(u8, line, 'x');
        var new_p_dimensions = [3]u32{ 0, 0, 0 };
        var i: usize = 0;
        while (val_it.next()) |str_int| {
            new_p_dimensions[i] = std.fmt.parseInt(u8, str_int, 10) catch unreachable;
            i += 1;
        }

        const new_p = Present{ .dimensions = new_p_dimensions };
        presents[j] = new_p;
        j += 1;
    }
}

fn part1(presents: []Present) !void {
    var sum: u32 = 0;
    for (presents) |p| {
        const res = p.getNeededPackingSurface();
        sum += res;
    }
    print("Part1 result: {}\n", .{sum});
}

fn part2(presents: []Present) !void {
    var sum: u32 = 0;
    for (presents) |p| {
        const res = p.getRibbonLen();
        sum += res;
    }
    print("Part2 result: {}\n", .{sum});
}
