// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
#if !SKIP
import class Foundation.Bundle
public typealias Bundle = Foundation.Bundle
public typealias PlatformBundle = Foundation.Bundle
#else
public typealias Bundle = SkipBundle
public typealias PlatformBundle = AnyClass
#endif

// TODO: each platform should have a local Bundle.module extension created … once we can create static extensions

// override the Kotlin type to be public while keeping the Swift version internal:
// SKIP DECLARE: class SkipBundle
@available(macOS 13, iOS 16, tvOS 16, watchOS 8, *)
internal class SkipBundle {
    /// A reference to the singleton `main` bundle
    public static let main = SkipBundle(location: .main)

    private let location: SkipLocalizedStringResource.BundleDescription

    private init(location: SkipLocalizedStringResource.BundleDescription) {
        self.location = location
        // attempt to read the paths at the given resources location
    }

    public convenience init(path: String) {
        self.init(location: .atURL(URL(fileURLWithPath: path)))
    }

    public convenience init(url: URL) {
        self.init(location: .atURL(url))
    }

    public convenience init(for: AnyClass) {
        self.init(location: .forClass(`for`))
    }

    var description: String {
        return location.description
    }
}

#if SKIP

public func NSLocalizedString(_ key: String, tableName: String? = nil, bundle: Bundle = Bundle.main, value: String = "", comment: String) -> String {
    // TODO: access the java.util.ResourceBundle for the calling class
    return key
}

extension SkipBundle {
    public var resourceURL: SkipURL? {
        return bundleURL
    }

    /// The bundle for the local module.
    ///
    /// FIXME: this is terribly expensive, since it generates a stack trace and dyamically loads the class;
    /// once static extensions are supported, this can be rectified with locally-generated modules.
    public static var module: SkipBundle {
        var callingClassName = Thread.currentThread().stackTrace[2].className
        // work-around the issue where Kotlin's top-level functions are compiled as being part of a synthesized FileNameKt file
        if callingClassName.hasSuffix("Kt") {
            callingClassName = callingClassName.dropLast(2)
        }
        let callingClass = Class.forName(callingClassName)
        return SkipBundle(callingClass.kotlin as AnyClass)
    }

    /// Creates a relative path to the given bundle URL
    private func relativeBundleURL(path: String) -> SkipURL? {
        let loc: SkipLocalizedStringResource.BundleDescription = location
        switch loc {
        case .main:
            fatalError("main bundle not supported with Skip")
        case .atURL(let url):
            return url.appendingPathComponent(path)
        case .forClass(let cls):
            do {
                let resURL = cls.java.getResource("Resources/" + path)
                return SkipURL(resURL)
            } catch {
                // getResource throws when it cannot find the resource
                return nil
            }
        }
    }

    public var bundleURL: SkipURL {
        let loc: SkipLocalizedStringResource.BundleDescription = location
        switch loc {
        case .main:
            fatalError("main bundle not supported with Skip")
        case .atURL(let url):
            return url
        case .forClass(let cls):
            return relativeBundleURL("resources.lst")!
                .deletingLastPathComponent()
        }
    }

    public var bundlePath: String {
        bundleURL.path
    }

    /// Loads the resources index stored in the `resources.lst` file at the root of the resources folder.
    private func loadResourcePaths() throws -> [String] {
        guard let resourceListURL = try url(forResource: "resources.lst") else {
            return []
        }
        let resourceList = try Data(contentsOf: resourceListURL)
        guard let resourceListString = String(data: resourceList, encoding: String.Encoding.utf8) else {
            return []
        }
        let resourcePaths = resourceListString.split(separator: "\n")
        return resourcePaths
    }

    public var localizations: [String] {
        get throws {
            return try loadResourcePaths()
                .compactMap({ $0.split(separator: "/").first })
                .filter({ $0.hasSuffix(".lproj") })
                .map({ $0.dropLast(".lproj".count) })
        }
    }

    public func path(forResource: String? = nil, ofType: String? = nil, inDirectory: String? = nil, forLocalization: String? = nil) -> String? {
        url(forResource: forResource, withExtension: ofType, subdirectory: inDirectory, localization: forLocalization)?.path
    }

    public func url(forResource: String? = nil, withExtension: String? = nil, subdirectory: String? = nil, localization: String? = nil) -> SkipURL? {
        // similar behavior to: https://github.com/apple/swift-corelibs-foundation/blob/69ab3975ea636d1322ad19bbcea38ce78b65b26a/CoreFoundation/PlugIn.subproj/CFBundle_Resources.c#L1114
        var res = forResource ?? ""
        if let withExtension = withExtension, !withExtension.isEmpty {
            // TODO: is `forResource` is nil, we are expected to find the first file in the bundle whose extension matches
            res += "." + withExtension
        } else {
            if res.isEmpty {
                return nil
            }
        }
        if let localization = localization {
            //let lprojExtension = "lproj" // _CFBundleLprojExtension
            var lprojExtensionWithDot = ".lproj" // _CFBundleLprojExtensionWithDot
            res = localization + lprojExtensionWithDot + "/" + res
        }
        if let subdirectory = subdirectory {
            res = subdirectory + "/" + res
        }

        return relativeBundleURL(path: res)
    }

    public func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
        let table = tableName ?? "Localizable"

        return key // TODO: load localization
    }

}

#endif

// SKIP REPLACE: internal val _SkipFoundationBundle = Bundle(for_ = SkipBundle::class as AnyClass)
let _SkipFoundationBundle = Bundle.module
