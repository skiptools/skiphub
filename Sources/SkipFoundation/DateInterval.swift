// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP
@_implementationOnly import struct Foundation.DateInterval
internal typealias PlatformDateInterval = Foundation.DateInterval
#else
public typealias PlatformDateInterval = java.time.Duration
#endif

/// The span of time between a specific start date and end date.
public struct DateInterval : Hashable, CustomStringConvertible {
    internal var platformValue: PlatformDateInterval

    internal init(platformValue: PlatformDateInterval) {
        self.platformValue = platformValue
    }

    public var description: String {
        return platformValue.description
    }
}
