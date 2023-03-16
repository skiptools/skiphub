// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
#if !SKIP
import class Foundation.NumberFormatter
public typealias NumberFormatter = Foundation.NumberFormatter
public typealias PlatformNumberFormatter = Foundation.NumberFormatter
#else
public typealias NumberFormatter = SkipNumberFormatter
public typealias PlatformNumberFormatter = java.text.NumberFormat
#endif


// SKIP REPLACE: @JvmInline public value class SkipNumberFormatter(val rawValue: PlatformNumberFormatter) { companion object { } }
public struct SkipNumberFormatter : RawRepresentable {
    public let rawValue: PlatformNumberFormatter

    public init(rawValue: PlatformNumberFormatter) {
        self.rawValue = rawValue
    }

    public init(_ rawValue: PlatformNumberFormatter) {
        self.rawValue = rawValue
    }
}

#if !SKIP

extension SkipNumberFormatter {
}

#else

// SKXX INSERT: public operator fun SkipNumberFormatter.Companion.invoke(): SkipNumberFormatter { return SkipNumberFormatter(PlatformNumberFormatter()) }

extension SkipNumberFormatter {
}

#endif

