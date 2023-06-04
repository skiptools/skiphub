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
    internal let platformValue: PlatformLocale

    internal init(platformValue: PlatformLocale) {
        self.platformValue = platformValue
    }

    public init(identifier: String) {
        #if SKIP
        //self.platformValue = PlatformLocale(identifier)
        //self.platformValue = PlatformLocale.forLanguageTag(identifier)
        let parts = Array(identifier.split("_"))
        if parts.count >= 2 {
            // turn fr_FR into the language/country form
            self.platformValue = PlatformLocale(parts.first, parts.last)
        } else {
            // language only
            self.platformValue = PlatformLocale(identifier)
        }
        #else
        self.platformValue = PlatformLocale(identifier: identifier)
        #endif
    }

    public static var current: Locale {
        #if !SKIP
        return Locale(platformValue: PlatformLocale.current)
        #else
        return Locale(platformValue: PlatformLocale.getDefault())
        #endif
    }

    public static var system: Locale {
        #if !SKIP
        return Locale(platformValue: NSLocale.system)
        #else
        return Locale(platformValue: PlatformLocale.getDefault()) // FIXME: not the same as .system: “Use the system locale when you don’t want any localizations”
        #endif
    }

    public var identifier: String {
        #if !SKIP
        return platformValue.identifier
        #else
        //return platformValue.toLanguageTag()
        return platformValue.toString()
        #endif
    }

    public var languageCode: String? {
        #if !SKIP
        return platformValue.languageCode
        #else
        return platformValue.getLanguage()
        #endif
    }

    public func localizedString(forLanguageCode languageCode: String) -> String? {
        #if !SKIP
        return platformValue.localizedString(forLanguageCode: languageCode)
        #else
        return PlatformLocale(languageCode).getDisplayLanguage(platformValue)
        #endif
    }

    public var currencySymbol: String? {
        #if !SKIP
        return platformValue.currencySymbol
        #else
        java.text.NumberFormat.getCurrencyInstance(platformValue).currency?.symbol
        #endif
    }

}
