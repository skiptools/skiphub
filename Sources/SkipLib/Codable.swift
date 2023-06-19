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
    mutating func encodeConditional<T>(_ object: T, forKey key: CodingKey) throws where T : Encodable
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
    public mutating func encodeConditional<T>(_ object: T, forKey key: CodingKey) throws where T : Encodable {
        try encode(object, forKey: key)
    }

    public mutating func encodeIfPresent(_ value: Bool?, forKey key: CodingKey) throws {
        guard let value = value else { return }
        try encode(value, forKey: key)
    }

    public mutating func encodeIfPresent(_ value: String?, forKey key: CodingKey) throws {
        guard let value = value else { return }
        try encode(value, forKey: key)
    }

    public mutating func encodeIfPresent(_ value: Double?, forKey key: CodingKey) throws {
        guard let value = value else { return }
        try encode(value, forKey: key)
    }

    public mutating func encodeIfPresent(_ value: Float?, forKey key: CodingKey) throws {
        guard let value = value else { return }
        try encode(value, forKey: key)
    }

#if !SKIP // Int = Int32 in Kotlin
    public mutating func encodeIfPresent(_ value: Int?, forKey key: CodingKey) throws {
        guard let value = value else { return }
        try encode(value, forKey: key)
    }
    public mutating func encodeIfPresent(_ value: UInt?, forKey key: CodingKey) throws {
        guard let value = value else { return }
        try encode(value, forKey: key)
    }
#endif

    public mutating func encodeIfPresent(_ value: Int8?, forKey key: CodingKey) throws {
        guard let value = value else { return }
        try encode(value, forKey: key)
    }

    public mutating func encodeIfPresent(_ value: Int16?, forKey key: CodingKey) throws {
        guard let value = value else { return }
        try encode(value, forKey: key)
    }

    public mutating func encodeIfPresent(_ value: Int32?, forKey key: CodingKey) throws {
        guard let value = value else { return }
        try encode(value, forKey: key)
    }

    public mutating func encodeIfPresent(_ value: Int64?, forKey key: CodingKey) throws {
        guard let value = value else { return }
        try encode(value, forKey: key)
    }

    public mutating func encodeIfPresent(_ value: UInt8?, forKey key: CodingKey) throws {
        guard let value = value else { return }
        try encode(value, forKey: key)
    }

    public mutating func encodeIfPresent(_ value: UInt16?, forKey key: CodingKey) throws {
        guard let value = value else { return }
        try encode(value, forKey: key)
    }

    public mutating func encodeIfPresent(_ value: UInt32?, forKey key: CodingKey) throws {
        guard let value = value else { return }
        try encode(value, forKey: key)
    }

    public mutating func encodeIfPresent(_ value: UInt64?, forKey key: CodingKey) throws {
        guard let value = value else { return }
        try encode(value, forKey: key)
    }

    public mutating func encodeIfPresent<T>(_ value: T?, forKey key: CodingKey) throws where T : Encodable {
        guard let value = value else { return }
        try encode(value, forKey: key)
    }
}

public struct KeyedEncodingContainer<Key: CodingKey> : KeyedEncodingContainerProtocol {
    internal var _box: _KeyedEncodingContainerBase

    public init(_ container: KeyedEncodingContainerProtocol) {
        self._box = _KeyedEncodingContainerBox(container)
    }

    public var codingPath: [any CodingKey] {
      return _box.codingPath
    }

    public mutating func encodeNil(forKey key: CodingKey) throws {
        try _box.encodeNil(forKey: key)
    }

    public mutating func encode(_ value: Bool, forKey key: CodingKey) throws {
        try _box.encode(value, forKey: key)
    }

    public mutating func encode(_ value: String, forKey key: CodingKey) throws {
        try _box.encode(value, forKey: key)
    }

    public mutating func encode(_ value: Double, forKey key: CodingKey) throws {
        try _box.encode(value, forKey: key)
    }

    public mutating func encode(_ value: Float, forKey key: CodingKey) throws {
        try _box.encode(value, forKey: key)
    }

#if !SKIP // Int = Int32 in Kotlin
    public mutating func encode(_ value: Int, forKey key: CodingKey) throws {
        try _box.encode(value, forKey: key)
    }

    public mutating func encode(_ value: UInt, forKey key: CodingKey) throws {
        try _box.encode(value, forKey: key)
    }

    public mutating func encodeIfPresent(_ value: Int?, forKey key: CodingKey) throws {
        try _box.encodeIfPresent(value, forKey: key)
    }

    public mutating func encodeIfPresent(_ value: UInt?, forKey key: CodingKey) throws {
        try _box.encodeIfPresent(value, forKey: key)
    }
#endif

    public mutating func encode(_ value: Int8, forKey key: CodingKey) throws {
        try _box.encode(value, forKey: key)
    }

    public mutating func encode(_ value: Int16, forKey key: CodingKey) throws {
        try _box.encode(value, forKey: key)
    }

    public mutating func encode(_ value: Int32, forKey key: CodingKey) throws {
        try _box.encode(value, forKey: key)
    }

    public mutating func encode(_ value: Int64, forKey key: CodingKey) throws {
        try _box.encode(value, forKey: key)
    }

    public mutating func encode(_ value: UInt8, forKey key: CodingKey) throws {
        try _box.encode(value, forKey: key)
    }

    public mutating func encode(_ value: UInt16, forKey key: CodingKey) throws {
        try _box.encode(value, forKey: key)
    }

    public mutating func encode(_ value: UInt32, forKey key: CodingKey) throws {
        try _box.encode(value, forKey: key)
    }

    public mutating func encode(_ value: UInt64, forKey key: CodingKey) throws {
        try _box.encode(value, forKey: key)
    }

    public mutating func encode<T>(_ value: T, forKey key: CodingKey) throws where T : Encodable {
        try _box.encode(value, forKey: key)
    }

    public mutating func encodeConditional<T>(_ object: T, forKey key: CodingKey) throws where T : Encodable {
        fatalError("TODO: KeyedEncodingContainer.encodeIfPresent T \(key)")
    }

    public mutating func encodeIfPresent(_ value: Bool?, forKey key: CodingKey) throws {
        try _box.encodeIfPresent(value, forKey: key)
    }

    public mutating func encodeIfPresent(_ value: String?, forKey key: CodingKey) throws {
        try _box.encodeIfPresent(value, forKey: key)
    }

    public mutating func encodeIfPresent(_ value: Double?, forKey key: CodingKey) throws {
        try _box.encodeIfPresent(value, forKey: key)
    }

    public mutating func encodeIfPresent(_ value: Float?, forKey key: CodingKey) throws {
        try _box.encodeIfPresent(value, forKey: key)
    }

    public mutating func encodeIfPresent(_ value: Int8?, forKey key: CodingKey) throws {
        try _box.encodeIfPresent(value, forKey: key)
    }

    public mutating func encodeIfPresent(_ value: Int16?, forKey key: CodingKey) throws {
        try _box.encodeIfPresent(value, forKey: key)
    }

    public mutating func encodeIfPresent(_ value: Int32?, forKey key: CodingKey) throws {
        try _box.encodeIfPresent(value, forKey: key)
    }

    public mutating func encodeIfPresent(_ value: Int64?, forKey key: CodingKey) throws {
        try _box.encodeIfPresent(value, forKey: key)
    }

    public mutating func encodeIfPresent(_ value: UInt8?, forKey key: CodingKey) throws {
        try _box.encodeIfPresent(value, forKey: key)
    }

    public mutating func encodeIfPresent(_ value: UInt16?, forKey key: CodingKey) throws {
        try _box.encodeIfPresent(value, forKey: key)
    }

    public mutating func encodeIfPresent(_ value: UInt32?, forKey key: CodingKey) throws {
        try _box.encodeIfPresent(value, forKey: key)
    }

    public mutating func encodeIfPresent(_ value: UInt64?, forKey key: CodingKey) throws {
        try _box.encodeIfPresent(value, forKey: key)
    }

    public mutating func encodeIfPresent<T>(_ value: T?, forKey key: CodingKey) throws where T : Encodable {
        try _box.encodeIfPresent(value, forKey: key)
    }

    public mutating func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type, forKey key: CodingKey) -> KeyedEncodingContainer<NestedKey> where NestedKey : CodingKey {
        //return _box.nestedContainer(keyedBy: NestedKey.self, forKey: key)
        fatalError("TODO: KeyedEncodingContainer.nestedContainer NestedKey  \(key)")
    }

    public mutating func nestedUnkeyedContainer(forKey key: CodingKey) -> UnkeyedEncodingContainer {
        return _box.nestedUnkeyedContainer(forKey: key)

    }
    public mutating func superEncoder() -> Encoder {
        return _box.superEncoder()
    }

    public mutating func superEncoder(forKey key: CodingKey) -> Encoder {
        return _box.superEncoder(forKey: key)
    }
}

extension KeyedEncodingContainerProtocol {
    public mutating func encode<T>(_ value: any Sequence<T>, forKey key: CodingKey) throws {
        var container = nestedUnkeyedContainer(forKey: key)
        for element in value {
            switch (element) {
            case let str as String:
                try container.encode(str)
            case let boolValue as Bool:
                try container.encode(boolValue)
            case let num as Int:
                try container.encode(num)
            case let num as Int8:
                try container.encode(num)
            case let num as Int16:
                try container.encode(num)
            case let num as Int32:
                try container.encode(num)
            case let num as Int64:
                try container.encode(num)
            case let num as UInt:
                try container.encode(num)
            case let num as UInt8:
                try container.encode(num)
            case let num as UInt16:
                try container.encode(num)
            case let num as UInt32:
                try container.encode(num)
            case let num as UInt64:
                try container.encode(num)
            case let num as Float:
                try container.encode(num)
            case let num as Double:
                try container.encode(num)
            case let enc as Encodable:
                try container.encode(enc)
            default:
                fatalError("Cannot encode \(element)")
            }
        }
    }
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
        fatalError("TODO: KeyedDecodingContainerProtocol")
    }

    public func decodeIfPresent(_ type: String.Type, forKey key: CodingKey) throws -> String? {
        fatalError("TODO: KeyedDecodingContainerProtocol")
    }

    public func decodeIfPresent(_ type: Double.Type, forKey key: CodingKey) throws -> Double? {
        fatalError("TODO: KeyedDecodingContainerProtocol")
    }

    public func decodeIfPresent(_ type: Float.Type, forKey key: CodingKey) throws -> Float? {
        fatalError("TODO: KeyedDecodingContainerProtocol")
    }

    #if !SKIP // Int = Int32 in Kotlin
    public func decodeIfPresent(_ type: Int.Type, forKey key: CodingKey) throws -> Int? {
        fatalError("TODO: KeyedDecodingContainerProtocol")
    }
    #endif

    public func decodeIfPresent(_ type: Int8.Type, forKey key: CodingKey) throws -> Int8? {
        fatalError("TODO: KeyedDecodingContainerProtocol")
    }

    public func decodeIfPresent(_ type: Int16.Type, forKey key: CodingKey) throws -> Int16? {
        fatalError("TODO: KeyedDecodingContainerProtocol")
    }

    public func decodeIfPresent(_ type: Int32.Type, forKey key: CodingKey) throws -> Int32? {
        fatalError("TODO: KeyedDecodingContainerProtocol")
    }

    public func decodeIfPresent(_ type: Int64.Type, forKey key: CodingKey) throws -> Int64? {
        fatalError("TODO: KeyedDecodingContainerProtocol")
    }

    #if !SKIP // Int = Int32 in Kotlin
    public func decodeIfPresent(_ type: UInt.Type, forKey key: CodingKey) throws -> UInt? {
        fatalError("TODO: KeyedDecodingContainerProtocol")
    }
    #endif

    public func decodeIfPresent(_ type: UInt8.Type, forKey key: CodingKey) throws -> UInt8? {
        fatalError("TODO: KeyedDecodingContainerProtocol")
    }

    public func decodeIfPresent(_ type: UInt16.Type, forKey key: CodingKey) throws -> UInt16? {
        fatalError("TODO: KeyedDecodingContainerProtocol")
    }

    public func decodeIfPresent(_ type: UInt32.Type, forKey key: CodingKey) throws -> UInt32? {
        fatalError("TODO: KeyedDecodingContainerProtocol")
    }

    public func decodeIfPresent(_ type: UInt64.Type, forKey key: CodingKey) throws -> UInt64? {
        fatalError("TODO: KeyedDecodingContainerProtocol")
    }

    public func decodeIfPresent<T>(_ type: T.Type, forKey key: CodingKey) throws -> T? where T : Decodable {
        fatalError("TODO: KeyedDecodingContainerProtocol")
    }
}


public struct KeyedDecodingContainer<Key: CodingKey> : KeyedDecodingContainerProtocol {
#if SKIP // Container type
    public init(_ container: Any) {
        fatalError("TODO: KeyedDecodingContainer")
    }
#else
    public init<Container>(_ container: Container) {
        fatalError("TODO: KeyedDecodingContainer")
    }
#endif
    public var codingPath: [CodingKey] {
        fatalError("TODO: KeyedDecodingContainer")
    }
    public var allKeys: [CodingKey] {
        fatalError("TODO: KeyedDecodingContainer")
    }
    public func contains(_ key: CodingKey) -> Bool {
        fatalError("TODO: KeyedDecodingContainer")
    }
    public func decodeNil(forKey key: CodingKey) throws -> Bool {
        fatalError("TODO: KeyedDecodingContainer")
    }
    public func decode(_ type: Bool.Type, forKey key: CodingKey) throws -> Bool {
        fatalError("TODO: KeyedDecodingContainer")
    }
    public func decode(_ type: String.Type, forKey key: CodingKey) throws -> String {
        fatalError("TODO: KeyedDecodingContainer")
    }
    public func decode(_ type: Double.Type, forKey key: CodingKey) throws -> Double {
        fatalError("TODO: KeyedDecodingContainer")
    }
    public func decode(_ type: Float.Type, forKey key: CodingKey) throws -> Float {
        fatalError("TODO: KeyedDecodingContainer")
    }
    #if !SKIP // Int = Int32 in Kotlin
    public func decode(_ type: Int.Type, forKey key: CodingKey) throws -> Int {
        fatalError("TODO: KeyedDecodingContainer")
    }
    public func decode(_ type: UInt.Type, forKey key: CodingKey) throws -> UInt {
        fatalError("TODO: KeyedDecodingContainer")
    }
    public func decodeIfPresent(_ type: Int.Type, forKey key: CodingKey) throws -> Int? {
        fatalError("TODO: KeyedDecodingContainer")
    }
    public func decodeIfPresent(_ type: UInt.Type, forKey key: CodingKey) throws -> UInt? {
        fatalError("TODO: KeyedDecodingContainer")
    }
    #endif
    public func decode(_ type: Int8.Type, forKey key: CodingKey) throws -> Int8 {
        fatalError("TODO: KeyedDecodingContainer")
    }
    public func decode(_ type: Int16.Type, forKey key: CodingKey) throws -> Int16 {
        fatalError("TODO: KeyedDecodingContainer")
    }
    public func decode(_ type: Int32.Type, forKey key: CodingKey) throws -> Int32 {
        fatalError("TODO: KeyedDecodingContainer")
    }
    public func decode(_ type: Int64.Type, forKey key: CodingKey) throws -> Int64 {
        fatalError("TODO: KeyedDecodingContainer")
    }
    public func decode(_ type: UInt8.Type, forKey key: CodingKey) throws -> UInt8 {
        fatalError("TODO: KeyedDecodingContainer")
    }
    public func decode(_ type: UInt16.Type, forKey key: CodingKey) throws -> UInt16 {
        fatalError("TODO: KeyedDecodingContainer")
    }
    public func decode(_ type: UInt32.Type, forKey key: CodingKey) throws -> UInt32 {
        fatalError("TODO: KeyedDecodingContainer")
    }
    public func decode(_ type: UInt64.Type, forKey key: CodingKey) throws -> UInt64 {
        fatalError("TODO: KeyedDecodingContainer")
    }
    public func decode<T>(_ type: T.Type, forKey key: CodingKey) throws -> T where T : Decodable {
        fatalError("TODO: KeyedDecodingContainer")
    }
    public func decodeIfPresent(_ type: Bool.Type, forKey key: CodingKey) throws -> Bool? {
        fatalError("TODO: KeyedDecodingContainer")
    }
    public func decodeIfPresent(_ type: String.Type, forKey key: CodingKey) throws -> String? {
        fatalError("TODO: KeyedDecodingContainer")
    }
    public func decodeIfPresent(_ type: Double.Type, forKey key: CodingKey) throws -> Double? {
        fatalError("TODO: KeyedDecodingContainer")
    }
    public func decodeIfPresent(_ type: Float.Type, forKey key: CodingKey) throws -> Float? {
        fatalError("TODO: KeyedDecodingContainer")
    }
    public func decodeIfPresent(_ type: Int8.Type, forKey key: CodingKey) throws -> Int8? {
        fatalError("TODO: KeyedDecodingContainer")
    }
    public func decodeIfPresent(_ type: Int16.Type, forKey key: CodingKey) throws -> Int16? {
        fatalError("TODO: KeyedDecodingContainer")
    }
    public func decodeIfPresent(_ type: Int32.Type, forKey key: CodingKey) throws -> Int32? {
        fatalError("TODO: KeyedDecodingContainer")
    }
    public func decodeIfPresent(_ type: Int64.Type, forKey key: CodingKey) throws -> Int64? {
        fatalError("TODO: KeyedDecodingContainer")
    }
    public func decodeIfPresent(_ type: UInt8.Type, forKey key: CodingKey) throws -> UInt8? {
        fatalError("TODO: KeyedDecodingContainer")
    }
    public func decodeIfPresent(_ type: UInt16.Type, forKey key: CodingKey) throws -> UInt16? {
        fatalError("TODO: KeyedDecodingContainer")
    }
    public func decodeIfPresent(_ type: UInt32.Type, forKey key: CodingKey) throws -> UInt32? {
        fatalError("TODO: KeyedDecodingContainer")
    }
    public func decodeIfPresent(_ type: UInt64.Type, forKey key: CodingKey) throws -> UInt64? {
        fatalError("TODO: KeyedDecodingContainer")
    }
    public func decodeIfPresent<T>(_ type: T.Type, forKey key: CodingKey) throws -> T? where T : Decodable {
        fatalError("TODO: KeyedDecodingContainer")
    }
    public func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: CodingKey) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
        fatalError("TODO: KeyedDecodingContainer")
    }
    public func nestedUnkeyedContainer(forKey key: CodingKey) throws -> UnkeyedDecodingContainer {
        fatalError("TODO: KeyedDecodingContainer")
    }
    public func superDecoder() throws -> Decoder {
        fatalError("TODO: KeyedDecodingContainer")
    }
    public func superDecoder(forKey key: CodingKey) throws -> Decoder {
        fatalError("TODO: KeyedDecodingContainer")
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
    mutating func encodeConditional<T>(_ object: T) throws where T : Encodable
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
//    public mutating func encodeConditional<T>(_ object: T) throws where T : Encodable
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


public struct CodingUserInfoKey : RawRepresentable, Equatable, Hashable, Sendable {

    public var hashValue: Int {
        fatalError("TODO: hashValue")
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
        fatalError("TODO: dataCorruptedError")
    }
    public static func dataCorruptedError(in container: UnkeyedDecodingContainer, debugDescription: String) -> DecodingError {
        fatalError("TODO: dataCorruptedError")
    }
    public static func dataCorruptedError(in container: SingleValueDecodingContainer, debugDescription: String) -> DecodingError {
        fatalError("TODO: dataCorruptedError")
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



//===----------------------------------------------------------------------===//
// Keyed Encoding Container Implementations
//===----------------------------------------------------------------------===//
internal class _KeyedEncodingContainerBase {
  internal init(){}

  deinit {}

  // These must all be given a concrete implementation in _*Box.
  internal var codingPath: [CodingKey] {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }

  internal func encodeNil<K: CodingKey>(forKey key: K) throws {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }

  internal func encode<K: CodingKey>(_ value: Bool, forKey key: K) throws {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }

  internal func encode<K: CodingKey>(_ value: String, forKey key: K) throws {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }

  internal func encode<K: CodingKey>(_ value: Double, forKey key: K) throws {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }

  internal func encode<K: CodingKey>(_ value: Float, forKey key: K) throws {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }

#if !SKIP // Int = Int32 in Kotlin
  internal func encode<K: CodingKey>(_ value: Int, forKey key: K) throws {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }
#endif

  internal func encode<K: CodingKey>(_ value: Int8, forKey key: K) throws {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }

  internal func encode<K: CodingKey>(_ value: Int16, forKey key: K) throws {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }

  internal func encode<K: CodingKey>(_ value: Int32, forKey key: K) throws {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }

  internal func encode<K: CodingKey>(_ value: Int64, forKey key: K) throws {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }

#if !SKIP // Int = Int32 in Kotlin
  internal func encode<K: CodingKey>(_ value: UInt, forKey key: K) throws {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }
#endif

  internal func encode<K: CodingKey>(_ value: UInt8, forKey key: K) throws {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }

  internal func encode<K: CodingKey>(_ value: UInt16, forKey key: K) throws {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }

  internal func encode<K: CodingKey>(_ value: UInt32, forKey key: K) throws {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }

  internal func encode<K: CodingKey>(_ value: UInt64, forKey key: K) throws {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }

  internal func encode<T: Encodable, K: CodingKey>(_ value: T, forKey key: K) throws {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }

  internal func encodeConditional<T: Encodable, K: CodingKey>(
    _ object: T,
    forKey key: K
  ) throws {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }

  internal func encodeIfPresent<K: CodingKey>(_ value: Bool?, forKey key: K) throws {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }

  internal func encodeIfPresent<K: CodingKey>(_ value: String?, forKey key: K) throws {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }

  internal func encodeIfPresent<K: CodingKey>(_ value: Double?, forKey key: K) throws {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }

  internal func encodeIfPresent<K: CodingKey>(_ value: Float?, forKey key: K) throws {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }

#if !SKIP // Int = Int32 in Kotlin
  internal func encodeIfPresent<K: CodingKey>(_ value: Int?, forKey key: K) throws {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }
#endif

  internal func encodeIfPresent<K: CodingKey>(_ value: Int8?, forKey key: K) throws {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }

  internal func encodeIfPresent<K: CodingKey>(_ value: Int16?, forKey key: K) throws {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }

  internal func encodeIfPresent<K: CodingKey>(_ value: Int32?, forKey key: K) throws {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }

  internal func encodeIfPresent<K: CodingKey>(_ value: Int64?, forKey key: K) throws {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }

#if !SKIP // Int = Int32 in Kotlin
  internal func encodeIfPresent<K: CodingKey>(_ value: UInt?, forKey key: K) throws {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }
#endif

  internal func encodeIfPresent<K: CodingKey>(_ value: UInt8?, forKey key: K) throws {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }

  internal func encodeIfPresent<K: CodingKey>(_ value: UInt16?, forKey key: K) throws {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }

  internal func encodeIfPresent<K: CodingKey>(_ value: UInt32?, forKey key: K) throws {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }

  internal func encodeIfPresent<K: CodingKey>(_ value: UInt64?, forKey key: K) throws {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }

  internal func encodeIfPresent<T: Encodable, K: CodingKey>(
    _ value: T?,
    forKey key: K
  ) throws {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }

//  // SKIP DECLARE: internal open inline fun <reified NestedKey> nestedContainer(keyedBy: KClass<NestedKey>, forKey: CodingKey): KeyedEncodingContainer<NestedKey> where NestedKey: CodingKey
//  internal func nestedContainer<NestedKey: CodingKey>(
//    keyedBy keyType: NestedKey.Type,
//    forKey key: CodingKey
//  ) -> KeyedEncodingContainer<NestedKey> {
//    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
//  }

  internal func nestedUnkeyedContainer<K: CodingKey>(
    forKey key: K
  ) -> UnkeyedEncodingContainer {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }

  internal func superEncoder() -> Encoder {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }

  internal func superEncoder<K: CodingKey>(forKey key: K) -> Encoder {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }
}

internal typealias Concrete = KeyedEncodingContainerProtocol


// internal final class _KeyedEncodingContainerBox<Concrete: KeyedEncodingContainerProtocol>: _KeyedEncodingContainerBase {
internal final class _KeyedEncodingContainerBox: _KeyedEncodingContainerBase {
  //typealias Key = Concrete.Key

  internal var concrete: Concrete

  internal init(_ container: Concrete) {
    concrete = container
  }

  override internal var codingPath: [CodingKey] {
    return concrete.codingPath
  }

  override internal func encodeNil<K: CodingKey>(forKey key: K) throws {
    //_internalInvariant(K.self == Key.self)
    //let key = unsafeBitCast(key, to: Key.self)
    try concrete.encodeNil(forKey: key)
  }

  override internal func encode<K: CodingKey>(_ value: Bool, forKey key: K) throws {
    //_internalInvariant(K.self == Key.self)
    //let key = unsafeBitCast(key, to: Key.self)
    try concrete.encode(value, forKey: key)
  }

  override internal func encode<K: CodingKey>(_ value: String, forKey key: K) throws {
    //_internalInvariant(K.self == Key.self)
    //let key = unsafeBitCast(key, to: Key.self)
    try concrete.encode(value, forKey: key)
  }

  override internal func encode<K: CodingKey>(_ value: Double, forKey key: K) throws {
    //_internalInvariant(K.self == Key.self)
    //let key = unsafeBitCast(key, to: Key.self)
    try concrete.encode(value, forKey: key)
  }

  override internal func encode<K: CodingKey>(_ value: Float, forKey key: K) throws {
    //_internalInvariant(K.self == Key.self)
    //let key = unsafeBitCast(key, to: Key.self)
    try concrete.encode(value, forKey: key)
  }

#if !SKIP // Int = Int32 in Kotlin
  override internal func encode<K: CodingKey>(_ value: Int, forKey key: K) throws {
    //_internalInvariant(K.self == Key.self)
    //let key = unsafeBitCast(key, to: Key.self)
    try concrete.encode(value, forKey: key)
  }
#endif

  override internal func encode<K: CodingKey>(_ value: Int8, forKey key: K) throws {
    //_internalInvariant(K.self == Key.self)
    //let key = unsafeBitCast(key, to: Key.self)
    try concrete.encode(value, forKey: key)
  }

  override internal func encode<K: CodingKey>(_ value: Int16, forKey key: K) throws {
    //_internalInvariant(K.self == Key.self)
    //let key = unsafeBitCast(key, to: Key.self)
    try concrete.encode(value, forKey: key)
  }

  override internal func encode<K: CodingKey>(_ value: Int32, forKey key: K) throws {
    //_internalInvariant(K.self == Key.self)
    //let key = unsafeBitCast(key, to: Key.self)
    try concrete.encode(value, forKey: key)
  }

  override internal func encode<K: CodingKey>(_ value: Int64, forKey key: K) throws {
    //_internalInvariant(K.self == Key.self)
    //let key = unsafeBitCast(key, to: Key.self)
    try concrete.encode(value, forKey: key)
  }

#if !SKIP // Int = Int32 in Kotlin
  override internal func encode<K: CodingKey>(_ value: UInt, forKey key: K) throws {
    //_internalInvariant(K.self == Key.self)
    //let key = unsafeBitCast(key, to: Key.self)
    try concrete.encode(value, forKey: key)
  }
#endif

  override internal func encode<K: CodingKey>(_ value: UInt8, forKey key: K) throws {
    //_internalInvariant(K.self == Key.self)
    //let key = unsafeBitCast(key, to: Key.self)
    try concrete.encode(value, forKey: key)
  }

  override internal func encode<K: CodingKey>(_ value: UInt16, forKey key: K) throws {
    //_internalInvariant(K.self == Key.self)
    //let key = unsafeBitCast(key, to: Key.self)
    try concrete.encode(value, forKey: key)
  }

  override internal func encode<K: CodingKey>(_ value: UInt32, forKey key: K) throws {
    //_internalInvariant(K.self == Key.self)
    //let key = unsafeBitCast(key, to: Key.self)
    try concrete.encode(value, forKey: key)
  }

  override internal func encode<K: CodingKey>(_ value: UInt64, forKey key: K) throws {
    //_internalInvariant(K.self == Key.self)
    //let key = unsafeBitCast(key, to: Key.self)
    try concrete.encode(value, forKey: key)
  }

  override internal func encode<T: Encodable, K: CodingKey>(
    _ value: T,
    forKey key: K
  ) throws {
    //_internalInvariant(K.self == Key.self)
    //let key = unsafeBitCast(key, to: Key.self)
    try concrete.encode(value, forKey: key)
  }

  override internal func encodeConditional<T: Encodable, K: CodingKey>(
    _ object: T,
    forKey key: K
  ) throws {
    //_internalInvariant(K.self == Key.self)
    //let key = unsafeBitCast(key, to: Key.self)
    try concrete.encodeConditional(object, forKey: key)
  }

  override internal func encodeIfPresent<K: CodingKey>(
    _ value: Bool?,
    forKey key: K
  ) throws {
    //_internalInvariant(K.self == Key.self)
    //let key = unsafeBitCast(key, to: Key.self)
    try concrete.encodeIfPresent(value, forKey: key)
  }

  override internal func encodeIfPresent<K: CodingKey>(
    _ value: String?,
    forKey key: K
  ) throws {
    //_internalInvariant(K.self == Key.self)
    //let key = unsafeBitCast(key, to: Key.self)
    try concrete.encodeIfPresent(value, forKey: key)
  }

  override internal func encodeIfPresent<K: CodingKey>(
    _ value: Double?,
    forKey key: K
  ) throws {
    //_internalInvariant(K.self == Key.self)
    //let key = unsafeBitCast(key, to: Key.self)
    try concrete.encodeIfPresent(value, forKey: key)
  }

  override internal func encodeIfPresent<K: CodingKey>(
    _ value: Float?,
    forKey key: K
  ) throws {
    //_internalInvariant(K.self == Key.self)
    //let key = unsafeBitCast(key, to: Key.self)
    try concrete.encodeIfPresent(value, forKey: key)
  }

#if !SKIP // Int = Int32 in Kotlin
  override internal func encodeIfPresent<K: CodingKey>(
    _ value: Int?,
    forKey key: K
  ) throws {
    //_internalInvariant(K.self == Key.self)
    //let key = unsafeBitCast(key, to: Key.self)
    try concrete.encodeIfPresent(value, forKey: key)
  }
#endif

  override internal func encodeIfPresent<K: CodingKey>(
    _ value: Int8?,
    forKey key: K
  ) throws {
    //_internalInvariant(K.self == Key.self)
    //let key = unsafeBitCast(key, to: Key.self)
    try concrete.encodeIfPresent(value, forKey: key)
  }

  override internal func encodeIfPresent<K: CodingKey>(
    _ value: Int16?,
    forKey key: K
  ) throws {
    //_internalInvariant(K.self == Key.self)
    //let key = unsafeBitCast(key, to: Key.self)
    try concrete.encodeIfPresent(value, forKey: key)
  }

  override internal func encodeIfPresent<K: CodingKey>(
    _ value: Int32?,
    forKey key: K
  ) throws {
    //_internalInvariant(K.self == Key.self)
    //let key = unsafeBitCast(key, to: Key.self)
    try concrete.encodeIfPresent(value, forKey: key)
  }

  override internal func encodeIfPresent<K: CodingKey>(
    _ value: Int64?,
    forKey key: K
  ) throws {
    //_internalInvariant(K.self == Key.self)
    //let key = unsafeBitCast(key, to: Key.self)
    try concrete.encodeIfPresent(value, forKey: key)
  }

#if !SKIP // Int = Int32 in Kotlin
  override internal func encodeIfPresent<K: CodingKey>(
    _ value: UInt?,
    forKey key: K
  ) throws {
    //_internalInvariant(K.self == Key.self)
    //let key = unsafeBitCast(key, to: Key.self)
    try concrete.encodeIfPresent(value, forKey: key)
  }
#endif

  override internal func encodeIfPresent<K: CodingKey>(
    _ value: UInt8?,
    forKey key: K
  ) throws {
    //_internalInvariant(K.self == Key.self)
    //let key = unsafeBitCast(key, to: Key.self)
    try concrete.encodeIfPresent(value, forKey: key)
  }

  override internal func encodeIfPresent<K: CodingKey>(
    _ value: UInt16?,
    forKey key: K
  ) throws {
    //_internalInvariant(K.self == Key.self)
    //let key = unsafeBitCast(key, to: Key.self)
    try concrete.encodeIfPresent(value, forKey: key)
  }

  override internal func encodeIfPresent<K: CodingKey>(
    _ value: UInt32?,
    forKey key: K
  ) throws {
    //_internalInvariant(K.self == Key.self)
    //let key = unsafeBitCast(key, to: Key.self)
    try concrete.encodeIfPresent(value, forKey: key)
  }

  override internal func encodeIfPresent<K: CodingKey>(
    _ value: UInt64?,
    forKey key: K
  ) throws {
    //_internalInvariant(K.self == Key.self)
    //let key = unsafeBitCast(key, to: Key.self)
    try concrete.encodeIfPresent(value, forKey: key)
  }

  override internal func encodeIfPresent<T: Encodable, K: CodingKey>(
    _ value: T?,
    forKey key: K
  ) throws {
    //_internalInvariant(K.self == Key.self)
    //let key = unsafeBitCast(key, to: Key.self)
    try concrete.encodeIfPresent(value, forKey: key)
  }

//  // SKIP DECLARE: override inline fun <reified NestedKey> nestedContainer(keyedBy: KClass<NestedKey>, forKey: CodingKey): KeyedEncodingContainer<NestedKey> where NestedKey: CodingKey
//  override internal func nestedContainer<NestedKey: CodingKey>(
//    keyedBy keyType: NestedKey.Type,
//    forKey key: CodingKey
//  ) -> KeyedEncodingContainer<NestedKey> {
//    //_internalInvariant(K.self == Key.self)
//    //let key = unsafeBitCast(key, to: Key.self)
//    return concrete.nestedContainer(keyedBy: NestedKey.self, forKey: key)
//  }

  override internal func nestedUnkeyedContainer<K: CodingKey>(
    forKey key: K
  ) -> UnkeyedEncodingContainer {
    //_internalInvariant(K.self == Key.self)
    //let key = unsafeBitCast(key, to: Key.self)
    return concrete.nestedUnkeyedContainer(forKey: key)
  }

  override internal func superEncoder() -> Encoder {
    return concrete.superEncoder()
  }

  override internal func superEncoder<K: CodingKey>(forKey key: K) -> Encoder {
    //_internalInvariant(K.self == Key.self)
    //let key = unsafeBitCast(key, to: Key.self)
    return concrete.superEncoder(forKey: key)
  }
}

//internal class _KeyedDecodingContainerBase {
//  internal init(){}
//
//  deinit {}
//
//  internal var codingPath: [CodingKey] {
//    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
//  }
//
//  internal var allKeys: [CodingKey] {
//    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
//  }
//
//  internal func contains<K: CodingKey>(_ key: K) -> Bool {
//    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
//  }
//
//  internal func decodeNil<K: CodingKey>(forKey key: K) throws -> Bool {
//    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
//  }
//
//  internal func decode<K: CodingKey>(
//    _ type: Bool.Type,
//    forKey key: K
//  ) throws -> Bool {
//    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
//  }
//
//  internal func decode<K: CodingKey>(
//    _ type: String.Type,
//    forKey key: K
//  ) throws -> String {
//    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
//  }
//
//  internal func decode<K: CodingKey>(
//    _ type: Double.Type,
//    forKey key: K
//  ) throws -> Double {
//    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
//  }
//
//  internal func decode<K: CodingKey>(
//    _ type: Float.Type,
//    forKey key: K
//  ) throws -> Float {
//    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
//  }
//
//#if !SKIP // Int = Int32 in Kotlin
//  internal func decode<K: CodingKey>(
//    _ type: Int.Type,
//    forKey key: K
//  ) throws -> Int {
//    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
//  }
//#endif
//
//  internal func decode<K: CodingKey>(
//    _ type: Int8.Type,
//    forKey key: K
//  ) throws -> Int8 {
//    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
//  }
//
//  internal func decode<K: CodingKey>(
//    _ type: Int16.Type,
//    forKey key: K
//  ) throws -> Int16 {
//    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
//  }
//
//  internal func decode<K: CodingKey>(
//    _ type: Int32.Type,
//    forKey key: K
//  ) throws -> Int32 {
//    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
//  }
//
//  internal func decode<K: CodingKey>(
//    _ type: Int64.Type,
//    forKey key: K
//  ) throws -> Int64 {
//    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
//  }
//
//#if !SKIP // Int = Int32 in Kotlin
//  internal func decode<K: CodingKey>(
//    _ type: UInt.Type,
//    forKey key: K
//  ) throws -> UInt {
//    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
//  }
//#endif
//
//  internal func decode<K: CodingKey>(
//    _ type: UInt8.Type,
//    forKey key: K
//  ) throws -> UInt8 {
//    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
//  }
//
//  internal func decode<K: CodingKey>(
//    _ type: UInt16.Type,
//    forKey key: K
//  ) throws -> UInt16 {
//    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
//  }
//
//  internal func decode<K: CodingKey>(
//    _ type: UInt32.Type,
//    forKey key: K
//  ) throws -> UInt32 {
//    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
//  }
//
//  internal func decode<K: CodingKey>(
//    _ type: UInt64.Type,
//    forKey key: K
//  ) throws -> UInt64 {
//    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
//  }
//
//  internal func decode<T: Decodable, K: CodingKey>(
//    _ type: T.Type,
//    forKey key: K
//  ) throws -> T {
//    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
//  }
//
//  internal func decodeIfPresent<K: CodingKey>(
//    _ type: Bool.Type,
//    forKey key: K
//  ) throws -> Bool? {
//    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
//  }
//
//  internal func decodeIfPresent<K: CodingKey>(
//    _ type: String.Type,
//    forKey key: K
//  ) throws -> String? {
//    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
//  }
//
//  internal func decodeIfPresent<K: CodingKey>(
//    _ type: Double.Type,
//    forKey key: K
//  ) throws -> Double? {
//    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
//  }
//
//  internal func decodeIfPresent<K: CodingKey>(
//    _ type: Float.Type,
//    forKey key: K
//  ) throws -> Float? {
//    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
//  }
//
//#if !SKIP // Int = Int32 in Kotlin
//  internal func decodeIfPresent<K: CodingKey>(
//    _ type: Int.Type,
//    forKey key: K
//  ) throws -> Int? {
//    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
//  }
//#endif
//
//  internal func decodeIfPresent<K: CodingKey>(
//    _ type: Int8.Type,
//    forKey key: K
//  ) throws -> Int8? {
//    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
//  }
//
//  internal func decodeIfPresent<K: CodingKey>(
//    _ type: Int16.Type,
//    forKey key: K
//  ) throws -> Int16? {
//    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
//  }
//
//  internal func decodeIfPresent<K: CodingKey>(
//    _ type: Int32.Type,
//    forKey key: K
//  ) throws -> Int32? {
//    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
//  }
//
//  internal func decodeIfPresent<K: CodingKey>(
//    _ type: Int64.Type,
//    forKey key: K
//  ) throws -> Int64? {
//    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
//  }
//
//#if !SKIP // Int = Int32 in Kotlin
//  internal func decodeIfPresent<K: CodingKey>(
//    _ type: UInt.Type,
//    forKey key: K
//  ) throws -> UInt? {
//    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
//  }
//#endif
//
//  internal func decodeIfPresent<K: CodingKey>(
//    _ type: UInt8.Type,
//    forKey key: K
//  ) throws -> UInt8? {
//    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
//  }
//
//  internal func decodeIfPresent<K: CodingKey>(
//    _ type: UInt16.Type,
//    forKey key: K
//  ) throws -> UInt16? {
//    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
//  }
//
//  internal func decodeIfPresent<K: CodingKey>(
//    _ type: UInt32.Type,
//    forKey key: K
//  ) throws -> UInt32? {
//    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
//  }
//
//  internal func decodeIfPresent<K: CodingKey>(
//    _ type: UInt64.Type,
//    forKey key: K
//  ) throws -> UInt64? {
//    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
//  }
//
//  internal func decodeIfPresent<T: Decodable, K: CodingKey>(
//    _ type: T.Type,
//    forKey key: K
//  ) throws -> T? {
//    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
//  }
//
//  internal func nestedContainer<NestedKey, K: CodingKey>(
//    keyedBy type: NestedKey.Type,
//    forKey key: K
//  ) throws -> KeyedDecodingContainer<NestedKey> {
//    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
//  }
//
//  internal func nestedUnkeyedContainer<K: CodingKey>(
//    forKey key: K
//  ) throws -> UnkeyedDecodingContainer {
//    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
//  }
//
//  internal func superDecoder() throws -> Decoder {
//    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
//  }
//
//  internal func superDecoder<K: CodingKey>(forKey key: K) throws -> Decoder {
//    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
//  }
//}
//
//internal final class _KeyedDecodingContainerBox<
//  Concrete: KeyedDecodingContainerProtocol
//>: _KeyedDecodingContainerBase {
//  //typealias Key = Concrete.Key
//
//  internal var concrete: Concrete
//
//  internal init(_ container: Concrete) {
//    concrete = container
//  }
//
//  override var codingPath: [CodingKey] {
//    return concrete.codingPath
//  }
//
//  override var allKeys: [CodingKey] {
//    return concrete.allKeys
//  }
//
//  override internal func contains<K: CodingKey>(_ key: K) -> Bool {
//    //_internalInvariant(K.self == Key.self)
//    //let key = unsafeBitCast(key, to: Key.self)
//    return concrete.contains(key)
//  }
//
//  override internal func decodeNil<K: CodingKey>(forKey key: K) throws -> Bool {
//    //_internalInvariant(K.self == Key.self)
//    //let key = unsafeBitCast(key, to: Key.self)
//    return try concrete.decodeNil(forKey: key)
//  }
//
//  override internal func decode<K: CodingKey>(
//    _ type: Bool.Type,
//    forKey key: K
//  ) throws -> Bool {
//    //_internalInvariant(K.self == Key.self)
//    //let key = unsafeBitCast(key, to: Key.self)
//    return try concrete.decode(Bool.self, forKey: key)
//  }
//
//  override internal func decode<K: CodingKey>(
//    _ type: String.Type,
//    forKey key: K
//  ) throws -> String {
//    //_internalInvariant(K.self == Key.self)
//    //let key = unsafeBitCast(key, to: Key.self)
//    return try concrete.decode(String.self, forKey: key)
//  }
//
//  override internal func decode<K: CodingKey>(
//    _ type: Double.Type,
//    forKey key: K
//  ) throws -> Double {
//    //_internalInvariant(K.self == Key.self)
//    //let key = unsafeBitCast(key, to: Key.self)
//    return try concrete.decode(Double.self, forKey: key)
//  }
//
//  override internal func decode<K: CodingKey>(
//    _ type: Float.Type,
//    forKey key: K
//  ) throws -> Float {
//    //_internalInvariant(K.self == Key.self)
//    //let key = unsafeBitCast(key, to: Key.self)
//    return try concrete.decode(Float.self, forKey: key)
//  }
//
//#if !SKIP // Int = Int32 in Kotlin
//  override internal func decode<K: CodingKey>(
//    _ type: Int.Type,
//    forKey key: K
//  ) throws -> Int {
//    //_internalInvariant(K.self == Key.self)
//    //let key = unsafeBitCast(key, to: Key.self)
//    return try concrete.decode(Int.self, forKey: key)
//  }
//#endif
//
//  override internal func decode<K: CodingKey>(
//    _ type: Int8.Type,
//    forKey key: K
//  ) throws -> Int8 {
//    //_internalInvariant(K.self == Key.self)
//    //let key = unsafeBitCast(key, to: Key.self)
//    return try concrete.decode(Int8.self, forKey: key)
//  }
//
//  override internal func decode<K: CodingKey>(
//    _ type: Int16.Type,
//    forKey key: K
//  ) throws -> Int16 {
//    //_internalInvariant(K.self == Key.self)
//    //let key = unsafeBitCast(key, to: Key.self)
//    return try concrete.decode(Int16.self, forKey: key)
//  }
//
//  override internal func decode<K: CodingKey>(
//    _ type: Int32.Type,
//    forKey key: K
//  ) throws -> Int32 {
//    //_internalInvariant(K.self == Key.self)
//    //let key = unsafeBitCast(key, to: Key.self)
//    return try concrete.decode(Int32.self, forKey: key)
//  }
//
//  override internal func decode<K: CodingKey>(
//    _ type: Int64.Type,
//    forKey key: K
//  ) throws -> Int64 {
//    //_internalInvariant(K.self == Key.self)
//    //let key = unsafeBitCast(key, to: Key.self)
//    return try concrete.decode(Int64.self, forKey: key)
//  }
//
//#if !SKIP // Int = Int32 in Kotlin
//  override internal func decode<K: CodingKey>(
//    _ type: UInt.Type,
//    forKey key: K
//  ) throws -> UInt {
//    //_internalInvariant(K.self == Key.self)
//    //let key = unsafeBitCast(key, to: Key.self)
//    return try concrete.decode(UInt.self, forKey: key)
//  }
//#endif
//
//  override internal func decode<K: CodingKey>(
//    _ type: UInt8.Type,
//    forKey key: K
//  ) throws -> UInt8 {
//    //_internalInvariant(K.self == Key.self)
//    //let key = unsafeBitCast(key, to: Key.self)
//    return try concrete.decode(UInt8.self, forKey: key)
//  }
//
//  override internal func decode<K: CodingKey>(
//    _ type: UInt16.Type,
//    forKey key: K
//  ) throws -> UInt16 {
//    //_internalInvariant(K.self == Key.self)
//    //let key = unsafeBitCast(key, to: Key.self)
//    return try concrete.decode(UInt16.self, forKey: key)
//  }
//
//  override internal func decode<K: CodingKey>(
//    _ type: UInt32.Type,
//    forKey key: K
//  ) throws -> UInt32 {
//    //_internalInvariant(K.self == Key.self)
//    //let key = unsafeBitCast(key, to: Key.self)
//    return try concrete.decode(UInt32.self, forKey: key)
//  }
//
//  override internal func decode<K: CodingKey>(
//    _ type: UInt64.Type,
//    forKey key: K
//  ) throws -> UInt64 {
//    //_internalInvariant(K.self == Key.self)
//    //let key = unsafeBitCast(key, to: Key.self)
//    return try concrete.decode(UInt64.self, forKey: key)
//  }
//
//  override internal func decode<T: Decodable, K: CodingKey>(
//    _ type: T.Type,
//    forKey key: K
//  ) throws -> T {
//    //_internalInvariant(K.self == Key.self)
//    //let key = unsafeBitCast(key, to: Key.self)
//    return try concrete.decode(T.self, forKey: key)
//  }
//
//  override internal func decodeIfPresent<K: CodingKey>(
//    _ type: Bool.Type,
//    forKey key: K
//  ) throws -> Bool? {
//    //_internalInvariant(K.self == Key.self)
//    //let key = unsafeBitCast(key, to: Key.self)
//    return try concrete.decodeIfPresent(Bool.self, forKey: key)
//  }
//
//  override internal func decodeIfPresent<K: CodingKey>(
//    _ type: String.Type,
//    forKey key: K
//  ) throws -> String? {
//    //_internalInvariant(K.self == Key.self)
//    //let key = unsafeBitCast(key, to: Key.self)
//    return try concrete.decodeIfPresent(String.self, forKey: key)
//  }
//
//  override internal func decodeIfPresent<K: CodingKey>(
//    _ type: Double.Type,
//    forKey key: K
//  ) throws -> Double? {
//    //_internalInvariant(K.self == Key.self)
//    //let key = unsafeBitCast(key, to: Key.self)
//    return try concrete.decodeIfPresent(Double.self, forKey: key)
//  }
//
//  override internal func decodeIfPresent<K: CodingKey>(
//    _ type: Float.Type,
//    forKey key: K
//  ) throws -> Float? {
//    //_internalInvariant(K.self == Key.self)
//    //let key = unsafeBitCast(key, to: Key.self)
//    return try concrete.decodeIfPresent(Float.self, forKey: key)
//  }
//
//#if !SKIP // Int = Int32 in Kotlin
//  override internal func decodeIfPresent<K: CodingKey>(
//    _ type: Int.Type,
//    forKey key: K
//  ) throws -> Int? {
//    //_internalInvariant(K.self == Key.self)
//    //let key = unsafeBitCast(key, to: Key.self)
//    return try concrete.decodeIfPresent(Int.self, forKey: key)
//  }
//#endif
//
//  override internal func decodeIfPresent<K: CodingKey>(
//    _ type: Int8.Type,
//    forKey key: K
//  ) throws -> Int8? {
//    //_internalInvariant(K.self == Key.self)
//    //let key = unsafeBitCast(key, to: Key.self)
//    return try concrete.decodeIfPresent(Int8.self, forKey: key)
//  }
//
//  override internal func decodeIfPresent<K: CodingKey>(
//    _ type: Int16.Type,
//    forKey key: K
//  ) throws -> Int16? {
//    //_internalInvariant(K.self == Key.self)
//    //let key = unsafeBitCast(key, to: Key.self)
//    return try concrete.decodeIfPresent(Int16.self, forKey: key)
//  }
//
//  override internal func decodeIfPresent<K: CodingKey>(
//    _ type: Int32.Type,
//    forKey key: K
//  ) throws -> Int32? {
//    //_internalInvariant(K.self == Key.self)
//    //let key = unsafeBitCast(key, to: Key.self)
//    return try concrete.decodeIfPresent(Int32.self, forKey: key)
//  }
//
//  override internal func decodeIfPresent<K: CodingKey>(
//    _ type: Int64.Type,
//    forKey key: K
//  ) throws -> Int64? {
//    //_internalInvariant(K.self == Key.self)
//    //let key = unsafeBitCast(key, to: Key.self)
//    return try concrete.decodeIfPresent(Int64.self, forKey: key)
//  }
//
//#if !SKIP // Int = Int32 in Kotlin
//  override internal func decodeIfPresent<K: CodingKey>(
//    _ type: UInt.Type,
//    forKey key: K
//  ) throws -> UInt? {
//    //_internalInvariant(K.self == Key.self)
//    //let key = unsafeBitCast(key, to: Key.self)
//    return try concrete.decodeIfPresent(UInt.self, forKey: key)
//  }
//#endif
//
//  override internal func decodeIfPresent<K: CodingKey>(
//    _ type: UInt8.Type,
//    forKey key: K
//  ) throws -> UInt8? {
//    //_internalInvariant(K.self == Key.self)
//    //let key = unsafeBitCast(key, to: Key.self)
//    return try concrete.decodeIfPresent(UInt8.self, forKey: key)
//  }
//
//  override internal func decodeIfPresent<K: CodingKey>(
//    _ type: UInt16.Type,
//    forKey key: K
//  ) throws -> UInt16? {
//    //_internalInvariant(K.self == Key.self)
//    //let key = unsafeBitCast(key, to: Key.self)
//    return try concrete.decodeIfPresent(UInt16.self, forKey: key)
//  }
//
//  override internal func decodeIfPresent<K: CodingKey>(
//    _ type: UInt32.Type,
//    forKey key: K
//  ) throws -> UInt32? {
//    //_internalInvariant(K.self == Key.self)
//    //let key = unsafeBitCast(key, to: Key.self)
//    return try concrete.decodeIfPresent(UInt32.self, forKey: key)
//  }
//
//  override internal func decodeIfPresent<K: CodingKey>(
//    _ type: UInt64.Type,
//    forKey key: K
//  ) throws -> UInt64? {
//    //_internalInvariant(K.self == Key.self)
//    //let key = unsafeBitCast(key, to: Key.self)
//    return try concrete.decodeIfPresent(UInt64.self, forKey: key)
//  }
//
//  override internal func decodeIfPresent<T: Decodable, K: CodingKey>(
//    _ type: T.Type,
//    forKey key: K
//  ) throws -> T? {
//    //_internalInvariant(K.self == Key.self)
//    //let key = unsafeBitCast(key, to: Key.self)
//    return try concrete.decodeIfPresent(T.self, forKey: key)
//  }
//
//  override internal func nestedContainer<NestedKey, K: CodingKey>(
//    keyedBy type: NestedKey.Type,
//    forKey key: K
//  ) throws -> KeyedDecodingContainer<NestedKey> {
//    //_internalInvariant(K.self == Key.self)
//    //let key = unsafeBitCast(key, to: Key.self)
//    return try concrete.nestedContainer(keyedBy: NestedKey.self, forKey: key)
//  }
//
//  override internal func nestedUnkeyedContainer<K: CodingKey>(
//    forKey key: K
//  ) throws -> UnkeyedDecodingContainer {
//    //_internalInvariant(K.self == Key.self)
//    //let key = unsafeBitCast(key, to: Key.self)
//    return try concrete.nestedUnkeyedContainer(forKey: key)
//  }
//
//  override internal func superDecoder() throws -> Decoder {
//    return try concrete.superDecoder()
//  }
//
//  override internal func superDecoder<K: CodingKey>(forKey key: K) throws -> Decoder {
//    //_internalInvariant(K.self == Key.self)
//    //let key = unsafeBitCast(key, to: Key.self)
//    return try concrete.superDecoder(forKey: key)
//  }
//}
//
//===----------------------------------------------------------------------===//
// Primitive and RawRepresentable Extensions
//===----------------------------------------------------------------------===//
//extension Bool: Codable {
//  /// Creates a new instance by decoding from the given decoder.
//  ///
//  /// This initializer throws an error if reading from the decoder fails, or
//  /// if the data read is corrupted or otherwise invalid.
//  ///
//  /// - Parameter decoder: The decoder to read data from.
//  public init(from decoder: any Decoder) throws {
//    self = try decoder.singleValueContainer().decode(Bool.self)
//  }
//
//  /// Encodes this value into the given encoder.
//  ///
//  /// This function throws an error if any values are invalid for the given
//  /// encoder's format.
//  ///
//  /// - Parameter encoder: The encoder to write data to.
//  public func encode(to encoder: any Encoder) throws {
//    var container = encoder.singleValueContainer()
//    try container.encode(self)
//  }
//}
//
//extension RawRepresentable<Bool> where Self: Encodable {
//  /// Encodes this value into the given encoder, when the type's `RawValue`
//  /// is `Bool`.
//  ///
//  /// This function throws an error if any values are invalid for the given
//  /// encoder's format.
//  ///
//  /// - Parameter encoder: The encoder to write data to.
//  public func encode(to encoder: any Encoder) throws {
//    var container = encoder.singleValueContainer()
//    try container.encode(self.rawValue)
//  }
//}
//
//extension RawRepresentable<Bool> where Self: Decodable {
//  /// Creates a new instance by decoding from the given decoder, when the
//  /// type's `RawValue` is `Bool`.
//  ///
//  /// This initializer throws an error if reading from the decoder fails, or
//  /// if the data read is corrupted or otherwise invalid.
//  ///
//  /// - Parameter decoder: The decoder to read data from.
//  public init(from decoder: any Decoder) throws {
//    let decoded = try decoder.singleValueContainer().decode(RawValue.self)
//    guard let value = Self(rawValue: decoded) else {
//      throw DecodingError.dataCorrupted(
//        DecodingError.Context(
//          codingPath: decoder.codingPath,
//          debugDescription: "Cannot initialize \(Self.self) from invalid \(RawValue.self) value \(decoded)"
//        )
//      )
//    }
//
//    self = value
//  }
//}
//
//extension String: Codable {
//  /// Creates a new instance by decoding from the given decoder.
//  ///
//  /// This initializer throws an error if reading from the decoder fails, or
//  /// if the data read is corrupted or otherwise invalid.
//  ///
//  /// - Parameter decoder: The decoder to read data from.
//  public init(from decoder: any Decoder) throws {
//    self = try decoder.singleValueContainer().decode(String.self)
//  }
//
//  /// Encodes this value into the given encoder.
//  ///
//  /// This function throws an error if any values are invalid for the given
//  /// encoder's format.
//  ///
//  /// - Parameter encoder: The encoder to write data to.
//  public func encode(to encoder: any Encoder) throws {
//    var container = encoder.singleValueContainer()
//    try container.encode(self)
//  }
//}
//
//extension RawRepresentable<String> where Self: Encodable {
//  /// Encodes this value into the given encoder, when the type's `RawValue`
//  /// is `String`.
//  ///
//  /// This function throws an error if any values are invalid for the given
//  /// encoder's format.
//  ///
//  /// - Parameter encoder: The encoder to write data to.
//  public func encode(to encoder: any Encoder) throws {
//    var container = encoder.singleValueContainer()
//    try container.encode(self.rawValue)
//  }
//}
//
//extension RawRepresentable<String> where Self: Decodable {
//  /// Creates a new instance by decoding from the given decoder, when the
//  /// type's `RawValue` is `String`.
//  ///
//  /// This initializer throws an error if reading from the decoder fails, or
//  /// if the data read is corrupted or otherwise invalid.
//  ///
//  /// - Parameter decoder: The decoder to read data from.
//  public init(from decoder: any Decoder) throws {
//    let decoded = try decoder.singleValueContainer().decode(RawValue.self)
//    guard let value = Self(rawValue: decoded) else {
//      throw DecodingError.dataCorrupted(
//        DecodingError.Context(
//          codingPath: decoder.codingPath,
//          debugDescription: "Cannot initialize \(Self.self) from invalid \(RawValue.self) value \(decoded)"
//        )
//      )
//    }
//
//    self = value
//  }
//}
//
//extension Double: Codable {
//  /// Creates a new instance by decoding from the given decoder.
//  ///
//  /// This initializer throws an error if reading from the decoder fails, or
//  /// if the data read is corrupted or otherwise invalid.
//  ///
//  /// - Parameter decoder: The decoder to read data from.
//  public init(from decoder: any Decoder) throws {
//    self = try decoder.singleValueContainer().decode(Double.self)
//  }
//
//  /// Encodes this value into the given encoder.
//  ///
//  /// This function throws an error if any values are invalid for the given
//  /// encoder's format.
//  ///
//  /// - Parameter encoder: The encoder to write data to.
//  public func encode(to encoder: any Encoder) throws {
//    var container = encoder.singleValueContainer()
//    try container.encode(self)
//  }
//}
//
//extension RawRepresentable<Double> where Self: Encodable {
//  /// Encodes this value into the given encoder, when the type's `RawValue`
//  /// is `Double`.
//  ///
//  /// This function throws an error if any values are invalid for the given
//  /// encoder's format.
//  ///
//  /// - Parameter encoder: The encoder to write data to.
//  public func encode(to encoder: any Encoder) throws {
//    var container = encoder.singleValueContainer()
//    try container.encode(self.rawValue)
//  }
//}
//
//extension RawRepresentable<Double> where Self: Decodable {
//  /// Creates a new instance by decoding from the given decoder, when the
//  /// type's `RawValue` is `Double`.
//  ///
//  /// This initializer throws an error if reading from the decoder fails, or
//  /// if the data read is corrupted or otherwise invalid.
//  ///
//  /// - Parameter decoder: The decoder to read data from.
//  public init(from decoder: any Decoder) throws {
//    let decoded = try decoder.singleValueContainer().decode(RawValue.self)
//    guard let value = Self(rawValue: decoded) else {
//      throw DecodingError.dataCorrupted(
//        DecodingError.Context(
//          codingPath: decoder.codingPath,
//          debugDescription: "Cannot initialize \(Self.self) from invalid \(RawValue.self) value \(decoded)"
//        )
//      )
//    }
//
//    self = value
//  }
//}
//
//extension Float: Codable {
//  /// Creates a new instance by decoding from the given decoder.
//  ///
//  /// This initializer throws an error if reading from the decoder fails, or
//  /// if the data read is corrupted or otherwise invalid.
//  ///
//  /// - Parameter decoder: The decoder to read data from.
//  public init(from decoder: any Decoder) throws {
//    self = try decoder.singleValueContainer().decode(Float.self)
//  }
//
//  /// Encodes this value into the given encoder.
//  ///
//  /// This function throws an error if any values are invalid for the given
//  /// encoder's format.
//  ///
//  /// - Parameter encoder: The encoder to write data to.
//  public func encode(to encoder: any Encoder) throws {
//    var container = encoder.singleValueContainer()
//    try container.encode(self)
//  }
//}
//
//extension RawRepresentable<Float> where Self: Encodable {
//  /// Encodes this value into the given encoder, when the type's `RawValue`
//  /// is `Float`.
//  ///
//  /// This function throws an error if any values are invalid for the given
//  /// encoder's format.
//  ///
//  /// - Parameter encoder: The encoder to write data to.
//  public func encode(to encoder: any Encoder) throws {
//    var container = encoder.singleValueContainer()
//    try container.encode(self.rawValue)
//  }
//}
//
//extension RawRepresentable<Float> where Self: Decodable {
//  /// Creates a new instance by decoding from the given decoder, when the
//  /// type's `RawValue` is `Float`.
//  ///
//  /// This initializer throws an error if reading from the decoder fails, or
//  /// if the data read is corrupted or otherwise invalid.
//  ///
//  /// - Parameter decoder: The decoder to read data from.
//  public init(from decoder: any Decoder) throws {
//    let decoded = try decoder.singleValueContainer().decode(RawValue.self)
//    guard let value = Self(rawValue: decoded) else {
//      throw DecodingError.dataCorrupted(
//        DecodingError.Context(
//          codingPath: decoder.codingPath,
//          debugDescription: "Cannot initialize \(Self.self) from invalid \(RawValue.self) value \(decoded)"
//        )
//      )
//    }
//
//    self = value
//  }
//}
//
//#if !((os(macOS) || targetEnvironment(macCatalyst)) && arch(x86_64))
//@available(SwiftStdlib 5.3, *)
//extension Float16: Codable {
//  /// Creates a new instance by decoding from the given decoder.
//  ///
//  /// This initializer throws an error if reading from the decoder fails, or
//  /// if the data read is corrupted or otherwise invalid.
//  ///
//  /// - Parameter decoder: The decoder to read data from.
//  public init(from decoder: any Decoder) throws {
//    let floatValue = try Float(from: decoder)
//    self = Float16(floatValue)
//    if isInfinite && floatValue.isFinite {
//      throw DecodingError.dataCorrupted(
//        DecodingError.Context(
//          codingPath: decoder.codingPath,
//          debugDescription: "Parsed JSON number \(floatValue) does not fit in Float16."
//        )
//      )
//    }
//  }
//
//  /// Encodes this value into the given encoder.
//  ///
//  /// This function throws an error if any values are invalid for the given
//  /// encoder's format.
//  ///
//  /// - Parameter encoder: The encoder to write data to.
//  public func encode(to encoder: any Encoder) throws {
//    try Float(self).encode(to: encoder)
//  }
//}
//#endif
//
//extension Int: Codable {
//  /// Creates a new instance by decoding from the given decoder.
//  ///
//  /// This initializer throws an error if reading from the decoder fails, or
//  /// if the data read is corrupted or otherwise invalid.
//  ///
//  /// - Parameter decoder: The decoder to read data from.
//  public init(from decoder: any Decoder) throws {
//    self = try decoder.singleValueContainer().decode(Int.self)
//  }
//
//  /// Encodes this value into the given encoder.
//  ///
//  /// This function throws an error if any values are invalid for the given
//  /// encoder's format.
//  ///
//  /// - Parameter encoder: The encoder to write data to.
//  public func encode(to encoder: any Encoder) throws {
//    var container = encoder.singleValueContainer()
//    try container.encode(self)
//  }
//}
//
//extension RawRepresentable<Int> where Self: Encodable {
//  /// Encodes this value into the given encoder, when the type's `RawValue`
//  /// is `Int`.
//  ///
//  /// This function throws an error if any values are invalid for the given
//  /// encoder's format.
//  ///
//  /// - Parameter encoder: The encoder to write data to.
//  public func encode(to encoder: any Encoder) throws {
//    var container = encoder.singleValueContainer()
//    try container.encode(self.rawValue)
//  }
//}
//
//extension RawRepresentable<Int> where Self: Decodable {
//  /// Creates a new instance by decoding from the given decoder, when the
//  /// type's `RawValue` is `Int`.
//  ///
//  /// This initializer throws an error if reading from the decoder fails, or
//  /// if the data read is corrupted or otherwise invalid.
//  ///
//  /// - Parameter decoder: The decoder to read data from.
//  public init(from decoder: any Decoder) throws {
//    let decoded = try decoder.singleValueContainer().decode(RawValue.self)
//    guard let value = Self(rawValue: decoded) else {
//      throw DecodingError.dataCorrupted(
//        DecodingError.Context(
//          codingPath: decoder.codingPath,
//          debugDescription: "Cannot initialize \(Self.self) from invalid \(RawValue.self) value \(decoded)"
//        )
//      )
//    }
//
//    self = value
//  }
//}
//
//extension Int8: Codable {
//  /// Creates a new instance by decoding from the given decoder.
//  ///
//  /// This initializer throws an error if reading from the decoder fails, or
//  /// if the data read is corrupted or otherwise invalid.
//  ///
//  /// - Parameter decoder: The decoder to read data from.
//  public init(from decoder: any Decoder) throws {
//    self = try decoder.singleValueContainer().decode(Int8.self)
//  }
//
//  /// Encodes this value into the given encoder.
//  ///
//  /// This function throws an error if any values are invalid for the given
//  /// encoder's format.
//  ///
//  /// - Parameter encoder: The encoder to write data to.
//  public func encode(to encoder: any Encoder) throws {
//    var container = encoder.singleValueContainer()
//    try container.encode(self)
//  }
//}
//
//extension RawRepresentable<Int8> where Self: Encodable {
//  /// Encodes this value into the given encoder, when the type's `RawValue`
//  /// is `Int8`.
//  ///
//  /// This function throws an error if any values are invalid for the given
//  /// encoder's format.
//  ///
//  /// - Parameter encoder: The encoder to write data to.
//  public func encode(to encoder: any Encoder) throws {
//    var container = encoder.singleValueContainer()
//    try container.encode(self.rawValue)
//  }
//}
//
//extension RawRepresentable<Int8> where Self: Decodable {
//  /// Creates a new instance by decoding from the given decoder, when the
//  /// type's `RawValue` is `Int8`.
//  ///
//  /// This initializer throws an error if reading from the decoder fails, or
//  /// if the data read is corrupted or otherwise invalid.
//  ///
//  /// - Parameter decoder: The decoder to read data from.
//  public init(from decoder: any Decoder) throws {
//    let decoded = try decoder.singleValueContainer().decode(RawValue.self)
//    guard let value = Self(rawValue: decoded) else {
//      throw DecodingError.dataCorrupted(
//        DecodingError.Context(
//          codingPath: decoder.codingPath,
//          debugDescription: "Cannot initialize \(Self.self) from invalid \(RawValue.self) value \(decoded)"
//        )
//      )
//    }
//
//    self = value
//  }
//}
//
//extension Int16: Codable {
//  /// Creates a new instance by decoding from the given decoder.
//  ///
//  /// This initializer throws an error if reading from the decoder fails, or
//  /// if the data read is corrupted or otherwise invalid.
//  ///
//  /// - Parameter decoder: The decoder to read data from.
//  public init(from decoder: any Decoder) throws {
//    self = try decoder.singleValueContainer().decode(Int16.self)
//  }
//
//  /// Encodes this value into the given encoder.
//  ///
//  /// This function throws an error if any values are invalid for the given
//  /// encoder's format.
//  ///
//  /// - Parameter encoder: The encoder to write data to.
//  public func encode(to encoder: any Encoder) throws {
//    var container = encoder.singleValueContainer()
//    try container.encode(self)
//  }
//}
//
//extension RawRepresentable<Int16> where Self: Encodable {
//  /// Encodes this value into the given encoder, when the type's `RawValue`
//  /// is `Int16`.
//  ///
//  /// This function throws an error if any values are invalid for the given
//  /// encoder's format.
//  ///
//  /// - Parameter encoder: The encoder to write data to.
//  public func encode(to encoder: any Encoder) throws {
//    var container = encoder.singleValueContainer()
//    try container.encode(self.rawValue)
//  }
//}
//
//extension RawRepresentable<Int16> where Self: Decodable {
//  /// Creates a new instance by decoding from the given decoder, when the
//  /// type's `RawValue` is `Int16`.
//  ///
//  /// This initializer throws an error if reading from the decoder fails, or
//  /// if the data read is corrupted or otherwise invalid.
//  ///
//  /// - Parameter decoder: The decoder to read data from.
//  public init(from decoder: any Decoder) throws {
//    let decoded = try decoder.singleValueContainer().decode(RawValue.self)
//    guard let value = Self(rawValue: decoded) else {
//      throw DecodingError.dataCorrupted(
//        DecodingError.Context(
//          codingPath: decoder.codingPath,
//          debugDescription: "Cannot initialize \(Self.self) from invalid \(RawValue.self) value \(decoded)"
//        )
//      )
//    }
//
//    self = value
//  }
//}
//
//extension Int32: Codable {
//  /// Creates a new instance by decoding from the given decoder.
//  ///
//  /// This initializer throws an error if reading from the decoder fails, or
//  /// if the data read is corrupted or otherwise invalid.
//  ///
//  /// - Parameter decoder: The decoder to read data from.
//  public init(from decoder: any Decoder) throws {
//    self = try decoder.singleValueContainer().decode(Int32.self)
//  }
//
//  /// Encodes this value into the given encoder.
//  ///
//  /// This function throws an error if any values are invalid for the given
//  /// encoder's format.
//  ///
//  /// - Parameter encoder: The encoder to write data to.
//  public func encode(to encoder: any Encoder) throws {
//    var container = encoder.singleValueContainer()
//    try container.encode(self)
//  }
//}
//
//extension RawRepresentable<Int32> where Self: Encodable {
//  /// Encodes this value into the given encoder, when the type's `RawValue`
//  /// is `Int32`.
//  ///
//  /// This function throws an error if any values are invalid for the given
//  /// encoder's format.
//  ///
//  /// - Parameter encoder: The encoder to write data to.
//  public func encode(to encoder: any Encoder) throws {
//    var container = encoder.singleValueContainer()
//    try container.encode(self.rawValue)
//  }
//}
//
//extension RawRepresentable<Int32> where Self: Decodable {
//  /// Creates a new instance by decoding from the given decoder, when the
//  /// type's `RawValue` is `Int32`.
//  ///
//  /// This initializer throws an error if reading from the decoder fails, or
//  /// if the data read is corrupted or otherwise invalid.
//  ///
//  /// - Parameter decoder: The decoder to read data from.
//  public init(from decoder: any Decoder) throws {
//    let decoded = try decoder.singleValueContainer().decode(RawValue.self)
//    guard let value = Self(rawValue: decoded) else {
//      throw DecodingError.dataCorrupted(
//        DecodingError.Context(
//          codingPath: decoder.codingPath,
//          debugDescription: "Cannot initialize \(Self.self) from invalid \(RawValue.self) value \(decoded)"
//        )
//      )
//    }
//
//    self = value
//  }
//}
//
//extension Int64: Codable {
//  /// Creates a new instance by decoding from the given decoder.
//  ///
//  /// This initializer throws an error if reading from the decoder fails, or
//  /// if the data read is corrupted or otherwise invalid.
//  ///
//  /// - Parameter decoder: The decoder to read data from.
//  public init(from decoder: any Decoder) throws {
//    self = try decoder.singleValueContainer().decode(Int64.self)
//  }
//
//  /// Encodes this value into the given encoder.
//  ///
//  /// This function throws an error if any values are invalid for the given
//  /// encoder's format.
//  ///
//  /// - Parameter encoder: The encoder to write data to.
//  public func encode(to encoder: any Encoder) throws {
//    var container = encoder.singleValueContainer()
//    try container.encode(self)
//  }
//}
//
//extension RawRepresentable<Int64> where Self: Encodable {
//  /// Encodes this value into the given encoder, when the type's `RawValue`
//  /// is `Int64`.
//  ///
//  /// This function throws an error if any values are invalid for the given
//  /// encoder's format.
//  ///
//  /// - Parameter encoder: The encoder to write data to.
//  public func encode(to encoder: any Encoder) throws {
//    var container = encoder.singleValueContainer()
//    try container.encode(self.rawValue)
//  }
//}
//
//extension RawRepresentable<Int64> where Self: Decodable {
//  /// Creates a new instance by decoding from the given decoder, when the
//  /// type's `RawValue` is `Int64`.
//  ///
//  /// This initializer throws an error if reading from the decoder fails, or
//  /// if the data read is corrupted or otherwise invalid.
//  ///
//  /// - Parameter decoder: The decoder to read data from.
//  public init(from decoder: any Decoder) throws {
//    let decoded = try decoder.singleValueContainer().decode(RawValue.self)
//    guard let value = Self(rawValue: decoded) else {
//      throw DecodingError.dataCorrupted(
//        DecodingError.Context(
//          codingPath: decoder.codingPath,
//          debugDescription: "Cannot initialize \(Self.self) from invalid \(RawValue.self) value \(decoded)"
//        )
//      )
//    }
//
//    self = value
//  }
//}
//
//extension UInt: Codable {
//  /// Creates a new instance by decoding from the given decoder.
//  ///
//  /// This initializer throws an error if reading from the decoder fails, or
//  /// if the data read is corrupted or otherwise invalid.
//  ///
//  /// - Parameter decoder: The decoder to read data from.
//  public init(from decoder: any Decoder) throws {
//    self = try decoder.singleValueContainer().decode(UInt.self)
//  }
//
//  /// Encodes this value into the given encoder.
//  ///
//  /// This function throws an error if any values are invalid for the given
//  /// encoder's format.
//  ///
//  /// - Parameter encoder: The encoder to write data to.
//  public func encode(to encoder: any Encoder) throws {
//    var container = encoder.singleValueContainer()
//    try container.encode(self)
//  }
//}
//
//extension RawRepresentable<UInt> where Self: Encodable {
//  /// Encodes this value into the given encoder, when the type's `RawValue`
//  /// is `UInt`.
//  ///
//  /// This function throws an error if any values are invalid for the given
//  /// encoder's format.
//  ///
//  /// - Parameter encoder: The encoder to write data to.
//  public func encode(to encoder: any Encoder) throws {
//    var container = encoder.singleValueContainer()
//    try container.encode(self.rawValue)
//  }
//}
//
//extension RawRepresentable<UInt> where Self: Decodable {
//  /// Creates a new instance by decoding from the given decoder, when the
//  /// type's `RawValue` is `UInt`.
//  ///
//  /// This initializer throws an error if reading from the decoder fails, or
//  /// if the data read is corrupted or otherwise invalid.
//  ///
//  /// - Parameter decoder: The decoder to read data from.
//  public init(from decoder: any Decoder) throws {
//    let decoded = try decoder.singleValueContainer().decode(RawValue.self)
//    guard let value = Self(rawValue: decoded) else {
//      throw DecodingError.dataCorrupted(
//        DecodingError.Context(
//          codingPath: decoder.codingPath,
//          debugDescription: "Cannot initialize \(Self.self) from invalid \(RawValue.self) value \(decoded)"
//        )
//      )
//    }
//
//    self = value
//  }
//}
//
//extension UInt8: Codable {
//  /// Creates a new instance by decoding from the given decoder.
//  ///
//  /// This initializer throws an error if reading from the decoder fails, or
//  /// if the data read is corrupted or otherwise invalid.
//  ///
//  /// - Parameter decoder: The decoder to read data from.
//  public init(from decoder: any Decoder) throws {
//    self = try decoder.singleValueContainer().decode(UInt8.self)
//  }
//
//  /// Encodes this value into the given encoder.
//  ///
//  /// This function throws an error if any values are invalid for the given
//  /// encoder's format.
//  ///
//  /// - Parameter encoder: The encoder to write data to.
//  public func encode(to encoder: any Encoder) throws {
//    var container = encoder.singleValueContainer()
//    try container.encode(self)
//  }
//}
//
//extension RawRepresentable<UInt8> where Self: Encodable {
//  /// Encodes this value into the given encoder, when the type's `RawValue`
//  /// is `UInt8`.
//  ///
//  /// This function throws an error if any values are invalid for the given
//  /// encoder's format.
//  ///
//  /// - Parameter encoder: The encoder to write data to.
//  public func encode(to encoder: any Encoder) throws {
//    var container = encoder.singleValueContainer()
//    try container.encode(self.rawValue)
//  }
//}
//
//extension RawRepresentable<UInt8> where Self: Decodable {
//  /// Creates a new instance by decoding from the given decoder, when the
//  /// type's `RawValue` is `UInt8`.
//  ///
//  /// This initializer throws an error if reading from the decoder fails, or
//  /// if the data read is corrupted or otherwise invalid.
//  ///
//  /// - Parameter decoder: The decoder to read data from.
//  public init(from decoder: any Decoder) throws {
//    let decoded = try decoder.singleValueContainer().decode(RawValue.self)
//    guard let value = Self(rawValue: decoded) else {
//      throw DecodingError.dataCorrupted(
//        DecodingError.Context(
//          codingPath: decoder.codingPath,
//          debugDescription: "Cannot initialize \(Self.self) from invalid \(RawValue.self) value \(decoded)"
//        )
//      )
//    }
//
//    self = value
//  }
//}
//
//extension UInt16: Codable {
//  /// Creates a new instance by decoding from the given decoder.
//  ///
//  /// This initializer throws an error if reading from the decoder fails, or
//  /// if the data read is corrupted or otherwise invalid.
//  ///
//  /// - Parameter decoder: The decoder to read data from.
//  public init(from decoder: any Decoder) throws {
//    self = try decoder.singleValueContainer().decode(UInt16.self)
//  }
//
//  /// Encodes this value into the given encoder.
//  ///
//  /// This function throws an error if any values are invalid for the given
//  /// encoder's format.
//  ///
//  /// - Parameter encoder: The encoder to write data to.
//  public func encode(to encoder: any Encoder) throws {
//    var container = encoder.singleValueContainer()
//    try container.encode(self)
//  }
//}
//
//extension RawRepresentable<UInt16> where Self: Encodable {
//  /// Encodes this value into the given encoder, when the type's `RawValue`
//  /// is `UInt16`.
//  ///
//  /// This function throws an error if any values are invalid for the given
//  /// encoder's format.
//  ///
//  /// - Parameter encoder: The encoder to write data to.
//  public func encode(to encoder: any Encoder) throws {
//    var container = encoder.singleValueContainer()
//    try container.encode(self.rawValue)
//  }
//}
//
//extension RawRepresentable<UInt16> where Self: Decodable {
//  /// Creates a new instance by decoding from the given decoder, when the
//  /// type's `RawValue` is `UInt16`.
//  ///
//  /// This initializer throws an error if reading from the decoder fails, or
//  /// if the data read is corrupted or otherwise invalid.
//  ///
//  /// - Parameter decoder: The decoder to read data from.
//  public init(from decoder: any Decoder) throws {
//    let decoded = try decoder.singleValueContainer().decode(RawValue.self)
//    guard let value = Self(rawValue: decoded) else {
//      throw DecodingError.dataCorrupted(
//        DecodingError.Context(
//          codingPath: decoder.codingPath,
//          debugDescription: "Cannot initialize \(Self.self) from invalid \(RawValue.self) value \(decoded)"
//        )
//      )
//    }
//
//    self = value
//  }
//}
//
//extension UInt32: Codable {
//  /// Creates a new instance by decoding from the given decoder.
//  ///
//  /// This initializer throws an error if reading from the decoder fails, or
//  /// if the data read is corrupted or otherwise invalid.
//  ///
//  /// - Parameter decoder: The decoder to read data from.
//  public init(from decoder: any Decoder) throws {
//    self = try decoder.singleValueContainer().decode(UInt32.self)
//  }
//
//  /// Encodes this value into the given encoder.
//  ///
//  /// This function throws an error if any values are invalid for the given
//  /// encoder's format.
//  ///
//  /// - Parameter encoder: The encoder to write data to.
//  public func encode(to encoder: any Encoder) throws {
//    var container = encoder.singleValueContainer()
//    try container.encode(self)
//  }
//}
//
//extension RawRepresentable<UInt32> where Self: Encodable {
//  /// Encodes this value into the given encoder, when the type's `RawValue`
//  /// is `UInt32`.
//  ///
//  /// This function throws an error if any values are invalid for the given
//  /// encoder's format.
//  ///
//  /// - Parameter encoder: The encoder to write data to.
//  public func encode(to encoder: any Encoder) throws {
//    var container = encoder.singleValueContainer()
//    try container.encode(self.rawValue)
//  }
//}
//
//extension RawRepresentable<UInt32> where Self: Decodable {
//  /// Creates a new instance by decoding from the given decoder, when the
//  /// type's `RawValue` is `UInt32`.
//  ///
//  /// This initializer throws an error if reading from the decoder fails, or
//  /// if the data read is corrupted or otherwise invalid.
//  ///
//  /// - Parameter decoder: The decoder to read data from.
//  public init(from decoder: any Decoder) throws {
//    let decoded = try decoder.singleValueContainer().decode(RawValue.self)
//    guard let value = Self(rawValue: decoded) else {
//      throw DecodingError.dataCorrupted(
//        DecodingError.Context(
//          codingPath: decoder.codingPath,
//          debugDescription: "Cannot initialize \(Self.self) from invalid \(RawValue.self) value \(decoded)"
//        )
//      )
//    }
//
//    self = value
//  }
//}
//
//extension UInt64: Codable {
//  /// Creates a new instance by decoding from the given decoder.
//  ///
//  /// This initializer throws an error if reading from the decoder fails, or
//  /// if the data read is corrupted or otherwise invalid.
//  ///
//  /// - Parameter decoder: The decoder to read data from.
//  public init(from decoder: any Decoder) throws {
//    self = try decoder.singleValueContainer().decode(UInt64.self)
//  }
//
//  /// Encodes this value into the given encoder.
//  ///
//  /// This function throws an error if any values are invalid for the given
//  /// encoder's format.
//  ///
//  /// - Parameter encoder: The encoder to write data to.
//  public func encode(to encoder: any Encoder) throws {
//    var container = encoder.singleValueContainer()
//    try container.encode(self)
//  }
//}
//
//extension RawRepresentable<UInt64> where Self: Encodable {
//  /// Encodes this value into the given encoder, when the type's `RawValue`
//  /// is `UInt64`.
//  ///
//  /// This function throws an error if any values are invalid for the given
//  /// encoder's format.
//  ///
//  /// - Parameter encoder: The encoder to write data to.
//  public func encode(to encoder: any Encoder) throws {
//    var container = encoder.singleValueContainer()
//    try container.encode(self.rawValue)
//  }
//}
//
//extension RawRepresentable<UInt64> where Self: Decodable {
//  /// Creates a new instance by decoding from the given decoder, when the
//  /// type's `RawValue` is `UInt64`.
//  ///
//  /// This initializer throws an error if reading from the decoder fails, or
//  /// if the data read is corrupted or otherwise invalid.
//  ///
//  /// - Parameter decoder: The decoder to read data from.
//  public init(from decoder: any Decoder) throws {
//    let decoded = try decoder.singleValueContainer().decode(RawValue.self)
//    guard let value = Self(rawValue: decoded) else {
//      throw DecodingError.dataCorrupted(
//        DecodingError.Context(
//          codingPath: decoder.codingPath,
//          debugDescription: "Cannot initialize \(Self.self) from invalid \(RawValue.self) value \(decoded)"
//        )
//      )
//    }
//
//    self = value
//  }
//}
//
////===----------------------------------------------------------------------===//
//// Optional/Collection Type Conformances
////===----------------------------------------------------------------------===//
//extension Optional: Encodable where Wrapped: Encodable {
//  /// Encodes this optional value into the given encoder.
//  ///
//  /// This function throws an error if any values are invalid for the given
//  /// encoder's format.
//  ///
//  /// - Parameter encoder: The encoder to write data to.
//  public func encode(to encoder: any Encoder) throws {
//    var container = encoder.singleValueContainer()
//    switch self {
//    case .none: try container.encodeNil()
//    case .some(let wrapped): try container.encode(wrapped)
//    }
//  }
//}
//
//extension Optional: Decodable where Wrapped: Decodable {
//  /// Creates a new instance by decoding from the given decoder.
//  ///
//  /// This initializer throws an error if reading from the decoder fails, or
//  /// if the data read is corrupted or otherwise invalid.
//  ///
//  /// - Parameter decoder: The decoder to read data from.
//  public init(from decoder: any Decoder) throws {
//    let container = try decoder.singleValueContainer()
//    if container.decodeNil() {
//      self = .none
//    }  else {
//      let element = try container.decode(Wrapped.self)
//      self = .some(element)
//    }
//  }
//}
//
//extension Array: Encodable where Element: Encodable {
//  /// Encodes the elements of this array into the given encoder in an unkeyed
//  /// container.
//  ///
//  /// This function throws an error if any values are invalid for the given
//  /// encoder's format.
//  ///
//  /// - Parameter encoder: The encoder to write data to.
//  public func encode(to encoder: any Encoder) throws {
//    var container = encoder.unkeyedContainer()
//    for element in self {
//      try container.encode(element)
//    }
//  }
//}
//
//extension Array: Decodable where Element: Decodable {
//  /// Creates a new array by decoding from the given decoder.
//  ///
//  /// This initializer throws an error if reading from the decoder fails, or
//  /// if the data read is corrupted or otherwise invalid.
//  ///
//  /// - Parameter decoder: The decoder to read data from.
//  public init(from decoder: any Decoder) throws {
//    self.init()
//
//    var container = try decoder.unkeyedContainer()
//    while !container.isAtEnd {
//      let element = try container.decode(Element.self)
//      self.append(element)
//    }
//  }
//}
//
//extension ContiguousArray: Encodable where Element: Encodable {
//  /// Encodes the elements of this contiguous array into the given encoder
//  /// in an unkeyed container.
//  ///
//  /// This function throws an error if any values are invalid for the given
//  /// encoder's format.
//  ///
//  /// - Parameter encoder: The encoder to write data to.
//  public func encode(to encoder: any Encoder) throws {
//    var container = encoder.unkeyedContainer()
//    for element in self {
//      try container.encode(element)
//    }
//  }
//}
//
//extension ContiguousArray: Decodable where Element: Decodable {
//  /// Creates a new contiguous array by decoding from the given decoder.
//  ///
//  /// This initializer throws an error if reading from the decoder fails, or
//  /// if the data read is corrupted or otherwise invalid.
//  ///
//  /// - Parameter decoder: The decoder to read data from.
//  public init(from decoder: any Decoder) throws {
//    self.init()
//
//    var container = try decoder.unkeyedContainer()
//    while !container.isAtEnd {
//      let element = try container.decode(Element.self)
//      self.append(element)
//    }
//  }
//}
//
//extension Set: Encodable where Element: Encodable {
//  /// Encodes the elements of this set into the given encoder in an unkeyed
//  /// container.
//  ///
//  /// This function throws an error if any values are invalid for the given
//  /// encoder's format.
//  ///
//  /// - Parameter encoder: The encoder to write data to.
//  public func encode(to encoder: any Encoder) throws {
//    var container = encoder.unkeyedContainer()
//    for element in self {
//      try container.encode(element)
//    }
//  }
//}
//
//extension Set: Decodable where Element: Decodable {
//  /// Creates a new set by decoding from the given decoder.
//  ///
//  /// This initializer throws an error if reading from the decoder fails, or
//  /// if the data read is corrupted or otherwise invalid.
//  ///
//  /// - Parameter decoder: The decoder to read data from.
//  public init(from decoder: any Decoder) throws {
//    self.init()
//
//    var container = try decoder.unkeyedContainer()
//    while !container.isAtEnd {
//      let element = try container.decode(Element.self)
//      self.insert(element)
//    }
//  }
//}
//
///// A wrapper for dictionary keys which are Strings or Ints.
//internal struct _DictionaryCodingKey: CodingKey {
//  internal let stringValue: String
//  internal let intValue: Int?
//
//  internal init(stringValue: String) {
//    self.stringValue = stringValue
//    self.intValue = Int(stringValue)
//  }
//
//  internal init(intValue: Int) {
//    self.stringValue = "\(intValue)"
//    self.intValue = intValue
//  }
//
//  fileprivate init(codingKey: any CodingKey) {
//    self.stringValue = codingKey.stringValue
//    self.intValue = codingKey.intValue
//  }
//}
//
///// A type that can be converted to and from a coding key.
/////
///// With a `CodingKeyRepresentable` type, you can losslessly convert between a
///// custom type and a `CodingKey` type.
/////
///// Conforming a type to `CodingKeyRepresentable` lets you opt in to encoding
///// and decoding `Dictionary` values keyed by the conforming type to and from
///// a keyed container, rather than encoding and decoding the dictionary as an
///// unkeyed container of alternating key-value pairs.
//@available(SwiftStdlib 5.6, *)
//public protocol CodingKeyRepresentable {
//  @available(SwiftStdlib 5.6, *)
//  var codingKey: CodingKey { get }
//  @available(SwiftStdlib 5.6, *)
//  init?<T: CodingKey>(codingKey: T)
//}
//
//@available(SwiftStdlib 5.6, *)
//extension RawRepresentable
//where Self: CodingKeyRepresentable, RawValue == String {
//  @available(SwiftStdlib 5.6, *)
//  public var codingKey: CodingKey {
//    _DictionaryCodingKey(stringValue: rawValue)
//  }
//  @available(SwiftStdlib 5.6, *)
//  public init?<T: CodingKey>(codingKey: T) {
//    self.init(rawValue: codingKey.stringValue)
//  }
//}
//
//@available(SwiftStdlib 5.6, *)
//extension RawRepresentable where Self: CodingKeyRepresentable, RawValue == Int {
//  @available(SwiftStdlib 5.6, *)
//  public var codingKey: CodingKey {
//    _DictionaryCodingKey(intValue: rawValue)
//  }
//  @available(SwiftStdlib 5.6, *)
//  public init?<T: CodingKey>(codingKey: T) {
//    if let intValue = codingKey.intValue {
//      self.init(rawValue: intValue)
//    } else {
//      return nil
//    }
//  }
//}
//
//@available(SwiftStdlib 5.6, *)
//extension Int: CodingKeyRepresentable {
//  @available(SwiftStdlib 5.6, *)
//  public var codingKey: CodingKey {
//    _DictionaryCodingKey(intValue: self)
//  }
//  @available(SwiftStdlib 5.6, *)
//  public init?<T: CodingKey>(codingKey: T) {
//    if let intValue = codingKey.intValue {
//      self = intValue
//    } else {
//      return nil
//    }
//  }
//}
//
//@available(SwiftStdlib 5.6, *)
//extension String: CodingKeyRepresentable {
//  @available(SwiftStdlib 5.6, *)
//  public var codingKey: CodingKey {
//    _DictionaryCodingKey(stringValue: self)
//  }
//  @available(SwiftStdlib 5.6, *)
//  public init?<T: CodingKey>(codingKey: T) {
//    self = codingKey.stringValue
//  }
//}
//
//extension Dictionary: Encodable where Key: Encodable, Value: Encodable {
//  /// Encodes the contents of this dictionary into the given encoder.
//  ///
//  /// If the dictionary uses keys that are `String`, `Int`, or a type conforming
//  /// to `CodingKeyRepresentable`, the contents are encoded in a keyed
//  /// container. Otherwise, the contents are encoded as alternating key-value
//  /// pairs in an unkeyed container.
//  ///
//  /// This function throws an error if any values are invalid for the given
//  /// encoder's format.
//  ///
//  /// - Parameter encoder: The encoder to write data to.
//  public func encode(to encoder: any Encoder) throws {
//    if Key.self == String.self {
//      // Since the keys are already Strings, we can use them as keys directly.
//      var container = encoder.container(keyedBy: _DictionaryCodingKey.self)
//      for (key, value) in self {
//        let codingKey = _DictionaryCodingKey(stringValue: key as! String)
//        try container.encode(value, forKey: codingKey)
//      }
//    } else if Key.self == Int.self {
//      // Since the keys are already Ints, we can use them as keys directly.
//      var container = encoder.container(keyedBy: _DictionaryCodingKey.self)
//      for (key, value) in self {
//        let codingKey = _DictionaryCodingKey(intValue: key as! Int)
//        try container.encode(value, forKey: codingKey)
//      }
//    } else if #available(SwiftStdlib 5.6, *),
//              Key.self is CodingKeyRepresentable.Type {
//      // Since the keys are CodingKeyRepresentable, we can use the `codingKey`
//      // to create `_DictionaryCodingKey` instances.
//      var container = encoder.container(keyedBy: _DictionaryCodingKey.self)
//      for (key, value) in self {
//        let codingKey = (key as! CodingKeyRepresentable).codingKey
//        let dictionaryCodingKey = _DictionaryCodingKey(codingKey: codingKey)
//        try container.encode(value, forKey: dictionaryCodingKey)
//      }
//    } else {
//      // Keys are Encodable but not Strings or Ints, so we cannot arbitrarily
//      // convert to keys. We can encode as an array of alternating key-value
//      // pairs, though.
//      var container = encoder.unkeyedContainer()
//      for (key, value) in self {
//        try container.encode(key)
//        try container.encode(value)
//      }
//    }
//  }
//}
//
//extension Dictionary: Decodable where Key: Decodable, Value: Decodable {
//  /// Creates a new dictionary by decoding from the given decoder.
//  ///
//  /// This initializer throws an error if reading from the decoder fails, or
//  /// if the data read is corrupted or otherwise invalid.
//  ///
//  /// - Parameter decoder: The decoder to read data from.
//  public init(from decoder: any Decoder) throws {
//    self.init()
//
//    if Key.self == String.self {
//      // The keys are Strings, so we should be able to expect a keyed container.
//      let container = try decoder.container(keyedBy: _DictionaryCodingKey.self)
//      for key in container.allKeys {
//        let value = try container.decode(Value.self, forKey: key)
//        self[key.stringValue as! Key] = value
//      }
//    } else if Key.self == Int.self {
//      // The keys are Ints, so we should be able to expect a keyed container.
//      let container = try decoder.container(keyedBy: _DictionaryCodingKey.self)
//      for key in container.allKeys {
//        guard key.intValue != nil else {
//          // We provide stringValues for Int keys; if an encoder chooses not to
//          // use the actual intValues, we've encoded string keys.
//          // So on init, _DictionaryCodingKey tries to parse string keys as
//          // Ints. If that succeeds, then we would have had an intValue here.
//          // We don't, so this isn't a valid Int key.
//          var codingPath = decoder.codingPath
//          codingPath.append(key)
//          throw DecodingError.typeMismatch(
//            Int.self,
//            DecodingError.Context(
//              codingPath: codingPath,
//              debugDescription: "Expected Int key but found String key instead."
//            )
//          )
//        }
//
//        let value = try container.decode(Value.self, forKey: key)
//        self[key.intValue! as! Key] = value
//      }
//    } else if #available(SwiftStdlib 5.6, *),
//              let keyType = Key.self as? CodingKeyRepresentable.Type {
//      // The keys are CodingKeyRepresentable, so we should be able to expect
//      // a keyed container.
//      let container = try decoder.container(keyedBy: _DictionaryCodingKey.self)
//      for codingKey in container.allKeys {
//        guard let key: Key = keyType.init(codingKey: codingKey) as? Key else {
//          throw DecodingError.dataCorruptedError(
//            forKey: codingKey,
//            in: container,
//            debugDescription: "Could not convert key to type \(Key.self)"
//          )
//        }
//        let value: Value = try container.decode(Value.self, forKey: codingKey)
//        self[key] = value
//      }
//    } else {
//      // We should have encoded as an array of alternating key-value pairs.
//      var container = try decoder.unkeyedContainer()
//
//      // We're expecting to get pairs. If the container has a known count, it
//      // had better be even; no point in doing work if not.
//      if let count = container.count {
//        guard count % 2 == 0 else {
//          throw DecodingError.dataCorrupted(
//            DecodingError.Context(
//              codingPath: decoder.codingPath,
//              debugDescription: "Expected collection of key-value pairs; encountered odd-length array instead."
//            )
//          )
//        }
//      }
//
//      while !container.isAtEnd {
//        let key = try container.decode(Key.self)
//
//        guard !container.isAtEnd else {
//          throw DecodingError.dataCorrupted(
//            DecodingError.Context(
//              codingPath: decoder.codingPath,
//              debugDescription: "Unkeyed container reached end before value in key-value pair."
//            )
//          )
//        }
//
//        let value = try container.decode(Value.self)
//        self[key] = value
//      }
//    }
//  }
//}
//
////===----------------------------------------------------------------------===//
//// Convenience Default Implementations
////===----------------------------------------------------------------------===//
//// Default implementation of encodeConditional(_:forKey:) in terms of
//// encode(_:forKey:)
//extension KeyedEncodingContainerProtocol {
//  public mutating func encodeConditional<T: AnyObject & Encodable>(
//    _ object: T,
//    forKey key: Key
//  ) throws {
//    try encode(object, forKey: key)
//  }
//}
//
//// Default implementation of encodeIfPresent(_:forKey:) in terms of
//// encode(_:forKey:)
//extension KeyedEncodingContainerProtocol {
//  public mutating func encodeIfPresent(
//    _ value: Bool?,
//    forKey key: Key
//  ) throws {
//    guard let value = value else { return }
//    try encode(value, forKey: key)
//  }
//
//  public mutating func encodeIfPresent(
//    _ value: String?,
//    forKey key: Key
//  ) throws {
//    guard let value = value else { return }
//    try encode(value, forKey: key)
//  }
//
//  public mutating func encodeIfPresent(
//    _ value: Double?,
//    forKey key: Key
//  ) throws {
//    guard let value = value else { return }
//    try encode(value, forKey: key)
//  }
//
//  public mutating func encodeIfPresent(
//    _ value: Float?,
//    forKey key: Key
//  ) throws {
//    guard let value = value else { return }
//    try encode(value, forKey: key)
//  }
//
//  public mutating func encodeIfPresent(
//    _ value: Int?,
//    forKey key: Key
//  ) throws {
//    guard let value = value else { return }
//    try encode(value, forKey: key)
//  }
//
//  public mutating func encodeIfPresent(
//    _ value: Int8?,
//    forKey key: Key
//  ) throws {
//    guard let value = value else { return }
//    try encode(value, forKey: key)
//  }
//
//  public mutating func encodeIfPresent(
//    _ value: Int16?,
//    forKey key: Key
//  ) throws {
//    guard let value = value else { return }
//    try encode(value, forKey: key)
//  }
//
//  public mutating func encodeIfPresent(
//    _ value: Int32?,
//    forKey key: Key
//  ) throws {
//    guard let value = value else { return }
//    try encode(value, forKey: key)
//  }
//
//  public mutating func encodeIfPresent(
//    _ value: Int64?,
//    forKey key: Key
//  ) throws {
//    guard let value = value else { return }
//    try encode(value, forKey: key)
//  }
//
//  public mutating func encodeIfPresent(
//    _ value: UInt?,
//    forKey key: Key
//  ) throws {
//    guard let value = value else { return }
//    try encode(value, forKey: key)
//  }
//
//  public mutating func encodeIfPresent(
//    _ value: UInt8?,
//    forKey key: Key
//  ) throws {
//    guard let value = value else { return }
//    try encode(value, forKey: key)
//  }
//
//  public mutating func encodeIfPresent(
//    _ value: UInt16?,
//    forKey key: Key
//  ) throws {
//    guard let value = value else { return }
//    try encode(value, forKey: key)
//  }
//
//  public mutating func encodeIfPresent(
//    _ value: UInt32?,
//    forKey key: Key
//  ) throws {
//    guard let value = value else { return }
//    try encode(value, forKey: key)
//  }
//
//  public mutating func encodeIfPresent(
//    _ value: UInt64?,
//    forKey key: Key
//  ) throws {
//    guard let value = value else { return }
//    try encode(value, forKey: key)
//  }
//
//  public mutating func encodeIfPresent<T: Encodable>(
//    _ value: T?,
//    forKey key: Key
//  ) throws {
//    guard let value = value else { return }
//    try encode(value, forKey: key)
//  }
//}
//
//// Default implementation of decodeIfPresent(_:forKey:) in terms of
//// decode(_:forKey:) and decodeNil(forKey:)
//extension KeyedDecodingContainerProtocol {
//  public func decodeIfPresent(
//    _ type: Bool.Type,
//    forKey key: Key
//  ) throws -> Bool? {
//    guard try self.contains(key) && !self.decodeNil(forKey: key)
//      else { return nil }
//    return try self.decode(Bool.self, forKey: key)
//  }
//
//  public func decodeIfPresent(
//    _ type: String.Type,
//    forKey key: Key
//  ) throws -> String? {
//    guard try self.contains(key) && !self.decodeNil(forKey: key)
//      else { return nil }
//    return try self.decode(String.self, forKey: key)
//  }
//
//  public func decodeIfPresent(
//    _ type: Double.Type,
//    forKey key: Key
//  ) throws -> Double? {
//    guard try self.contains(key) && !self.decodeNil(forKey: key)
//      else { return nil }
//    return try self.decode(Double.self, forKey: key)
//  }
//
//  public func decodeIfPresent(
//    _ type: Float.Type,
//    forKey key: Key
//  ) throws -> Float? {
//    guard try self.contains(key) && !self.decodeNil(forKey: key)
//      else { return nil }
//    return try self.decode(Float.self, forKey: key)
//  }
//
//  public func decodeIfPresent(
//    _ type: Int.Type,
//    forKey key: Key
//  ) throws -> Int? {
//    guard try self.contains(key) && !self.decodeNil(forKey: key)
//      else { return nil }
//    return try self.decode(Int.self, forKey: key)
//  }
//
//  public func decodeIfPresent(
//    _ type: Int8.Type,
//    forKey key: Key
//  ) throws -> Int8? {
//    guard try self.contains(key) && !self.decodeNil(forKey: key)
//      else { return nil }
//    return try self.decode(Int8.self, forKey: key)
//  }
//
//  public func decodeIfPresent(
//    _ type: Int16.Type,
//    forKey key: Key
//  ) throws -> Int16? {
//    guard try self.contains(key) && !self.decodeNil(forKey: key)
//      else { return nil }
//    return try self.decode(Int16.self, forKey: key)
//  }
//
//  public func decodeIfPresent(
//    _ type: Int32.Type,
//    forKey key: Key
//  ) throws -> Int32? {
//    guard try self.contains(key) && !self.decodeNil(forKey: key)
//      else { return nil }
//    return try self.decode(Int32.self, forKey: key)
//  }
//
//  public func decodeIfPresent(
//    _ type: Int64.Type,
//    forKey key: Key
//  ) throws -> Int64? {
//    guard try self.contains(key) && !self.decodeNil(forKey: key)
//      else { return nil }
//    return try self.decode(Int64.self, forKey: key)
//  }
//
//  public func decodeIfPresent(
//    _ type: UInt.Type,
//    forKey key: Key
//  ) throws -> UInt? {
//    guard try self.contains(key) && !self.decodeNil(forKey: key)
//      else { return nil }
//    return try self.decode(UInt.self, forKey: key)
//  }
//
//  public func decodeIfPresent(
//    _ type: UInt8.Type,
//    forKey key: Key
//  ) throws -> UInt8? {
//    guard try self.contains(key) && !self.decodeNil(forKey: key)
//      else { return nil }
//    return try self.decode(UInt8.self, forKey: key)
//  }
//
//  public func decodeIfPresent(
//    _ type: UInt16.Type,
//    forKey key: Key
//  ) throws -> UInt16? {
//    guard try self.contains(key) && !self.decodeNil(forKey: key)
//      else { return nil }
//    return try self.decode(UInt16.self, forKey: key)
//  }
//
//  public func decodeIfPresent(
//    _ type: UInt32.Type,
//    forKey key: Key
//  ) throws -> UInt32? {
//    guard try self.contains(key) && !self.decodeNil(forKey: key)
//      else { return nil }
//    return try self.decode(UInt32.self, forKey: key)
//  }
//
//  public func decodeIfPresent(
//    _ type: UInt64.Type,
//    forKey key: Key
//  ) throws -> UInt64? {
//    guard try self.contains(key) && !self.decodeNil(forKey: key)
//      else { return nil }
//    return try self.decode(UInt64.self, forKey: key)
//  }
//
//  public func decodeIfPresent<T: Decodable>(
//    _ type: T.Type,
//    forKey key: Key
//  ) throws -> T? {
//    guard try self.contains(key) && !self.decodeNil(forKey: key)
//      else { return nil }
//    return try self.decode(T.self, forKey: key)
//  }
//}
//
//// Default implementation of encodeConditional(_:) in terms of encode(_:),
//// and encode(contentsOf:) in terms of encode(_:) loop.
//extension UnkeyedEncodingContainer {
//  public mutating func encodeConditional<T: AnyObject & Encodable>(
//    _ object: T
//  ) throws {
//    try self.encode(object)
//  }
//
//  public mutating func encode<T: Sequence>(
//    contentsOf sequence: T
//  ) throws where T.Element == Bool {
//    for element in sequence {
//      try self.encode(element)
//    }
//  }
//
//  public mutating func encode<T: Sequence>(
//    contentsOf sequence: T
//  ) throws where T.Element == String {
//    for element in sequence {
//      try self.encode(element)
//    }
//  }
//
//  public mutating func encode<T: Sequence>(
//    contentsOf sequence: T
//  ) throws where T.Element == Double {
//    for element in sequence {
//      try self.encode(element)
//    }
//  }
//
//  public mutating func encode<T: Sequence>(
//    contentsOf sequence: T
//  ) throws where T.Element == Float {
//    for element in sequence {
//      try self.encode(element)
//    }
//  }
//
//  public mutating func encode<T: Sequence>(
//    contentsOf sequence: T
//  ) throws where T.Element == Int {
//    for element in sequence {
//      try self.encode(element)
//    }
//  }
//
//  public mutating func encode<T: Sequence>(
//    contentsOf sequence: T
//  ) throws where T.Element == Int8 {
//    for element in sequence {
//      try self.encode(element)
//    }
//  }
//
//  public mutating func encode<T: Sequence>(
//    contentsOf sequence: T
//  ) throws where T.Element == Int16 {
//    for element in sequence {
//      try self.encode(element)
//    }
//  }
//
//  public mutating func encode<T: Sequence>(
//    contentsOf sequence: T
//  ) throws where T.Element == Int32 {
//    for element in sequence {
//      try self.encode(element)
//    }
//  }
//
//  public mutating func encode<T: Sequence>(
//    contentsOf sequence: T
//  ) throws where T.Element == Int64 {
//    for element in sequence {
//      try self.encode(element)
//    }
//  }
//
//  public mutating func encode<T: Sequence>(
//    contentsOf sequence: T
//  ) throws where T.Element == UInt {
//    for element in sequence {
//      try self.encode(element)
//    }
//  }
//
//  public mutating func encode<T: Sequence>(
//    contentsOf sequence: T
//  ) throws where T.Element == UInt8 {
//    for element in sequence {
//      try self.encode(element)
//    }
//  }
//
//  public mutating func encode<T: Sequence>(
//    contentsOf sequence: T
//  ) throws where T.Element == UInt16 {
//    for element in sequence {
//      try self.encode(element)
//    }
//  }
//
//  public mutating func encode<T: Sequence>(
//    contentsOf sequence: T
//  ) throws where T.Element == UInt32 {
//    for element in sequence {
//      try self.encode(element)
//    }
//  }
//
//  public mutating func encode<T: Sequence>(
//    contentsOf sequence: T
//  ) throws where T.Element == UInt64 {
//    for element in sequence {
//      try self.encode(element)
//    }
//  }
//
//  public mutating func encode<T: Sequence>(
//    contentsOf sequence: T
//  ) throws where T.Element: Encodable {
//    for element in sequence {
//      try self.encode(element)
//    }
//  }
//}
//
//// Default implementation of decodeIfPresent(_:) in terms of decode(_:) and
//// decodeNil()
//extension UnkeyedDecodingContainer {
//  public mutating func decodeIfPresent(
//    _ type: Bool.Type
//  ) throws -> Bool? {
//    guard try !self.isAtEnd && !self.decodeNil() else { return nil }
//    return try self.decode(Bool.self)
//  }
//
//  public mutating func decodeIfPresent(
//    _ type: String.Type
//  ) throws -> String? {
//    guard try !self.isAtEnd && !self.decodeNil() else { return nil }
//    return try self.decode(String.self)
//  }
//
//  public mutating func decodeIfPresent(
//    _ type: Double.Type
//  ) throws -> Double? {
//    guard try !self.isAtEnd && !self.decodeNil() else { return nil }
//    return try self.decode(Double.self)
//  }
//
//  public mutating func decodeIfPresent(
//    _ type: Float.Type
//  ) throws -> Float? {
//    guard try !self.isAtEnd && !self.decodeNil() else { return nil }
//    return try self.decode(Float.self)
//  }
//
//  public mutating func decodeIfPresent(
//    _ type: Int.Type
//  ) throws -> Int? {
//    guard try !self.isAtEnd && !self.decodeNil() else { return nil }
//    return try self.decode(Int.self)
//  }
//
//  public mutating func decodeIfPresent(
//    _ type: Int8.Type
//  ) throws -> Int8? {
//    guard try !self.isAtEnd && !self.decodeNil() else { return nil }
//    return try self.decode(Int8.self)
//  }
//
//  public mutating func decodeIfPresent(
//    _ type: Int16.Type
//  ) throws -> Int16? {
//    guard try !self.isAtEnd && !self.decodeNil() else { return nil }
//    return try self.decode(Int16.self)
//  }
//
//  public mutating func decodeIfPresent(
//    _ type: Int32.Type
//  ) throws -> Int32? {
//    guard try !self.isAtEnd && !self.decodeNil() else { return nil }
//    return try self.decode(Int32.self)
//  }
//
//  public mutating func decodeIfPresent(
//    _ type: Int64.Type
//  ) throws -> Int64? {
//    guard try !self.isAtEnd && !self.decodeNil() else { return nil }
//    return try self.decode(Int64.self)
//  }
//
//  public mutating func decodeIfPresent(
//    _ type: UInt.Type
//  ) throws -> UInt? {
//    guard try !self.isAtEnd && !self.decodeNil() else { return nil }
//    return try self.decode(UInt.self)
//  }
//
//  public mutating func decodeIfPresent(
//    _ type: UInt8.Type
//  ) throws -> UInt8? {
//    guard try !self.isAtEnd && !self.decodeNil() else { return nil }
//    return try self.decode(UInt8.self)
//  }
//
//  public mutating func decodeIfPresent(
//    _ type: UInt16.Type
//  ) throws -> UInt16? {
//    guard try !self.isAtEnd && !self.decodeNil() else { return nil }
//    return try self.decode(UInt16.self)
//  }
//
//  public mutating func decodeIfPresent(
//    _ type: UInt32.Type
//  ) throws -> UInt32? {
//    guard try !self.isAtEnd && !self.decodeNil() else { return nil }
//    return try self.decode(UInt32.self)
//  }
//
//  public mutating func decodeIfPresent(
//    _ type: UInt64.Type
//  ) throws -> UInt64? {
//    guard try !self.isAtEnd && !self.decodeNil() else { return nil }
//    return try self.decode(UInt64.self)
//  }
//
//  public mutating func decodeIfPresent<T: Decodable>(
//    _ type: T.Type
//  ) throws -> T? {
//    guard try !self.isAtEnd && !self.decodeNil() else { return nil }
//    return try self.decode(T.self)
//  }
//}
