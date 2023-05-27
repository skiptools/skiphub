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
public typealias StringProtocol = Swift.StringProtocol
public typealias DataWritingOptions = Data.WritingOptions
#else
public typealias Data = SkipData
public typealias PlatformData = kotlin.ByteArray
public typealias DataProtocol = SkipDataProtocol
public typealias StringProtocol = kotlin.CharSequence
public typealias DataWritingOptions = SkipData.WritingOptions
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

    #if SKIP
    public init(_ bytes: [Int]) {
        self.rawValue = PlatformData(size: bytes.count, init: {
            bytes[$0].toByte()
        })
    }
    #endif

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

    static func ==(lhs: SkipData, rhs: SkipData) -> Bool {
        #if SKIP
        return lhs.rawValue.contentEquals(rhs.rawValue)
        #else
        return lhs.rawValue == rhs.rawValue
        #endif
    }

    public struct WritingOptions : OptionSet, Sendable {
        public let rawValue: UInt
        public init(rawValue: UInt) {
            self.rawValue = rawValue
        }

        public static let atomic = WritingOptions(rawValue: UInt(1 << 0))
    }

}

public extension Data {
    /// The UTF8-encoded String for this data
    var utf8String: String? {
        String(data: self, encoding: .utf8)
    }
}


#if SKIP

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
        //if url.isFileURL {
        //    return Data(java.io.File(url.path).readBytes())
        //} else {
        //    return Data(url.rawValue.openConnection().getInputStream().readBytes())
        //}

        // this seems to work for both file URLs and network URLs
        return Data(url.rawValue.readBytes())
    }

    /// Foundation uses `count`, Java uses `size`.
    public var count: Int { return rawValue.size }
}

public extension StringProtocol {
    public func lowercased() -> String { description.lowercased() }
    public func uppercased() -> String { description.uppercased() }

    public func hasPrefix(_ string: String) -> Bool { description.hasPrefix(string) }
    public func hasSuffix(_ string: String) -> Bool { description.hasSuffix(string) }
}

public func String(data: SkipData, encoding: String.Encoding) -> String? {
    String(data.rawValue, encoding.rawValue)
}

#endif
