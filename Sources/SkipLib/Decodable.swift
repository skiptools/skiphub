// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
public protocol Decodable {

    #if SKIP // Kotlin does not support constructors in protocols
    // SKIP DECLARE: fun init(from: Decoder): Decodable?
    // static func `init`(from decoder: Decoder) throws -> Decodable
    #else
    init(from decoder: Decoder) throws
    #endif
}

public protocol DecodableCompanion {
    associatedtype Owner
    // SKIP TODO: automatic de-quote the reserved `init` function name
    // SKIP REPLACE: fun init(from: Decoder): Owner
    func `init`(from decoder: Decoder) throws -> Owner
}

/// A type that can decode values from a native format into in-memory
/// representations.
public protocol Decoder {
    var codingPath: [CodingKey] { get }
    var userInfo: [CodingUserInfoKey : Any] { get }
    func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key : CodingKey
    func unkeyedContainer() throws -> UnkeyedDecodingContainer
    func singleValueContainer() throws -> SingleValueDecodingContainer
}


/// A type that provides a view into a decoder's storage and is used to hold
/// the encoded properties of a decodable type in a keyed manner.
///
/// Decoders should provide types conforming to `UnkeyedDecodingContainer` for
/// their format.
public protocol KeyedDecodingContainerProtocol {

    associatedtype Key : CodingKey
    
    var codingPath: [CodingKey] { get }
    var allKeys: [Key] { get }
    func contains(_ key: Key) -> Bool
    func decodeNil(forKey key: Key) throws -> Bool
    func decode(_ type: Bool.Type, forKey key: Key) throws -> Bool
    func decode(_ type: String.Type, forKey key: Key) throws -> String
    func decode(_ type: Double.Type, forKey key: Key) throws -> Double
    func decode(_ type: Float.Type, forKey key: Key) throws -> Float
    func decode(_ type: Int8.Type, forKey key: Key) throws -> Int8
    func decode(_ type: Int16.Type, forKey key: Key) throws -> Int16
    func decode(_ type: Int32.Type, forKey key: Key) throws -> Int32
    func decode(_ type: Int64.Type, forKey key: Key) throws -> Int64
    #if !SKIP
    func decode(_ type: Int.Type, forKey key: Key) throws -> Int
    func decode(_ type: UInt.Type, forKey key: Key) throws -> UInt
    #endif
    func decode(_ type: UInt8.Type, forKey key: Key) throws -> UInt8
    func decode(_ type: UInt16.Type, forKey key: Key) throws -> UInt16
    func decode(_ type: UInt32.Type, forKey key: Key) throws -> UInt32
    func decode(_ type: UInt64.Type, forKey key: Key) throws -> UInt64
    func decode<T>(_ type: T.Type, forKey key: Key) throws -> T where T : Decodable
    func decodeIfPresent(_ type: Bool.Type, forKey key: Key) throws -> Bool?
    func decodeIfPresent(_ type: String.Type, forKey key: Key) throws -> String?
    func decodeIfPresent(_ type: Double.Type, forKey key: Key) throws -> Double?
    func decodeIfPresent(_ type: Float.Type, forKey key: Key) throws -> Float?
    func decodeIfPresent(_ type: Int8.Type, forKey key: Key) throws -> Int8?
    func decodeIfPresent(_ type: Int16.Type, forKey key: Key) throws -> Int16?
    func decodeIfPresent(_ type: Int32.Type, forKey key: Key) throws -> Int32?
    func decodeIfPresent(_ type: Int64.Type, forKey key: Key) throws -> Int64?
    #if !SKIP
    func decodeIfPresent(_ type: Int.Type, forKey key: Key) throws -> Int?
    func decodeIfPresent(_ type: UInt.Type, forKey key: Key) throws -> UInt?
    #endif
    func decodeIfPresent(_ type: UInt8.Type, forKey key: Key) throws -> UInt8?
    func decodeIfPresent(_ type: UInt16.Type, forKey key: Key) throws -> UInt16?
    func decodeIfPresent(_ type: UInt32.Type, forKey key: Key) throws -> UInt32?
    func decodeIfPresent(_ type: UInt64.Type, forKey key: Key) throws -> UInt64?
    func decodeIfPresent<T>(_ type: T.Type, forKey key: Key) throws -> T? where T : Decodable
    func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: Key) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey
    func nestedUnkeyedContainer(forKey key: Key) throws -> UnkeyedDecodingContainer
    func superDecoder() throws -> Decoder
    func superDecoder(forKey key: Key) throws -> Decoder
}

extension KeyedDecodingContainerProtocol {
    public func decodeIfPresent(_ type: Bool.Type, forKey key: Key) throws -> Bool? {
        fatalError("SKIP DECODING TODO")
    }

    public func decodeIfPresent(_ type: String.Type, forKey key: Key) throws -> String? {
        fatalError("SKIP DECODING TODO")
    }

    public func decodeIfPresent(_ type: Double.Type, forKey key: Key) throws -> Double? {
        fatalError("SKIP DECODING TODO")
    }

    public func decodeIfPresent(_ type: Float.Type, forKey key: Key) throws -> Float? {
        fatalError("SKIP DECODING TODO")
    }

    //public func decodeIfPresent(_ type: Int.Type, forKey key: Key) throws -> Int? {
    //    fatalError("SKIP DECODING TODO")
    //}

    public func decodeIfPresent(_ type: Int8.Type, forKey key: Key) throws -> Int8? {
        fatalError("SKIP DECODING TODO")
    }

    public func decodeIfPresent(_ type: Int16.Type, forKey key: Key) throws -> Int16? {
        fatalError("SKIP DECODING TODO")
    }

    public func decodeIfPresent(_ type: Int32.Type, forKey key: Key) throws -> Int32? {
        fatalError("SKIP DECODING TODO")
    }

    public func decodeIfPresent(_ type: Int64.Type, forKey key: Key) throws -> Int64? {
        fatalError("SKIP DECODING TODO")
    }

    //public func decodeIfPresent(_ type: UInt.Type, forKey key: Key) throws -> UInt? {
    //    fatalError("SKIP DECODING TODO")
    //}

    public func decodeIfPresent(_ type: UInt8.Type, forKey key: Key) throws -> UInt8? {
        fatalError("SKIP DECODING TODO")
    }

    public func decodeIfPresent(_ type: UInt16.Type, forKey key: Key) throws -> UInt16? {
        fatalError("SKIP DECODING TODO")
    }

    public func decodeIfPresent(_ type: UInt32.Type, forKey key: Key) throws -> UInt32? {
        fatalError("SKIP DECODING TODO")
    }

    public func decodeIfPresent(_ type: UInt64.Type, forKey key: Key) throws -> UInt64? {
        fatalError("SKIP DECODING TODO")
    }

    public func decodeIfPresent<T>(_ type: T.Type, forKey key: Key) throws -> T? where T : Decodable {
        fatalError("SKIP DECODING TODO")
    }
}

#if SKIP
typealias DecodingContainerKey = CodingKey
#endif

/// A concrete container that provides a view into a decoder's storage, making
/// the encoded properties of a decodable type accessible by keys.
public struct KeyedDecodingContainer<K> : KeyedDecodingContainerProtocol where K : CodingKey {
    #if !SKIP
    public typealias Key = K
    public typealias DecodingContainerKey = Key
    #endif

    #if !SKIP
    /// Creates a new instance with the given container.
    ///
    /// - parameter container: The container to hold.
    public init<Container>(_ container: Container) where K == Container.Key, Container : KeyedDecodingContainerProtocol {
        fatalError("SKIP DECODING TODO")
    }
    #else
    public init(_ container: Any) {
    }
    #endif

    /// The path of coding keys taken to get to this point in decoding.
    public var codingPath: [CodingKey] = []

    public var allKeys: [DecodingContainerKey] = []

    public func contains(_ key: DecodingContainerKey) -> Bool {
        fatalError("SKIP DECODING TODO")
    }

    public func decodeNil(forKey key: DecodingContainerKey) throws -> Bool {
        fatalError("SKIP DECODING TODO")
    }

    public func decode(_ type: Bool.Type, forKey key: DecodingContainerKey) throws -> Bool {
        fatalError("SKIP DECODING TODO")
    }

    public func decode(_ type: String.Type, forKey key: DecodingContainerKey) throws -> String {
        fatalError("SKIP DECODING TODO")
    }

    public func decode(_ type: Double.Type, forKey key: DecodingContainerKey) throws -> Double {
        fatalError("SKIP DECODING TODO")
    }

    public func decode(_ type: Float.Type, forKey key: DecodingContainerKey) throws -> Float {
        fatalError("SKIP DECODING TODO")
    }

    #if !SKIP
    public func decode(_ type: Int.Type, forKey key: DecodingContainerKey) throws -> Int {
        fatalError("SKIP DECODING TODO")
    }
    #endif

    public func decode(_ type: Int8.Type, forKey key: DecodingContainerKey) throws -> Int8 {
        fatalError("SKIP DECODING TODO")
    }

    public func decode(_ type: Int16.Type, forKey key: DecodingContainerKey) throws -> Int16 {
        fatalError("SKIP DECODING TODO")
    }

    public func decode(_ type: Int32.Type, forKey key: DecodingContainerKey) throws -> Int32 {
        fatalError("SKIP DECODING TODO")
    }

    public func decode(_ type: Int64.Type, forKey key: DecodingContainerKey) throws -> Int64 {
        fatalError("SKIP DECODING TODO")
    }

    #if !SKIP
    public func decode(_ type: UInt.Type, forKey key: DecodingContainerKey) throws -> UInt {
        fatalError("SKIP DECODING TODO")
    }
    #endif

    public func decode(_ type: UInt8.Type, forKey key: DecodingContainerKey) throws -> UInt8 {
        fatalError("SKIP DECODING TODO")
    }

    public func decode(_ type: UInt16.Type, forKey key: DecodingContainerKey) throws -> UInt16 {
        fatalError("SKIP DECODING TODO")
    }

    public func decode(_ type: UInt32.Type, forKey key: DecodingContainerKey) throws -> UInt32 {
        fatalError("SKIP DECODING TODO")
    }

    public func decode(_ type: UInt64.Type, forKey key: DecodingContainerKey) throws -> UInt64 {
        fatalError("SKIP DECODING TODO")
    }

    public func decode<T>(_ type: T.Type, forKey key: DecodingContainerKey) throws -> T where T : Decodable {
        fatalError("SKIP DECODING TODO")
    }

    public func decodeIfPresent(_ type: Bool.Type, forKey key: DecodingContainerKey) throws -> Bool? {
        fatalError("SKIP DECODING TODO")
    }

    public func decodeIfPresent(_ type: String.Type, forKey key: DecodingContainerKey) throws -> String? {
        fatalError("SKIP DECODING TODO")
    }

    public func decodeIfPresent(_ type: Double.Type, forKey key: DecodingContainerKey) throws -> Double? {
        fatalError("SKIP DECODING TODO")
    }

    public func decodeIfPresent(_ type: Float.Type, forKey key: DecodingContainerKey) throws -> Float? {
        fatalError("SKIP DECODING TODO")
    }

    //public func decodeIfPresent(_ type: Int.Type, forKey key: DecodingContainerKey) throws -> Int? {
    //    fatalError("SKIP DECODING TODO")
    //}

    public func decodeIfPresent(_ type: Int8.Type, forKey key: DecodingContainerKey) throws -> Int8? {
        fatalError("SKIP DECODING TODO")
    }

    public func decodeIfPresent(_ type: Int16.Type, forKey key: DecodingContainerKey) throws -> Int16? {
        fatalError("SKIP DECODING TODO")
    }

    public func decodeIfPresent(_ type: Int32.Type, forKey key: DecodingContainerKey) throws -> Int32? {
        fatalError("SKIP DECODING TODO")
    }

    public func decodeIfPresent(_ type: Int64.Type, forKey key: DecodingContainerKey) throws -> Int64? {
        fatalError("SKIP DECODING TODO")
    }

    #if !SKIP
    public func decodeIfPresent(_ type: Int.Type, forKey key: DecodingContainerKey) throws -> Int? {
        fatalError("SKIP DECODING TODO")
    }

    public func decodeIfPresent(_ type: UInt.Type, forKey key: DecodingContainerKey) throws -> UInt? {
        fatalError("SKIP DECODING TODO")
    }
    #endif

    public func decodeIfPresent(_ type: UInt8.Type, forKey key: DecodingContainerKey) throws -> UInt8? {
        fatalError("SKIP DECODING TODO")
    }

    public func decodeIfPresent(_ type: UInt16.Type, forKey key: DecodingContainerKey) throws -> UInt16? {
        fatalError("SKIP DECODING TODO")
    }

    public func decodeIfPresent(_ type: UInt32.Type, forKey key: DecodingContainerKey) throws -> UInt32? {
        fatalError("SKIP DECODING TODO")
    }

    public func decodeIfPresent(_ type: UInt64.Type, forKey key: DecodingContainerKey) throws -> UInt64? {
        fatalError("SKIP DECODING TODO")
    }

    public func decodeIfPresent<T>(_ type: T.Type, forKey key: DecodingContainerKey) throws -> T? where T : Decodable {
        fatalError("SKIP DECODING TODO")
    }

    public func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: DecodingContainerKey) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
        fatalError("SKIP DECODING TODO")
    }

    public func nestedUnkeyedContainer(forKey key: DecodingContainerKey) throws -> UnkeyedDecodingContainer {
        fatalError("SKIP DECODING TODO")
    }

    public func superDecoder() throws -> Decoder {
        fatalError("SKIP DECODING TODO")
    }

    public func superDecoder(forKey key: DecodingContainerKey) throws -> Decoder {
        fatalError("SKIP DECODING TODO")
    }
}


/// A type that provides a view into a decoder's storage and is used to hold
/// the encoded properties of a decodable type sequentially, without keys.
///
/// Decoders should provide types conforming to `UnkeyedDecodingContainer` for
/// their format.
public protocol UnkeyedDecodingContainer {

    /// The path of coding keys taken to get to this point in decoding.
    var codingPath: [CodingKey] { get }

    /// The number of elements contained within this container.
    ///
    /// If the number of elements is unknown, the value is `nil`.
    var count: Int? { get }

    /// A Boolean value indicating whether there are no more elements left to be
    /// decoded in the container.
    var isAtEnd: Bool { get }

    /// The current decoding index of the container (i.e. the index of the next
    /// element to be decoded.) Incremented after every successful decode call.
    var currentIndex: Int { get }

    /// Decodes a null value.
    mutating func decodeNil() throws -> Bool

    mutating func decode(_ type: Bool.Type) throws -> Bool
    mutating func decode(_ type: String.Type) throws -> String
    mutating func decode(_ type: Double.Type) throws -> Double
    mutating func decode(_ type: Float.Type) throws -> Float
    mutating func decode(_ type: Int8.Type) throws -> Int8
    mutating func decode(_ type: Int16.Type) throws -> Int16
    mutating func decode(_ type: Int32.Type) throws -> Int32
    mutating func decode(_ type: Int64.Type) throws -> Int64
    #if !SKIP
    mutating func decode(_ type: Int.Type) throws -> Int
    mutating func decode(_ type: UInt.Type) throws -> UInt
    #endif
    mutating func decode(_ type: UInt8.Type) throws -> UInt8
    mutating func decode(_ type: UInt16.Type) throws -> UInt16
    mutating func decode(_ type: UInt32.Type) throws -> UInt32
    mutating func decode(_ type: UInt64.Type) throws -> UInt64
    mutating func decode<T>(_ type: T.Type) throws -> T where T : Decodable
    mutating func decodeIfPresent(_ type: Bool.Type) throws -> Bool?
    mutating func decodeIfPresent(_ type: String.Type) throws -> String?
    mutating func decodeIfPresent(_ type: Double.Type) throws -> Double?
    mutating func decodeIfPresent(_ type: Float.Type) throws -> Float?
    mutating func decodeIfPresent(_ type: Int8.Type) throws -> Int8?
    mutating func decodeIfPresent(_ type: Int16.Type) throws -> Int16?
    mutating func decodeIfPresent(_ type: Int32.Type) throws -> Int32?
    mutating func decodeIfPresent(_ type: Int64.Type) throws -> Int64?
    #if !SKIP
    mutating func decodeIfPresent(_ type: Int.Type) throws -> Int?
    mutating func decodeIfPresent(_ type: UInt.Type) throws -> UInt?
    #endif
    mutating func decodeIfPresent(_ type: UInt8.Type) throws -> UInt8?
    mutating func decodeIfPresent(_ type: UInt16.Type) throws -> UInt16?
    mutating func decodeIfPresent(_ type: UInt32.Type) throws -> UInt32?
    mutating func decodeIfPresent(_ type: UInt64.Type) throws -> UInt64?
    mutating func decodeIfPresent<T>(_ type: T.Type) throws -> T? where T : Decodable
    mutating func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey
    mutating func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer
    mutating func superDecoder() throws -> Decoder
}


extension UnkeyedDecodingContainer {
    public mutating func decodeIfPresent(_ type: Bool.Type) throws -> Bool? {
        fatalError("SKIP DECODING TODO")
    }

    public mutating func decodeIfPresent(_ type: String.Type) throws -> String? {
        fatalError("SKIP DECODING TODO")
    }

    public mutating func decodeIfPresent(_ type: Double.Type) throws -> Double? {
        fatalError("SKIP DECODING TODO")
    }

    public mutating func decodeIfPresent(_ type: Float.Type) throws -> Float? {
        fatalError("SKIP DECODING TODO")
    }

    public mutating func decodeIfPresent(_ type: Int8.Type) throws -> Int8? {
        fatalError("SKIP DECODING TODO")
    }

    public mutating func decodeIfPresent(_ type: Int16.Type) throws -> Int16? {
        fatalError("SKIP DECODING TODO")
    }

    public mutating func decodeIfPresent(_ type: Int32.Type) throws -> Int32? {
        fatalError("SKIP DECODING TODO")
    }

    public mutating func decodeIfPresent(_ type: Int64.Type) throws -> Int64? {
        fatalError("SKIP DECODING TODO")
    }

    #if !SKIP
    public mutating func decodeIfPresent(_ type: Int.Type) throws -> Int? {
        fatalError("SKIP DECODING TODO")
    }

    public mutating func decodeIfPresent(_ type: UInt.Type) throws -> UInt? {
        fatalError("SKIP DECODING TODO")
    }
    #endif

    public mutating func decodeIfPresent(_ type: UInt8.Type) throws -> UInt8? {
        fatalError("SKIP DECODING TODO")
    }

    public mutating func decodeIfPresent(_ type: UInt16.Type) throws -> UInt16? {
        fatalError("SKIP DECODING TODO")
    }

    public mutating func decodeIfPresent(_ type: UInt32.Type) throws -> UInt32? {
        fatalError("SKIP DECODING TODO")
    }

    public mutating func decodeIfPresent(_ type: UInt64.Type) throws -> UInt64? {
        fatalError("SKIP DECODING TODO")
    }

    public mutating func decodeIfPresent<T>(_ type: T.Type) throws -> T? where T : Decodable {
        fatalError("SKIP DECODING TODO")
    }
}


/// A container that can support the storage and direct decoding of a single
/// nonkeyed value.
public protocol SingleValueDecodingContainer {

    /// The path of coding keys taken to get to this point in encoding.
    var codingPath: [CodingKey] { get }

    func decodeNil() -> Bool
    func decode(_ type: Bool.Type) throws -> Bool
    func decode(_ type: String.Type) throws -> String
    func decode(_ type: Double.Type) throws -> Double
    func decode(_ type: Float.Type) throws -> Float

    func decode(_ type: Int8.Type) throws -> Int8
    func decode(_ type: Int16.Type) throws -> Int16
    func decode(_ type: Int32.Type) throws -> Int32
    func decode(_ type: Int64.Type) throws -> Int64
    #if !SKIP
    func decode(_ type: Int.Type) throws -> Int
    func decode(_ type: UInt.Type) throws -> UInt
    #endif
    func decode(_ type: UInt8.Type) throws -> UInt8
    func decode(_ type: UInt16.Type) throws -> UInt16
    func decode(_ type: UInt32.Type) throws -> UInt32
    func decode(_ type: UInt64.Type) throws -> UInt64

    func decode<T>(_ type: T.Type) throws -> T where T : Decodable
}


/// An error that occurs during the decoding of a value.
public enum DecodingError : Error {

    /// The context in which the error occurred.
    public struct Context : Sendable {

        /// The path of coding keys taken to get to the point of the failing decode
        /// call.
        public let codingPath: [CodingKey]

        /// A description of what went wrong, for debugging purposes.
        public let debugDescription: String

        /// The underlying error which caused this error, if any.
        public let underlyingError: (Error)?

        public init(codingPath: [CodingKey], debugDescription: String, underlyingError: (Error)? = nil) {
            self.codingPath = codingPath
            self.debugDescription = debugDescription
            self.underlyingError = underlyingError
        }
    }

    /// An indication that a value of the given type could not be decoded because
    /// it did not match the type of what was found in the encoded payload.
    ///
    /// As associated values, this case contains the attempted type and context
    /// for debugging.
    case typeMismatch(Any.Type, DecodingError.Context)

    /// An indication that a non-optional value of the given type was expected,
    /// but a null value was found.
    ///
    /// As associated values, this case contains the attempted type and context
    /// for debugging.
    case valueNotFound(Any.Type, DecodingError.Context)

    /// An indication that a keyed decoding container was asked for an entry for
    /// the given key, but did not contain one.
    ///
    /// As associated values, this case contains the attempted key and context
    /// for debugging.
    case keyNotFound(CodingKey, DecodingError.Context)

    /// An indication that the data is corrupted or otherwise invalid.
    ///
    /// As an associated value, this case contains the context for debugging.
    case dataCorrupted(DecodingError.Context)

    /// Returns a new `.dataCorrupted` error using a constructed coding path and
    /// the given debug description.
    //public static func dataCorruptedError<C>(forKey key: C.Key, in container: C, debugDescription: String) -> DecodingError where C : KeyedDecodingContainerProtocol {
    //    fatalError("SKIP DECODING TODO")
    //}

    /// Returns a new `.dataCorrupted` error using a constructed coding path and
    /// the given debug description.
    public static func dataCorruptedError(in container: UnkeyedDecodingContainer, debugDescription: String) -> DecodingError {
        fatalError("SKIP DECODING TODO")
    }

    /// Returns a new `.dataCorrupted` error using a constructed coding path and
    /// the given debug description.
    public static func dataCorruptedError(in container: SingleValueDecodingContainer, debugDescription: String) -> DecodingError {
        fatalError("SKIP DECODING TODO")
    }
}
