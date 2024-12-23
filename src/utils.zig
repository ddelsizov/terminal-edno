const std = @import("std");
const builtin = @import("builtin");
const vars = @import("vars.zig");
const Child = std.process.Child;
const red = vars.red;
const reset = vars.reset;
const max_history_size = vars.MAX_HISTORY_SIZE;
pub const io = std.io;
pub const mem = std.mem;
pub const ArrayList = std.ArrayList;

// TODO:
// Spawn a shell as master / slave process pair, instead of single command execution.

pub fn executeCommand(allocator: mem.Allocator, cmd: []const u8) !void {
    const stdout = io.getStdOut().writer();

    // Define command shell based on OS
    const shell_cmd = switch (builtin.os.tag) {
        .windows => &.{ "cmd.exe", "/C", cmd },
        .macos, .linux => &.{ "/bin/sh", "-c", cmd },
        else => return error.UnsupportedOS,
    };

    var child = Child.init(shell_cmd, allocator);
    child.stdout_behavior = .Inherit;
    child.stderr_behavior = .Inherit;

    try child.spawn();

    const result = try child.wait();

    switch (result) {
        .Exited => |code| {
            if (code != 0) {
                try stdout.print("{s}Command exited with non-zero status code: {}{s}\n", .{ red, code, reset });
            }
        },
        else => try stdout.print("{s}Command failed to execute{s}\n", .{ red, reset }),
    }
}

pub fn printHistory(writer: anytype, history: ArrayList([]const u8)) !void {
    for (history.items, 0..) |cmd, i| {
        try writer.print("{d}: {s}\n", .{ i + 1, cmd });
    }
}

pub fn addToHistory(history: *ArrayList([]const u8), allocator: mem.Allocator, cmd: []const u8) !void {
    if (history.items.len == max_history_size) {
        const oldest = history.orderedRemove(0);
        allocator.free(oldest);
    }
    const cmd_copy = try allocator.dupe(u8, cmd);
    try history.append(cmd_copy);
}
