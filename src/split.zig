const std = @import("std");

pub fn split(input_file_path: []const u8, parts_name: []const u8, split_bytes: u64) !u64 {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer std.debug.assert(gpa.deinit() == .ok);
    var allocator = gpa.allocator();

    const input_file = std.fs.cwd().openFile(input_file_path, .{ .mode = .read_only }) catch {
        std.debug.print("File not found: {s}\n", .{input_file_path});
        return 0;
    };

    const file_size = try input_file.getEndPos();
    const total_no_of_files: u64 = (file_size + split_bytes - 1) / split_bytes;

    for (0..total_no_of_files) |i| {
        const part_file_name = try std.fmt.allocPrint(allocator, "{s}.part_{}", .{ parts_name, i + 1 });
        defer allocator.free(part_file_name);

        const part_file = try std.fs.cwd().createFile(part_file_name, .{});
        defer part_file.close();

        var part_size = split_bytes;
        if (part_size > (file_size - (i * part_size))) {
            part_size = file_size - (i * part_size);
        }

        var buffer = try allocator.alloc(u8, part_size);
        defer allocator.free(buffer);
        _ = try input_file.read(buffer[0..]);
        _ = try part_file.writeAll(buffer[0..]);
    }

    return total_no_of_files;
}
