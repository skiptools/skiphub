// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
#if !SKIP
import class Foundation.DateFormatter
public typealias DateFormatter = Foundation.DateFormatter
internal typealias PlatformDateFormatter = Foundation.DateFormatter
#else
public typealias DateFormatter = SkipDateFormatter
public typealias PlatformDateFormatter = java.text.SimpleDateFormat
#endif


// SKIP DECLARE: open class SkipDateFormatter: RawRepresentable<PlatformDateFormatter>
internal class SkipDateFormatter : RawRepresentable, Hashable, CustomStringConvertible {
    public let rawValue: PlatformDateFormatter

    public required init(rawValue: PlatformDateFormatter) {
        self.rawValue = rawValue
    }

    public init(_ rawValue: PlatformDateFormatter) {
        self.rawValue = rawValue
    }

    public init() {
        self.rawValue = PlatformDateFormatter()
    }

    public var description: String {
        return rawValue.description
    }

    public var isLenient: Bool {
        get {
            #if !SKIP
            return rawValue.isLenient
            #else
            return rawValue.isLenient
            #endif
        }

        set {
            #if !SKIP
            rawValue.isLenient = newValue
            #else
            rawValue.isLenient = newValue
            #endif
        }
    }

    public var dateFormat: String {
        get {
            #if !SKIP
            return rawValue.dateFormat
            #else
            return rawValue.toPattern()
            #endif
        }

        set {
            #if !SKIP
            rawValue.dateFormat = newValue
            #else
            rawValue.applyPattern(newValue)
            #endif
        }
    }

    public var timeZone: SkipTimeZone! {
        get {
            #if !SKIP
            return rawValue.timeZone.flatMap(SkipTimeZone.init(rawValue:))
            #else
            return SkipTimeZone(rawValue: rawValue.timeZone)
            #endif
        }

        set {
            #if !SKIP
            rawValue.timeZone = newValue.rawValue
            #else
            rawValue.timeZone = newValue.rawValue
            #endif
        }
    }

    public var calendar: SkipCalendar! {
        get {
            #if !SKIP
            return rawValue.calendar.flatMap(SkipCalendar.init(rawValue:))
            #else
            return SkipCalendar(rawValue: rawValue.calendar)
            #endif
        }

        set {
            #if !SKIP
            rawValue.calendar = newValue.rawValue
            #else
            rawValue.calendar = newValue.rawValue
            #endif
        }
    }

    public func date(from string: String) -> SkipDate? {
        #if !SKIP
        return rawValue.date(from: string).flatMap(SkipDate.init(rawValue:))
        #else
        if let date = rawValue.parse(string) {
            return SkipDate(rawValue: date)
        } else {
            return nil
        }
        #endif
    }
}
