
// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
#if !SKIP
/// Needed because Skip cannot create typealias inside extensions, so all references to `String.Encoding` need to be `StringEncoding`
public typealias StringEncoding = String.Encoding

#else

extension String {
    public func data(using: StringEncoding, allowLossyConversion: Bool) -> Data? {
        return try? Data(rawValue: toByteArray(using.rawValue))
    }
}

public struct StringEncoding : RawRepresentable, Hashable {
    public static let utf8 = StringEncoding(rawValue: Charsets.UTF_8)

    public let rawValue: java.nio.charset.Charset

    public init(rawValue: java.nio.charset.Charset) {
        self.rawValue = rawValue
    }

    public init(_ rawValue: java.nio.charset.Charset) {
        self.rawValue = rawValue
    }
}

#endif
