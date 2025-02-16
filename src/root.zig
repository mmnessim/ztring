//! By convention, root.zig is the root source file when making a library. If
//! you are making an executable, the convention is to delete this file and
//! start with main.zig instead.
const std = @import("std");
const testing = std.testing;

pub fn concatString(str1: []const u8, str2: []const u8, buffer: []u8) ![]const u8 {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    const allocator = gpa.allocator();

    var combined = try allocator.alloc(u8, str1.len + str2.len);
    defer allocator.free(combined);
    std.mem.copyForwards(u8, combined[0..], str1);
    std.mem.copyForwards(u8, combined[str1.len..], str2);

    const result = try std.fmt.bufPrint(buffer, "{s}", .{combined});
    return result;
}

pub fn charToString(char: u8, buffer: []u8) ![]const u8 {
    const result = try std.fmt.bufPrint(buffer, "{c}", .{char});
    return result;
}
