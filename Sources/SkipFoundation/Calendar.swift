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
public typealias SkipCalendarIdentifier = SkipCalendar.Identifier
// SKIP INSERT: typealias Calendar.Identifier = SkipCalendarIdentifier
#else
/// `SkipFoundation.Calendar` is an alias to `Foundation.Calendar`
public typealias Calendar = Foundation.Calendar
/// The wrapped type for Swift Calendar is only included in Swift debug builds
internal typealias PlatformCalendar = Foundation.Calendar
internal typealias SkipCalendarIdentifier = PlatformCalendar.Identifier
#endif

// override the Kotlin type to be public while keeping the Swift version internal:
// SKIP DECLARE: public class SkipCalendar: RawRepresentable<PlatformCalendar>, MutableStruct
internal struct SkipCalendar : RawRepresentable, Hashable, CustomStringConvertible {
    public var rawValue: PlatformCalendar

    public static var current: SkipCalendar {
        #if !SKIP
        return SkipCalendar(rawValue: PlatformCalendar.current)
        #else
        return SkipCalendar(rawValue: PlatformCalendar.getInstance())
        #endif
    }

    public init(rawValue: PlatformCalendar) {
        self.rawValue = rawValue
    }

    public init(_ rawValue: PlatformCalendar) {
        self.rawValue = rawValue
    }

    public init(identifier: SkipCalendarIdentifier) {
        #if !SKIP
        self.rawValue = PlatformCalendar(identifier: identifier)
        #else
        switch identifier {
        case .gregorian:
            self.rawValue = java.util.GregorianCalendar()
        default:
            // TODO: how to support the other calendars?
            fatalError("Skip: unsupported calendar identifier \(identifier)")
        }
        #endif
    }

    public func date(from components: SkipDateComponents) -> SkipDate? {
        #if !SKIP
        return rawValue.date(from: components.components).flatMap(SkipDate.init(rawValue:))
        #else
        fatalError("TODO: date(from:SkipDateComponents)")
        #endif
    }

    public func dateComponents(in zone: SkipTimeZone, from date: SkipDate) -> SkipDateComponents {
        #if !SKIP
        return SkipDateComponents(components: rawValue.dateComponents(in: zone.rawValue, from: date.rawValue))
        #else
        fatalError("TODO: SkipCalendar.dateComponents")
        #endif
    }

    public var timeZone: SkipTimeZone {
        get {
            #if !SKIP
            return SkipTimeZone(rawValue.timeZone)
            #else
            return SkipTimeZone(rawValue.getTimeZone())
            #endif
        }

        set {
            #if !SKIP
            rawValue.timeZone = newValue.rawValue
            #else
            rawValue.setTimeZone(newValue.rawValue)
            #endif
        }
    }

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
