const std = @import("std");
const testing = std.testing;
const ztring = @import("root.zig");

test "Concat two strings" {
    const str1 = "Hel";
    const str2 = "lo";
    var buffer: [100]u8 = undefined;

    const result = try ztring.concatString(str1, str2, &buffer);
    try testing.expect(std.mem.eql(u8, result, "Hello"));
}

test "Char to string" {
    const char: u8 = 'a';
    var buffer: [100]u8 = undefined;
    const result: []const u8 = try ztring.charToString(char, &buffer);
    try testing.expect(@TypeOf(result) == []const u8);
    try testing.expect(std.mem.eql(u8, result, "a"));
}

test "Get substring" {
    const string = "Hello there";

    const result = try ztring.getSubstring(string, "there");
    const expected = "there";
    try testing.expect(std.mem.eql(u8, result, expected));

    const result2 = try ztring.getSubstring("This is another string", "another");
    try testing.expect(std.mem.eql(u8, result2, "another"));

    const result3 = try ztring.getSubstring("ab abcde abcdefg", "bcde");
    try testing.expect(std.mem.eql(u8, result3, "bcde"));

    const err = ztring.getSubstring("Hello", "r");
    try testing.expect(err == ztring.ZtringError.NotFound);
}

test "Split string" {
    const string: []const u8 = "altogether";
    const result = try ztring.splitString(string, 'g');
    try testing.expect(std.mem.eql(u8, result.first, "altog"));
    try testing.expect(std.mem.eql(u8, result.second, "ether"));
    const err = ztring.splitString(string, '!');
    try testing.expect(err == ztring.ZtringError.NotFound);
}

test "Num to string" {
    const num: i32 = 1234;
    var buffer: [100]u8 = undefined;
    const result = try ztring.numToString(num, &buffer);

    try testing.expect(std.mem.eql(u8, result, "1234"));

    const float: f32 = 1.234;
    const result2 = try ztring.numToString(float, &buffer);

    try testing.expect(std.mem.eql(u8, result2, "1.234"));

    //const notANumber = "hello";
    //const result3 = ztring.numToString(notANumber, &buffer);
    //
    //try testing.expect(result3 == ztring.ZtringError.FormatError);
}
