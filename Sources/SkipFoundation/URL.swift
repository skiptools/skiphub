// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
#if SKIP
/// `URL` aliases to `SkipURL` type and wraps `java.net.URL`
public typealias URL = SkipURL
/// The wrapped type for Kotlin's URL equivalent
public typealias PlatformURL = java.net.URL
#else
/// `SkipFoundation.URL` is an alias to `Foundation.URL`
public typealias URL = Foundation.URL
/// The wrapped type for Swift URL is only included in Swift debug builds
internal typealias PlatformURL = Foundation.URL
#endif


// override the Kotlin type to be public while keeping the Swift version internal:
// SKIP DECLARE: class SkipURL: RawRepresentable<PlatformURL>, MutableStruct
internal struct SkipURL : RawRepresentable, Hashable, CustomStringConvertible {
    /// `SkipURL` wraps either a `Foundation.URL` in Swift or `java.net.URL` in Kotlin.
    var rawValue: PlatformURL
    #if SKIP
    private let isDirectoryFlag: Bool?
    public let baseURL: SkipURL?

    init(_ rawValue: PlatformURL, isDirectory: Bool? = nil, baseURL: SkipURL? = nil) {
        self.rawValue = rawValue
        self.isDirectoryFlag = isDirectory
        self.baseURL = baseURL
    }

    init(_ skipURL: SkipURL) {
        self.rawValue = skipURL.rawValue
        self.isDirectoryFlag = skipURL.isDirectoryFlag
        self.baseURL = skipURL.baseURL
    }
    #else
    init(_ rawValue: PlatformURL) {
        self.rawValue = rawValue
    }

    init(rawValue: PlatformURL) {
        self.rawValue = rawValue
    }
    #endif

    /// This is an overloaded form of three separate `URL.fileURLWithPath` constructors. We defer to those on nil, because they have subtle behavior differences.
    public init(fileURLWithPath path: String, isDirectory: Bool? = nil, relativeTo base: SkipURL? = nil) {
        #if SKIP
        self.rawValue = PlatformURL("file://" + path) // TODO: escaping
        self.baseURL = base // TODO: base resolution
        self.isDirectoryFlag = isDirectory ?? path.hasSuffix("/") // TODO: should we hit the file system like NSURL does?
        #else
        if let isDirectory = isDirectory {
            if let base = base {
                self.rawValue = Foundation.URL(fileURLWithPath: path, isDirectory: isDirectory, relativeTo: base.rawValue)
            } else {
                self.rawValue = Foundation.URL(fileURLWithPath: path, isDirectory: isDirectory)
            }
        } else {
            if let base = base {
                self.rawValue = Foundation.URL(fileURLWithPath: path, relativeTo: base.rawValue)
            } else {
                self.rawValue = Foundation.URL(fileURLWithPath: path)
            }
        }
        #endif
    }

    public var description: String {
        return rawValue.description
    }

    #if SKIP
    /// Converts this URL to a java.nio.file.Path
    public func toPath() -> java.nio.file.Path {
        return java.nio.file.Paths.get(rawValue.toURI())
    }
    #endif

    #if !SKIP
    /// The base URL. It is provided as a member in SKIP but a calculated property in Swift
    public var baseURL: SkipURL? {
        return foundationURL.baseURL.flatMap({ .init(rawValue: $0 as PlatformURL) })
    }
    #endif

    /// The host component of a URL if the URL conforms to RFC 1808 (the most common form of URL), otherwise nil.
    public var host: String? {
        #if SKIP
        return rawValue.host
        #else
        return foundationURL.host
        #endif
    }

    /// A Boolean that is true if the URL path represents a directory.
    public var hasDirectoryPath: Bool {
        #if SKIP
        return self.isDirectoryFlag == true
        #else
        return foundationURL.hasDirectoryPath
        #endif
    }

    /// The path component of the URL if the URL conforms to RFC 1808 (the most common form of URL), otherwise an empty string.
    public var path: String {
        #if SKIP
        return rawValue.path
        #else
        return foundationURL.path
        #endif
    }

    /// The port component of the URL if the URL conforms to RFC 1808 (the most common form of URL), otherwise nil.
    public var port: Int? {
        #if SKIP
        fatalError("TODO: implement port")
        #else
        return foundationURL.port
        #endif
    }

    /// The scheme of the URL.
    public var scheme: String? {
        #if SKIP
        fatalError("TODO: implement scheme")
        #else
        return foundationURL.scheme
        #endif
    }

    /// The query of the URL if the URL conforms to RFC 1808 (the most common form of URL), otherwise nil.
    public var query: String? {
        #if SKIP
        fatalError("TODO: implement query")
        #else
        return foundationURL.query
        #endif
    }

    /// The user component of the URL if the URL conforms to RFC 1808 (the most common form of URL), otherwise nil.
    public var user: String? {
        #if SKIP
        fatalError("TODO: implement user")
        #else
        return foundationURL.user
        #endif
    }

    /// The password component of the URL if the URL conforms to RFC 1808 (the most common form of URL), otherwise nil.
    public var password: String? {
        #if SKIP
        fatalError("TODO: implement password")
        #else
        return foundationURL.password
        #endif
    }

    /// The fragment component of the URL if the URL conforms to RFC 1808 (the most common form of URL), otherwise nil.
    public var fragment: String? {
        #if SKIP
        fatalError("TODO: implement fragment")
        #else
        return foundationURL.fragment
        #endif
    }

    /// A version of the URL with any instances of “..” or “.” removed from its path.
    public var standardized: SkipURL {
        #if SKIP
        fatalError("TODO: implement standardized")
        #else
        return Self(foundationURL.standardized as PlatformURL)
        #endif
    }

    /// The absolute string for the URL.
    public var absoluteString: String {
        #if SKIP
        return rawValue.toExternalForm()
        #else
        return foundationURL.absoluteString
        #endif
    }

    /// The last path component of the URL, or an empty string if the path is an empty string.
    public var lastPathComponent: String {
        #if SKIP
        return pathComponents.last()
        #else
        return foundationURL.lastPathComponent
        #endif
    }

    /// The path extension of the URL, or an empty string if the path is an empty string.
    public var pathExtension: String {
        #if SKIP
        let parts = Array((lastPathComponent ?? "").split("."))
        if parts.count >= 2 {
            return parts.last!
        } else {
            return ""
        }
        #else
        return foundationURL.pathExtension
        #endif
    }

    /// A Boolean that is true if the scheme is file:.
    public var isFileURL: Bool {
        #if SKIP
        return rawValue.`protocol` == "file"
        #else
        return foundationURL.isFileURL
        #endif
    }

    /// The path components of the URL, or an empty array if the path is an empty string.
    public var pathComponents: [String] {
        #if SKIP
        return Array(rawValue.path.split("/")).filter({ !$0.isEmpty })
        #else
        return foundationURL.pathComponents
        #endif
    }

    /// The relative path of the URL if the URL conforms to RFC 1808 (the most common form of URL), otherwise nil.
    public var relativePath: String {
        #if SKIP
        fatalError("TODO: implement relativePath")
        #else
        return foundationURL.relativePath
        #endif
    }

    /// The relative portion of a URL.
    public var relativeString: String {
        #if SKIP
        fatalError("TODO: implement relativeString")
        #else
        return foundationURL.relativeString
        #endif
    }

    /// A standardized version of the path of a file URL.
    public var standardizedFileURL: SkipURL {
        #if SKIP
        fatalError("TODO: implement standardizedFileURL")
        #else
        return Self(foundationURL.standardizedFileURL as PlatformURL)
        #endif
    }

    /// The absolute URL.
    public var absoluteURL: SkipURL {
        #if SKIP
        fatalError("TODO: implement absoluteURL")
        #else
        return Self(foundationURL.absoluteURL as PlatformURL)
        #endif
    }

    /// Returns a URL by appending the specified path component to self.
    public func appendingPathComponent(_ pathComponent: String) -> SkipURL {
        #if SKIP
        var url = self.rawValue.toExternalForm()
        if !url.hasSuffix("/") { url = url + "/" }
        url = url + pathComponent
        return SkipURL(rawValue: PlatformURL(url))
        #else
        return Self(foundationURL.appendingPathComponent(pathComponent) as PlatformURL)
        #endif
    }

    /// Returns a URL by appending the specified path component to self.
    public func appendingPathComponent(_ pathComponent: String, isDirectory: Bool) -> SkipURL {
        #if SKIP
        var url = self.rawValue.toExternalForm()
        if !url.hasSuffix("/") { url = url + "/" }
        url = url + pathComponent
        return SkipURL(rawValue: PlatformURL(url), isDirectory: isDirectory)
        #else
        return Self(foundationURL.appendingPathComponent(pathComponent, isDirectory: isDirectory) as PlatformURL)
        #endif
    }

    /// Returns a URL constructed by removing the last path component of self.
    public func deletingLastPathComponent() -> SkipURL {
        #if SKIP
        var url = self.rawValue.toExternalForm()
        while url.hasSuffix("/") && !url.isEmpty {
            url = url.dropLast(1)
        }
        while !url.hasSuffix("/") && !url.isEmpty {
            url = url.dropLast(1)
        }
        return SkipURL(rawValue: PlatformURL(url))
        #else
        return Self(foundationURL.deletingLastPathComponent() as PlatformURL)
        #endif
    }

    /// Returns a URL by appending the specified path extension to self.
    public func appendingPathExtension(_ pathExtension: String) -> SkipURL {
        #if SKIP
        fatalError("TODO: implement appendingPathExtension")
        #else
        return Self(foundationURL.appendingPathExtension(pathExtension) as PlatformURL)
        #endif
    }

    /// Returns a URL constructed by removing any path extension.
    public func deletingPathExtension() -> SkipURL {
        #if SKIP
        let ext = pathExtension
        var url = self.rawValue.toExternalForm()
        while url.hasSuffix("/") {
            url = url.dropLast(1)
        }
        if url.hasSuffix("." + ext) {
            url = url.dropLast(ext.count + 1)
        }
        return SkipURL(rawValue: PlatformURL(url))
        #else
        return Self(foundationURL.deletingPathExtension() as PlatformURL)
        #endif
    }

    /// Resolves any symlinks in the path of a file URL.
    public func resolvingSymlinksInPath() -> SkipURL {
        #if SKIP
        let originalPath = toPath()
        if !java.nio.file.Files.isSymbolicLink(originalPath) {
            return self // not a link
        } else {
            let normalized = java.nio.file.Files.readSymbolicLink(originalPath).normalize()
            return SkipURL(rawValue: normalized.toUri().toURL())
        }
        #else
        return Self(foundationURL.resolvingSymlinksInPath() as PlatformURL)
        #endif
    }

    /// Returns whether the URL’s resource exists and is reachable.
    public func checkResourceIsReachable() throws -> Bool {
        #if SKIP
        // check whether the resource can be reached by opening and closing a connection
        rawValue.openConnection().getInputStream().close()
        return true
        #else
        return try self.foundationURL.checkResourceIsReachable()
        #endif
    }

    /// Removes all cached resource values and all temporary resource values from the URL object.
    ///
    /// This method is currently applicable only to URLs for file system resources.
    public mutating func removeAllCachedResourceValues() {
        #if SKIP
        fatalError("TODO: implement removeAllCachedResourceValues")
        #else
        foundationURL.removeAllCachedResourceValues()
        #endif
    }

    #if !SKIP
    /// Return a collection of resource values identified by the given resource keys.
    ///
    /// This method first checks if the URL object already caches the resource value. If so, it returns the cached resource value to the caller. If not, then this method synchronously obtains the resource value from the backing store, adds the resource value to the URL object's cache, and returns the resource value to the caller. The type of the resource value varies by resource property (see resource key definitions). If this method does not throw and the resulting value in the `URLResourceValues` is populated with nil, it means the resource property is not available for the specified resource and no errors occurred when determining the resource property was not available. This method is currently applicable only to URLs for file system resources.
    ///
    /// When this function is used from the main thread, resource values cached by the URL (except those added as temporary properties) are removed the next time the main thread's run loop runs. `func removeCachedResourceValue(forKey:)` and `func removeAllCachedResourceValues()` also may be used to remove cached resource values.
    ///
    /// Only the values for the keys specified in `keys` will be populated.
    public func resourceValues(forKeys keys: Set<URLResourceKey>) throws -> URLResourceValues {
        #if SKIP
        fatalError("TODO: implement resourceValues")
        #else
        return try foundationURL.resourceValues(forKeys: keys)
        #endif
    }

    /// Sets the resource value identified by a given resource key.
    ///
    /// This method writes the new resource values out to the backing store. Attempts to set a read-only resource property or to set a resource property not supported by the resource are ignored and are not considered errors. This method is currently applicable only to URLs for file system resources.
    ///
    /// `URLResourceValues` keeps track of which of its properties have been set. Those values are the ones used by this function to determine which properties to write.
    public mutating func setResourceValues(_ values: URLResourceValues) throws -> Void {
        #if SKIP
        fatalError("TODO: implement setResourceValues")
        #else
        try foundationURL.setResourceValues(values)
        #endif
    }
    #endif
}


// MARK: Optional Constructors

#if SKIP

public struct URLResourceKey : Hashable, Equatable, RawRepresentable {
    public let rawValue: String

    public init(_ rawValue: String) {
        self.rawValue = rawValue
    }

    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

// The optional constructors must be implemented as global functions as Kotlin has no support for failable initializers

public func URL(string: String, relativeTo baseURL: SkipURL? = nil) -> SkipURL? {
    do {
        let url = PlatformURL(relativeTo?.rawValue, string) // throws on malformed
        return SkipURL(url, isDirectory: nil, baseURL: baseURL)
    } catch {
        // e.g., malformed URL
        return nil
    }
}

//public func URL(fileURLWithPath path: String, relativeTo: SkipURL? = nil, isDirectory: Bool? = nil) -> SkipURL {
//    SkipURL(fileURLWithPath: path, relativeTo: relativeTo, isDirectory: isDirectory)
//}

//public func URL(fileURLWithFileSystemRepresentation path: String, relativeTo: SkipURL?, isDirectory: Bool) -> SkipURL {
//    // SKIP INSERT: val nil = null
//    if (relativeTo != nil) {
//        return SkipURL(rawValue: PlatformURL(relativeTo?.rawValue, path))
//    } else {
//        return SkipURL(rawValue: PlatformURL("file://" + path)) // TODO: isDirectory handling?
//    }
//}

#else

// MARK: Foundation.URL compatibility

extension SkipURL {

    /// The underlying Foundation.URL for the Swift target
    internal var foundationURL: Foundation.URL {
        get { rawValue as Foundation.URL }
        set { rawValue = newValue as PlatformURL }
    }

    public init?(string: String) {
        guard let url = Foundation.URL(string: string) else {
            return nil
        }
        self.rawValue = url as PlatformURL
    }

    public init?(string: String, relativeTo: SkipURL?) {
        guard let url = Foundation.URL(string: string, relativeTo: relativeTo?.rawValue as Foundation.URL?) else {
            return nil
        }
        self.rawValue = url as PlatformURL
    }

    public init(fileURLWithPath path: String) {
        self.rawValue = PlatformURL(fileURLWithPath: path)
    }

    public init(fileURLWithPath path: String, relativeTo: SkipURL? = nil) {
        self.rawValue = PlatformURL(fileURLWithPath: path, relativeTo: relativeTo?.rawValue as Foundation.URL?)
    }

    public init(fileURLWithPath path: String, isDirectory: Bool, relativeTo: SkipURL? = nil) {
        self.rawValue = PlatformURL(fileURLWithPath: path, isDirectory: isDirectory, relativeTo: relativeTo?.rawValue as Foundation.URL?)
    }

    public init(fileURLWithFileSystemRepresentation path: String, isDirectory: Bool, relativeTo: SkipURL? = nil) {
        self.rawValue = PlatformURL(fileURLWithPath: path, isDirectory: isDirectory, relativeTo: relativeTo?.rawValue as Foundation.URL?)
    }
}

extension Foundation.URL {
    /// Shim to support parity for test cases
    internal var foundationURL: Foundation.URL { self }
}

#endif
