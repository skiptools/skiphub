// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
public protocol Encodable {
    func encode(to encoder: Encoder) throws
}
public protocol Decodable {

    #if SKIP // Kotlin does not support constructors in protocols
    // SKIP DECLARE: fun init(from: Decoder): Decodable?
    // static func `init`(from decoder: Decoder) throws -> Decodable
    #else
    init(from decoder: Decoder) throws
    #endif
}

#if !SKIP // Kotlin has no composite protocols
public typealias Codable = Decodable & Encodable
#else
public protocol Codable : Decodable, Encodable {
}
#endif

public protocol CodingKey : CustomDebugStringConvertible, CustomStringConvertible, Sendable {
    #if SKIP // Kotlin does not support constructors in protocols
    // SKIP DECLARE: fun init(stringValue: String): CodingKey?
    // static func `init`(stringValue: String) -> CodingKey?
    // SKIP DECLARE: fun init(intValue: Int): CodingKey?
    // static func `init`(intValue: Int) -> CodingKey?
    #else
    init?(stringValue: String)
    init?(intValue: Int)
    #endif

    var rawValue: String { get }

    var stringValue: String { get }
    var intValue: Int? { get }
}

extension CodingKey {
    public var stringValue: String {
        rawValue
    }
}

extension CodingKey {

    /// Skip only supports String codable keys; Int always returns nil
    public var intValue: Int? {
        nil
    }

    /// A textual representation of this key.
    public var description: String {
        rawValue
    }

    /// A textual representation of this key, suitable for debugging.
    // SKIP DECLARE: override val debugDescription: String
    public var debugDescription: String {
        // TODO: mimic the format of Swift.CodingKey.debugDescription?
        rawValue
    }
}

public protocol Encoder {
    var codingPath: [CodingKey] { get }
    var userInfo: [CodingUserInfoKey : Any] { get }
    func container<Key>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> where Key : CodingKey
    func unkeyedContainer() -> UnkeyedEncodingContainer
    func singleValueContainer() -> SingleValueEncodingContainer
}

public protocol Decoder {
    var codingPath: [CodingKey] { get }
    var userInfo: [CodingUserInfoKey : Any] { get }
    func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key : CodingKey
    func unkeyedContainer() throws -> UnkeyedDecodingContainer
    func singleValueContainer() throws -> SingleValueDecodingContainer
}

public protocol KeyedEncodingContainerProtocol {
    var codingPath: [CodingKey] { get }
    mutating func encodeNil(forKey key: CodingKey) throws
    mutating func encode(_ value: Bool, forKey key: CodingKey) throws
    mutating func encode(_ value: String, forKey key: CodingKey) throws
    mutating func encode(_ value: Double, forKey key: CodingKey) throws
    mutating func encode(_ value: Float, forKey key: CodingKey) throws
    mutating func encode(_ value: Int8, forKey key: CodingKey) throws
    mutating func encode(_ value: Int16, forKey key: CodingKey) throws
    mutating func encode(_ value: Int32, forKey key: CodingKey) throws
    mutating func encode(_ value: Int64, forKey key: CodingKey) throws
    mutating func encode(_ value: UInt8, forKey key: CodingKey) throws
    mutating func encode(_ value: UInt16, forKey key: CodingKey) throws
    mutating func encode(_ value: UInt32, forKey key: CodingKey) throws
    mutating func encode(_ value: UInt64, forKey key: CodingKey) throws
#if !SKIP // Int = Int32 in Kotlin
    mutating func encode(_ value: Int, forKey key: CodingKey) throws
    mutating func encode(_ value: UInt, forKey key: CodingKey) throws
    mutating func encodeIfPresent(_ value: Int?, forKey key: CodingKey) throws
    mutating func encodeIfPresent(_ value: UInt?, forKey key: CodingKey) throws
#endif
    mutating func encode<T>(_ value: T, forKey key: CodingKey) throws where T : Encodable
    mutating func encodeConditional<T>(_ object: T, forKey key: CodingKey) throws where T : AnyObject, T : Encodable
    mutating func encodeIfPresent(_ value: Bool?, forKey key: CodingKey) throws
    mutating func encodeIfPresent(_ value: String?, forKey key: CodingKey) throws
    mutating func encodeIfPresent(_ value: Double?, forKey key: CodingKey) throws
    mutating func encodeIfPresent(_ value: Float?, forKey key: CodingKey) throws
    mutating func encodeIfPresent(_ value: Int8?, forKey key: CodingKey) throws
    mutating func encodeIfPresent(_ value: Int16?, forKey key: CodingKey) throws
    mutating func encodeIfPresent(_ value: Int32?, forKey key: CodingKey) throws
    mutating func encodeIfPresent(_ value: Int64?, forKey key: CodingKey) throws
    mutating func encodeIfPresent(_ value: UInt8?, forKey key: CodingKey) throws
    mutating func encodeIfPresent(_ value: UInt16?, forKey key: CodingKey) throws
    mutating func encodeIfPresent(_ value: UInt32?, forKey key: CodingKey) throws
    mutating func encodeIfPresent(_ value: UInt64?, forKey key: CodingKey) throws
    mutating func encodeIfPresent<T>(_ value: T?, forKey key: CodingKey) throws where T : Encodable
    mutating func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type, forKey key: CodingKey) -> KeyedEncodingContainer<NestedKey> where NestedKey : CodingKey
    mutating func nestedUnkeyedContainer(forKey key: CodingKey) -> UnkeyedEncodingContainer
    mutating func superEncoder() -> Encoder
    mutating func superEncoder(forKey key: CodingKey) -> Encoder
}

extension KeyedEncodingContainerProtocol {
    public mutating func encodeConditional<T>(_ object: T, forKey key: CodingKey) throws where T : AnyObject, T : Encodable {
        fatalError("TODO")
    }

    public mutating func encodeIfPresent(_ value: Bool?, forKey key: CodingKey) throws {
        fatalError("TODO")
    }

    public mutating func encodeIfPresent(_ value: String?, forKey key: CodingKey) throws {
        fatalError("TODO")
    }

    public mutating func encodeIfPresent(_ value: Double?, forKey key: CodingKey) throws {
        fatalError("TODO")
    }

    public mutating func encodeIfPresent(_ value: Float?, forKey key: CodingKey) throws {
        fatalError("TODO")
    }

#if !SKIP // Int = Int32 in Kotlin
    public mutating func encodeIfPresent(_ value: Int?, forKey key: CodingKey) throws {
        fatalError("TODO")
    }
    public mutating func encodeIfPresent(_ value: UInt?, forKey key: CodingKey) throws {
        fatalError("TODO")
    }
#endif

    public mutating func encodeIfPresent(_ value: Int8?, forKey key: CodingKey) throws {
        fatalError("TODO")
    }

    public mutating func encodeIfPresent(_ value: Int16?, forKey key: CodingKey) throws {
        fatalError("TODO")
    }

    public mutating func encodeIfPresent(_ value: Int32?, forKey key: CodingKey) throws {
        fatalError("TODO")
    }

    public mutating func encodeIfPresent(_ value: Int64?, forKey key: CodingKey) throws {
        fatalError("TODO")
    }

    public mutating func encodeIfPresent(_ value: UInt8?, forKey key: CodingKey) throws {
        fatalError("TODO")
    }

    public mutating func encodeIfPresent(_ value: UInt16?, forKey key: CodingKey) throws {
        fatalError("TODO")
    }

    public mutating func encodeIfPresent(_ value: UInt32?, forKey key: CodingKey) throws {
        fatalError("TODO")
    }

    public mutating func encodeIfPresent(_ value: UInt64?, forKey key: CodingKey) throws {
        fatalError("TODO")
    }

    public mutating func encodeIfPresent<T>(_ value: T?, forKey key: CodingKey) throws where T : Encodable {
        fatalError("TODO")
    }
}

public struct KeyedEncodingContainer<Key: CodingKey> : KeyedEncodingContainerProtocol {
    public init(_ container: Any) {
        fatalError("TODO")
    }
    public var codingPath: [CodingKey] {
        fatalError("TODO")
    }
    public mutating func encodeNil(forKey key: CodingKey) throws {
        fatalError("TODO")
    }
    public mutating func encode(_ value: Bool, forKey key: CodingKey) throws {
        fatalError("TODO")
    }
    public mutating func encode(_ value: String, forKey key: CodingKey) throws {
        fatalError("TODO")
    }
    public mutating func encode(_ value: Double, forKey key: CodingKey) throws {
        fatalError("TODO")
    }
    public mutating func encode(_ value: Float, forKey key: CodingKey) throws {
        fatalError("TODO")
    }
#if !SKIP // Int = Int32 in Kotlin
    public mutating func encode(_ value: Int, forKey key: CodingKey) throws {
        fatalError("TODO")
    }
    public mutating func encode(_ value: UInt, forKey key: CodingKey) throws {
        fatalError("TODO")
    }
    public mutating func encodeIfPresent(_ value: Int?, forKey key: CodingKey) throws {
        fatalError("TODO")
    }
    public mutating func encodeIfPresent(_ value: UInt?, forKey key: CodingKey) throws {
        fatalError("TODO")
    }
#endif
    public mutating func encode(_ value: Int8, forKey key: CodingKey) throws {
        fatalError("TODO")
    }
    public mutating func encode(_ value: Int16, forKey key: CodingKey) throws {
        fatalError("TODO")
    }
    public mutating func encode(_ value: Int32, forKey key: CodingKey) throws {
        fatalError("TODO")
    }
    public mutating func encode(_ value: Int64, forKey key: CodingKey) throws {
        fatalError("TODO")
    }
    public mutating func encode(_ value: UInt8, forKey key: CodingKey) throws {
        fatalError("TODO")
    }
    public mutating func encode(_ value: UInt16, forKey key: CodingKey) throws {
        fatalError("TODO")
    }
    public mutating func encode(_ value: UInt32, forKey key: CodingKey) throws {
        fatalError("TODO")
    }
    public mutating func encode(_ value: UInt64, forKey key: CodingKey) throws {
        fatalError("TODO")
    }
    public mutating func encode<T>(_ value: T, forKey key: CodingKey) throws where T : Encodable {
        fatalError("TODO")
    }
    public mutating func encodeConditional<T>(_ object: T, forKey key: CodingKey) throws where T : AnyObject, T : Encodable {
        fatalError("TODO")
    }
    public mutating func encodeIfPresent(_ value: Bool?, forKey key: CodingKey) throws {
        fatalError("TODO")
    }
    public mutating func encodeIfPresent(_ value: String?, forKey key: CodingKey) throws {
        fatalError("TODO")
    }
    public mutating func encodeIfPresent(_ value: Double?, forKey key: CodingKey) throws {
        fatalError("TODO")
    }
    public mutating func encodeIfPresent(_ value: Float?, forKey key: CodingKey) throws {
        fatalError("TODO")
    }
    public mutating func encodeIfPresent(_ value: Int8?, forKey key: CodingKey) throws {
        fatalError("TODO")
    }
    public mutating func encodeIfPresent(_ value: Int16?, forKey key: CodingKey) throws {
        fatalError("TODO")
    }
    public mutating func encodeIfPresent(_ value: Int32?, forKey key: CodingKey) throws {
        fatalError("TODO")
    }
    public mutating func encodeIfPresent(_ value: Int64?, forKey key: CodingKey) throws {
        fatalError("TODO")
    }
    public mutating func encodeIfPresent(_ value: UInt8?, forKey key: CodingKey) throws {
        fatalError("TODO")
    }
    public mutating func encodeIfPresent(_ value: UInt16?, forKey key: CodingKey) throws {
        fatalError("TODO")
    }
    public mutating func encodeIfPresent(_ value: UInt32?, forKey key: CodingKey) throws {
        fatalError("TODO")
    }
    public mutating func encodeIfPresent(_ value: UInt64?, forKey key: CodingKey) throws {
        fatalError("TODO")
    }
    public mutating func encodeIfPresent<T>(_ value: T?, forKey key: CodingKey) throws where T : Encodable {
        fatalError("TODO")
    }
    public mutating func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type, forKey key: CodingKey) -> KeyedEncodingContainer<NestedKey> where NestedKey : CodingKey {
        fatalError("TODO")
    }
    public mutating func nestedUnkeyedContainer(forKey key: CodingKey) -> UnkeyedEncodingContainer {
        fatalError("TODO")
    }
    public mutating func superEncoder() -> Encoder {
        fatalError("TODO")
    }
    public mutating func superEncoder(forKey key: CodingKey) -> Encoder {
        fatalError("TODO")
    }
//    public mutating func encodeConditional<T>(_ object: T, forKey key: K) throws where T : AnyObject, T : Encodable {
//        fatalError("TODO")
//    }
//
//    public mutating func encodeIfPresent(_ value: Bool?, forKey key: K) throws {
//        fatalError("TODO")
//    }
//
//    public mutating func encodeIfPresent(_ value: String?, forKey key: K) throws {
//        fatalError("TODO")
//    }
//
//    public mutating func encodeIfPresent(_ value: Double?, forKey key: K) throws {
//        fatalError("TODO")
//    }
//
//    public mutating func encodeIfPresent(_ value: Float?, forKey key: K) throws {
//        fatalError("TODO")
//    }
//
//    public mutating func encodeIfPresent(_ value: Int?, forKey key: K) throws {
//        fatalError("TODO")
//    }
//
//    public mutating func encodeIfPresent(_ value: Int8?, forKey key: K) throws {
//        fatalError("TODO")
//    }
//
//    public mutating func encodeIfPresent(_ value: Int16?, forKey key: K) throws {
//        fatalError("TODO")
//    }
//
//    public mutating func encodeIfPresent(_ value: Int32?, forKey key: K) throws {
//        fatalError("TODO")
//    }
//
//    public mutating func encodeIfPresent(_ value: Int64?, forKey key: K) throws {
//        fatalError("TODO")
//    }
//
//    public mutating func encodeIfPresent(_ value: UInt?, forKey key: K) throws {
//        fatalError("TODO")
//    }
//
//    public mutating func encodeIfPresent(_ value: UInt8?, forKey key: K) throws {
//        fatalError("TODO")
//    }
//
//    public mutating func encodeIfPresent(_ value: UInt16?, forKey key: K) throws {
//        fatalError("TODO")
//    }
//
//    public mutating func encodeIfPresent(_ value: UInt32?, forKey key: K) throws {
//        fatalError("TODO")
//    }
//
//    public mutating func encodeIfPresent(_ value: UInt64?, forKey key: K) throws {
//        fatalError("TODO")
//    }
//
//    public mutating func encodeIfPresent<T>(_ value: T?, forKey key: K) throws where T : Encodable {
//        fatalError("TODO")
//    }
}

public protocol KeyedDecodingContainerProtocol {
    var codingPath: [CodingKey] { get }
    var allKeys: [CodingKey] { get }
    func contains(_ key: CodingKey) -> Bool
    func decodeNil(forKey key: CodingKey) throws -> Bool
    func decode(_ type: Bool.Type, forKey key: CodingKey) throws -> Bool
    func decode(_ type: String.Type, forKey key: CodingKey) throws -> String
    func decode(_ type: Double.Type, forKey key: CodingKey) throws -> Double
    func decode(_ type: Float.Type, forKey key: CodingKey) throws -> Float
#if !SKIP // Int = Int32 in Kotlin
    func decode(_ type: Int.Type, forKey key: CodingKey) throws -> Int
    func decode(_ type: UInt.Type, forKey key: CodingKey) throws -> UInt
    func decodeIfPresent(_ type: Int.Type, forKey key: CodingKey) throws -> Int?
    func decodeIfPresent(_ type: UInt.Type, forKey key: CodingKey) throws -> UInt?
#endif
    func decode(_ type: Int8.Type, forKey key: CodingKey) throws -> Int8
    func decode(_ type: Int16.Type, forKey key: CodingKey) throws -> Int16
    func decode(_ type: Int32.Type, forKey key: CodingKey) throws -> Int32
    func decode(_ type: Int64.Type, forKey key: CodingKey) throws -> Int64
    func decode(_ type: UInt8.Type, forKey key: CodingKey) throws -> UInt8
    func decode(_ type: UInt16.Type, forKey key: CodingKey) throws -> UInt16
    func decode(_ type: UInt32.Type, forKey key: CodingKey) throws -> UInt32
    func decode(_ type: UInt64.Type, forKey key: CodingKey) throws -> UInt64
    func decode<T>(_ type: T.Type, forKey key: CodingKey) throws -> T where T : Decodable
    func decodeIfPresent(_ type: Bool.Type, forKey key: CodingKey) throws -> Bool?
    func decodeIfPresent(_ type: String.Type, forKey key: CodingKey) throws -> String?
    func decodeIfPresent(_ type: Double.Type, forKey key: CodingKey) throws -> Double?
    func decodeIfPresent(_ type: Float.Type, forKey key: CodingKey) throws -> Float?
    func decodeIfPresent(_ type: Int8.Type, forKey key: CodingKey) throws -> Int8?
    func decodeIfPresent(_ type: Int16.Type, forKey key: CodingKey) throws -> Int16?
    func decodeIfPresent(_ type: Int32.Type, forKey key: CodingKey) throws -> Int32?
    func decodeIfPresent(_ type: Int64.Type, forKey key: CodingKey) throws -> Int64?
    func decodeIfPresent(_ type: UInt8.Type, forKey key: CodingKey) throws -> UInt8?
    func decodeIfPresent(_ type: UInt16.Type, forKey key: CodingKey) throws -> UInt16?
    func decodeIfPresent(_ type: UInt32.Type, forKey key: CodingKey) throws -> UInt32?
    func decodeIfPresent(_ type: UInt64.Type, forKey key: CodingKey) throws -> UInt64?
    func decodeIfPresent<T>(_ type: T.Type, forKey key: CodingKey) throws -> T? where T : Decodable
    func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: CodingKey) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey
    func nestedUnkeyedContainer(forKey key: CodingKey) throws -> UnkeyedDecodingContainer
    func superDecoder() throws -> Decoder
    func superDecoder(forKey key: CodingKey) throws -> Decoder
}

extension KeyedDecodingContainerProtocol {

    public func decodeIfPresent(_ type: Bool.Type, forKey key: CodingKey) throws -> Bool? {
        fatalError("TODO")
    }

    public func decodeIfPresent(_ type: String.Type, forKey key: CodingKey) throws -> String? {
        fatalError("TODO")
    }

    public func decodeIfPresent(_ type: Double.Type, forKey key: CodingKey) throws -> Double? {
        fatalError("TODO")
    }

    public func decodeIfPresent(_ type: Float.Type, forKey key: CodingKey) throws -> Float? {
        fatalError("TODO")
    }

    #if !SKIP // Int = Int32 in Kotlin
    public func decodeIfPresent(_ type: Int.Type, forKey key: CodingKey) throws -> Int? {
        fatalError("TODO")
    }
    #endif

    public func decodeIfPresent(_ type: Int8.Type, forKey key: CodingKey) throws -> Int8? {
        fatalError("TODO")
    }

    public func decodeIfPresent(_ type: Int16.Type, forKey key: CodingKey) throws -> Int16? {
        fatalError("TODO")
    }

    public func decodeIfPresent(_ type: Int32.Type, forKey key: CodingKey) throws -> Int32? {
        fatalError("TODO")
    }

    public func decodeIfPresent(_ type: Int64.Type, forKey key: CodingKey) throws -> Int64? {
        fatalError("TODO")
    }

    #if !SKIP // Int = Int32 in Kotlin
    public func decodeIfPresent(_ type: UInt.Type, forKey key: CodingKey) throws -> UInt? {
        fatalError("TODO")
    }
    #endif

    public func decodeIfPresent(_ type: UInt8.Type, forKey key: CodingKey) throws -> UInt8? {
        fatalError("TODO")
    }

    public func decodeIfPresent(_ type: UInt16.Type, forKey key: CodingKey) throws -> UInt16? {
        fatalError("TODO")
    }

    public func decodeIfPresent(_ type: UInt32.Type, forKey key: CodingKey) throws -> UInt32? {
        fatalError("TODO")
    }

    public func decodeIfPresent(_ type: UInt64.Type, forKey key: CodingKey) throws -> UInt64? {
        fatalError("TODO")
    }

    public func decodeIfPresent<T>(_ type: T.Type, forKey key: CodingKey) throws -> T? where T : Decodable {
        fatalError("TODO")
    }
}


public struct KeyedDecodingContainer<Key: CodingKey> : KeyedDecodingContainerProtocol {
#if SKIP // Container type
    public init(_ container: Any) {
        fatalError("TODO")
    }
#else
    public init<Container>(_ container: Container) {
        fatalError("TODO")
    }
#endif
    public var codingPath: [CodingKey] {
        fatalError("TODO")
    }
    public var allKeys: [CodingKey] {
        fatalError("TODO")
    }
    public func contains(_ key: CodingKey) -> Bool {
        fatalError("TODO")
    }
    public func decodeNil(forKey key: CodingKey) throws -> Bool {
        fatalError("TODO")
    }
    public func decode(_ type: Bool.Type, forKey key: CodingKey) throws -> Bool {
        fatalError("TODO")
    }
    public func decode(_ type: String.Type, forKey key: CodingKey) throws -> String {
        fatalError("TODO")
    }
    public func decode(_ type: Double.Type, forKey key: CodingKey) throws -> Double {
        fatalError("TODO")
    }
    public func decode(_ type: Float.Type, forKey key: CodingKey) throws -> Float {
        fatalError("TODO")
    }
#if !SKIP // Int = Int32 in Kotlin
    public func decode(_ type: Int.Type, forKey key: CodingKey) throws -> Int {
        fatalError("TODO")
    }
    public func decode(_ type: UInt.Type, forKey key: CodingKey) throws -> UInt {
        fatalError("TODO")
    }
    public func decodeIfPresent(_ type: Int.Type, forKey key: CodingKey) throws -> Int? {
        fatalError("TODO")
    }
    public func decodeIfPresent(_ type: UInt.Type, forKey key: CodingKey) throws -> UInt? {
        fatalError("TODO")
    }
#endif
    public func decode(_ type: Int8.Type, forKey key: CodingKey) throws -> Int8 {
        fatalError("TODO")
    }
    public func decode(_ type: Int16.Type, forKey key: CodingKey) throws -> Int16 {
        fatalError("TODO")
    }
    public func decode(_ type: Int32.Type, forKey key: CodingKey) throws -> Int32 {
        fatalError("TODO")
    }
    public func decode(_ type: Int64.Type, forKey key: CodingKey) throws -> Int64 {
        fatalError("TODO")
    }
    public func decode(_ type: UInt8.Type, forKey key: CodingKey) throws -> UInt8 {
        fatalError("TODO")
    }
    public func decode(_ type: UInt16.Type, forKey key: CodingKey) throws -> UInt16 {
        fatalError("TODO")
    }
    public func decode(_ type: UInt32.Type, forKey key: CodingKey) throws -> UInt32 {
        fatalError("TODO")
    }
    public func decode(_ type: UInt64.Type, forKey key: CodingKey) throws -> UInt64 {
        fatalError("TODO")
    }
    public func decode<T>(_ type: T.Type, forKey key: CodingKey) throws -> T where T : Decodable {
        fatalError("TODO")
    }
    public func decodeIfPresent(_ type: Bool.Type, forKey key: CodingKey) throws -> Bool? {
        fatalError("TODO")
    }
    public func decodeIfPresent(_ type: String.Type, forKey key: CodingKey) throws -> String? {
        fatalError("TODO")
    }
    public func decodeIfPresent(_ type: Double.Type, forKey key: CodingKey) throws -> Double? {
        fatalError("TODO")
    }
    public func decodeIfPresent(_ type: Float.Type, forKey key: CodingKey) throws -> Float? {
        fatalError("TODO")
    }
    public func decodeIfPresent(_ type: Int8.Type, forKey key: CodingKey) throws -> Int8? {
        fatalError("TODO")
    }
    public func decodeIfPresent(_ type: Int16.Type, forKey key: CodingKey) throws -> Int16? {
        fatalError("TODO")
    }
    public func decodeIfPresent(_ type: Int32.Type, forKey key: CodingKey) throws -> Int32? {
        fatalError("TODO")
    }
    public func decodeIfPresent(_ type: Int64.Type, forKey key: CodingKey) throws -> Int64? {
        fatalError("TODO")
    }
    public func decodeIfPresent(_ type: UInt8.Type, forKey key: CodingKey) throws -> UInt8? {
        fatalError("TODO")
    }
    public func decodeIfPresent(_ type: UInt16.Type, forKey key: CodingKey) throws -> UInt16? {
        fatalError("TODO")
    }
    public func decodeIfPresent(_ type: UInt32.Type, forKey key: CodingKey) throws -> UInt32? {
        fatalError("TODO")
    }
    public func decodeIfPresent(_ type: UInt64.Type, forKey key: CodingKey) throws -> UInt64? {
        fatalError("TODO")
    }
    public func decodeIfPresent<T>(_ type: T.Type, forKey key: CodingKey) throws -> T? where T : Decodable {
        fatalError("TODO")
    }
    public func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: CodingKey) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
        fatalError("TODO")
    }
    public func nestedUnkeyedContainer(forKey key: CodingKey) throws -> UnkeyedDecodingContainer {
        fatalError("TODO")
    }
    public func superDecoder() throws -> Decoder {
        fatalError("TODO")
    }
    public func superDecoder(forKey key: CodingKey) throws -> Decoder {
        fatalError("TODO")
    }
}

public protocol UnkeyedEncodingContainer {
    var codingPath: [CodingKey] { get }
    var count: Int { get }
    mutating func encodeNil() throws
    mutating func encode(_ value: Bool) throws
    mutating func encode(_ value: String) throws
    mutating func encode(_ value: Double) throws
    mutating func encode(_ value: Float) throws
    #if !SKIP // Int = Int32 in Kotlin
    mutating func encode(_ value: Int) throws
    mutating func encode(_ value: UInt) throws
    #endif
    mutating func encode(_ value: Int8) throws
    mutating func encode(_ value: Int16) throws
    mutating func encode(_ value: Int32) throws
    mutating func encode(_ value: Int64) throws
    mutating func encode(_ value: UInt8) throws
    mutating func encode(_ value: UInt16) throws
    mutating func encode(_ value: UInt32) throws
    mutating func encode(_ value: UInt64) throws
    mutating func encode<T>(_ value: T) throws where T : Encodable

    #if !SKIP // “Skip does not support the referenced type as a generic constraint”
    mutating func encodeConditional<T>(_ object: T) throws where T : AnyObject, T : Encodable
    mutating func encode<T>(contentsOf sequence: T) throws where T : Sequence, T.Element == Bool
    mutating func encode<T>(contentsOf sequence: T) throws where T : Sequence, T.Element == String
    mutating func encode<T>(contentsOf sequence: T) throws where T : Sequence, T.Element == Double
    mutating func encode<T>(contentsOf sequence: T) throws where T : Sequence, T.Element == Float
    mutating func encode<T>(contentsOf sequence: T) throws where T : Sequence, T.Element == Int
    mutating func encode<T>(contentsOf sequence: T) throws where T : Sequence, T.Element == Int8
    mutating func encode<T>(contentsOf sequence: T) throws where T : Sequence, T.Element == Int16
    mutating func encode<T>(contentsOf sequence: T) throws where T : Sequence, T.Element == Int32
    mutating func encode<T>(contentsOf sequence: T) throws where T : Sequence, T.Element == Int64
    mutating func encode<T>(contentsOf sequence: T) throws where T : Sequence, T.Element == UInt
    mutating func encode<T>(contentsOf sequence: T) throws where T : Sequence, T.Element == UInt8
    mutating func encode<T>(contentsOf sequence: T) throws where T : Sequence, T.Element == UInt16
    mutating func encode<T>(contentsOf sequence: T) throws where T : Sequence, T.Element == UInt32
    mutating func encode<T>(contentsOf sequence: T) throws where T : Sequence, T.Element == UInt64
    mutating func encode<T>(contentsOf sequence: T) throws where T : Sequence, T.Element : Encodable
    mutating func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type) -> KeyedEncodingContainer<NestedKey>
#endif
    mutating func nestedUnkeyedContainer() -> UnkeyedEncodingContainer
    mutating func superEncoder() -> Encoder
}

//extension UnkeyedEncodingContainer {
//
//    /// Encodes a reference to the given object only if it is encoded
//    /// unconditionally elsewhere in the payload (previously, or in the future).
//    ///
//    /// For encoders which don't support this feature, the default implementation
//    /// encodes the given object unconditionally.
//    ///
//    /// For formats which don't support this feature, the default implementation
//    /// encodes the given object unconditionally.
//    ///
//    /// - parameter object: The object to encode.
//    /// - throws: `EncodingError.invalidValue` if the given value is invalid in
//    ///   the current context for this format.
//    public mutating func encodeConditional<T>(_ object: T) throws where T : AnyObject, T : Encodable
//
//    public mutating func encode<T>(contentsOf sequence: T) throws where T : Sequence, T.Element == Bool
//
//    public mutating func encode<T>(contentsOf sequence: T) throws where T : Sequence, T.Element == String
//
//    public mutating func encode<T>(contentsOf sequence: T) throws where T : Sequence, T.Element == Double
//
//    public mutating func encode<T>(contentsOf sequence: T) throws where T : Sequence, T.Element == Float
//
//    public mutating func encode<T>(contentsOf sequence: T) throws where T : Sequence, T.Element == Int
//
//    public mutating func encode<T>(contentsOf sequence: T) throws where T : Sequence, T.Element == Int8
//
//    public mutating func encode<T>(contentsOf sequence: T) throws where T : Sequence, T.Element == Int16
//
//    public mutating func encode<T>(contentsOf sequence: T) throws where T : Sequence, T.Element == Int32
//
//    public mutating func encode<T>(contentsOf sequence: T) throws where T : Sequence, T.Element == Int64
//
//    public mutating func encode<T>(contentsOf sequence: T) throws where T : Sequence, T.Element == UInt
//
//    public mutating func encode<T>(contentsOf sequence: T) throws where T : Sequence, T.Element == UInt8
//
//    public mutating func encode<T>(contentsOf sequence: T) throws where T : Sequence, T.Element == UInt16
//
//    public mutating func encode<T>(contentsOf sequence: T) throws where T : Sequence, T.Element == UInt32
//
//    public mutating func encode<T>(contentsOf sequence: T) throws where T : Sequence, T.Element == UInt64
//
//    public mutating func encode<T>(contentsOf sequence: T) throws where T : Sequence, T.Element : Encodable
//}

public protocol UnkeyedDecodingContainer {
    var codingPath: [CodingKey] { get }
    var count: Int? { get }
    var isAtEnd: Bool { get }
    var currentIndex: Int { get }
    mutating func decodeNil() throws -> Bool
    mutating func decode(_ type: Bool.Type) throws -> Bool
    mutating func decode(_ type: String.Type) throws -> String
    mutating func decode(_ type: Double.Type) throws -> Double
    mutating func decode(_ type: Float.Type) throws -> Float
#if !SKIP // Int = Int32 in Kotlin
    mutating func decode(_ type: Int.Type) throws -> Int
    mutating func decode(_ type: UInt.Type) throws -> UInt
    mutating func decodeIfPresent(_ type: Int.Type) throws -> Int?
    mutating func decodeIfPresent(_ type: UInt.Type) throws -> UInt?
#endif
    mutating func decode(_ type: Int8.Type) throws -> Int8
    mutating func decode(_ type: Int16.Type) throws -> Int16
    mutating func decode(_ type: Int32.Type) throws -> Int32
    mutating func decode(_ type: Int64.Type) throws -> Int64
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
        fatalError("TODO: UnkeyedDecodingContainer extension impl")
    }

    public mutating func decodeIfPresent(_ type: String.Type) throws -> String? {
        fatalError("TODO: UnkeyedDecodingContainer extension impl")
    }

    public mutating func decodeIfPresent(_ type: Double.Type) throws -> Double? {
        fatalError("TODO: UnkeyedDecodingContainer extension impl")
    }

    public mutating func decodeIfPresent(_ type: Float.Type) throws -> Float? {
        fatalError("TODO: UnkeyedDecodingContainer extension impl")
    }

    #if !SKIP
    public mutating func decodeIfPresent(_ type: Int.Type) throws -> Int? {
        fatalError("TODO: UnkeyedDecodingContainer extension impl")
    }
    #endif

    public mutating func decodeIfPresent(_ type: Int8.Type) throws -> Int8? {
        fatalError("TODO: UnkeyedDecodingContainer extension impl")
    }

    public mutating func decodeIfPresent(_ type: Int16.Type) throws -> Int16? {
        fatalError("TODO: UnkeyedDecodingContainer extension impl")
    }

    public mutating func decodeIfPresent(_ type: Int32.Type) throws -> Int32? {
        fatalError("TODO: UnkeyedDecodingContainer extension impl")
    }

    public mutating func decodeIfPresent(_ type: Int64.Type) throws -> Int64? {
        fatalError("TODO: UnkeyedDecodingContainer extension impl")
    }

    #if !SKIP
    public mutating func decodeIfPresent(_ type: UInt.Type) throws -> UInt? {
        fatalError("TODO: UnkeyedDecodingContainer extension impl")
    }
    #endif

    public mutating func decodeIfPresent(_ type: UInt8.Type) throws -> UInt8? {
        fatalError("TODO: UnkeyedDecodingContainer extension impl")
    }

    public mutating func decodeIfPresent(_ type: UInt16.Type) throws -> UInt16? {
        fatalError("TODO: UnkeyedDecodingContainer extension impl")
    }

    public mutating func decodeIfPresent(_ type: UInt32.Type) throws -> UInt32? {
        fatalError("TODO: UnkeyedDecodingContainer extension impl")
    }

    public mutating func decodeIfPresent(_ type: UInt64.Type) throws -> UInt64? {
        fatalError("TODO: UnkeyedDecodingContainer extension impl")
    }

    public mutating func decodeIfPresent<T>(_ type: T.Type) throws -> T? where T : Decodable {
        fatalError("TODO: UnkeyedDecodingContainer extension impl")
    }
}


public protocol SingleValueEncodingContainer {
    var codingPath: [CodingKey] { get }
    mutating func encodeNil() throws
    mutating func encode(_ value: Bool) throws
    mutating func encode(_ value: String) throws
    mutating func encode(_ value: Double) throws
    mutating func encode(_ value: Float) throws
#if !SKIP // Int = Int32 in Kotlin
    mutating func encode(_ value: Int) throws
    mutating func encode(_ value: UInt) throws
#endif
    mutating func encode(_ value: Int8) throws
    mutating func encode(_ value: Int16) throws
    mutating func encode(_ value: Int32) throws
    mutating func encode(_ value: Int64) throws
    mutating func encode(_ value: UInt8) throws
    mutating func encode(_ value: UInt16) throws
    mutating func encode(_ value: UInt32) throws
    mutating func encode(_ value: UInt64) throws
    mutating func encode<T>(_ value: T) throws where T : Encodable
}


public protocol SingleValueDecodingContainer {
    var codingPath: [CodingKey] { get }
    func decodeNil() -> Bool
    func decode(_ type: Bool.Type) throws -> Bool
    func decode(_ type: String.Type) throws -> String
    func decode(_ type: Double.Type) throws -> Double
    func decode(_ type: Float.Type) throws -> Float
#if !SKIP // Int = Int32 in Kotlin
    func decode(_ type: Int.Type) throws -> Int
    func decode(_ type: UInt.Type) throws -> UInt
#endif
    func decode(_ type: Int8.Type) throws -> Int8
    func decode(_ type: Int16.Type) throws -> Int16
    func decode(_ type: Int32.Type) throws -> Int32
    func decode(_ type: Int64.Type) throws -> Int64
    func decode(_ type: UInt8.Type) throws -> UInt8
    func decode(_ type: UInt16.Type) throws -> UInt16
    func decode(_ type: UInt32.Type) throws -> UInt32
    func decode(_ type: UInt64.Type) throws -> UInt64
    func decode<T>(_ type: T.Type) throws -> T where T : Decodable
}


#if !SKIP // so CodingUserInfoKey can be used as a dictionary key
extension CodingUserInfoKey : Swift.Hashable {

}
#endif

public struct CodingUserInfoKey : RawRepresentable, Equatable, Hashable, Sendable {

    public var hashValue: Int {
        fatalError("TODO")
    }


    #if !SKIP // “Kotlin does not support typealias declarations within functions and types. Consider moving this to a top level declaration”
    public typealias RawValue = String
    #endif
    public let rawValue: String
    public init?(rawValue: String) {
        self.rawValue = rawValue
    }
}
public enum EncodingError : Error {
    public struct Context : Sendable {
        public let codingPath: [CodingKey]
        public let debugDescription: String
        public let underlyingError: (Error)?
//        public init(codingPath: [CodingKey], debugDescription: String, underlyingError: (Error)? = nil) {
//            fatalError("TODO")
//        }
    }
    case invalidValue(Any, EncodingError.Context)
}
public enum DecodingError : Error {
    public struct Context : Sendable {
        public let codingPath: [CodingKey]
        public let debugDescription: String
        public let underlyingError: (Error)?
//        public init(codingPath: [CodingKey], debugDescription: String, underlyingError: (Error)? = nil) {
//            fatalError("TODO")
//        }
    }
    case typeMismatch(Any.Type, DecodingError.Context)
    case valueNotFound(Any.Type, DecodingError.Context)
    case keyNotFound(CodingKey, DecodingError.Context)
    case dataCorrupted(DecodingError.Context)
    public static func dataCorruptedError<C>(forKey key: CodingKey, in container: C, debugDescription: String) -> DecodingError where C : KeyedDecodingContainerProtocol {
        fatalError("TODO")
    }
    public static func dataCorruptedError(in container: UnkeyedDecodingContainer, debugDescription: String) -> DecodingError {
        fatalError("TODO")
    }
    public static func dataCorruptedError(in container: SingleValueDecodingContainer, debugDescription: String) -> DecodingError {
        fatalError("TODO")
    }
}

@available(macOS 12.3, iOS 15.4, watchOS 8.5, tvOS 15.4, *)
public protocol CodingKeyRepresentable {

    @available(macOS 12.3, iOS 15.4, watchOS 8.5, tvOS 15.4, *)
    var codingKey: CodingKey { get }

    #if !SKIP
    @available(macOS 12.3, iOS 15.4, watchOS 8.5, tvOS 15.4, *)
    init?<T>(codingKey: T) where T : CodingKey
    #endif
}


