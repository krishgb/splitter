const std = @import("std");
const print = std.debug.print;

pub fn size(str: []const u8) !u64 {
    std.debug.assert(str.len > 0);

    const AllMeasurements = enum { kb, KB, KiB, kib, mb, MB, MiB, mib, gb, GB, GiB, gib, tb, TB, TiB, tib, pb, PB, PiB, pib };

    const N_KILO_BYTE = 1000;
    const N_MEGA_BYTE = 1000 * N_KILO_BYTE;
    const N_GIGA_BYTE = 1000 * N_MEGA_BYTE;
    const N_TERA_BYTE = 1000 * N_GIGA_BYTE;
    const N_PETA_BYTE = 1000 * N_TERA_BYTE;

    const KILO_BYTE = 1024;
    const MEGA_BYTE = 1024 * KILO_BYTE;
    const GIGA_BYTE = 1024 * MEGA_BYTE;
    const TERA_BYTE = 1024 * GIGA_BYTE;
    const PETA_BYTE = 1024 * TERA_BYTE;

    var num_end_index: usize = 0;

    for (0..str.len) |i| {
        const ch = str[i];
        // print("I ::: {}\tSIZE ::: {}\tS: {s}\n", .{ i, str.len, str[0..i] });
        if (ch < '0' or ch > '9') {
            num_end_index = i;
            break;
        }
    }

    if (num_end_index == 0) {
        return try std.fmt.parseInt(u64, str, 10);
    }

    const num_size = str[0..num_end_index];
    // print("NUM SIZE ::: {s}\t{}\n", .{ num_size, num_end_index });
    const nsize = try std.fmt.parseInt(u64, num_size, 10);

    const measurement = str[num_end_index..];

    if (measurement.len == 0) {
        return nsize;
    }

    const parsed_measurement = std.meta.stringToEnum(AllMeasurements, measurement) orelse return error.InvalidMeasurement;
    return switch (parsed_measurement) {
        .kb, .KB => nsize * N_KILO_BYTE,
        .mb, .MB => nsize * N_MEGA_BYTE,
        .gb, .GB => nsize * N_GIGA_BYTE,
        .tb, .TB => nsize * N_TERA_BYTE,
        .pb, .PB => nsize * N_PETA_BYTE,

        .kib, .KiB => nsize * KILO_BYTE,
        .mib, .MiB => nsize * MEGA_BYTE,
        .gib, .GiB => nsize * GIGA_BYTE,
        .tib, .TiB => nsize * TERA_BYTE,
        .pib, .PiB => nsize * PETA_BYTE,
    };
}

test "n_size" {
    const expect = std.testing.expect;

    try expect(try size("100kb") == 100000);
    try expect(try size("100KB") == 100000);

    try expect(try size("173mb") == 173000000);
    try expect(try size("173MB") == 173000000);

    try expect(try size("3gb") == 3000000000);
    try expect(try size("3GB") == 3000000000);

    try expect(try size("64tb") == 64000000000000);
    try expect(try size("64TB") == 64000000000000);

    try expect(try size("12pb") == 12000000000000000);
    try expect(try size("12PB") == 12000000000000000);
}

test "size" {
    const expect = std.testing.expect;

    try expect(try size("100kib") == 102400);
    try expect(try size("100KiB") == 102400);

    try expect(try size("173mib") == 181403648);
    try expect(try size("173MiB") == 181403648);

    try expect(try size("3gib") == 3221225472);
    try expect(try size("3GiB") == 3221225472);

    try expect(try size("64tib") == 70368744177664);
    try expect(try size("64TiB") == 70368744177664);

    try expect(try size("12pib") == 13510798882111488);
    try expect(try size("12PiB") == 13510798882111488);
}

test "just bytes" {
    const expect = std.testing.expect;
    try expect(try size("13510798882111488") == 13510798882111488);
}

test "invalid_measurement" {
    const expect = std.testing.expectError;
    try expect(error.InvalidMeasurement, size("100.1gb"));
    try expect(error.InvalidMeasurement, size("100g"));
}
