// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
#if !SKIP
import struct Foundation.LocalizedStringResource
@available(macOS 13, iOS 16, tvOS 16, watchOS 8, *)
public typealias LocalizedStringResource = Foundation.LocalizedStringResource
#else
public typealias LocalizedStringResource = SkipLocalizedStringResource
#endif


public final class SkipLocalizedStringResource {
    public let key: String
    public let defaultValue: String? // TODO: String.LocalizationValue
    public let table: String?
    public var locale: SkipLocale?
    public var bundle: SkipBundle? // TODO: LocalizedStringResource.BundleDescription

    // SKIP REPLACE: constructor(key: String, defaultValue: String? = null, table: String? = null, locale: SkipLocale? = null, bundle: SkipBundle? = null) { this.key = key; this.defaultValue = defaultValue; this.table = table; this.locale = locale; this.bundle = bundle; }
    init(key: String, defaultValue: String, table: String?, locale: SkipLocale, bundle: SkipBundle) {
        self.key = key
        self.defaultValue = defaultValue
        self.table = table
        self.locale = locale
        self.bundle = bundle
    }


}

#if SKIP

// SKXX INSERT: public operator fun SkipLocalizedStringResource.Companion.invoke(contentsOf: URL): SkipLocalizedStringResource { return SkipLocalizedStringResource(TODO) }

extension SkipLocalizedStringResource {
}

#endif

