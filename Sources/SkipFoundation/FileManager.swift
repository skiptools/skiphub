// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
#if !SKIP
import class Foundation.FileManager
public typealias FileManager = Foundation.FileManager
public typealias PlatformFileManager = Foundation.FileManager
#else
public typealias FileManager = SkipFileManager
#endif

/// An interface to the file system compatible with ``Foundation.FileManager``
public final class SkipFileManager {
    #if SKIP
    /// Returns the shared single file manager
    public static var `default` = SkipFileManager()
    #else
    public static var `default` = SkipFileManager(rawValue: FileManager.default)

    init(rawValue: FileManager) {
        self.rawValue = rawValue
    }

    let rawValue: FileManager
    #endif

    public func createSymbolicLink(at url: SkipURL, withDestinationURL destinationURL: SkipURL) throws {
        #if !SKIP
        return try rawValue.createSymbolicLink(at: url.foundationURL, withDestinationURL: destinationURL.foundationURL)
        #else
        fatalError("SkipFileManager.createSymbolicLink unavailable")
        #endif
    }

    public func createDirectory(at url: SkipURL, withIntermediateDirectories: Bool, attributes: [FileAttributeKey : Any]? = nil) throws {
        #if !SKIP
        try rawValue.createDirectory(at: url.foundationURL, withIntermediateDirectories: withIntermediateDirectories, attributes: attributes)
        #else
        // TODO: attributes
        if (java.io.File(url.path).mkdir() != true) {
            throw UnableToCreateDirectory(path: url.path)
        }
        #endif
    }

    public func createDirectory(atPath path: String, withIntermediateDirectories: Bool, attributes: [FileAttributeKey : Any]? = nil) throws {
        #if !SKIP
        return try rawValue.createDirectory(atPath: path, withIntermediateDirectories: withIntermediateDirectories, attributes: attributes)
        #else
        fatalError("SkipFileManager.createDirectory unavailable")
        #endif
    }

    public func attributesOfItem(atPath path: String) throws -> [FileAttributeKey: Any] {
        #if !SKIP
        return try rawValue.attributesOfItem(atPath: path)
        #else
        fatalError("SkipFileManager.attributesOfItem unavailable")
        #endif
    }

    public func createFile(atPath: String, contents: Data? = nil, attributes: [FileAttributeKey : Any]? = nil) -> Bool {
        #if !SKIP
        return rawValue.createFile(atPath: atPath, contents: contents, attributes: attributes)
        #else
        // TODO: attributes
        do {
            let data: Data = contents ?? Data(rawValue: PlatformData(size: 0))
            let bytes = data.rawValue
            java.io.File(atPath).writeBytes(bytes)
            return true
        } catch {
            return false
        }
        #endif
    }

    @available(*, unavailable, message: "changeCurrentDirectoryPath is unavailable in Skip: the current directory cannot be changed in the JVM")
    public func changeCurrentDirectoryPath(_ path: String) -> Bool {
        #if !SKIP
        return rawValue.changeCurrentDirectoryPath(path)
        #else
        fatalError("SkipFileManager.changeCurrentDirectoryPath unavailable")
        #endif
    }

    public var currentDirectoryPath: String {
        #if !SKIP
        return rawValue.currentDirectoryPath
        #else
        return System.getProperty("user.dir")
        #endif
    }

    public func removeItem(atPath path: String) throws {
        #if !SKIP
        try rawValue.removeItem(atPath: path)
        #else
        if (java.io.File(path).delete() != true) {
            throw UnableToDeleteFileError(path: path)
        }
        #endif
    }

    public func removeItem(at url: SkipURL) throws {
        #if !SKIP
        try rawValue.removeItem(at: url.foundationURL)
        #else
        if (java.io.File(url.path).delete() != true) {
            throw UnableToDeleteFileError(path: url.path)
        }
        #endif
    }

    #if SKIP
    // SKIP REPLACE: data class UnableToDeleteFileError(val path: String) : java.io.IOException() { }
    struct UnableToDeleteFileError : java.io.IOException {
        let path: String
    }

    // SKIP REPLACE: data class UnableToCreateDirectory(val path: String) : java.io.IOException() { }
    struct UnableToCreateDirectory : java.io.IOException {
        let path: String
    }

    #endif
}

#if SKIP
/// The system temporary folder
public func NSTemporaryDirectory() -> String {
    return java.lang.System.getProperty("java.io.tmpdir")
}

/// The user's home directory.
public func NSHomeDirectory() -> String {
    return java.lang.System.getProperty("user.home")
}

/// The current user name.
public func NSUserName() -> String {
    return java.lang.System.getProperty("user.name")
}

public struct FileAttributeKey : RawRepresentable, Hashable {
    public let rawValue: String
}

#endif
