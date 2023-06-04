// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
#if !SKIP
import struct Foundation.TimeZone
public typealias TimeZone = Foundation.TimeZone
internal typealias PlatformTimeZone = Foundation.TimeZone
public typealias SkipTimeZoneNameStyle = NSTimeZone.NameStyle
#else
public typealias TimeZone = SkipTimeZone
public typealias NSTimeZone = TimeZone
public typealias PlatformTimeZone = java.util.TimeZone
public typealias SkipTimeZoneNameStyle = SkipTimeZone.NameStyle
#endif

// override the Kotlin type to be public while keeping the Swift version internal:
// SKIP DECLARE: class SkipTimeZone: RawRepresentable<PlatformTimeZone>, Hashable, MutableStruct
internal struct SkipTimeZone : RawRepresentable, Hashable, CustomStringConvertible {
    public var rawValue: PlatformTimeZone

    public static var current: SkipTimeZone {
        #if !SKIP
        return SkipTimeZone(rawValue: PlatformTimeZone.current)
        #else
        return SkipTimeZone(rawValue: PlatformTimeZone.getDefault())
        #endif
    }

    public static var `default`: SkipTimeZone {
        get {
            #if !SKIP
            return SkipTimeZone(rawValue: NSTimeZone.default)
            #else
            return SkipTimeZone(rawValue: PlatformTimeZone.getDefault())
            #endif
        }

        set {
            #if !SKIP
            NSTimeZone.default = newValue.rawValue
            #else
            PlatformTimeZone.setDefault(newValue.rawValue)
            #endif
        }
    }

    public static var system: SkipTimeZone {
        #if !SKIP
        return SkipTimeZone(rawValue: PlatformTimeZone.current)
        #else
        return SkipTimeZone(rawValue: PlatformTimeZone.getDefault())
        #endif
    }
    
    public static var local: SkipTimeZone {
        #if !SKIP
        return SkipTimeZone(rawValue: PlatformTimeZone.current)
        #else
        return SkipTimeZone(rawValue: PlatformTimeZone.getDefault())
        #endif
    }

    public static var autoupdatingCurrent: SkipTimeZone {
        #if !SKIP
        return SkipTimeZone(.autoupdatingCurrent)
        #else
        return SkipTimeZone(rawValue: PlatformTimeZone.getDefault())
        #endif
    }

    @available(macOS 13, iOS 16, tvOS 16, watchOS 9, *)
    public static var gmt: SkipTimeZone {
        #if !SKIP
        return SkipTimeZone(rawValue: PlatformTimeZone.gmt)
        #else
        return SkipTimeZone(rawValue: PlatformTimeZone.getTimeZone("GMT"))
        #endif
    }

    public init(rawValue: PlatformTimeZone) {
        self.rawValue = rawValue
    }

    public init(_ rawValue: PlatformTimeZone) {
        self.rawValue = rawValue
    }

    public init?(identifier: String) {
        #if !SKIP
        guard let tz = PlatformTimeZone(identifier: identifier) else {
            return nil
        }
        self.rawValue = tz
        #else
        guard let tz = PlatformTimeZone.getTimeZone(identifier) else {
            return nil
        }
        self.rawValue = tz
        #endif
    }

    public init?(abbreviation: String) {
        #if !SKIP
        guard let tz = PlatformTimeZone(abbreviation: abbreviation) else {
            return nil
        }
        self.rawValue = tz
        #else
        guard let identifier = Self.abbreviationDictionary[abbreviation] else {
        }
        guard let tz = PlatformTimeZone.getTimeZone(identifier) else {
            return nil
        }
        self.rawValue = tz
        #endif
    }

    public init?(secondsFromGMT seconds: Int) {
        #if !SKIP
        guard let tz = PlatformTimeZone(secondsFromGMT: seconds) else {
            return nil
        }
        self.rawValue = tz
        #else
        // java.time.ZoneId is more modern, but doesn't seem to be able to vend a java.util.TimeZone
        // guard let tz = PlatformTimeZone.getTimeZone(java.time.ZoneId.ofOffset(seconds))

        //let timeZoneId = seconds >= 0
        //    ? String.format("GMT+%02d:%02d", seconds / 3600, (seconds % 3600) / 60)
        //    : String.format("GMT-%02d:%02d", -seconds / 3600, (-seconds % 3600) / 60)
        //guard let tz = PlatformTimeZone.getTimeZone(timeZoneId) else {
        //    return nil
        //}

        self.rawValue = java.util.SimpleTimeZone(seconds, "GMT")
        #endif
    }

    public var identifier: String {
        #if !SKIP
        return rawValue.identifier
        #else
        return rawValue.getID()
        #endif
    }

    public func abbreviation(for date: SkipDate = SkipDate()) -> String? {
        #if !SKIP
        return rawValue.abbreviation(for: date.rawValue)
        #else
        return rawValue.getDisplayName(true, PlatformTimeZone.SHORT)
        #endif
    }

    public func secondsFromGMT(for date: SkipDate = SkipDate()) -> Int {
        #if !SKIP
        return rawValue.secondsFromGMT(for: date.rawValue)
        #else
        return rawValue.getOffset(date.currentTimeMillis) / 1000 // offset is in milliseconds
        #endif
    }

    var description: String {
        return rawValue.description
    }

    public func isDaylightSavingTime(for date: SkipDate = SkipDate()) -> Bool {
        #if !SKIP
        return rawValue.isDaylightSavingTime(for: date.rawValue)
        #else
        return rawValue.toZoneId().rules.isDaylightSavings(java.time.ZonedDateTime.ofInstant(date.rawValue.toInstant(), rawValue.toZoneId()).toInstant())
        #endif
    }

    public func daylightSavingTimeOffset(for date: SkipDate = SkipDate()) -> TimeInterval {
        #if !SKIP
        return rawValue.daylightSavingTimeOffset(for: date.rawValue)
        #else
        return isDaylightSavingTime(for: date) ? java.time.ZonedDateTime.ofInstant(date.rawValue.toInstant(), rawValue.toZoneId()).offset.getTotalSeconds().toDouble() : 0.0
        #endif
    }

    public var nextDaylightSavingTimeTransition: Date? {
        #if !SKIP
        return rawValue.nextDaylightSavingTimeTransition
        #else
        return nextDaylightSavingTimeTransition(after: SkipDate())
        #endif
    }

    public func nextDaylightSavingTimeTransition(after date: SkipDate) -> Date? {
        #if !SKIP
        return rawValue.nextDaylightSavingTimeTransition(after: date.rawValue)
        #else
        // testSkipModule(): java.lang.NullPointerException: Cannot invoke "java.time.zone.ZoneOffsetTransition.getInstant()" because the return value of "java.time.zone.ZoneRules.nextTransition(java.time.Instant)" is null
        let zonedDateTime = java.time.ZonedDateTime.ofInstant(date.rawValue.toInstant(), rawValue.toZoneId())
        guard let transition = rawValue.toZoneId().rules.nextTransition(zonedDateTime.toInstant()) else {
            return nil
        }
        return SkipDate(rawValue: java.util.Date.from(transition.getInstant()))
        #endif
    }

    public static var knownTimeZoneIdentifiers: [String] {
        #if !SKIP
        return TimeZone.knownTimeZoneIdentifiers
        #else
        return Array(java.time.ZoneId.getAvailableZoneIds())
        #endif
    }

    public static var knownTimeZoneNames: [String] {
        #if !SKIP
        return NSTimeZone.knownTimeZoneNames
        #else
        return Array(java.time.ZoneId.getAvailableZoneIds())
        #endif
    }

    #if !SKIP
    public static var abbreviationDictionary: [String : String] {
        get {
            return TimeZone.abbreviationDictionary
        }

        set {
            return TimeZone.abbreviationDictionary = newValue
        }
    }
    #else
    public static var abbreviationDictionary: [String : String] = [:]
    #endif

    public static var timeZoneDataVersion: String {
        #if !SKIP
        return TimeZone.timeZoneDataVersion
        #else
        fatalError("TODO: SkipTimeZone")
        #endif
    }

    public func localizedName(for style: SkipTimeZoneNameStyle, locale: SkipLocale?) -> String? {
        #if !SKIP
        return rawValue.localizedName(for: style, locale: locale?.rawValue)
        #else
        switch style {
        case .generic:
            return rawValue.toZoneId().getDisplayName(java.time.format.TextStyle.FULL, locale?.rawValue)
        case .standard:
            return rawValue.toZoneId().getDisplayName(java.time.format.TextStyle.FULL_STANDALONE, locale?.rawValue)
        case .shortStandard:
            return rawValue.toZoneId().getDisplayName(java.time.format.TextStyle.SHORT_STANDALONE, locale?.rawValue)
        case .daylightSaving:
            return rawValue.toZoneId().getDisplayName(java.time.format.TextStyle.FULL, locale?.rawValue)
        case .shortDaylightSaving:
            return rawValue.toZoneId().getDisplayName(java.time.format.TextStyle.SHORT, locale?.rawValue)
        case .shortGeneric:
            return rawValue.toZoneId().getDisplayName(java.time.format.TextStyle.SHORT, locale?.rawValue)
        }
        #endif
    }

    public enum NameStyle : Int {
        case standard = 0
        case shortStandard = 1
        case daylightSaving = 2
        case shortDaylightSaving = 3
        case generic = 4
        case shortGeneric = 5
    }
}
