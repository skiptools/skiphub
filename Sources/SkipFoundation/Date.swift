// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
#if !SKIP
import struct Foundation.Date
public typealias Date = Foundation.Date
public typealias PlatformDate = Foundation.Date
@available(macOS 13, iOS 16, tvOS 16, watchOS 9, *)
internal typealias SkipISO8601FormatStyle = Foundation.Date.ISO8601FormatStyle
#else
public typealias Date = SkipDate
public typealias PlatformDate = java.util.Date
public typealias SkipISO8601FormatStyle = SkipDate.ISO8601FormatStyle
#endif

#if !SKIP
public let CFAbsoluteTimeGetCurrent = Foundation.CFAbsoluteTimeGetCurrent
#else

public typealias TimeInterval = Double
public typealias CFTimeInterval = TimeInterval

/// absolute time is the time interval since the reference date the reference date (epoch) is 00:00:00 1 January 2001.
public typealias CFAbsoluteTime = CFTimeInterval


/// Absolute time is measured in seconds relative to the absolute reference date of Jan 1 2001 00:00:00 GMT. A positive value represents a date after the reference date, a negative value represents a date before it. For example, the absolute time -32940326 is equivalent to December 16th, 1999 at 17:54:34. Repeated calls to this function do not guarantee monotonically increasing results. The system time may decrease due to synchronization with external time references or due to an explicit user change of the clock.
public func CFAbsoluteTimeGetCurrent() -> CFAbsoluteTime {
    SkipDate.timeIntervalSinceReferenceDate
}

#endif

// override the Kotlin type to be public while keeping the Swift version internal:
// SKIP DECLARE: class SkipDate: RawRepresentable<PlatformDate>, MutableStruct, Comparable<SkipDate>
internal struct SkipDate : RawRepresentable, Hashable, CustomStringConvertible, Comparable {
    public var rawValue: PlatformDate

    public static let timeIntervalBetween1970AndReferenceDate: TimeInterval = 978307200.0

    /// The interval between 00:00:00 UTC on 1 January 2001 and the current date and time.
    public static var timeIntervalSinceReferenceDate: TimeInterval {
        #if !SKIP
        return PlatformDate.timeIntervalSinceReferenceDate
        #else
        (System.currentTimeMillis().toDouble() / 1000.0) - timeIntervalBetween1970AndReferenceDate
        #endif
    }

    public static let distantPast = SkipDate(timeIntervalSince1970: -62135769600.0)
    public static let distantFuture = SkipDate(timeIntervalSince1970: 64092211200.0)

    public init() {
        self.rawValue = PlatformDate()
    }

    public init(rawValue: PlatformDate) {
        self.rawValue = rawValue
    }

    public init(_ rawValue: PlatformDate = PlatformDate()) {
        self.rawValue = rawValue
    }

    public init(timeIntervalSince1970: TimeInterval) {
        #if !SKIP
        self.rawValue = PlatformDate(timeIntervalSince1970: timeIntervalSince1970)
        #else
        self.rawValue = PlatformDate((timeIntervalSince1970 * 1000.0).toLong())
        #endif
    }

    public init(timeIntervalSinceReferenceDate: TimeInterval) {
        #if !SKIP
        self.rawValue = PlatformDate(timeIntervalSinceReferenceDate: timeIntervalSinceReferenceDate)
        #else
        self.rawValue = PlatformDate(((timeIntervalSinceReferenceDate + SkipDate.timeIntervalBetween1970AndReferenceDate) * 1000.0).toLong())
        #endif
    }

    public init(timeInterval: TimeInterval, since: SkipDate) {
        #if !SKIP
        self.rawValue = PlatformDate(timeInterval: timeInterval, since: since.rawValue)
        #else
        self.init(timeIntervalSince1970: timeInterval + since.timeIntervalSince1970)
        #endif
    }

    /// Useful for converting to Java's `long` time representation
    public var currentTimeMillis: Int64 {
        #if !SKIP
        return Int64(rawValue.timeIntervalSince1970 * 1000.0)
        #else
        return rawValue.getTime()
        #endif
    }

    var description: String {
        return rawValue.description
    }

    func description(with locale: SkipLocale?) -> String {
        #if !SKIP
        return rawValue.description(with: locale?.rawValue)
        #else
        let fmt = java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss Z", (locale ?? SkipLocale.current).rawValue)
        fmt.setTimeZone(SkipTimeZone.gmt.rawValue);
        return fmt.format(rawValue)
        #endif
    }

    public var timeIntervalSince1970: TimeInterval {
        #if !SKIP
        return rawValue.timeIntervalSince1970
        #else
        return currentTimeMillis.toDouble() / 1000.0
        #endif
    }

    public var timeIntervalSinceReferenceDate: TimeInterval {
        #if !SKIP
        return rawValue.timeIntervalSinceReferenceDate
        #else
        return timeIntervalSince1970 - SkipDate.timeIntervalBetween1970AndReferenceDate
        #endif
    }

    public static func < (lhs: SkipDate, rhs: SkipDate) -> Bool {
        #if !SKIP
        lhs.rawValue.timeIntervalSince1970 < rhs.rawValue.timeIntervalSince1970
        #else
        lhs.timeIntervalSince1970 < rhs.timeIntervalSince1970
        #endif
    }

    public func timeIntervalSince(_ date: SkipDate) -> TimeInterval {
        #if !SKIP
        return rawValue.timeIntervalSince(date.rawValue)
        #else
        return self.timeIntervalSinceReferenceDate - date.timeIntervalSinceReferenceDate
        #endif
    }

    public func addingTimeInterval(_ timeInterval: TimeInterval) -> SkipDate {
        #if !SKIP
        return SkipDate(rawValue.addingTimeInterval(timeInterval))
        #else
        return SkipDate(timeInterval: timeInterval, since: self)
        #endif
    }

    public mutating func addTimeInterval(_ timeInterval: TimeInterval) {
        #if !SKIP
        rawValue.addTimeInterval(timeInterval)
        #else
        self = addingTimeInterval(timeInterval)
        #endif
    }

    @available(macOS 13, iOS 16, tvOS 16, watchOS 9, *)
    public func ISO8601Format(_ style: SkipISO8601FormatStyle = .iso8601) -> String {
        #if !SKIP
        return rawValue.ISO8601Format(style)
        #else
        // local time zone specific
        // return java.text.SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ssXXX", java.util.Locale.getDefault()).format(rawValue)
        var dateFormat = java.text.SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'", java.util.Locale.getDefault())
        dateFormat.timeZone = java.util.TimeZone.getTimeZone("GMT")
        return dateFormat.format(rawValue)
        #endif

    }

    public struct ISO8601FormatStyle : Sendable {
        public static let iso8601 = ISO8601FormatStyle()

        public enum TimeZoneSeparator : String, Sendable {
            case colon
            case omitted
        }

        public enum DateSeparator : String, Sendable {
            case dash
            case omitted
        }

        public enum TimeSeparator : String, Sendable {
            case colon
            case omitted
        }

        public enum DateTimeSeparator : String, Sendable {
            case space
            case standard
        }

        public var timeSeparator: TimeSeparator
        public var includingFractionalSeconds: Bool
        public var timeZoneSeparator: TimeZoneSeparator
        public var dateSeparator: DateSeparator
        public var dateTimeSeparator: DateTimeSeparator
        public var timeZone: TimeZone

        public init(dateSeparator: DateSeparator = .dash, dateTimeSeparator: DateTimeSeparator = .standard, timeSeparator: TimeSeparator = .colon, timeZoneSeparator: TimeZoneSeparator = .omitted, includingFractionalSeconds: Bool = false, timeZone: TimeZone = TimeZone(secondsFromGMT: 0)!) {
            self.dateSeparator = dateSeparator
            self.dateTimeSeparator = dateTimeSeparator
            self.timeSeparator = timeSeparator
            self.timeZoneSeparator = timeZoneSeparator
            self.includingFractionalSeconds = includingFractionalSeconds
            self.timeZone = timeZone
        }
    }
}
