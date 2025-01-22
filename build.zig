const std = @import("std");

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const run_step = b.step("run", "Run the app");

    for (try findSolutions(b.allocator, "src/")) |solution| {
        const exe_mod = b.createModule(.{
            .root_source_file = b.path(solution),
            .target = target,
            .optimize = optimize,
        });

        const exe_name_index = std.mem.indexOf(u8, solution, "day") orelse continue;
        const exe_name = solution[exe_name_index..(exe_name_index + "day00".len)];
        const exe = b.addExecutable(.{
            .name = exe_name,
            .root_module = exe_mod,
        });

        // add info about day number to each solution
        const wf = b.addWriteFiles();
        const output = wf.add("dayinfo", exe_name);
        exe.root_module.addAnonymousImport("dayinfo", .{
            .root_source_file = output,
        });

        b.installArtifact(exe);

        const run_cmd = b.addRunArtifact(exe);

        run_cmd.step.dependOn(b.getInstallStep());

        if (b.args) |args| {
            run_cmd.addArgs(args);
        }

        run_step.dependOn(&run_cmd.step);
    }
}

fn findSolutions(allocator: std.mem.Allocator, path: []const u8) ![][]const u8 {
    const absolute_path = if (std.fs.path.isAbsolute(path))
        path
    else
        std.fs.cwd().realpathAlloc(allocator, path) catch |err| {
            switch (err) {
                error.FileNotFound => return &.{},
                else => return err,
            }
        };

    var dir = std.fs.openDirAbsolute(absolute_path, .{ .iterate = true }) catch |err| {
        switch (err) {
            error.FileNotFound => return &.{},
            else => return err,
        }
    };
    defer dir.close();

    var solutions = std.ArrayList([]const u8).init(allocator);

    var it = dir.iterate();
    while (try it.next()) |entry| {
        if (entry.kind != .directory) continue;
        if (!std.mem.eql(u8, entry.name[0.."day".len], "day")) continue;
        try solutions.append(try std.fs.path.join(allocator, &.{ path, entry.name, "main.zig" }));
    }

    return try solutions.toOwnedSlice();
}
