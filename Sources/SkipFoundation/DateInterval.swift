// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP
/* @_implementationOnly */import struct Foundation.DateInterval
public typealias DateInterval = Foundation.DateInterval
public typealias PlatformDateInterval = Foundation.DateInterval
#else
public typealias DateInterval = SkipDateInterval
public typealias PlatformDateInterval = java.time.Duration
#endif

// override the Kotlin type to be public while keeping the Swift version internal:
// SKIP DECLARE: class SkipDateInterval: RawRepresentable<PlatformDateInterval>, MutableStruct
internal struct SkipDateInterval : RawRepresentable, Hashable, CustomStringConvertible {
    public var rawValue: PlatformDateInterval

    public init(rawValue: PlatformDateInterval) {
        self.rawValue = rawValue
    }

    public init(_ rawValue: PlatformDateInterval) {
        self.rawValue = rawValue
    }

    var description: String {
        return rawValue.description
    }
}
