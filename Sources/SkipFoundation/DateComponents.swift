// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
#if !SKIP
import struct Foundation.DateComponents
public typealias DateComponents = Foundation.DateComponents
internal typealias PlatformDateComponents = Foundation.DateComponents
#else
public typealias DateComponents = SkipDateComponents
//public typealias PlatformDateComponents = java.text.DateFormat
#endif


// SKIP DECLARE: open class SkipDateComponents: Hashable, MutableStruct
internal struct SkipDateComponents : Hashable, CustomStringConvertible {
    #if !SKIP
    public var components: PlatformDateComponents

    public var calendar: PlatformCalendar? {
        get { components.calendar }
        set { components.calendar = newValue }
    }
    public var timeZone: TimeZone? {
        get { components.timeZone }
        set { components.timeZone = newValue }
    }
    public var era: Int? {
        get { components.era }
        set { components.era = newValue }
    }
    public var year: Int? {
        get { components.year }
        set { components.year = newValue }
    }
    public var month: Int? {
        get { components.month }
        set { components.month = newValue }
    }
    public var day: Int? {
        get { components.day }
        set { components.day = newValue }
    }
    public var hour: Int? {
        get { components.hour }
        set { components.hour = newValue }
    }
    public var minute: Int? {
        get { components.minute }
        set { components.minute = newValue }
    }
    public var second: Int? {
        get { components.second }
        set { components.second = newValue }
    }
    public var nanosecond: Int? {
        get { components.nanosecond }
        set { components.nanosecond = newValue }
    }
    public var weekday: Int? {
        get { components.weekday }
        set { components.weekday = newValue }
    }
    public var weekdayOrdinal: Int? {
        get { components.weekdayOrdinal }
        set { components.weekdayOrdinal = newValue }
    }
    public var quarter: Int? {
        get { components.quarter }
        set { components.quarter = newValue }
    }
    public var weekOfMonth: Int? {
        get { components.weekOfMonth }
        set { components.weekOfMonth = newValue }
    }
    public var weekOfYear: Int? {
        get { components.weekOfYear }
        set { components.weekOfYear = newValue }
    }
    public var yearForWeekOfYear: Int? {
        get { components.yearForWeekOfYear }
        set { components.yearForWeekOfYear = newValue }
    }

    internal init(components: PlatformDateComponents) {
        self.components = components
    }
    #else

    // the is no direct analogue to DateComponents in Java (other then java.util.Calendar), so we store the fields individually

    public var calendar: SkipCalendar? = nil
    public var timeZone: SkipTimeZone? = nil
    public var era: Int? = nil
    public var year: Int? = nil
    public var month: Int? = nil
    public var day: Int? = nil
    public var hour: Int? = nil
    public var minute: Int? = nil
    public var second: Int? = nil
    public var nanosecond: Int? = nil
    public var weekday: Int? = nil
    public var weekdayOrdinal: Int? = nil
    public var quarter: Int? = nil
    public var weekOfMonth: Int? = nil
    public var weekOfYear: Int? = nil
    public var yearForWeekOfYear: Int? = nil
    #endif

    public init(calendar: SkipCalendar? = nil, timeZone: SkipTimeZone? = nil, era: Int? = nil, year: Int? = nil, month: Int? = nil, day: Int? = nil, hour: Int? = nil, minute: Int? = nil, second: Int? = nil, nanosecond: Int? = nil, weekday: Int? = nil, weekdayOrdinal: Int? = nil, quarter: Int? = nil, weekOfMonth: Int? = nil, weekOfYear: Int? = nil, yearForWeekOfYear: Int? = nil) {
        #if !SKIP
        self.components = PlatformDateComponents(calendar: calendar?.rawValue, timeZone: timeZone?.rawValue, era: era, year: year, month: month, day: day, hour: hour, minute: minute, second: second, nanosecond: nanosecond, weekday: weekday, weekdayOrdinal: weekdayOrdinal, quarter: quarter, weekOfMonth: weekOfMonth, weekOfYear: weekOfYear, yearForWeekOfYear: yearForWeekOfYear)
        #else
        self.calendar = calendar
        self.timeZone = timeZone
        self.era = era
        self.year = year
        self.month = month
        self.day = day
        self.hour = hour
        self.minute = minute
        self.second = second
        self.nanosecond = nanosecond
        self.weekday = weekday
        self.weekdayOrdinal = weekdayOrdinal
        self.quarter = quarter
        self.weekOfMonth = weekOfMonth
        self.weekOfYear = weekOfYear
        self.yearForWeekOfYear = yearForWeekOfYear
        #endif
    }

    public var description: String {
        #if !SKIP
        return components.description
        #else
        var strs: [String] = []
        if let calendar = self.calendar {
            strs.append("calendar \(calendar)")
        }
        if let timeZone = self.timeZone {
            strs.append("timeZone \(timeZone)")
        }
        if let era = self.era {
            strs.append("era \(era)")
        }
        if let year = self.year {
            strs.append("year \(year)")
        }
        if let month = self.month {
            strs.append("month \(month)")
        }
        if let day = self.day {
            strs.append("day \(day)")
        }
        if let hour = self.hour {
            strs.append("hour \(hour)")
        }
        if let minute = self.minute {
            strs.append("minute \(minute)")
        }
        if let second = self.second {
            strs.append("second \(second)")
        }
        if let nanosecond = self.nanosecond {
            strs.append("nanosecond \(nanosecond)")
        }
        if let weekday = self.weekday {
            strs.append("weekday \(weekday)")
        }
        if let weekdayOrdinal = self.weekdayOrdinal {
            strs.append("weekdayOrdinal \(weekdayOrdinal)")
        }
        if let quarter = self.quarter {
            strs.append("quarter \(quarter)")
        }
        if let weekOfMonth = self.weekOfMonth {
            strs.append("weekOfMonth \(weekOfMonth)")
        }
        if let weekOfYear = self.weekOfYear {
            strs.append("weekOfYear \(weekOfYear)")
        }
        if let yearForWeekOfYear = self.yearForWeekOfYear {
            strs.append("yearForWeekOfYear \(yearForWeekOfYear)")
        }

        // SKIP REPLACE: return strs.joinToString(separator = " ")
        return strs.joined(separator: " ")
        #endif
    }

    #if SKIP
    /// Builds a java.util.Calendar from the fields
    private func createCalendar() -> PlatformCalendar {
        let c: PlatformCalendar = (self.calendar?.rawValue ?? PlatformCalendar.getInstance())
        let cal: PlatformCalendar = (c as java.util.Calendar).clone() as PlatformCalendar

        if let timeZoneValue = timeZone {
            cal.setTimeZone(timeZoneValue.rawValue)
        }
        if let eraValue = era {
            cal.set(PlatformCalendar.ERA, eraValue)
        }
        if let yearValue = year {
            cal.set(PlatformCalendar.YEAR, yearValue)
        }
        if let monthValue = month {
            cal.set(PlatformCalendar.MONTH, monthValue)
        }
        if let dayValue = day {
            cal.set(PlatformCalendar.DATE, dayValue) // i.e., DAY_OF_MONTH
        }
        if let hourValue = hour {
            cal.set(PlatformCalendar.HOUR, hourValue)
        }
        if let minuteValue = minute {
            cal.set(PlatformCalendar.MINUTE, minuteValue)
        }
        if let secondValue = second {
            cal.set(PlatformCalendar.SECOND, secondValue)
        }
        if let nanosecondValue = nanosecond {
            //cal.set(PlatformCalendar.NANOSECOND, nanosecondValue)
            fatalError("DateComponents.nanosecond unsupported in Skip")
        }
        if let weekdayValue = weekday {
            cal.set(PlatformCalendar.DAY_OF_WEEK, weekdayValue)
        }
        if let weekdayOrdinalValue = weekdayOrdinal {
            //cal.set(PlatformCalendar.WEEKDAYORDINAL, weekdayOrdinalValue)
            fatalError("DateComponents.weekdayOrdinal unsupported in Skip")
        }
        if let quarterValue = quarter {
            //cal.set(PlatformCalendar.QUARTER, quarterValue)
            fatalError("DateComponents.quarter unsupported in Skip")
        }
        if let weekOfMonthValue = weekOfMonth {
            cal.set(PlatformCalendar.WEEK_OF_MONTH, weekOfMonthValue)
        }
        if let weekOfYearValue = weekOfYear {
            cal.set(PlatformCalendar.WEEK_OF_YEAR, weekOfYearValue)
        }
        if let yearForWeekOfYearValue = yearForWeekOfYear {
            //cal.set(PlatformCalendar.YEARFORWEEKOFYEAR, yearForWeekOfYearValue)
            fatalError("DateComponents.yearForWeekOfYear unsupported in Skip")
        }

        return cal
    }
    #endif

    public var isValidDate: Bool {
        #if !SKIP
        return components.isValidDate
        #else
        if self.calendar == nil {
            return false
        }
        let cal = createCalendar()
        return cal.getActualMinimum(PlatformCalendar.DAY_OF_MONTH) <= cal.get(PlatformCalendar.DAY_OF_MONTH)
        && cal.getActualMaximum(PlatformCalendar.DAY_OF_MONTH) >= cal.get(PlatformCalendar.DAY_OF_MONTH)
        && cal.getActualMinimum(PlatformCalendar.MONTH) <= cal.get(PlatformCalendar.MONTH) + (cal.get(PlatformCalendar.MONTH) == 2 ? ((cal as? java.util.GregorianCalendar)?.isLeapYear(self.year ?? -1) == true ? 0 : 1) : 0)
        && cal.getActualMaximum(PlatformCalendar.MONTH) >= cal.get(PlatformCalendar.MONTH)
        && cal.getActualMinimum(PlatformCalendar.YEAR) <= cal.get(PlatformCalendar.YEAR)
        && cal.getActualMaximum(PlatformCalendar.YEAR) >= cal.get(PlatformCalendar.YEAR)
        #endif
    }
}
