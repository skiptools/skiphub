// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
#if !SKIP
import class Foundation.FileManager
public typealias FileManager = Foundation.FileManager
internal typealias PlatformFileManager = Foundation.FileManager
#else
public typealias FileManager = SkipFileManager
#endif

// SKIP DECLARE: open class SkipFileManager
/// An interface to the file system compatible with ``Foundation.FileManager``
internal class SkipFileManager {
#if SKIP
    /// Returns the shared single file manager
    public static var `default` = SkipFileManager()
#else
    static var `default` = SkipFileManager(rawValue: FileManager.default)

    init(rawValue: FileManager) {
        self.rawValue = rawValue
    }

    let rawValue: FileManager
#endif
}

extension SkipFileManager {
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
        if withIntermediateDirectories == true {
            java.nio.file.Files.createDirectories(url.toPath())
        } else {
            java.nio.file.Files.createDirectory(url.toPath())
        }
        #endif
    }

    public func createDirectory(atPath path: String, withIntermediateDirectories: Bool, attributes: [FileAttributeKey : Any]? = nil) throws {
        #if !SKIP
        return try rawValue.createDirectory(atPath: path, withIntermediateDirectories: withIntermediateDirectories, attributes: attributes)
        #else
        // TODO: attributes
        if withIntermediateDirectories == true {
            java.nio.file.Files.createDirectories(java.nio.file.Paths.get(path))
        } else {
            java.nio.file.Files.createDirectory(java.nio.file.Paths.get(path))
        }
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

    public func fileExists(atPath path: String) -> Bool {
        #if !SKIP
        return rawValue.fileExists(atPath: path)
        #else
        return java.nio.file.Files.exists(java.nio.file.Paths.get(path))
        #endif
    }

    public func fileExists(atPath path: String, isDirectory: inout ObjCBool) -> Bool {
        #if !SKIP
        return rawValue.fileExists(atPath: path, isDirectory: &isDirectory)
        #else
        let p = java.nio.file.Paths.get(path)
        if java.nio.file.Files.exists(p) {
            isDirectory = ObjCBool(java.nio.file.Files.isDirectory(p))
            return true
        } else {
            return false
        }
        #endif
    }

    public func isReadableFile(atPath path: String) -> Bool {
        #if !SKIP
        return rawValue.isReadableFile(atPath: path)
        #else
        return java.nio.file.Files.isReadable(java.nio.file.Paths.get(path))
        #endif
    }

    public func isExecutableFile(atPath path: String) -> Bool {
        #if !SKIP
        return rawValue.isExecutableFile(atPath: path)
        #else
        return java.nio.file.Files.isExecutable(java.nio.file.Paths.get(path))
        #endif
    }

    public func isDeletableFile(atPath path: String) -> Bool {
        #if !SKIP
        return rawValue.isDeletableFile(atPath: path)
        #else
        if !isWritableFile(atPath: path) {
            return false
        }
        let permissions = java.nio.file.Files.getPosixFilePermissions(java.nio.file.Paths.get(path))
        let ownerWritable = java.nio.file.attribute.PosixFilePermissions.fromString("rw-------")
        if !permissions.containsAll(ownerWritable) {
            return false
        }
        return true
        #endif
    }

    public func isWritableFile(atPath path: String) -> Bool {
        #if !SKIP
        return rawValue.isWritableFile(atPath: path)
        #else
        return java.nio.file.Files.isWritable(java.nio.file.Paths.get(path))
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

    public func contentsOfDirectory(at url: SkipURL, includingPropertiesForKeys: [URLResourceKey]?) throws -> [SkipURL] {
        #if !SKIP
        return try rawValue.contentsOfDirectory(at: url.rawValue, includingPropertiesForKeys: includingPropertiesForKeys)
            .map({ SkipURL($0) })
        #else
        // https://developer.android.com/reference/kotlin/java/nio/file/Files
        let files = java.nio.file.Files.list(url.toPath()).collect(java.util.stream.Collectors.toList())

        let contents = files.map { SkipURL($0.toUri().toURL()) }
        return Array(contents)
        #endif
    }
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

struct UnableToDeleteFileError : java.io.IOException {
    let path: String
}

struct UnableToCreateDirectory : java.io.IOException {
    let path: String
}

#endif
