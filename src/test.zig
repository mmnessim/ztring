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
}

test "Get substring" {
    const string = "Hello there";
    var buffer: [100]u8 = undefined;
    const result = try ztring.getSubstring(string, "there", &buffer);
    const expected = "there";
    try testing.expect(std.mem.eql(u8, result, expected));

    const result2 = try ztring.getSubstring("This is another string", "another", &buffer);
    try testing.expect(std.mem.eql(u8, result2, "another"));

    const result3 = try ztring.getSubstring("ab abcde abcdefg", "bcde", &buffer);
    try testing.expect(std.mem.eql(u8, result3, "bcde"));
}

test "Split string" {
    const string: []const u8 = "altogether";
    const result = try ztring.splitString(string, 'g');
    try testing.expect(std.mem.eql(u8, result[0], "altog"));
    try testing.expect(std.mem.eql(u8, result[1], "ether"));
    const err = ztring.splitString(string, '!');
    try testing.expect(err == ztring.ZtringError.NotFound);
}
