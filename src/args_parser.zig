const std = @import("std");
const Split = @import("split.zig");
const Join = @import("join.zig");
const Size = @import("size.zig");

pub const Command = enum { split, join };

pub const ArgsParser = struct {
    command: Command,
    input_path: []const u8,
    output_path: []const u8,
    size: u64,

    const Self = @This();
    pub fn init(args: [][]const u8) !ArgsParser {
        if (args.len != 5) {
            return error.NotEnoughArgumentsOrTooManyArguments;
        }

        const command: Command = if (std.mem.eql(u8, args[1], "-s"))
            .split
        else if (std.mem.eql(u8, args[1], "-j"))
            .join
        else
            return error.InvalidOperationArgument;

        const size = switch (command) {
            .split => try Size.size(args[4]),
            .join => std.fmt.parseUnsigned(u64, args[4], 10) catch return error.InvalidParts,
        };

        return ArgsParser{ .command = command, .input_path = args[2], .output_path = args[3], .size = size };
    }

    pub fn execute(self: *Self) !void {
        switch (self.command) {
            .split => {
                _ = try Split.split(self.input_path, self.output_path, self.size);
            },
            .join => {
                try Join.join(self.input_path, self.output_path, self.size);
            },
        }
    }
};
