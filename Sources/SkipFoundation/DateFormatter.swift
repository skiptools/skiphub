// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
#if !SKIP
import class Foundation.DateFormatter
public typealias DateFormatter = Foundation.DateFormatter
public typealias PlatformDateFormatter = Foundation.DateFormatter
#else
public typealias DateFormatter = SkipDateFormatter
public typealias PlatformDateFormatter = java.text.DateFormat
#endif


public struct SkipDateFormatter : Hashable, RawRepresentable {
    public let rawValue: PlatformDateFormatter

    public init(rawValue: PlatformDateFormatter) {
        self.rawValue = rawValue
    }

    public init(_ rawValue: PlatformDateFormatter) {
        self.rawValue = rawValue
    }
}

#if !SKIP

extension SkipDateFormatter {
}

#else

// SKXX INSERT: public operator fun SkipDateFormatter.Companion.invoke(): SkipDateFormatter { return SkipDateFormatter(PlatformDateFormatter()) }

extension SkipDateFormatter {
}

#endif

