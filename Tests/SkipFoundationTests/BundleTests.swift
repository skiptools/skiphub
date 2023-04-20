// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
import SkipFoundation
import OSLog
import XCTest

#if !SKIP
/// Name fix until skip supports Dictionary -> Map transpilation
fileprivate typealias Map = Dictionary
#endif

@available(macOS 11, iOS 14, watchOS 7, tvOS 14, *)
final class BundleTests: XCTestCase {
    fileprivate let logger = Logger(subsystem: "test", category: "BundleTests")

    func testBundle() throws {
        if true {
            return // TODO: fix resources
        }

        #if !SKIP

        let resourceURL: URL = try XCTUnwrap(Bundle.module.url(forResource: "textasset", withExtension: "txt", subdirectory: nil, localization: nil))
        logger.info("resourceURL: \(resourceURL.absoluteString)")

        // Swift will be: Contents/Resources/ -- file:///~/Library/Developer/Xcode/DerivedData/DemoApp-ABCDEF/Build/Products/Debug/SkipFoundationTests.xctest/Contents/Resources/Skip_SkipFoundationTests.bundle/
        // Kotlin will be: file:/SRCDIR/Skip/kip/SkipFoundationTests/modules/SkipFoundation/build/tmp/kotlin-classes/debugUnitTest/skip/foundation/

        let str = try String(contentsOf: resourceURL)
        XCTAssertEqual("Some text\n", str)
        #endif
    }

    func testBundleInfo() throws {
        #if !SKIP
        // sadly, the Info.plist is auto-generated by SPM and cannot be overridden
        let _ = Bundle.module.infoDictionary ?? [:]
        let name = Bundle.module.bundleURL.deletingPathExtension().lastPathComponent
        XCTAssertEqual("skiphub_SkipFoundationTests", name)
        let moduleName = name.split(separator: "_").last?.description ?? name // turn "Skip_SkipFoundationTests" into "SkipFoundationTests"
        XCTAssertEqual("SkipFoundationTests", moduleName)

        //XCTAssertEqual(["BuildMachineOSBuild", "CFBundleDevelopmentRegion", "CFBundleIdentifier", "CFBundleInfoDictionaryVersion", "CFBundleName", "CFBundlePackageType", "CFBundleSupportedPlatforms", "DTCompiler", "DTPlatformBuild", "DTPlatformName", "DTPlatformVersion", "DTSDKBuild", "DTSDKName", "DTXcode", "DTXcodeBuild", "LSMinimumSystemVersion"], Set(info.keys))
        //XCTAssertEqual("Skip_SkipFoundationTests", info["CFBundleName"] as? String)
        #endif
    }

    func testManualStringLocalization() throws {
        let locstr = """
        /* A comment */
        "Yes" = "Oui";
        "The \\\"same\\\" text in English" = "Le \\\"même\\\" texte en anglais";
        """

        let data = try XCTUnwrap(locstr.data(using: StringEncoding.utf8, allowLossyConversion: false))

        let plist = try PropertyListSerialization.propertyList(from: data, format: nil)

        let dict = try XCTUnwrap(plist as? Map<String, String>)

        XCTAssertEqual("Oui", dict["Yes"])
        logger.debug("KEYS: \(dict.keys)")
        XCTAssertEqual("Le \"même\" texte en anglais", dict["The \"same\" text in English"])
    }


    func testLocalizedStrings() throws {
        #if !SKIP // TODO
        if #available(macOS 13, iOS 16, tvOS 16, watchOS 8, *) {
            let enlproj = try XCTUnwrap(Bundle.module.url(forResource: "Localizable", withExtension: "strings", subdirectory: nil, localization: "en"))
            let frlproj = try XCTUnwrap(Bundle.module.url(forResource: "Localizable", withExtension: "strings", subdirectory: nil, localization: "fr"))
            //let delproj = try XCTUnwrap(Bundle.module.url(forResource: "Localizable", withExtension: "strings", subdirectory: nil, localization: "de"))

            XCTAssertNotEqual(enlproj, frlproj, "localized resources lookup should return different paths")

            var loc = LocalizedStringResource("Hello", bundle: Bundle.module.location)
            //XCTAssertEqual("bonjour", NSLocalizedString("Hello", bundle: fr, comment: ""))


            XCTAssertEqual("Hi", String(localized: loc))
            loc.locale = Locale(identifier: "fr")
            XCTAssertEqual("bonjour", String(localized: loc))
            loc.locale = Locale(identifier: "UNKNOWN")
            XCTAssertEqual("Hi", String(localized: loc))


            XCTAssertEqual("Hello", NSLocalizedString("Hello", comment: ""))
            XCTAssertEqual("Hi", NSLocalizedString("Hello", bundle: Bundle.module, comment: ""))
            XCTAssertEqual("Hi", NSLocalizedString("Hello", bundle: Bundle.module, comment: ""))
            XCTAssertEqual("Hi", String(localized: "Hello", bundle: Bundle.module, locale: Locale(identifier: "en"), comment: "greetings"))

            let fr = try XCTUnwrap(Bundle(path: XCTUnwrap(Bundle.module.path(forResource: "fr", ofType: "lproj"))))
            XCTAssertEqual("bonjour", NSLocalizedString("Hello", bundle: fr, comment: ""))
            XCTAssertEqual("bonjour", String(localized: "Hello", bundle: fr, comment: "greetings"))

            XCTAssertEqual("Hi", String(localized: LocalizedStringResource("Hello", bundle: .atURL(Bundle.module.bundleURL))))
            XCTAssertEqual("Hi", String(localized: LocalizedStringResource("Hello", bundle: .atURL(Bundle.module.bundleURL), comment: nil)))
            XCTAssertEqual("Hi", String(localized: LocalizedStringResource("Hello", table: "Localizable", bundle: .atURL(Bundle.module.bundleURL), comment: nil)))

            XCTAssertEqual("Hello", String(localized: LocalizedStringResource("Hello", table: "DOES_NOT_EXIST", bundle: .atURL(Bundle.module.bundleURL), comment: nil)))

            XCTAssertEqual("bonjour", String(localized: LocalizedStringResource("Hello", table: "Localizable", locale: Locale(identifier: "fr"), bundle: .atURL(Bundle.module.bundleURL), comment: nil)))
            XCTAssertEqual("bonjour", String(localized: LocalizedStringResource("Hello", locale: Locale(identifier: "fr"), bundle: .atURL(Bundle.module.bundleURL), comment: nil)))
        }
        #endif
    }
}
