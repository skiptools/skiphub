// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
import Foundation
import XCTest

// These tests are adapted from https://github.com/apple/swift-corelibs-foundation/blob/main/Tests/Foundation/Tests which have the following license:


// This source file is part of the Swift.org open source project
//
// Copyright (c) 2014 - 2016 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See http://swift.org/LICENSE.txt for license information
// See http://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//

class TestNSLocale : XCTestCase {

    func test_Identifier() {
        #if SKIP
        throw XCTSkip("TODO")
        #else
        // Current locale identifier should not be empty
        // Or things like NumberFormatter spellOut style won't work
        XCTAssertFalse(Locale.current.identifier.isEmpty)

        let enUSID = "en_US"
        let locale = Locale(identifier: enUSID)
        XCTAssertEqual(enUSID, locale.identifier)

        let deDEID = "de_DE"
        let germanLocale = Locale(identifier: deDEID)
        XCTAssertEqual(deDEID, germanLocale.identifier)
        #endif // !SKIP
    }
    
    func test_constants() {
        #if SKIP
        throw XCTSkip("TODO")
        #else
        XCTAssertEqual(NSLocale.currentLocaleDidChangeNotification.rawValue, "kCFLocaleCurrentLocaleDidChangeNotification",
                        "\(NSLocale.currentLocaleDidChangeNotification.rawValue) is not equal to kCFLocaleCurrentLocaleDidChangeNotification")
        
        XCTAssertEqual(NSLocale.Key.identifier.rawValue, "kCFLocaleIdentifierKey",
                        "\(NSLocale.Key.identifier.rawValue) is not equal to kCFLocaleIdentifierKey")

        XCTAssertEqual(NSLocale.Key.languageCode.rawValue, "kCFLocaleLanguageCodeKey",
                        "\(NSLocale.Key.languageCode.rawValue) is not equal to kCFLocaleLanguageCodeKey")

        XCTAssertEqual(NSLocale.Key.countryCode.rawValue, "kCFLocaleCountryCodeKey",
                        "\(NSLocale.Key.countryCode.rawValue) is not equal to kCFLocaleCountryCodeKey")

        XCTAssertEqual(NSLocale.Key.scriptCode.rawValue, "kCFLocaleScriptCodeKey",
                        "\(NSLocale.Key.scriptCode.rawValue) is not equal to kCFLocaleScriptCodeKey")

        XCTAssertEqual(NSLocale.Key.variantCode.rawValue, "kCFLocaleVariantCodeKey",
                        "\(NSLocale.Key.variantCode.rawValue) is not equal to kCFLocaleVariantCodeKey")

        XCTAssertEqual(NSLocale.Key.exemplarCharacterSet.rawValue, "kCFLocaleExemplarCharacterSetKey",
                        "\(NSLocale.Key.exemplarCharacterSet.rawValue) is not equal to kCFLocaleExemplarCharacterSetKey")

        XCTAssertEqual(NSLocale.Key.calendar.rawValue, "kCFLocaleCalendarKey",
                        "\(NSLocale.Key.calendar.rawValue) is not equal to kCFLocaleCalendarKey")

        XCTAssertEqual(NSLocale.Key.collationIdentifier.rawValue, "collation",
                        "\(NSLocale.Key.collationIdentifier.rawValue) is not equal to collation")

        XCTAssertEqual(NSLocale.Key.usesMetricSystem.rawValue, "kCFLocaleUsesMetricSystemKey",
                        "\(NSLocale.Key.usesMetricSystem.rawValue) is not equal to kCFLocaleUsesMetricSystemKey")

        XCTAssertEqual(NSLocale.Key.measurementSystem.rawValue, "kCFLocaleMeasurementSystemKey",
                        "\(NSLocale.Key.measurementSystem.rawValue) is not equal to kCFLocaleMeasurementSystemKey")

        XCTAssertEqual(NSLocale.Key.decimalSeparator.rawValue, "kCFLocaleDecimalSeparatorKey",
                        "\(NSLocale.Key.decimalSeparator.rawValue) is not equal to kCFLocaleDecimalSeparatorKey")

        XCTAssertEqual(NSLocale.Key.groupingSeparator.rawValue, "kCFLocaleGroupingSeparatorKey",
                        "\(NSLocale.Key.groupingSeparator.rawValue) is not equal to kCFLocaleGroupingSeparatorKey")

        XCTAssertEqual(NSLocale.Key.currencySymbol.rawValue, "kCFLocaleCurrencySymbolKey",
                        "\(NSLocale.Key.currencySymbol.rawValue) is not equal to kCFLocaleCurrencySymbolKey")

        XCTAssertEqual(NSLocale.Key.currencyCode.rawValue, "currency",
                        "\(NSLocale.Key.currencyCode.rawValue) is not equal to currency")

        XCTAssertEqual(NSLocale.Key.collatorIdentifier.rawValue, "kCFLocaleCollatorIdentifierKey",
                        "\(NSLocale.Key.collatorIdentifier.rawValue) is not equal to kCFLocaleCollatorIdentifierKey")

        XCTAssertEqual(NSLocale.Key.quotationBeginDelimiterKey.rawValue, "kCFLocaleQuotationBeginDelimiterKey",
                        "\(NSLocale.Key.quotationBeginDelimiterKey.rawValue) is not equal to kCFLocaleQuotationBeginDelimiterKey")

        XCTAssertEqual(NSLocale.Key.quotationEndDelimiterKey.rawValue, "kCFLocaleQuotationEndDelimiterKey",
                        "\(NSLocale.Key.quotationEndDelimiterKey.rawValue) is not equal to kCFLocaleQuotationEndDelimiterKey")

        XCTAssertEqual(NSLocale.Key.alternateQuotationBeginDelimiterKey.rawValue, "kCFLocaleAlternateQuotationBeginDelimiterKey",
                        "\(NSLocale.Key.alternateQuotationBeginDelimiterKey.rawValue) is not equal to kCFLocaleAlternateQuotationBeginDelimiterKey")

        XCTAssertEqual(NSLocale.Key.alternateQuotationEndDelimiterKey.rawValue, "kCFLocaleAlternateQuotationEndDelimiterKey",
                        "\(NSLocale.Key.alternateQuotationEndDelimiterKey.rawValue) is not equal to kCFLocaleAlternateQuotationEndDelimiterKey")

        #endif // !SKIP
    }

    func test_copy() {
        #if SKIP
        throw XCTSkip("TODO")
        #else
        let locale = Locale(identifier: "en_US")
        let localeCopy = locale

        XCTAssertTrue(locale == localeCopy)
        #endif // !SKIP
    }

    func test_hash() {
        #if SKIP
        throw XCTSkip("TODO")
        #else
        let a1 = Locale(identifier: "en_US")
        let a2 = Locale(identifier: "en_US")

        XCTAssertEqual(a1, a2)
        XCTAssertEqual(a1.hashValue, a2.hashValue)
        #endif // !SKIP
    }

    func test_staticProperties() {
        #if SKIP
        throw XCTSkip("TODO")
        #else
        let euroCurrencyCode = "EUR"
        let spainRegionCode = "ES"
        let galicianLanguageCode = "gl"
        let galicianLocaleIdentifier = Locale.identifier(fromComponents: [NSLocale.Key.languageCode.rawValue: galicianLanguageCode,
                                                                          NSLocale.Key.countryCode.rawValue: spainRegionCode])

        XCTAssertTrue(galicianLocaleIdentifier == "\(galicianLanguageCode)_\(spainRegionCode)")
        
        let components = Locale.components(fromIdentifier: galicianLocaleIdentifier)

        XCTAssertTrue(components[NSLocale.Key.languageCode.rawValue] == galicianLanguageCode)
        XCTAssertTrue(components[NSLocale.Key.countryCode.rawValue] == spainRegionCode)

        XCTAssertTrue(Locale.availableIdentifiers.contains(galicianLocaleIdentifier))
        XCTAssertTrue(Locale.isoCurrencyCodes.contains(euroCurrencyCode))
        XCTAssertTrue(Locale.isoRegionCodes.contains(spainRegionCode))
        XCTAssertTrue(Locale.isoLanguageCodes.contains(galicianLanguageCode))

        #if os(macOS)
        // iOS 16+ only
        XCTAssertTrue(Locale.commonISOCurrencyCodes.contains(euroCurrencyCode))
        #endif
        
        XCTAssertTrue(Locale.preferredLanguages.count == UserDefaults.standard.array(forKey: "AppleLanguages")?.count ?? 0)
        #endif // !SKIP
    }
    
    func test_localeProperties(){
        #if SKIP
        throw XCTSkip("TODO")
        #else
        let enUSID = "en_US"
        let locale = Locale(identifier: enUSID)
        XCTAssertEqual(String(describing: locale.languageCode!), "en")
        XCTAssertEqual(String(describing: locale.decimalSeparator!), ".")
        XCTAssertEqual(String(describing: locale.currencyCode!), "USD")
        XCTAssertEqual(String(describing: locale.collatorIdentifier!), enUSID)
        #endif // !SKIP
    }

}


