// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
#if !SKIP
@_exported import Foundation
#endif

/// A runtime check for whether we are running in a JVM, which is based on whether Ints are 32 or 64 bit
public let isJVM = Int.max == Int32.max

internal func SkipFoundationInternalModuleName() -> String {
    return "SkipFoundation"
}

public func SkipFoundationPublicModuleName() -> String {
    return "SkipFoundation"
}

// MARK: Foundation Adapter Types

#if SKIP
public typealias AnyClass = kotlin.reflect.KClass<Any>
public typealias NSObject = java.lang.Object
public typealias NSString = kotlin.String
public typealias NSNumber = java.lang.Number
public typealias NSURL = SkipURL
public typealias NSUUID = SkipUUID
public typealias NSDate = SkipDate

public protocol NSObjectProtocol {
}

//public extension NSObjectProtocol {
//    public var description: String { "\(self)" }
//    public func isEqual(_ other: Any?) -> Bool { other === self }
//}

public struct NSNull {
    public static let null = NSNull()
    public init() {
    }
}

public func NSString(string: String) -> NSString { string }

public extension java.lang.Number {
    var doubleValue: Double { doubleValue() }
    var intValue: Int { intValue() }
    var longValue: Int64 { longValue() }
    var int64Value: Int64 { longValue() }
    var int32Value: Int32 { intValue() }
    var int16Value: Int16 { shortValue() }
    var int8Value: Int8 { byteValue() }
}

/// Initializing an NSNumber with a numeric value just returns the instance itself
public func NSNumber(value: Int8) -> NSNumber { value as NSNumber }
public func NSNumber(value: Int16) -> NSNumber { value as NSNumber }
public func NSNumber(value: Int32) -> NSNumber { value as NSNumber }
public func NSNumber(value: Int64) -> NSNumber { value as NSNumber }
public func NSNumber(value: UInt8) -> NSNumber { value as NSNumber }
public func NSNumber(value: UInt16) -> NSNumber { value as NSNumber }
public func NSNumber(value: UInt32) -> NSNumber { value as NSNumber }
public func NSNumber(value: UInt64) -> NSNumber { value as NSNumber }
public func NSNumber(value: Float) -> NSNumber { value as NSNumber }
public func NSNumber(value: Double) -> NSNumber { value as NSNumber }

public func abs(_ number: Double) -> Double { Math.abs(number) }
public func sqrt(_ number: Double) -> Double { Math.sqrt(number) }
public func sin(_ number: Double) -> Double { Math.sin(number) }
public func cos(_ number: Double) -> Double { Math.cos(number) }
public func atan(_ number: Double) -> Double { Math.atan(number) }

public struct ObjCBool : RawRepresentable {
    public var rawValue: Bool

    init(rawValue: Bool) {
        self.rawValue = rawValue
    }

    init(_ rawValue: Bool) {
        self.rawValue = rawValue
    }

    init(booleanLiteral: Bool) {
        self.rawValue = booleanLiteral
    }

    public var boolValue: Bool {
        return rawValue
    }
}

// MARK: Foundation Stubs

internal protocol SocketPort {
}

internal protocol AttributedString {
}

internal protocol NotificationCenter {
}

internal protocol PersonNameComponents {
}

internal protocol Operation {
}

internal protocol OperationQueue {
}

internal class XMLParser {
}

internal protocol XMLParserDelegate {
}

internal class URLCache {
    public enum StoragePolicy {
        case allowed
        case allowedInMemoryOnly
        case notAllowed
    }
}

internal protocol CachedURLResponse {
}

internal func strlen(_ string: String) -> Int {
    return string.count
}

internal func strncmp(_ str1: String, _ str2: String) -> Int {
    return str1.toLowerCase() == str2.toLowerCase() ? 0 : 1
}

internal func NSLog(_ message: String) {
    //logger.info(message)
    print(message)
}

public class NSCoder : NSObject {
}


// Cannot extend `NSObject`: An Error type cannot extend another class because it will be translated to extend Exception in Kotlin
public class NSError : Error {
}

public protocol CustomNSError : Error {
    /// The domain of the error.
    //static var errorDomain: String { get }

    /// The error code within the given domain.
    //var errorCode: Int { get }

    /// The user-info dictionary.
    //var errorUserInfo: [String : Any] { get }
}

//internal class NSString : NSObject {
//}
//
//internal class NSMutableString : NSString {
//}


internal protocol NSRange {
}

internal class NSData : NSObject {
}

internal class NSMutableData : NSData {
}

internal class NSAttributedString : NSObject {
    public struct Key {
    }
}

internal class NSMutableAttributedString : NSAttributedString {
}

internal class NSCharacterSet : NSObject {
}

internal class NSMutableCharacterSet : NSCharacterSet {
}

internal class NSArray : NSObject {
}

internal class NSMutableArray : NSArray {
}

internal class NSDateComponents : NSArray {
}

internal class NSPredicate : NSObject {
}

internal class NSTextCheckingResult : NSObject {
}

internal protocol NSBinarySearchingOptions {
}

internal protocol NSCoding {
}

internal protocol NSSecureCoding {
}

internal protocol NSKeyedArchiver {
}

internal protocol NSKeyedUnarchiver {
}

// MARK: Foundation Placeholders

internal protocol ComparisonResult {
}

internal protocol DateIntervalFormatter {
}

internal struct EnergyFormatter {
}

internal struct LengthFormatter {
}

internal struct MassFormatter {
}

internal protocol HTTPCookieStorage {
}

internal protocol ISO8601DateFormatter {
}

internal protocol FileHandle {
}

#endif


#if !SKIP
// The non-Skip version is in FoundationHelpers.kt
func foundationHelperDemo() -> String {
    return "Swift"
}
#endif
