const std = @import("std");
const date = @import("date.zig");

pub fn main() !void {
    std.debug.print("Hello world!\n", .{});
    while (true) {
        std.time.sleep(std.time.ns_per_s);
        var timestamp = std.time.timestamp();
        const now = try date.timeParser(&timestamp);
        std.debug.print("{d}:{d:0>2}:{d:0>2}\n", .{ now.hour, now.minute, now.second });
    }
}
