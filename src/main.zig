const std = @import("std");
const split = @import("split.zig");
const join = @import("join.zig");

pub fn main() !void {
    // To run the test
    _ = 0;
}

test "parts" {
    const parts = try split.split("video.mp4", "parts.mp4", 10000000);
    try std.testing.expect(parts == 16);
    _ = try join.join("parts.mp4", "output.mp4", parts);
}
