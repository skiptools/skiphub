// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
#if !SKIP
/* @_implementationOnly */import class Foundation.DateFormatter
public typealias PlatformDateFormatter = Foundation.DateFormatter
#else
public typealias PlatformDateFormatter = java.text.SimpleDateFormat
#endif

/// A formatter that converts between dates and their textual representations.
public class DateFormatter : RawRepresentable, Hashable, CustomStringConvertible {
    public var rawValue: PlatformDateFormatter

    public required init(rawValue: PlatformDateFormatter) {
        self.rawValue = rawValue
    }

    public init(_ rawValue: PlatformDateFormatter) {
        self.rawValue = rawValue
    }

    public init() {
        self.rawValue = PlatformDateFormatter()
        self.isLenient = false // SimpleDateFormat is lenient by default
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

    public func setLocalizedDateFormatFromTemplate(dateFormatTemplate: String) {
        #if !SKIP
        rawValue.setLocalizedDateFormatFromTemplate(dateFormatTemplate)
        #else
        rawValue.applyLocalizedPattern(dateFormatTemplate)
        #endif
    }

    public static func dateFormat(fromTemplate: String, options: Int, locale: Locale?) -> String? {
        #if !SKIP
        return PlatformDateFormatter.dateFormat(fromTemplate: fromTemplate, options: options, locale: locale?.rawValue)
        #else
        let fmt = DateFormatter()
        fmt.locale = locale
        fmt.setLocalizedDateFormatFromTemplate(fromTemplate)
        return fmt.rawValue.toLocalizedPattern()
        #endif
    }

    public var timeZone: TimeZone? {
        get {
            #if !SKIP
            return rawValue.timeZone.flatMap(TimeZone.init(rawValue:))
            #else
            if let rawTimeZone = rawValue.timeZone {
                return TimeZone(rawValue: rawTimeZone)
            } else {
                return TimeZone.current
            }

            fatalError("unreachable") // “A 'return' expression required in a function with a block body ('{...}'). If you got this error after the compiler update, then it's most likely due to a fix of a bug introduced in 1.3.0 (see KT-28061 for details)”
            #endif
        }

        set {
            #if !SKIP
            rawValue.timeZone = newValue?.rawValue ?? TimeZone.system.rawValue
            #else
            rawValue.timeZone = newValue?.rawValue ?? TimeZone.current.rawValue
            #endif
        }
    }

    #if SKIP
    /// SimpleDateFormat holds a locale, but it is not readable
    private var _locale: Locale? = nil
    #endif

    public var locale: Locale? {
        get {
            #if !SKIP
            return rawValue.locale.flatMap(Locale.init(rawValue:))
            #else
            return self._locale ?? Locale.current
            #endif
        }

        set {
            #if !SKIP
            rawValue.locale = newValue?.rawValue
            #else
            // need to make a whole new SimpleDateFormat with the locale, since the instance does not provide access to the locale that was used to initialize it
            if let newValue = newValue {
                var formatter = PlatformDateFormatter(self.rawValue.toPattern(), newValue.rawValue)
                formatter.timeZone = self.timeZone?.rawValue
                self.rawValue = formatter
                self._locale = newValue
            }
            #endif
        }
    }

    public var calendar: Calendar? {
        get {
            #if !SKIP
            return rawValue.calendar.flatMap(Calendar.init(rawValue:))
            #else
            return Calendar(rawValue: rawValue.calendar)
            #endif
        }

        set {
            #if !SKIP
            rawValue.calendar = newValue?.rawValue
            #else
            rawValue.calendar = newValue?.rawValue
            #endif
        }
    }

    public func date(from string: String) -> Date? {
        #if !SKIP
        return rawValue.date(from: string).flatMap(Date.init(rawValue:))
        #else
        if let date = try? rawValue.parse(string) { // DateFormat throws java.text.ParseException: Unparseable date: "2018-03-09"
            return Date(rawValue: date)
        } else {
            return nil
        }
        #endif
    }

    public func string(from date: Date) -> String {
        #if !SKIP
        return rawValue.string(from: date.rawValue)
        #else
        return rawValue.format(date.rawValue)
        #endif
    }

}
