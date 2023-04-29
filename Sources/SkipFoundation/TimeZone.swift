// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
#if !SKIP
import struct Foundation.TimeZone
public typealias TimeZone = Foundation.TimeZone
public typealias PlatformTimeZone = Foundation.TimeZone
#else
public typealias TimeZone = SkipTimeZone
public typealias PlatformTimeZone = java.util.TimeZone
#endif


public struct SkipTimeZone : RawRepresentable, Hashable {
    public let rawValue: PlatformTimeZone

    public init(rawValue: PlatformTimeZone) {
        self.rawValue = rawValue
    }

    public init(_ rawValue: PlatformTimeZone) {
        self.rawValue = rawValue
    }

//    public static var current: TimeZone { get }
//    public static var autoupdatingCurrent: TimeZone { get }
//    public init?(identifier: String)
//    public init?(secondsFromGMT seconds: Int)
//    public init?(abbreviation: String)
//    public var identifier: String { get }
//    public func secondsFromGMT(for date: Date = Date()) -> Int
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

#if !SKIP
extension SkipTimeZone {
}
#else
extension SkipTimeZone {
}
#endif
