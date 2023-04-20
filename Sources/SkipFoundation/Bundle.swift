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
public typealias PlatformBundle = java.lang.Class<Any>
#endif

public struct SkipBundle : Hashable, RawRepresentable {
    public let rawValue: PlatformBundle

    public init(rawValue: PlatformBundle) {
        self.rawValue = rawValue
    }

    public init(_ rawValue: PlatformBundle) {
        self.rawValue = rawValue
    }
}

#if !SKIP

extension PlatformBundle {
    /// The location of a bundle to use for looking up localized strings, such as the main bundle, or a bundle at a specific file URL.
    @available(macOS 13, iOS 16, tvOS 16, watchOS 8, *)
    public var location: LocalizedStringResource.BundleDescription {
        .atURL(bundleURL)
    }
}

#else

// SKXX INSERT: public operator fun SkipBundle.Companion.invoke(contentsOf: URL): SkipBundle { return SkipBundle(TODO) }

extension SkipBundle {
    /// Returns the description for this bundle, which in the case of Java, is the bundle itself
    public var location: SkipBundle? {
        return self
    }

    // FIXME: this probably won't return what we expect, since the resources may live in another classloader
    public var resourceURL: SkipURL? {
        get {
            var url: java.net.URL? = rawValue.getResource(".")
            if (url != nil) {
                return SkipURL(url)
            } else {
                return nil
            }
        }
    }

    public func url(forResource: String, withExtension: String?, subdirectory: String?, localization: String?) -> URL? {
        // similar behavior to: https://github.com/apple/swift-corelibs-foundation/blob/69ab3975ea636d1322ad19bbcea38ce78b65b26a/CoreFoundation/PlugIn.subproj/CFBundle_Resources.c#L1114
        var res = forResource
        if (withExtension != nil) {
            res += "." + withExtension
        }
        if (localization != nil) {
            //let lprojExtension = "lproj" // _CFBundleLprojExtension
            var lprojExtensionWithDot = ".lproj" // _CFBundleLprojExtensionWithDot
            res = localization + lprojExtensionWithDot + "/" + res
        }
        if (subdirectory != nil) {
            res = subdirectory + "/" + res
        }
        var url: java.net.URL? = rawValue.getResource(res)
        if (url != nil) {
            return SkipURL(url)
        } else {
            return nil
        }
    }
}

#endif

