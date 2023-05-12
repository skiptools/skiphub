
// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
#if SKIP
extension String {
    public func data(using: StringEncoding, allowLossyConversion: Bool = true) -> Data? {
        return try? Data(rawValue: toByteArray(using.rawValue))
    }

    public var utf8: Data {
        // note: this differs from Swift in that it is a Data, but both Data and String.UTF8View conform to Sequence where Element == UInt8
        return Data(toByteArray(java.nio.charset.StandardCharsets.UTF_8))
    }

    //public var utf16: Data {
    //    return Data(toByteArray(java.nio.charset.StandardCharsets.UTF_16))
    //}

    public func replacingOccurrences(of search: String, with replacement: String) -> String {
        return replace(search, replacement)
    }

    public func components(separatedBy separator: String) -> [String] {
        // SKIP REPLACE: return Array(split(separator))
        return []
    }
}

public struct StringEncoding : RawRepresentable, Hashable, CustomStringConvertible {
    public static let utf8 = StringEncoding(rawValue: Charsets.UTF_8)
    public static let utf16 = StringEncoding(rawValue: Charsets.UTF_16)
    public static let utf16LittleEndian = StringEncoding(rawValue: Charsets.UTF_16LE)
    public static let utf16BigEndian = StringEncoding(rawValue: Charsets.UTF_16BE)
    public static let utf32 = StringEncoding(rawValue: Charsets.UTF_32)
    public static let utf32LittleEndian = StringEncoding(rawValue: Charsets.UTF_32LE)
    public static let utf32BigEndian = StringEncoding(rawValue: Charsets.UTF_32BE)

    public let rawValue: java.nio.charset.Charset

    public init(rawValue: java.nio.charset.Charset) {
        self.rawValue = rawValue
    }

    public init(_ rawValue: java.nio.charset.Charset) {
        self.rawValue = rawValue
    }

    public var description: String {
        rawValue.description
    }
}

#endif
