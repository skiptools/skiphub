// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
#if !SKIP
import struct Foundation.TimeZone
public typealias TimeZone = Foundation.TimeZone
public typealias PlatformTimeZone = Foundation.NSTimeZone
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
}

#if !SKIP

extension SkipTimeZone {
}

#else

// SKXX INSERT: public operator fun SkipTimeZone.Companion.invoke(contentsOf: URL): SkipTimeZone { return SkipTimeZone(TODO) }

extension SkipTimeZone {
}

#endif

