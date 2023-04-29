// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP
import struct Foundation.DateInterval
public typealias DateInterval = Foundation.DateInterval
public typealias PlatformDateInterval = Foundation.DateInterval
#else
public typealias DateInterval = SkipDateInterval
public typealias PlatformDateInterval = java.time.Duration
#endif


public struct SkipDateInterval : RawRepresentable, Hashable {
    public let rawValue: PlatformDateInterval

    public init(rawValue: PlatformDateInterval) {
        self.rawValue = rawValue
    }

    public init(_ rawValue: PlatformDateInterval) {
        self.rawValue = rawValue
    }
}
