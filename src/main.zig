const std = @import("std");
const io = std.io;
const mem = std.mem;
const Child = std.process.Child;
const ArrayList = std.ArrayList;

const MAX_INPUT_SIZE = 1024;
const MAX_HISTORY_SIZE = 128;

pub fn main() !void {
    const stdout = io.getStdOut().writer();
    const stdin = io.getStdIn().reader();

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var history = ArrayList([]const u8).init(allocator);
    defer {
        for (history.items) |item| {
            allocator.free(item);
        }
        history.deinit();
    }

    try stdout.print("Welcome to Terminal edno!\n", .{});

    while (true) {
        try stdout.print("> ", .{});
        var input_buffer: [MAX_INPUT_SIZE]u8 = undefined;
        const input = try stdin.readUntilDelimiterOrEof(&input_buffer, '\n');

        if (input) |cmd| {
            const trimmed_cmd = mem.trim(u8, cmd, &std.ascii.whitespace);
            if (trimmed_cmd.len == 0) continue;

            if (mem.eql(u8, trimmed_cmd, "exit")) {
                break;
            } else if (mem.eql(u8, trimmed_cmd, "history")) {
                try printHistory(stdout, history);
            } else {
                try addToHistory(&history, allocator, trimmed_cmd);
                try executeCommand(allocator, trimmed_cmd);
            }
        } else {
            break;
        }
    }

    try stdout.print("Goodbye!\n", .{});
}

fn executeCommand(allocator: mem.Allocator, cmd: []const u8) !void {
    const stdout = io.getStdOut().writer();

    var child = Child.init(&.{ "/bin/sh", "-c", cmd }, allocator);
    child.stdout_behavior = .Inherit;
    child.stderr_behavior = .Inherit;

    try child.spawn();

    const result = try child.wait();

    switch (result) {
        .Exited => |code| {
            if (code != 0) {
                try stdout.print("Command exited with non-zero status code: {}\n", .{code});
            }
        },
        else => try stdout.print("Command failed to execute\n", .{}),
    }
}

fn printHistory(writer: anytype, history: ArrayList([]const u8)) !void {
    for (history.items, 0..) |cmd, i| {
        try writer.print("{d}: {s}\n", .{ i + 1, cmd });
    }
}

fn addToHistory(history: *ArrayList([]const u8), allocator: mem.Allocator, cmd: []const u8) !void {
    if (history.items.len == MAX_HISTORY_SIZE) {
        const oldest = history.orderedRemove(0);
        allocator.free(oldest);
    }
    const cmd_copy = try allocator.dupe(u8, cmd);
    try history.append(cmd_copy);
}
