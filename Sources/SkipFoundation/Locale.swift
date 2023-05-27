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
        #if SKIP
        //self.rawValue = PlatformLocale(identifier)
        //self.rawValue = PlatformLocale.forLanguageTag(identifier)
        let parts = Array(identifier.split("_"))
        if parts.count >= 2 {
            // turn fr_FR into the language/country form
            self.rawValue = PlatformLocale(parts.first, parts.last)
        } else {
            // language only
            self.rawValue = PlatformLocale(identifier)
        }
        #else
        self.rawValue = PlatformLocale(identifier: identifier)
        #endif
    }

    public static var current: SkipLocale {
        #if !SKIP
        return SkipLocale(PlatformLocale.current)
        #else
        return SkipLocale(PlatformLocale.getDefault())
        #endif
    }

    public var identifier: String {
        #if !SKIP
        return rawValue.identifier
        #else
        //return rawValue.toLanguageTag()
        return rawValue.toString()
        #endif
    }

    public var languageCode: String? {
        #if !SKIP
        return rawValue.languageCode
        #else
        return rawValue.getLanguage()
        #endif
    }

    public func localizedString(forLanguageCode languageCode: String) -> String? {
        #if !SKIP
        return rawValue.localizedString(forLanguageCode: languageCode)
        #else
        return PlatformLocale(languageCode).getDisplayLanguage(rawValue)
        #endif
    }

    public var currencySymbol: String? {
        #if !SKIP
        return rawValue.currencySymbol
        #else
        java.text.NumberFormat.getCurrencyInstance(rawValue).currency?.symbol
        #endif
    }

}
