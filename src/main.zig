const std = @import("std");
const os = std.os;
const io = std.io;
const mem = std.mem;
const process = std.process;
const Child = std.process.Child;

const MAX_INPUT_SIZE = 1024;

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    const stdin = std.io.getStdIn().reader();

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    try stdout.print("Welcome to Terminal edno!\n", .{});

    while (true) {
        try stdout.print("> ", .{});
        var input_buffer: [MAX_INPUT_SIZE]u8 = undefined;
        const input = try stdin.readUntilDelimiterOrEof(&input_buffer, '\n');

        if (input) |cmd| {
            if (mem.eql(u8, cmd, "exit")) {
                break;
            }
            try executeCommand(allocator, cmd);
        } else {
            break;
        }
    }

    try stdout.print("Goodbye!\n", .{});
}

fn executeCommand(allocator: std.mem.Allocator, cmd: []const u8) !void {
    const stdout = std.io.getStdOut().writer();

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
