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
        if withIntermediateDirectories == true {
            java.nio.file.Files.createDirectories(java.nio.file.Paths.get(path))
        } else {
            java.nio.file.Files.createDirectory(java.nio.file.Paths.get(path))
        }
        if let attributes = attributes {
            setAttributes(attributes, ofItemAtPath: path)
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

    public func setAttributes(_ attributes: [FileAttributeKey : Any], ofItemAtPath path: String) throws {
        #if !SKIP
        try rawValue.setAttributes(attributes, ofItemAtPath: path)
        #else
        for (key, value) in attributes {
            switch key {
            case FileAttributeKey.posixPermissions:
                let number = (value as Number).toInt()
                var permissions = Set<java.nio.file.attribute.PosixFilePermission>()
                if ((number & 256) != 0) { // 0o400
                    permissions.insert(java.nio.file.attribute.PosixFilePermission.OWNER_READ)
                }
                if ((number & 128) != 0) { // 0o200
                    permissions.insert(java.nio.file.attribute.PosixFilePermission.OWNER_WRITE)
                }
                if ((number & 64) != 0) { // 0o100
                    permissions.insert(java.nio.file.attribute.PosixFilePermission.OWNER_EXECUTE)
                }
                if ((number & 32) != 0) { // 0o40
                    permissions.insert(java.nio.file.attribute.PosixFilePermission.GROUP_READ)
                }
                if ((number & 16) != 0) { // 0o20
                    permissions.insert(java.nio.file.attribute.PosixFilePermission.GROUP_WRITE)
                }
                if ((number & 8) != 0) { // 0o10
                    permissions.insert(java.nio.file.attribute.PosixFilePermission.GROUP_EXECUTE)
                }
                if ((number & 4) != 0) { // 0o4
                    permissions.insert(java.nio.file.attribute.PosixFilePermission.OTHERS_READ)
                }
                if ((number & 2) != 0) { // 0o2
                    permissions.insert(java.nio.file.attribute.PosixFilePermission.OTHERS_WRITE)
                }
                if ((number & 1) != 0) { // 0o1
                    permissions.insert(java.nio.file.attribute.PosixFilePermission.OTHERS_EXECUTE)
                }
                java.nio.file.Files.setPosixFilePermissions(java.nio.file.Paths.get(path), permissions.toSet())
            default:
                fatalError("TODO: unsupported file attribute: \(key)")
            }
        }
        #endif
    }

    public func createFile(atPath path: String, contents: Data? = nil, attributes: [FileAttributeKey : Any]? = nil) -> Bool {
        #if !SKIP
        return rawValue.createFile(atPath: path, contents: contents, attributes: attributes)
        #else
        do {
            java.nio.file.Files.write(java.nio.file.Paths.get(path), (contents ?? Data(rawValue: PlatformData(size: 0))).rawValue)
            if let attributes = attributes {
                setAttributes(attributes, ofItemAtPath: path)
            }
            return true
        } catch {
            return false
        }
        #endif
    }

    public func moveItem(atPath path: String, toPath: String) throws {
        #if !SKIP
        try rawValue.moveItem(atPath: path, toPath: toPath)
        #else
        java.nio.file.Files.move(java.nio.file.Paths.get(path), java.nio.file.Paths.get(toPath))
        #endif
    }

    public func moveItem(at path: SkipURL, to: SkipURL) throws {
        #if !SKIP
        try rawValue.moveItem(at: path.rawValue, to: to.rawValue)
        #else
        java.nio.file.Files.move(path.toPath(), to.toPath())
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
        java.nio.file.Files.delete(url.toPath())
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
    init(rawValue: String) {
        self.rawValue = rawValue
    }

    public static let appendOnly: FileAttributeKey = FileAttributeKey(rawValue: "NSFileAppendOnly")
    public static let creationDate: FileAttributeKey = FileAttributeKey(rawValue: "NSFileCreationDate")
    public static let deviceIdentifier: FileAttributeKey = FileAttributeKey(rawValue: "NSFileDeviceIdentifier")
    public static let extensionHidden: FileAttributeKey = FileAttributeKey(rawValue: "NSFileExtensionHidden")
    public static let groupOwnerAccountID: FileAttributeKey = FileAttributeKey(rawValue: "NSFileGroupOwnerAccountID")
    public static let groupOwnerAccountName: FileAttributeKey = FileAttributeKey(rawValue: "NSFileGroupOwnerAccountName")
    public static let hfsCreatorCode: FileAttributeKey = FileAttributeKey(rawValue: "NSFileHFSCreatorCode")
    public static let hfsTypeCode: FileAttributeKey = FileAttributeKey(rawValue: "NSFileHFSTypeCode")
    public static let immutable: FileAttributeKey = FileAttributeKey(rawValue: "NSFileImmutable")
    public static let modificationDate: FileAttributeKey = FileAttributeKey(rawValue: "NSFileModificationDate")
    public static let ownerAccountID: FileAttributeKey = FileAttributeKey(rawValue: "NSFileOwnerAccountID")
    public static let ownerAccountName: FileAttributeKey = FileAttributeKey(rawValue: "NSFileOwnerAccountName")
    public static let posixPermissions: FileAttributeKey = FileAttributeKey(rawValue: "NSFilePosixPermissions")
    public static let protectionKey: FileAttributeKey = FileAttributeKey(rawValue: "NSFileProtectionKey")
    public static let referenceCount: FileAttributeKey = FileAttributeKey(rawValue: "NSFileReferenceCount")
    public static let systemFileNumber: FileAttributeKey = FileAttributeKey(rawValue: "NSFileSystemFileNumber")
    public static let systemFreeNodes: FileAttributeKey = FileAttributeKey(rawValue: "NSFileSystemFreeNodes")
    public static let systemFreeSize: FileAttributeKey = FileAttributeKey(rawValue: "NSFileSystemFreeSize")
    public static let systemNodes: FileAttributeKey = FileAttributeKey(rawValue: "NSFileSystemNodes")
    public static let systemNumber: FileAttributeKey = FileAttributeKey(rawValue: "NSFileSystemNumber")
    public static let systemSize: FileAttributeKey = FileAttributeKey(rawValue: "NSFileSystemSize")
    public static let type: FileAttributeKey = FileAttributeKey(rawValue: "NSFileType")
    public static let busy: FileAttributeKey = FileAttributeKey(rawValue: "NSFileBusy")
}

struct UnableToDeleteFileError : java.io.IOException {
    let path: String
}

struct UnableToCreateDirectory : java.io.IOException {
    let path: String
}

#endif
