const std = @import("std");

pub fn join(parts_name: []const u8, output_file_name: []const u8, parts: u64) !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer std.debug.assert(gpa.deinit() == .ok);
    var allocator = gpa.allocator();

    const output_file = try std.fs.cwd().createFile(output_file_name, .{});
    defer output_file.close();

    const buffer_size: usize = 4098;
    var buffer: [buffer_size]u8 = undefined;
    for (1..parts + 1) |i| {
        const part_file_name = try std.fmt.allocPrint(allocator, "{s}.part_{}", .{ parts_name, i });
        defer allocator.free(part_file_name);

        const part_file = std.fs.cwd().openFile(part_file_name, .{}) catch {
            std.debug.print("Error opening file: {s}", .{part_file_name});
            return;
        };
        defer part_file.close();

        while (true) {
            const size = try part_file.read(&buffer);
            if (size == 0) break;
            _ = try output_file.writeAll(buffer[0..size]);
        }
    }
}
