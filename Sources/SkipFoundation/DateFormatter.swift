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

    public static func dateFormat(fromTemplate: String, options: Int, locale: SkipLocale?) -> String? {
        #if !SKIP
        return PlatformDateFormatter.dateFormat(fromTemplate: fromTemplate, options: options, locale: locale?.rawValue)
        #else
        let fmt = SkipDateFormatter()
        fmt.locale = locale
        fmt.setLocalizedDateFormatFromTemplate(fromTemplate)
        return fmt.rawValue.toLocalizedPattern()
        #endif
    }

    public var timeZone: SkipTimeZone? {
        get {
            #if !SKIP
            return rawValue.timeZone.flatMap(SkipTimeZone.init(rawValue:))
            #else
            if let rawTimeZone = rawValue.timeZone {
                return SkipTimeZone(rawValue: rawTimeZone)
            } else {
                return SkipTimeZone.current
            }

            fatalError("unreachable") // “A 'return' expression required in a function with a block body ('{...}'). If you got this error after the compiler update, then it's most likely due to a fix of a bug introduced in 1.3.0 (see KT-28061 for details)”
            #endif
        }

        set {
            #if !SKIP
            rawValue.timeZone = newValue?.rawValue ?? TimeZone.current
            #else
            rawValue.timeZone = newValue?.rawValue ?? TimeZone.current.rawValue
            #endif
        }
    }

    #if SKIP
    /// SimpleDateFormat holds a locale, but it is not readable
    private var _locale: SkipLocale? = nil
    #endif

    public var locale: SkipLocale? {
        get {
            #if !SKIP
            return rawValue.locale.flatMap(SkipLocale.init(rawValue:))
            #else
            return self._locale ?? SkipLocale.current
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

    public var calendar: SkipCalendar? {
        get {
            #if !SKIP
            return rawValue.calendar.flatMap(SkipCalendar.init(rawValue:))
            #else
            return SkipCalendar(rawValue: rawValue.calendar)
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

    public func date(from string: String) -> SkipDate? {
        #if !SKIP
        return rawValue.date(from: string).flatMap(SkipDate.init(rawValue:))
        #else
        if let date = try? rawValue.parse(string) { // DateFormat throws java.text.ParseException: Unparseable date: "2018-03-09"
            return SkipDate(rawValue: date)
        } else {
            return nil
        }
        #endif
    }

    public func string(from date: SkipDate) -> String {
        #if !SKIP
        return rawValue.string(from: date.rawValue)
        #else
        return rawValue.format(date.rawValue)
        #endif
    }

}
