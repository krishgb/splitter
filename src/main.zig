const std = @import("std");
const split = @import("split.zig");
const join = @import("join.zig");
const args_parser = @import("args_parser.zig");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer std.debug.assert(gpa.deinit() == .ok);

    const allocator = gpa.allocator();

    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    var parser = try args_parser.ArgsParser.init(args);
    try parser.execute();
}

test "parts" {
    const parts = try split.split("video.mp4", "parts.mp4", 10000000);
    try std.testing.expect(parts == 16);
    _ = try join.join("parts.mp4", "output.mp4", parts);
}
