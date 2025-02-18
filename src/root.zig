//! By convention, root.zig is the root source file when making a library. If
//! you are making an executable, the convention is to delete this file and
//! start with main.zig instead.
const std = @import("std");
const testing = std.testing;

pub const ZtringError = error{
    NotFound,
};

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

pub fn getSubstring(input: []const u8, substring: []const u8, buffer: []u8) ![]const u8 {
    var start: usize = 0;
    var end: usize = 0;
    for (input, 0..) |letter, index| {
        if (letter == substring[0]) {
            inner: for (substring) |sLetter| {
                if (input[index] == sLetter) {
                    start = index;
                    end = index;
                } else {
                    break :inner;
                }
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

pub fn splitString(input: []const u8, delimiter: u8) !struct { []const u8, []const u8 } {
    var separationPoint: usize = 0;
    for (input, 0..) |letter, index| {
        if (letter == delimiter) {
            std.debug.print("FOUND {c} at {d}\n", .{ letter, index });
            std.debug.print("{s}\n", .{input[0 .. index + 1]});
            std.debug.print("{s}\n", .{input[index + 1 ..]});
            separationPoint = index + 1;
        }
    }

    if (separationPoint != 0) {
        const result = .{ input[0..separationPoint], input[separationPoint..] };
        return result;
    }

    return ZtringError.NotFound;
}
