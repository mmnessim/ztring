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

// TODO build fn getSubstring
// probably iterate through all characters recursively to build substring?
// probably needs a buffer
pub fn getSubstring(input: []const u8, substring: []const u8, buffer: []u8) ![]const u8 {
    var start: usize = 0;
    var end: usize = 0;
    for (input, 0..) |letter, index| {
        if (letter == substring[0]) {
            if (input[index + 1] == substring[1]) {
                start = index;
                end = index;
            }
        }
    }
    for (substring, start..) |letter, index| {
        if (letter == input[index]) {
            end += 1;
            continue;
        } else {
            //end = index;
            break;
        }
    }
    const result = try std.fmt.bufPrint(buffer, "{s}", .{input[start..end]});
    std.debug.print("Result: {s}\n", .{result});
    return result;
}
