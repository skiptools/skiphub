// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
#if !SKIP
import struct Foundation.Data
public typealias Data = Foundation.Data
public typealias PlatformData = Foundation.Data
#else
public typealias Data = SkipData
public typealias PlatformData = kotlin.ByteArray
#endif

public protocol SkipDataProtocol {
    var rawValue: PlatformData { get }
}

public struct SkipData : RawRepresentable, Hashable, SkipDataProtocol {
    public let rawValue: PlatformData

    public init(rawValue: PlatformData) {
        self.rawValue = rawValue
    }

    public init(_ rawValue: PlatformData) {
        self.rawValue = rawValue
    }

    public init(_ skipData: SkipData) {
        self.rawValue = skipData.rawValue
    }
}

#if !SKIP

#else

// SKIP INSERT: public operator fun String.Companion.invoke(contentsOf: SkipURL): String { return contentsOf.rawValue.readText() }

// SKIP INSERT: public operator fun SkipData.Companion.invoke(contentsOf: SkipURL): SkipData { return SkipData.contentsOfURL(url = contentsOf) }


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
    public static func contentsOfURL(url: SkipURL) throws -> Data {
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
    public static func `init`(contentsOfURL url: SkipURL) throws -> String {
        return url.rawValue.readText()
    }
}

public func String(data: SkipData, encoding: StringEncoding) -> String? {
    String(data.rawValue, encoding.rawValue)
}

#endif
