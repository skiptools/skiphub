// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
#if !SKIP
import class Foundation.DateFormatter
public typealias DateFormatter = Foundation.DateFormatter
internal typealias PlatformDateFormatter = Foundation.DateFormatter
#else
public typealias DateFormatter = SkipDateFormatter
public typealias PlatformDateFormatter = java.text.DateFormat
#endif


// SKIP DECLARE: class SkipDateFormatter: RawRepresentable<PlatformDateFormatter>
internal class SkipDateFormatter : RawRepresentable, Hashable, CustomStringConvertible {
    public let rawValue: PlatformDateFormatter

    public required init(rawValue: PlatformDateFormatter) {
        self.rawValue = rawValue
    }

    public init(_ rawValue: PlatformDateFormatter) {
        self.rawValue = rawValue
    }

    public var description: String {
        return rawValue.description
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

