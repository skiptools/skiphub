// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
#if !SKIP
import struct Foundation.URL
public typealias URL = Foundation.URL
public typealias PlatformURL = Foundation.NSURL
#else
public typealias URL = SkipURL
public typealias PlatformURL = java.net.URL
#endif

// MARK: Optional Constructor Skip implementations

#if SKIP
public func SkipURL(string: String) -> SkipURL? {
    return SkipURL(rawValue: PlatformURL(string))
}

public func SkipURL(string: String, relativeTo: SkipURL?) -> SkipURL? {
    return SkipURL(rawValue: PlatformURL(relativeTo?.rawValue, string))
}

public func SkipURL(fileURLWithPath path: String, relativeTo: SkipURL? = nil, isDirectory: Bool? = nil) -> SkipURL {
    // SKIP INSERT: val nil = null
    if (relativeTo != nil) {
        return SkipURL(rawValue: PlatformURL(relativeTo?.rawValue, fileURLWithPath))
    } else {
        return SkipURL(rawValue: PlatformURL("file://" + path)) // TODO: isDirectory handling?
    }
}

public func URL(string: String, relativeTo: SkipURL? = nil) -> SkipURL? {
    SkipURL(string: string, relativeTo: relativeTo)
}

public func URL(fileURLWithPath path: String, relativeTo: SkipURL? = nil, isDirectory: Bool? = nil) -> SkipURL {
    SkipURL(fileURLWithPath: path, relativeTo: relativeTo, isDirectory: isDirectory)
}

public func URL(fileURLWithFileSystemRepresentation path: String, relativeTo: SkipURL?, isDirectory: Bool) -> SkipURL {
    // SKIP INSERT: val nil = null
    if (relativeTo != nil) {
        return SkipURL(rawValue: PlatformURL(relativeTo?.rawValue, path))
    } else {
        return SkipURL(rawValue: PlatformURL("file://" + path)) // TODO: isDirectory handling?
    }
}

#else
extension SkipURL {
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
#endif


/// `SkipURL` is compatible with `Foundation.URL` and wraps either an `NSURL` in Swift or `java.net.URL` in Kotlin.
public struct SkipURL : RawRepresentable, Hashable {
    public var rawValue: PlatformURL
    #if !SKIP
    /// The underlying Foundation.URL
    public var foundationURL: Foundation.URL {
        get { rawValue as Foundation.URL }
        set { rawValue = newValue as PlatformURL }
    }

    public static func ==(lhs: SkipURL, rhs: SkipURL) -> Bool {
        return lhs.rawValue.isEqual(rhs.rawValue)
    }
    #endif

    public init(rawValue: PlatformURL) {
        self.rawValue = rawValue
    }

    public init(_ rawValue: PlatformURL) {
        self.rawValue = rawValue
    }

    /// Create this URL by copying another URL
    public init(_ skipURL: SkipURL) {
        self.rawValue = skipURL.rawValue
    }

    public var description: String {
        #if !SKIP
        return foundationURL.description
        #else
        return rawValue.toString()
        #endif
    }

    public var host: String? {
        #if !SKIP
        return foundationURL.host
        #else
        return rawValue.host
        #endif
    }

    public var hasDirectoryPath: Bool {
        #if !SKIP
        return foundationURL.hasDirectoryPath
        #else
        fatalError("TODO: implement hasDirectoryPath")
        #endif
    }

    public var path: String {
        #if !SKIP
        return foundationURL.path
        #else
        return rawValue.path
        #endif
    }

    public var isDirectory: Bool {
        #if !SKIP
        return foundationURL.hasDirectoryPath
        #else
        fatalError("TODO: implement isDirectory")
        #endif
    }

    public var port: Int? {
        #if !SKIP
        return foundationURL.port
        #else
        fatalError("TODO: implement port")
        #endif
    }

    public var scheme: String? {
        #if !SKIP
        return foundationURL.scheme
        #else
        fatalError("TODO: implement scheme")
        #endif
    }

    public var query: String? {
        #if !SKIP
        return foundationURL.query
        #else
        fatalError("TODO: implement query")
        #endif
    }

    public var user: String? {
        #if !SKIP
        return foundationURL.user
        #else
        fatalError("TODO: implement user")
        #endif
    }

    public var password: String? {
        #if !SKIP
        return foundationURL.password
        #else
        fatalError("TODO: implement password")
        #endif
    }

    public var fragment: String? {
        #if !SKIP
        return foundationURL.fragment
        #else
        fatalError("TODO: implement fragment")
        #endif
    }

    public var standardized: SkipURL {
        #if !SKIP
        return Self(foundationURL.standardized as PlatformURL)
        #else
        fatalError("TODO: implement standardized")
        #endif
    }

    public var absoluteString: String {
        #if !SKIP
        return foundationURL.absoluteString
        #else
        return rawValue.toExternalForm()
        #endif
    }

    public var lastPathComponent: String {
        #if !SKIP
        return foundationURL.lastPathComponent
        #else
        return rawValue.path.split("/").last()
        #endif
    }

    public var pathExtension: String {
        #if !SKIP
        return foundationURL.pathExtension
        #else
        return lastPathComponent?.split(".")?.last() ?? ""
        #endif
    }

    public var isFileURL: Bool {
        #if !SKIP
        return foundationURL.isFileURL
        #else
        return rawValue.`protocol` == "file"
        #endif
    }

    #if SKIP
    // Convert this URL into a java.ui.File
    public func toFile() -> java.io.File {
        java.io.File(rawValue.toURI())
    }
    #endif

    public var pathComponents: [String] {
        #if !SKIP
        return foundationURL.pathComponents
        #else
        fatalError("TODO: implement pathComponents")
        #endif
    }

    public var relativePath: String {
        #if !SKIP
        return foundationURL.relativePath
        #else
        fatalError("TODO: implement relativePath")
        #endif
    }

    public var relativeString: String {
        #if !SKIP
        return foundationURL.relativeString
        #else
        fatalError("TODO: implement relativeString")
        #endif
    }

    public var standardizedFileURL: SkipURL {
        #if !SKIP
        return Self(foundationURL.standardizedFileURL as PlatformURL)
        #else
        fatalError("TODO: implement standardizedFileURL")
        #endif
    }

    public var absoluteURL: SkipURL {
        #if !SKIP
        return Self(foundationURL.absoluteURL as PlatformURL)
        #else
        fatalError("TODO: implement absoluteURL")
        #endif
    }

    public var baseURL: SkipURL? {
        #if !SKIP
        return foundationURL.baseURL.flatMap({ .init(rawValue: $0 as PlatformURL) })
        #else
        fatalError("TODO: implement baseURL")
        #endif
    }

    public func appendingPathComponent(_ pathComponent: String) -> SkipURL {
        #if !SKIP
        return Self(foundationURL.appendingPathComponent(pathComponent) as PlatformURL)
        #else
        fatalError("TODO: implement appendingPathComponent")
        #endif
    }

    public func appendingPathComponent(_ pathComponent: String, isDirectory: Bool) -> SkipURL {
        #if !SKIP
        return Self(foundationURL.appendingPathComponent(pathComponent, isDirectory: isDirectory) as PlatformURL)
        #else
        fatalError("TODO: implement appendingPathComponent")
        #endif
    }

    public func deletingLastPathComponent() -> SkipURL {
        #if !SKIP
        return Self(foundationURL.deletingLastPathComponent() as PlatformURL)
        #else
        fatalError("TODO: implement deletingLastPathComponent")
        #endif
    }

    public func appendingPathExtension(_ pathExtension: String) -> SkipURL {
        #if !SKIP
        return Self(foundationURL.appendingPathExtension(pathExtension) as PlatformURL)
        #else
        fatalError("TODO: implement appendingPathExtension")
        #endif
    }

    public func deletingPathExtension() -> SkipURL {
        #if !SKIP
        return Self(foundationURL.deletingPathExtension() as PlatformURL)
        #else
        fatalError("TODO: implement deletingPathExtension")
        #endif
    }

    public func resolvingSymlinksInPath() -> SkipURL {
        #if !SKIP
        return Self(foundationURL.resolvingSymlinksInPath() as PlatformURL)
        #else
        let originalPath = java.nio.file.Paths.get(path)
        if !java.nio.file.Files.isSymbolicLink(originalPath) {
            return self // not a link
        } else {
            let normalized = java.nio.file.Files.readSymbolicLink(originalPath).normalize()
            return SkipURL(rawValue: normalized.toUri().toURL())
        }
        #endif
    }

    public func checkResourceIsReachable() throws -> Bool {
        #if !SKIP
        return try self.foundationURL.checkResourceIsReachable()
        #else
        fatalError("TODO: implement checkResourceIsReachable")
        #endif
    }

    public mutating func removeAllCachedResourceValues() {
        #if !SKIP
        foundationURL.removeAllCachedResourceValues()
        #else
        fatalError("TODO: implement removeAllCachedResourceValues")
        #endif
    }

    #if !SKIP
    public func resourceValues(forKeys keys: Set<URLResourceKey>) throws -> URLResourceValues {
        #if !SKIP
        return try foundationURL.resourceValues(forKeys: keys)
        #else
        fatalError("TODO: implement resourceValues")
        #endif
    }

    public mutating func setResourceValues(_ values: URLResourceValues) throws -> Void {
        #if !SKIP
        try foundationURL.setResourceValues(values)
        #else
        fatalError("TODO: implement setResourceValues")
        #endif
    }
    #endif
}
