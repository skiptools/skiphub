// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
#if !SKIP
import struct Foundation.Data
public typealias Data = Foundation.Data
public typealias PlatformData = Foundation.NSData
#else
public typealias Data = SkipData
public typealias PlatformData = kotlin.ByteArray
#endif


// SKIP REPLACE: @JvmInline public value class SkipData(val rawValue: PlatformData) { companion object { } }
public struct SkipData : RawRepresentable {
    public let rawValue: PlatformData

    public init(rawValue: PlatformData) {
        self.rawValue = rawValue
    }

    public init(_ rawValue: PlatformData) {
        self.rawValue = rawValue
    }
}

#if !SKIP

#else

// SKIP INSERT: public operator fun String.Companion.invoke(contentsOf: URL): String { return contentsOf.rawValue.readText() }

// SKIP INSERT: public operator fun SkipData.Companion.invoke(contentsOf: URL): SkipData { return SkipData.contentsOfURL(url = contentsOf) }

// SKXX INSERT: public fun Data(contentsOf: URL): SkipData { return SkipData.contentsOfURL(url = contentsOf) }

/// A byte buffer in memory.
///
/// This is a `Foundation.Data` wrapper around `kotlin.ByteArray`.
extension SkipData {
//    public init(rawValue: PlatformData) {
//        self.rawValue = rawValue
//    }

    /// static init until constructor overload works
    public static func contentsOfFile(filePath: String) throws -> Data {
        return Data(java.io.File(filePath).readBytes())
    }

    /// static init until constructor overload works
    public static func contentsOfURL(url: URL) throws -> Data {
//        if url.isFileURL {
//            return Data(java.io.File(url.path).readBytes())
//        } else {
//        return Data(url.rawValue.openConnection().getInputStream().readBytes())
//        }

        // this seems to work for both file URLs and network URLs
        return Data(url.rawValue.readBytes())
    }

    /// Foundation uses `count`, Java uses `size`.
    public var count: Int { return rawValue.size }
}

public extension String {
    public static func `init`(contentsOfURL url: URL) throws -> String {
        return url.rawValue.readText()
    }
}

#endif
