// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
#if SKIP
// SKIP INSERT: import skip.lib.Set

/// `Calendar` aliases to `SkipCalendar` type and wraps `java.util.Calendar`
public typealias Calendar = SkipCalendar
//public typealias SkipCalendar = Calendar
/// The wrapped type for Kotlin's Calendar equivalent
public typealias PlatformCalendar = java.util.Calendar
public typealias SkipCalendarIdentifier = SkipCalendar.Identifier
public typealias SkipCalendarComponent = SkipCalendar.Component
#else
/// `SkipFoundation.Calendar` is an alias to `Foundation.Calendar`
public typealias Calendar = Foundation.Calendar
/// The wrapped type for Swift Calendar is only included in Swift debug builds
internal typealias PlatformCalendar = Foundation.Calendar
internal typealias SkipCalendarIdentifier = PlatformCalendar.Identifier
internal typealias SkipCalendarComponent = PlatformCalendar.Component
#endif

// seems to be needed to expose java.util.Calendar.clone()
// SKIP INSERT: fun PlatformCalendar.clone(): PlatformCalendar { return this.clone() as PlatformCalendar }

// override the Kotlin type to be public while keeping the Swift version internal:
// SKIP DECLARE: public class SkipCalendar: RawRepresentable<PlatformCalendar>, MutableStruct
internal struct SkipCalendar : RawRepresentable, Hashable, CustomStringConvertible {
    public var rawValue: PlatformCalendar
    #if SKIP
    public var locale: SkipLocale
    #endif

    public static var current: SkipCalendar {
        #if !SKIP
        return SkipCalendar(rawValue: PlatformCalendar.current)
        #else
        return SkipCalendar(rawValue: PlatformCalendar.getInstance())
        #endif
    }

    public init(rawValue: PlatformCalendar) {
        self.rawValue = rawValue
        #if SKIP
        self.locale = SkipLocale.current
        #endif
    }

    public init(_ rawValue: PlatformCalendar) {
        self.rawValue = rawValue
        #if SKIP
        self.locale = SkipLocale.current
        #endif
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
        self.locale = SkipLocale.current
        #endif
    }

    public var identifier: SkipCalendarIdentifier {
        #if !SKIP
        return rawValue.identifier
        #else
        // TODO: non-gregorian calendar
        if gregorianCalendar != nil {
            return SkipCalendarIdentifier.gregorian
        } else {
            return SkipCalendarIdentifier.iso8601
        }
        #endif
    }

    #if SKIP
    internal func toDate() -> SkipDate {
        SkipDate(rawValue: rawValue.getTime())
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


    public func date(from components: SkipDateComponents) -> SkipDate? {
        #if !SKIP
        return rawValue.date(from: components.components).flatMap(SkipDate.init(rawValue:))
        #else
        // TODO: need to set `this` calendar in the components.calendar
        return SkipDate(rawValue: components.createCalendarComponents().getTime())
        #endif
    }

    public func dateComponents(in zone: SkipTimeZone? = nil, from date: SkipDate) -> SkipDateComponents {
        #if !SKIP
        return SkipDateComponents(components: rawValue.dateComponents(in: (zone ?? self.timeZone).rawValue, from: date.rawValue))
        #else
        return SkipDateComponents(fromCalendar: self, in: zone ?? self.timeZone, from: date)
        #endif
    }

    public func dateComponents(_ components: Set<SkipCalendarComponent>, from start: SkipDate, to end: SkipDate) -> SkipDateComponents {
        #if !SKIP
        return SkipDateComponents(components: rawValue.dateComponents(components, from: start.rawValue, to: end.rawValue))
        #else
        return SkipDateComponents(fromCalendar: self, in: nil, from: start, to: end)
        #endif
    }

    public func dateComponents(_ components: Set<SkipCalendarComponent>, from date: SkipDate) -> SkipDateComponents {
        #if !SKIP
        return SkipDateComponents(components: rawValue.dateComponents(components, from: date.rawValue))
        #else
        return SkipDateComponents(fromCalendar: self, in: nil, from: date, with: components)
        #endif
    }

    public func date(byAdding components: SkipDateComponents, to date: SkipDate, wrappingComponents: Bool = false) -> SkipDate? {
        #if !SKIP
        return rawValue.date(byAdding: components.rawValue, to: date.rawValue, wrappingComponents: wrappingComponents).flatMap(SkipDate.init(rawValue:))
        #else
        var comps = SkipDateComponents(fromCalendar: self, in: self.timeZone, from: date)
        comps.add(components)
        return date(from: comps)
        #endif
    }

    public func date(byAdding component: SkipCalendarComponent, value: Int, to date: SkipDate, wrappingComponents: Bool = false) -> SkipDate? {
        #if !SKIP
        return rawValue.date(byAdding: component, value: value, to: date.rawValue, wrappingComponents: wrappingComponents).flatMap(SkipDate.init(rawValue:))
        #else
        fatalError("TODO: SkipCalendar.date(byAdding:SkipCalendarComponent)")
        #endif
    }

    public func isDateInWeekend(_ date: SkipDate) -> Bool {
        #if !SKIP
        return rawValue.isDateInWeekend(date.rawValue)
        #else
        let components = dateComponents(from: date)
        return components.weekday == PlatformCalendar.SATURDAY || components.weekday == PlatformCalendar.SUNDAY
        #endif
    }

    public func isDate(_ date1: SkipDate, inSameDayAs date2: SkipDate) -> Bool {
        #if !SKIP
        return rawValue.isDate(date1.rawValue, inSameDayAs: date2.rawValue)
        #else
        fatalError("TODO: SkipCalendar.isDate(:inSameDayAs:)")
        #endif
    }

    public func isDateInToday(_ date: SkipDate) -> Bool {
        #if !SKIP
        return rawValue.isDateInToday(date.rawValue)
        #else
        return isDate(date, inSameDayAs: SkipDate())
        #endif
    }

    public func isDateInTomorrow(_ date: SkipDate) -> Bool {
        #if !SKIP
        return rawValue.isDateInTomorrow(date.rawValue)
        #else
        if let tomorrow = date(byAdding: DateComponents(day: -1), to: SkipDate()) {
            return isDate(date, inSameDayAs: tomorrow)
        } else {
            return false
        }
        #endif
    }

    public func isDateInYesterday(_ date: SkipDate) -> Bool {
        #if !SKIP
        return rawValue.isDateInYesterday(date.rawValue)
        #else
        if let yesterday = date(byAdding: DateComponents(day: -1), to: SkipDate()) {
            return isDate(date, inSameDayAs: yesterday)
        } else {
            return false
        }
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
