pub const date = struct {
    year: u16,
    month: u8,
    day: u8,
    hour: u8,
    minute: u8,
    second: u8,
};

pub fn timeParser(time: *i64) !date {
    const YEAR: i64 = 31536000;
    const MONTH: i64 = 2629743;
    const WEEK: i64 = 604800;
    const DAY: i64 = 86400;
    const HOUR: i64 = 3600;

    var currentYear: u16 = 1970;
    var currentMonth: u8 = 1;
    var currentDay: u8 = 0;
    var currentHour: u8 = 0;
    var currentMinute: u8 = 0;
    var currentSecond: u8 = 0;

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

fn monthSwitch(month: u8, currentYear: u16) i64 {
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
