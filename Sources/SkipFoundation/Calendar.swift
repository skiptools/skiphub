// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
#if !SKIP
/* @_implementationOnly */import struct Foundation.Calendar
public typealias PlatformCalendar = Foundation.Calendar
public typealias PlatformCalendarComponent = Foundation.Calendar.Component
public typealias PlatformCalendarIdentifier = Foundation.Calendar.Identifier
#else
// SKIP INSERT: import skip.lib.Set
public typealias PlatformCalendar = java.util.Calendar
public typealias PlatformCalendarComponent = Calendar.Component
public typealias PlatformCalendarIdentifier = Calendar.Identifier
#endif

// seems to be needed to expose java.util.Calendar.clone()
// SKIP INSERT: fun PlatformCalendar.clone(): PlatformCalendar { return this.clone() as PlatformCalendar }

/// A definition of the relationships between calendar units and absolute points in time, providing features for calculation and comparison of dates.
public struct Calendar : RawRepresentable, Hashable, CustomStringConvertible {
    public var rawValue: PlatformCalendar
    #if SKIP
    public var locale: Locale
    #endif

    public static var current: Calendar {
        #if !SKIP
        return Calendar(rawValue: PlatformCalendar.current)
        #else
        return Calendar(rawValue: PlatformCalendar.getInstance())
        #endif
    }

    public init(rawValue: PlatformCalendar) {
        self.rawValue = rawValue
        #if SKIP
        self.locale = Locale.current
        #endif
    }

    public init(_ rawValue: PlatformCalendar) {
        self.rawValue = rawValue
        #if SKIP
        self.locale = Locale.current
        #endif
    }

    public init(identifier: PlatformCalendarIdentifier) {
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
        self.locale = Locale.current
        #endif
    }

    public var identifier: PlatformCalendarIdentifier {
        #if !SKIP
        return rawValue.identifier
        #else
        // TODO: non-gregorian calendar
        if gregorianCalendar != nil {
            return Calendar.Identifier.gregorian
        } else {
            return Calendar.Identifier.iso8601
        }
        #endif
    }

    #if SKIP
    internal func toDate() -> Date {
        Date(rawValue: rawValue.getTime())
    }

    private var dateFormatSymbols: java.text.DateFormatSymbols {
        java.text.DateFormatSymbols.getInstance(locale.rawValue)
    }

    private var gregorianCalendar: java.util.GregorianCalendar? {
        return rawValue as? java.util.GregorianCalendar
    }
    #endif

    public var amSymbol: String {
        #if !SKIP
        return rawValue.amSymbol
        #else
        return dateFormatSymbols.getAmPmStrings()[0]
        #endif
    }

    public var pmSymbol: String {
        #if !SKIP
        return rawValue.pmSymbol
        #else
        return dateFormatSymbols.getAmPmStrings()[1]
        #endif
    }

    public var eraSymbols: [String] {
        #if !SKIP
        return rawValue.eraSymbols
        #else
        return Array(dateFormatSymbols.getEras().toList())
        #endif
    }

    public var monthSymbols: [String] {
        #if !SKIP
        return rawValue.monthSymbols
        #else
        // The java.text.DateFormatSymbols.getInstance().getMonths() method in Java returns an array of 13 symbols because it includes both the 12 months of the year and an additional symbol
        // some documentation says the blank symbol is at index 0, but other tests show it at the end, so just pare it out
        return Array(dateFormatSymbols.getMonths().toList()).filter({ $0?.isEmpty == false })
        #endif
    }

    public var shortMonthSymbols: [String] {
        #if !SKIP
        return rawValue.shortMonthSymbols
        #else
        return Array(dateFormatSymbols.getShortMonths().toList()).filter({ $0?.isEmpty == false })
        #endif
    }

    public var weekdaySymbols: [String] {
        #if !SKIP
        return rawValue.weekdaySymbols
        #else
        return Array(dateFormatSymbols.getWeekdays().toList()).filter({ $0?.isEmpty == false })
        #endif
    }

    public var shortWeekdaySymbols: [String] {
        #if !SKIP
        return rawValue.shortWeekdaySymbols
        #else
        return Array(dateFormatSymbols.getShortWeekdays().toList()).filter({ $0?.isEmpty == false })
        #endif
    }


    public func date(from components: DateComponents) -> Date? {
        #if !SKIP
        return rawValue.date(from: components.components).flatMap(Date.init(rawValue:))
        #else
        // TODO: need to set `this` calendar in the components.calendar
        return Date(rawValue: components.createCalendarComponents().getTime())
        #endif
    }

    public func dateComponents(in zone: TimeZone? = nil, from date: Date) -> DateComponents {
        #if !SKIP
        return DateComponents(components: rawValue.dateComponents(in: (zone ?? self.timeZone).rawValue, from: date.rawValue))
        #else
        return DateComponents(fromCalendar: self, in: zone ?? self.timeZone, from: date)
        #endif
    }

    public func dateComponents(_ components: Set<PlatformCalendarComponent>, from start: Date, to end: Date) -> DateComponents {
        #if !SKIP
        return DateComponents(components: rawValue.dateComponents(components, from: start.rawValue, to: end.rawValue))
        #else
        return DateComponents(fromCalendar: self, in: nil, from: start, to: end)
        #endif
    }

    public func dateComponents(_ components: Set<PlatformCalendarComponent>, from date: Date) -> DateComponents {
        #if !SKIP
        return DateComponents(components: rawValue.dateComponents(components, from: date.rawValue))
        #else
        return DateComponents(fromCalendar: self, in: nil, from: date, with: components)
        #endif
    }

    public func date(byAdding components: DateComponents, to date: Date, wrappingComponents: Bool = false) -> Date? {
        #if !SKIP
        return rawValue.date(byAdding: components.rawValue, to: date.rawValue, wrappingComponents: wrappingComponents).flatMap(Date.init(rawValue:))
        #else
        var comps = DateComponents(fromCalendar: self, in: self.timeZone, from: date)
        comps.add(components)
        return date(from: comps)
        #endif
    }

    public func date(byAdding component: PlatformCalendarComponent, value: Int, to date: Date, wrappingComponents: Bool = false) -> Date? {
        #if !SKIP
        return rawValue.date(byAdding: component, value: value, to: date.rawValue, wrappingComponents: wrappingComponents).flatMap(Date.init(rawValue:))
        #else
        fatalError("TODO: Skip Calendar.date(byAdding:Calendar.Component)")
        #endif
    }

    public func isDateInWeekend(_ date: Date) -> Bool {
        #if !SKIP
        return rawValue.isDateInWeekend(date.rawValue)
        #else
        let components = dateComponents(from: date)
        return components.weekday == PlatformCalendar.SATURDAY || components.weekday == PlatformCalendar.SUNDAY
        #endif
    }

    public func isDate(_ date1: Date, inSameDayAs date2: Date) -> Bool {
        #if !SKIP
        return rawValue.isDate(date1.rawValue, inSameDayAs: date2.rawValue)
        #else
        fatalError("TODO: Skip Calendar.isDate(:inSameDayAs:)")
        #endif
    }

    public func isDateInToday(_ date: Date) -> Bool {
        #if !SKIP
        return rawValue.isDateInToday(date.rawValue)
        #else
        return isDate(date, inSameDayAs: Date())
        #endif
    }

    public func isDateInTomorrow(_ date: Date) -> Bool {
        #if !SKIP
        return rawValue.isDateInTomorrow(date.rawValue)
        #else
        if let tomorrow = date(byAdding: DateComponents(day: -1), to: Date()) {
            return isDate(date, inSameDayAs: tomorrow)
        } else {
            return false
        }
        #endif
    }

    public func isDateInYesterday(_ date: Date) -> Bool {
        #if !SKIP
        return rawValue.isDateInYesterday(date.rawValue)
        #else
        if let yesterday = date(byAdding: DateComponents(day: -1), to: Date()) {
            return isDate(date, inSameDayAs: yesterday)
        } else {
            return false
        }
        #endif
    }

    public var timeZone: TimeZone {
        get {
            #if !SKIP
            return TimeZone(rawValue.timeZone)
            #else
            return TimeZone(rawValue.getTimeZone())
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

    public var description: String {
        return rawValue.description
    }

    public enum Component: Sendable {
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
}

#if SKIP // shims for testing
internal class NSCalendar : NSObject {
    struct Options {
    }

    enum Unit {
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

    enum Identifier {
        case gregorian
        case buddhist
        case chinese
        case coptic
        case ethiopicAmeteMihret
        case ethiopicAmeteAlem
        case hebrew
        case ISO8601
        case indian
        case islamic
        case islamicCivil
        case japanese
        case persian
        case republicOfChina
        case islamicTabular
        case islamicUmmAlQura
    }
}

#endif
