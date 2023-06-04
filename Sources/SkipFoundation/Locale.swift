// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
#if !SKIP
@_implementationOnly import struct Foundation.Locale
internal typealias PlatformLocale = Foundation.Locale
internal typealias NSLocale = Foundation.Locale.ReferenceType
#else
internal typealias PlatformLocale = java.util.Locale
internal typealias NSLocale = Locale
#endif

/// Information about linguistic, cultural, and technological conventions for use in formatting data for presentation.
public struct Locale : Hashable {
    internal let rawValue: PlatformLocale

    internal init(rawValue: PlatformLocale) {
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

    public static var current: Locale {
        #if !SKIP
        return Locale(rawValue: PlatformLocale.current)
        #else
        return Locale(rawValue: PlatformLocale.getDefault())
        #endif
    }

    public static var system: Locale {
        #if !SKIP
        return Locale(rawValue: NSLocale.system)
        #else
        return Locale(rawValue: PlatformLocale.getDefault()) // FIXME: not the same as .system: “Use the system locale when you don’t want any localizations”
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
