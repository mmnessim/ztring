//! By convention, root.zig is the root source file when making a library. If
//! you are making an executable, the convention is to delete this file and
//! start with main.zig instead.
const std = @import("std");
const ascii = std.ascii;
const testing = std.testing;

pub const ZtringError = error{
    NotFound,
    FormatError,
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

pub fn getSubstring(input: []const u8, substring: []const u8) ![]const u8 {
    var start: usize = 0;
    var end: usize = 0;
    for (input, 0..) |letter, index| {
        // Find first letter of the substring
        if (letter == substring[0]) {
            inner: for (substring) |sLetter| {
                // Check all letters for matches, update index
                if (input[index] == sLetter) {
                    start = index;
                    end = index;
                } else {
                    // Break and search for first letter again if
                    // nonmatching letter is found
                    break :inner;
                }
            }
        }
    }
    // Iterate through substring
    for (substring, start..) |letter, index| {
        if (letter == input[index]) {
            end += 1;
            continue;
        } else {
            //end = index;
            break;
        }
    }
    const result = input[start..end];
    if (end == 0) {
        return ZtringError.NotFound;
    }
    return result;
}

pub fn splitString(input: []const u8, delimiter: u8) !SplitResult {
    var separationPoint: usize = 0;
    for (input, 0..) |letter, index| {
        if (letter == delimiter) {
            separationPoint = index + 1;
        }
    }

    if (separationPoint != 0) {
        const result = SplitResult{ .first = input[0..separationPoint], .second = input[separationPoint..] };
        return result;
    }

    return ZtringError.NotFound;
}

pub const SplitResult = struct {
    first: []const u8,
    second: []const u8,
};

pub const date = struct {
    year: i16,
    month: i8,
    day: i8,
    hour: i8,
    minute: i8,
    second: i8,
};

pub fn timeParser(time: *i64) !date {
    const YEAR: i64 = 31536000;
    const MONTH: i64 = 2629743;
    const WEEK: i64 = 604800;
    const DAY: i64 = 86400;
    const HOUR: i64 = 3600;

    var currentYear: i16 = 1970;
    var currentMonth: i8 = 1;
    var currentDay: i8 = 0;
    var currentHour: i8 = 0;
    var currentMinute: i8 = 0;
    var currentSecond: i8 = 0;

    time.* -= (HOUR * 5); // Timezone adjustment
    time.* += 27; //leap seconds to date

    while (true) {
        if (time.* > YEAR) {
            currentYear += 1;
            if (@mod(currentYear, 4) == 0) {
                time.* -= (DAY * 366);
            } else {
                time.* -= (DAY * 365);
            }
        } else if (time.* >= MONTH) {
            time.* -= monthSwitch(currentMonth, currentYear);
            currentMonth += 1;
        } else if (time.* >= DAY) {
            currentDay += 1;
            time.* -= DAY;
        } else if (time.* >= HOUR) {
            currentHour += 1;
            time.* -= HOUR;
        } else if (time.* >= 60) {
            currentMinute += 1;
            time.* -= 60;
        } else if (time.* >= 1) {
            currentSecond += 1;
            time.* -= 1;
        } else {
            break;
        }
    }
    _ = WEEK;
    return date{
        .year = currentYear,
        .month = currentMonth,
        .day = currentDay,
        .hour = currentHour,
        .minute = currentMinute,
        .second = currentSecond,
    };
}

fn monthSwitch(month: i8, currentYear: i16) i64 {
    const DAY: i64 = 86400;
    switch (month) {
        1, 3, 5, 7, 8, 10, 12 => return 31 * DAY,
        2 => if (@mod(currentYear, 4) == 0) {
            return 29 * DAY;
        } else {
            return 28 * DAY;
        },
        4, 6, 9, 11 => return 30 * DAY,
        else => return 30 * DAY,
    }
}

//TODO handle non-number inputs somehow
pub fn numToString(num: anytype, buffer: []u8) ![]const u8 {
    const result = try std.fmt.bufPrint(buffer, "{d}", .{num});
    return result;
}
