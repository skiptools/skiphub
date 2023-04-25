// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
#if SKIP
/// `Calendar` aliases to `SkipCalendar` type and wraps `java.util.Calendar`
public typealias Calendar = SkipCalendar
/// The wrapped type for Kotlin's Calendar equivalent
public typealias PlatformCalendar = java.util.Calendar
#else
/// `SkipFoundation.Calendar` is an alias to `Foundation.Calendar`
public typealias Calendar = Foundation.Calendar
/// The wrapped type for Swift Calendar is only included in Swift debug builds
internal typealias PlatformCalendar = Foundation.Calendar
#endif

// override the Kotlin type to be public while keeping the Swift version internal:
// SKIP DECLARE: public class SkipCalendar: RawRepresentable<PlatformCalendar>
internal struct SkipCalendar : RawRepresentable, Hashable, CustomStringConvertible {
    public let rawValue: PlatformCalendar

    public init(rawValue: PlatformCalendar) {
        self.rawValue = rawValue
    }

    public init(_ rawValue: PlatformCalendar) {
        self.rawValue = rawValue
    }

    // SKIP DECLARE: val description: String
    var description: String {
        return rawValue.description
    }

    /// Calendar supports many different kinds of calendars. Each is identified by an identifier here.
    public enum Identifier : Sendable {
        /// The common calendar in Europe, the Western Hemisphere, and elsewhere.
        case gregorian
        case buddhist
        case chinese
        case coptic
        case ethiopicAmeteMihret
        case ethiopicAmeteAlem
        case hebrew
        case iso8601
        case indian
        case islamic
        case islamicCivil
        case japanese
        case persian
        case republicOfChina
        case islamicTabular
        case islamicUmmAlQura
    }

    /// An enumeration for the various components of a calendar date.
    public enum Component : Sendable {
        case era
        case year
        case month
        case day
        case hour
        case minute
        case second
        case weekday
        case weekdayOrdinal
        case quarter
        case weekOfMonth
        case weekOfYear
        case yearForWeekOfYear
        case nanosecond
        case calendar
        case timeZone
    }
}
