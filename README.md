# Ztring
## About
Some helper functions to work with strings in Zig.
## To use
At least Zig 0.13.0.

`zig fetch --save git+https://github.com/mmnessim/ztring.git`

Add these lines to build.zig

`const ztring = b.dependency("ztring", .{
  .target = target,
  });`

  `exe.root_module.addImport("ztring", ztring.module("ztring"));`

  Then import and use:
  `const ztring = @import("ztring");`

  `var buffer: [4096]u8 = undefined;`
  
  `const concat = try ztring.concatString("Hello ", "Zig!", &buffer);`
  
  `std.debug.print("{s}\n", .{concat}); // "Hello Zig!"`
