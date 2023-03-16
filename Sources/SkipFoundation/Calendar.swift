// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
#if !SKIP
import struct Foundation.Calendar
public typealias Calendar = Foundation.Calendar
public typealias PlatformCalendar = Foundation.NSCalendar
#else
public typealias Calendar = SkipCalendar
public typealias PlatformCalendar = java.util.Calendar
#endif

// SKIP REPLACE: @JvmInline public value class SkipCalendar(val rawValue: PlatformCalendar) { companion object { } }
public struct SkipCalendar : RawRepresentable {
    public let rawValue: PlatformCalendar

    public init(rawValue: PlatformCalendar) {
        self.rawValue = rawValue
    }

    public init(_ rawValue: PlatformCalendar) {
        self.rawValue = rawValue
    }
}

#if !SKIP

extension SkipCalendar {
}

#else

// SKXX INSERT: public operator fun SkipCalendar.Companion.invoke(contentsOf: URL): SkipCalendar { return SkipCalendar(TODO) }

extension SkipCalendar {
}

#endif

