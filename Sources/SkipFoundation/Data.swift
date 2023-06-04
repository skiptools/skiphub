// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
#if !SKIP
@_implementationOnly import struct Foundation.Data
@_implementationOnly import protocol Foundation.DataProtocol
internal typealias PlatformData = Foundation.Data
internal typealias PlatformDataProtocol = Foundation.DataProtocol
public typealias StringProtocol = Swift.StringProtocol
#else
public typealias PlatformData = kotlin.ByteArray
public typealias StringProtocol = kotlin.CharSequence
internal typealias PlatformDataProtocol = kotlin.ByteArray
#endif

public protocol DataProtocol {
    #if SKIP
    var platformData: any PlatformDataProtocol { get }
    #endif
}

/// A byte buffer in memory.
public struct Data : Hashable, DataProtocol, CustomStringConvertible {
    internal var rawValue: PlatformData

    internal var platformData: any PlatformDataProtocol {
        return rawValue
    }

    #if !SKIP
    internal init(rawValue: PlatformData) {
        self.rawValue = rawValue
    }
    #else
    public init(rawValue: PlatformData) {
        self.rawValue = rawValue
    }
    #endif

    public init(_ data: Data) {
        self.rawValue = data.rawValue
    }

    public init(_ bytes: [UInt8]) {
        #if !SKIP
        self.rawValue = PlatformData(bytes)
        #else
        self.rawValue = PlatformData(size: bytes.count, init: {
            bytes[$0].toByte()
        })
        #endif
    }

    // Platform declaration clash: The following declarations have the same JVM signature (<init>(Lskip/lib/Array;)V):
    //public init(_ bytes: [Int]) {
    //    self.rawValue = PlatformData(size: bytes.count, init: {
    //        bytes[$0].toByte()
    //    })
    //}

    public var description: String {
        return rawValue.description
    }

    /// A UTF8-encoded `String` created from this `Data`
    public var utf8String: String? {
        #if !SKIP
        String(data: rawValue, encoding: String.Encoding.utf8)
        #else
        String(data: self, encoding: String.Encoding.utf8)
        #endif
    }

    public init() {
        #if !SKIP
        self.rawValue = PlatformData(count: 0)
        #else
        self.rawValue = PlatformData(size: 0)
        #endif
    }

    public init(count: Int) {
        #if !SKIP
        self.rawValue = PlatformData(count: count)
        #else
        self.rawValue = PlatformData(size: count)
        #endif
    }

    public init(capacity: Int) {
        #if !SKIP
        self.rawValue = PlatformData(capacity: capacity)
        #else
        // No equivalent kotlin.ByteArray(capacity:), so allocate with zero
        self.rawValue = PlatformData(size: 0)
        #endif
    }

    public mutating func append(contentsOf bytes: [UInt8]) {
        #if !SKIP
        self.rawValue.append(contentsOf: bytes)
        #else
        self.rawValue += Data(bytes).rawValue
        #endif
    }

    public static func ==(lhs: Data, rhs: Data) -> Bool {
        #if !SKIP
        return lhs.rawValue == rhs.rawValue
        #else
        return lhs.rawValue.contentEquals(rhs.rawValue)
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

// SKIP TODO: fake constructor until Kotlin can add constructor extensions to external types
public func String(data: Data, encoding: PlatformStringEncoding) -> String? {
    #if !SKIP
    return String.init(data: data.rawValue, encoding: encoding)
    #else
    return java.lang.String(data.rawValue, encoding.rawValue) as kotlin.String?
    #endif
}

extension String {
    /// The UTF8-encoded data for this string
    public var utf8Data: Data {
        #if !SKIP
        Data(rawValue: data(using: String.Encoding.utf8) ?? PlatformData())
        #else
        data(using: String.Encoding.utf8) ?? Data()
        #endif
    }
}

#if SKIP

// SKIP INSERT: public operator fun String.Companion.invoke(contentsOf: URL): String { return contentsOf.rawValue.readText() }

// SKIP INSERT: public operator fun Data.Companion.invoke(contentsOf: URL): Data { return Data.contentsOfURL(url = contentsOf) }

extension Data {
    /// static init until constructor overload works
    public static func contentsOfFile(filePath: String) throws -> Data {
        return Data(java.io.File(filePath).readBytes())
    }

    /// static init until constructor overload works
    public static func contentsOfURL(url: URL) throws -> Data {
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

#endif
