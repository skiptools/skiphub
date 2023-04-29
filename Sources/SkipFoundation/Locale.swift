// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
#if !SKIP
import struct Foundation.Locale
public typealias Locale = Foundation.Locale
internal typealias PlatformLocale = Foundation.Locale
#else
public typealias Locale = SkipLocale
public typealias PlatformLocale = java.util.Locale
#endif

// override the Kotlin type to be public while keeping the Swift version internal:
// SKIP DECLARE: class SkipLocale: RawRepresentable<PlatformLocale>
internal struct SkipLocale : RawRepresentable, Hashable {
    public let rawValue: PlatformLocale

    public init(rawValue: PlatformLocale) {
        self.rawValue = rawValue
    }

    public init(_ rawValue: PlatformLocale) {
        self.rawValue = rawValue
    }

    public init(identifier: String) {
        #if !SKIP
        self.rawValue = PlatformLocale(identifier: identifier)
        #else
        self.rawValue = PlatformLocale(identifier)
        #endif
    }
}

#if !SKIP

extension SkipLocale {
}

#else

extension SkipLocale {
    public var identifier: String {
        //return rawValue.toLanguageTag()
        return rawValue.toString()
    }

    public var languageCode: String? {
        return rawValue.getLanguage()
    }
}

#endif
