// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
#if !SKIP
import struct Foundation.Data
public typealias Data = Foundation.Data
public typealias PlatformData = Foundation.Data
public typealias DataProtocol = Foundation.DataProtocol
#else
public typealias Data = SkipData
public typealias PlatformData = kotlin.ByteArray
public typealias DataProtocol = SkipDataProtocol
#endif

public protocol SkipDataProtocol {
    var rawValue: PlatformData { get }
}

// override the Kotlin type to be public while keeping the Swift version internal:
// SKIP DECLARE: class SkipData: RawRepresentable<PlatformData>, MutableStruct, SkipDataProtocol
internal struct SkipData : RawRepresentable, Hashable, SkipDataProtocol, CustomStringConvertible {
    public var rawValue: PlatformData

    public init(rawValue: PlatformData) {
        self.rawValue = rawValue
    }

    public init(_ rawValue: PlatformData) {
        self.rawValue = rawValue
    }

    public init(_ skipData: SkipData) {
        self.rawValue = skipData.rawValue
    }

    var description: String {
        return rawValue.description
    }

    public init() {
        #if SKIP
        self.rawValue = PlatformData(size: 0)
        #else
        self.rawValue = PlatformData(count: 0)
        #endif
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

    public func lowercased() -> String { toLowerCase() }
    public func uppercased() -> String { toUpperCase() }
}

public func String(data: SkipData, encoding: String.Encoding) -> String? {
    String(data.rawValue, encoding.rawValue)
}

#endif
