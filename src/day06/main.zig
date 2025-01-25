const std = @import("std");
const print = std.debug.print;
const input = @embedFile("input.txt");
const dayinfo = @embedFile("dayinfo");

const num_lines = blk: {
    @setEvalBranchQuota(100_000);
    break :blk std.mem.count(u8, input, "\n");
};

const Cell = u16;
const grid_size = 1000;
const Grid = [1000][1000]Cell;

const Point = struct {
    x: usize,
    y: usize,
};

const Op = enum {
    toggle,
    turn_on,
    turn_off,
};

const Instruction = struct {
    op: Op,
    start: Point,
    end: Point,
};

pub fn main() !void {
    print("Running solution for {s}\n", .{dayinfo});

    // allocate space for list of instructions
    var instructions: [num_lines]Instruction = undefined;

    const parsed = try parse(input, &instructions);
    try part12(1, parsed);
    try part12(2, parsed);
}

fn parse(data: []const u8, buf: []Instruction) ![]Instruction {
    // turn on 668,20 through 935,470
    // turn off 133,418 through 613,458
    var i: usize = 0;
    var iter = std.mem.splitScalar(u8, data, '\n');
    while (iter.next()) |line| {
        if (line.len == 0) continue;
        var tokens = std.mem.tokenizeAny(u8, line, " ,");

        var op: Op = undefined;
        var start: Point = undefined;
        var end: Point = undefined;

        // parse Op
        const first = tokens.next() orelse unreachable;
        if (!std.mem.eql(u8, first, "toggle")) {
            const second = tokens.next() orelse unreachable;
            if (std.mem.eql(u8, second, "on")) {
                op = .turn_on;
            } else {
                op = .turn_off;
            }
        } else {
            op = .toggle;
        }

        // parse start
        const start_x = tokens.next() orelse unreachable;
        const start_y = tokens.next() orelse unreachable;
        start = .{
            .x = try std.fmt.parseInt(usize, start_x, 10),
            .y = try std.fmt.parseInt(usize, start_y, 10),
        };

        // skip "through"
        _ = tokens.next();

        // parse end
        const end_x = tokens.next() orelse unreachable;
        const end_y = tokens.next() orelse unreachable;
        end = .{
            .x = try std.fmt.parseInt(usize, end_x, 10),
            .y = try std.fmt.parseInt(usize, end_y, 10),
        };

        // insert Instruction with parsed values
        buf[i] = .{
            .op = op,
            .start = start,
            .end = end,
        };

        i += 1;
    }
    return buf;
}

fn doInstruction(grid: *Grid, instruction: Instruction, op_func: fn (*Cell, Op) void) void {
    for (instruction.start.y..instruction.end.y + 1) |j| {
        for (instruction.start.x..instruction.end.x + 1) |i| {
            op_func(&grid[j][i], instruction.op);
        }
    }
}

fn applyOp1(cell: *Cell, op: Op) void {
    switch (op) {
        .toggle => cell.* = if (cell.* == 0) 1 else 0,
        .turn_on => cell.* = 1,
        .turn_off => cell.* = 0,
    }
}

fn applyOp2(cell: *Cell, op: Op) void {
    switch (op) {
        .toggle => cell.* += 2,
        .turn_on => cell.* += 1,
        .turn_off => cell.* = if (cell.* <= 1) 0 else cell.* - 1,
    }
}

fn count(grid: Grid) usize {
    var c: usize = 0;
    for (grid) |row| {
        for (row) |cell| {
            c += cell;
        }
    }
    return c;
}

fn part12(part: comptime_int, instructions: []Instruction) !void {
    // init grid
    var grid: Grid = undefined;
    for (&grid) |*row| {
        for (row) |*cell| {
            cell.* = 0;
        }
    }

    // op function
    const op_func = if (part == 1) applyOp1 else applyOp2;

    // apply instructions
    for (instructions) |i| {
        doInstruction(&grid, i, op_func);
    }

    // sum lights
    const result = count(grid);

    print("Part{d} result: {d}\n", .{ part, result });
}
