const std = @import("std");
const utils = @import("utils.zig");

pub fn main() !void {
    const stdout = utils.io.getStdOut().writer();
    const stdin = utils.io.getStdIn().reader();

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var history = utils.ArrayList([]const u8).init(allocator);
    defer {
        for (history.items) |item| {
            allocator.free(item);
        }
        history.deinit();
    }

    try stdout.print("Welcome to Terminal edno!\n", .{});

    while (true) {
        try stdout.print("λ → ", .{});
        var input_buffer: [utils.MAX_INPUT_SIZE]u8 = undefined;
        const input = try stdin.readUntilDelimiterOrEof(&input_buffer, '\n');

        if (input) |cmd| {
            const trimmed_cmd = utils.mem.trim(u8, cmd, &std.ascii.whitespace);
            if (trimmed_cmd.len == 0) continue;

            if (utils.mem.eql(u8, trimmed_cmd, "exit")) {
                break;
            } else if (utils.mem.eql(u8, trimmed_cmd, "history")) {
                try utils.printHistory(stdout, history);
            } else {
                try utils.addToHistory(&history, allocator, trimmed_cmd);
                try utils.executeCommand(allocator, trimmed_cmd);
            }
        } else {
            break;
        }
    }

    try stdout.print("Goodbye!\n", .{});
}
