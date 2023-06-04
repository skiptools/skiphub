// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
import Foundation
import XCTest

@available(macOS 13, iOS 16, watchOS 10, tvOS 16, *)
final class LocaleTests: XCTestCase {
    func testLanguageCodes() throws {
        let fr = Locale(identifier: "fr_FR")
        XCTAssertNotNil(fr)
        //logger.info("fr_FR: \(fr.identifier)")

        XCTAssertEqual("fr_FR", fr.identifier)

        XCTAssertEqual("€", Locale(identifier: "fr_FR").currencySymbol)
        XCTAssertEqual("€", Locale(identifier: "pt_PT").currencySymbol)
        #if SKIP
        //XCTAssertEqual("R", Locale(identifier: "pt_BR").currencySymbol)
        #else
        //XCTAssertEqual("R$", Locale(identifier: "pt_BR").currencySymbol)
        #endif

        XCTAssertEqual("¥", Locale(identifier: "jp_JP").currencySymbol)
        XCTAssertEqual("¤", Locale(identifier: "zh_ZH").currencySymbol)
        #if SKIP
        //XCTAssertEqual("", Locale(identifier: "en_US").currencySymbol)
        #else
        //XCTAssertEqual("$", Locale(identifier: "en_US").currencySymbol)
        #endif

        //XCTAssertEqual("fr", fr.languageCode)

        #if SKIP
        // TODO: make it top-level "Test.plist"

        // “The method getResource() returns a URL for the resource. The URL (and its representation) is specific to the implementation and the JVM (that is, the URL obtained in one runtime instance may not work in another). Its protocol is usually specific to the ClassLoader loading the resource. If the resource does not exist or is not visible due to security considerations, the methods return null.”
        let resURL: java.net.URL = try XCTAssertNotNil(javaClass.getResource("Resources/Test.plist"))
        let contents = try resURL.getContent()

        let module = Bundle.module

        // “If the client code wants to read the contents of the resource as an InputStream, it can apply the openStream() method on the URL. This is common enough to justify adding getResourceAsStream() to Class and ClassLoader. getResourceAsStream() the same as calling getResource().openStream(), except that getResourceAsStream() catches IO exceptions returns a null InputStream.”
        let res = try XCTAssertNotNil(javaClass.getResourceAsStream("Resources/Test.plist"))
        res.close()
        #endif

        XCTAssertEqual("anglais", fr.localizedString(forLanguageCode: "en"))
        XCTAssertEqual("français", fr.localizedString(forLanguageCode: "fr"))
        XCTAssertEqual("chinois", fr.localizedString(forLanguageCode: "zh"))

        let zh = Locale(identifier: "zh_HK")
        //logger.info("zh_HK: \(zh.identifier)")
        XCTAssertNotNil(zh)

        XCTAssertEqual("zh_HK", zh.identifier)

        //XCTAssertEqual("zh_HK", zh.identifier)
        //XCTAssertEqual("zh", zh.languageCode)

        //XCTAssertEqual("法文", zh.localizedString(forLanguageCode: "fr"))
        //XCTAssertEqual("英文", zh.localizedString(forLanguageCode: "en"))
        //XCTAssertEqual("中文", zh.localizedString(forLanguageCode: "zh"))

        //XCTAssertEqual(["en", "fr"], Bundle.module.localizations.sorted())

        //let foundationBundle = _SkipFoundationBundle // Bundle(for: SkipFoundationModule.self)

        //let localeIdentifiers = foundationBundle.localizations.sorted()

        #if !SKIP
        // TODO: the test resources list is overriding the foundation resources
        
        //XCTAssertEqual(["ar", "ca", "cs", "da", "de", "el", "en", "en_AU", "en_GB", "es", "es_419", "fa", "fi", "fr", "fr_CA", "he", "hi", "hr", "hu", "id", "it", "ja", "ko", "ms", "nl", "no", "pl", "pt", "pt_PT", "ro", "ru", "sk", "sv", "th", "tr", "uk", "vi", "zh-Hans", "zh-Hant"], localeIdentifiers)

//        for (lang, hello) in [
//            ("ar", "مرحبًا"),
//            ("ca", "Hola"),
//            ("cs", "Ahoj"),
//            ("da", "Hej"),
//            ("de", "Hallo"),
//            ("el", "Γεια σας"),
//            ("en_AU", "Hello"),
//            ("en_GB", "Hello"),
//            ("en", "Hello"),
//            ("es_419", "Hola"),
//            ("es", "Hola"),
//            ("fa", "سلام"),
//            ("fi", "Hei"),
//            ("fr_CA", "Bonjour"),
//            ("fr", "Bonjour"),
//            ("he", "שלום"),
//            ("hi", "नमस्ते"),
//            ("hr", "Bok"),
//            ("hu", "Sziasztok"),
//            ("id", "Halo"),
//            ("it", "Ciao"),
//            ("ja", "こんにちは"),
//            ("ko", "안녕하세요"),
//            ("ms", "Bonjour"),
//            ("nl", "Hallo"),
//            ("no", "Hei"),
//            ("pl", "Cześć"),
//            ("pt_PT", "Olá"),
//            ("pt", "Olá"),
//            ("ro", "Bună"),
//            ("ru", "Привет"),
//            ("sk", "Ahoj"),
//            ("sv", "Hej"),
//            ("th", "สวัสดี"),
//            ("tr", "Merhaba"),
//            ("uk", "Привіт"),
//            ("vi", "Xin chào"),
//            ("zh-Hans", "你好"),
//            ("zh-Hant", "你好"),
//        ] {
//
//            let lproj = try XCTUnwrap(foundationBundle.url(forResource: lang, withExtension: "lproj"), "error loading language: \(lang)")
//            let bundle = try XCTUnwrap(Bundle(url: lproj))
//            let helloLocalized = bundle.localizedString(forKey: "Hello", value: nil, table: nil)
//            XCTAssertEqual(hello, helloLocalized, "bad hello translation for: \(lang)")
//        }
        #endif
    }

    func testManualStringLocalization() throws {
        let locstr = """
        /* A comment */
        "Yes" = "Oui";
        "The \\\"same\\\" text in English" = "Le \\\"même\\\" texte en anglais";
        """

        let data = try XCTUnwrap(locstr.data(using: String.Encoding.utf8, allowLossyConversion: false))

        do {
            let plist = try PropertyListSerialization.propertyList(from: data, format: nil)

            let dict = try XCTUnwrap(plist as? Dictionary<String, String>)
            XCTAssertEqual(2, dict.keys.count)
            XCTAssertEqual("Oui", dict["Yes"])
            XCTAssertEqual("Le \"même\" texte en anglais", dict["The \"same\" text in English"])
        }

        // run the same test again, but this time verifying the SkipPropertyListSerialization implementation on Darwin
        do {
            let plist = try PropertyListSerialization.propertyList(from: data, format: nil)

            let dict = try XCTUnwrap(plist as? Dictionary<String, String>)
            XCTAssertEqual(2, dict.keys.count)
            XCTAssertEqual("Oui", dict["Yes"])
            XCTAssertEqual("Le \"même\" texte en anglais", dict["The \"same\" text in English"])
        }
    }

    func testLocalizedStrings() throws {
        #if SKIP
        let bundle = _SkipFoundationBundle

        XCTAssertNil(bundle.url(forResource: "Localizable", withExtension: "strings", subdirectory: nil, localization: "xxx"), "unknown localization should return nil")

        let enlproj = try XCTUnwrap(bundle.url(forResource: "Localizable", withExtension: "strings", subdirectory: nil, localization: "en"))
        let frlproj = try XCTUnwrap(bundle.url(forResource: "Localizable", withExtension: "strings", subdirectory: nil, localization: "fr"))
        //let delproj = try XCTUnwrap(bundle.url(forResource: "Localizable", withExtension: "strings", subdirectory: nil, localization: "de"))

        XCTAssertNotEqual(enlproj, frlproj, "localized resources lookup should return different paths")

        #if !SKIP
        XCTAssertEqual("Hello", NSLocalizedString("Hello", comment: ""))
        //XCTAssertEqual("Hi", NSLocalizedString("Hello", bundle: bundle, comment: ""))
        //XCTAssertEqual("Hi", NSLocalizedString("Hello", tableName: nil, bundle: bundle, comment: ""))
        //XCTAssertEqual("Hi", NSLocalizedString("Hello", tableName: "Localizable.strings", bundle: bundle, comment: ""))
        XCTAssertEqual("Hello", NSLocalizedString("Hello", tableName: "nonexistent.strings", bundle: bundle, comment: ""))
        #endif

        //XCTAssertEqual("Hi", String(localized: "Hello", bundle: bundle, locale: Locale(identifier: "en"), comment: "greetings"))
        //XCTAssertEqual("Hi", String(localized: "Hello", bundle: bundle, locale: Locale(identifier: "fr"), comment: "greetings"))

        //var loc = LocalizedStringResource("Hello", bundle: bundle.location)
        //XCTAssertEqual("bonjour", NSLocalizedString("Hello", bundle: fr, comment: ""))

        #if SKIP
        //XCTAssertEqual("bonjour", String(localized: LocalizedStringResource("Hello", locale: Locale(identifier: "fr"), bundle: SkipLocalizedStringResource.BundleDescription.atURL(bundle.bundleURL), comment: nil)))
        #endif

//        XCTAssertEqual("bonjour", String(localized: LocalizedStringResource("Hello", table: "Localizable", locale: Locale(identifier: "fr"), bundle: LocalizedStringResource.BundleDescription.atURL(bundle.bundleURL), comment: nil)))
//        XCTAssertEqual("Hi", String(localized: LocalizedStringResource("Hello", table: "Localizable", locale: Locale(identifier: "de"), bundle: LocalizedStringResource.BundleDescription.atURL(bundle.bundleURL), comment: nil)))
//        XCTAssertEqual("Hi", String(localized: LocalizedStringResource("Hello", table: "Localizable", locale: Locale(identifier: "xxx"), bundle: LocalizedStringResource.BundleDescription.atURL(bundle.bundleURL), comment: nil)))
//
//        XCTAssertEqual("Bonjour", String(localized: LocalizedStringResource("Hello", table: "Localizable", locale: Locale(identifier: "fr"), bundle: LocalizedStringResource.BundleDescription.atURL(_SkipFoundationBundle.bundleURL), comment: nil)))
//        XCTAssertEqual("Hallo", String(localized: LocalizedStringResource("Hello", table: "Localizable", locale: Locale(identifier: "de"), bundle: LocalizedStringResource.BundleDescription.atURL(_SkipFoundationBundle.bundleURL), comment: nil)))


        #if !SKIP
//        var loc = LocalizedStringResource("Hello", bundle: bundle.location)
//        XCTAssertEqual("Hi", String(localized: loc))
//        loc.locale = Locale(identifier: "fr")
//        XCTAssertEqual("bonjour", String(localized: loc))
//        loc.locale = Locale(identifier: "UNKNOWN")
//        XCTAssertEqual("Hi", String(localized: loc))


        let fr = try XCTUnwrap(Bundle(path: XCTUnwrap(bundle.path(forResource: "fr", ofType: "lproj"))))
        XCTAssertEqual("Bonjour", NSLocalizedString("Hello", bundle: fr, comment: ""))
        XCTAssertEqual("Bonjour", NSLocalizedString("Hello", tableName: "Localizable", bundle: fr, comment: ""))
        XCTAssertEqual("Bonjour", String(localized: "Hello", bundle: fr, comment: "greetings"))

        let name = "Name"
        XCTAssertEqual("Bonjour Name", String(localized: "Hi \(name)", bundle: fr, comment: "Personalized Greeting Message"))

        //XCTAssertEqual("Bonjour", String(localized: "Hello", table: "Localized.strings", bundle: bundle, locale: Locale(identifier: "fr_FR"), comment: "greetings"))

        //XCTAssertEqual("Bonjour", String(localized: "Hello", bundle: bundle, locale: Locale(identifier: "ar"), comment: "greetings"))
        //XCTAssertEqual("Bonjour", String(localized: "Hello", bundle: bundle, locale: Locale(identifier: "de"), comment: "greetings"))
        //XCTAssertEqual("Bonjour", String(localized: "Hello", bundle: bundle, locale: Locale(identifier: "zh"), comment: "greetings"))
        XCTAssertEqual("Hello", String(localized: LocalizedStringResource("Hello", table: "DOES_NOT_EXIST", bundle: .atURL(bundle.bundleURL), comment: nil)))

        #endif
        #endif
    }

}
