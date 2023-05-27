// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
#if !SKIP
import struct Foundation.TimeZone
public typealias TimeZone = Foundation.TimeZone
internal typealias PlatformTimeZone = Foundation.TimeZone
#else
public typealias TimeZone = SkipTimeZone
public typealias PlatformTimeZone = java.util.TimeZone
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

//    public init?(identifier: String) {
//        #if !SKIP
//        guard let tz = PlatformTimeZone(identifier: identifier) else {
//            return nil
//        }
//        self.rawValue = tz
//        #else
//        fatalError("TODO: timeZome")
//        #endif
//    }


    public init?(secondsFromGMT seconds: Int) {
        #if !SKIP
        guard let tz = PlatformTimeZone(secondsFromGMT: seconds) else {
            return nil
        }
        self.rawValue = tz
        #else
        // java.time.ZoneId is more modern, but doesn't seem to be able to vend a java.util.TimeZone
        // guard let tz = PlatformTimeZone.getTimeZone(java.time.ZoneId.ofOffset(seconds))

        let timeZoneId = seconds >= 0
            ? String.format("GMT+%02d:%02d", seconds / 3600, (seconds % 3600) / 60)
            : String.format("GMT-%02d:%02d", -seconds / 3600, (-seconds % 3600) / 60)

        guard let tz = PlatformTimeZone.getTimeZone(timeZoneId) else {
            return nil
        }

        self.rawValue = tz
        #endif
    }


//    public init?(abbreviation: String) {
//        #if !SKIP
//        guard let tz = PlatformTimeZone(abbreviation: abbreviation) else {
//            return nil
//        }
//        self.rawValue = tz
//        #else
//        fatalError("TODO: timeZome")
//        #endif
//    }


    public var identifier: String {
        #if !SKIP
        return rawValue.identifier
        #else
        return rawValue.getID()
        #endif
    }

    public func secondsFromGMT(for date: SkipDate = SkipDate()) -> Int {
        #if !SKIP
        return rawValue.secondsFromGMT(for: date.rawValue)
        #else
        return rawValue.getOffset(date.currentTimeMillis)
        #endif
    }

    var description: String {
        return rawValue.description
    }

//    public static var autoupdatingCurrent: TimeZone { get }
//    public func abbreviation(for date: Date = Date()) -> String?
//    public func isDaylightSavingTime(for date: Date = Date()) -> Bool
//    public func daylightSavingTimeOffset(for date: Date = Date()) -> TimeInterval
//    public func nextDaylightSavingTimeTransition(after date: Date) -> Date?
//    public static var knownTimeZoneIdentifiers: [String] { get }
//    public static var abbreviationDictionary: [String : String]
//    public static var timeZoneDataVersion: String { get }
//    public var nextDaylightSavingTimeTransition: Date? { get }
//    public func localizedName(for style: NSTimeZone.NameStyle, locale: Locale?) -> String?
//
//    public static var gmt: TimeZone { get }
//    public var hashValue: Int { get }
//    public var customMirror: Mirror { get }
//    public var description: String { get }
//    public var debugDescription: String { get }
}
