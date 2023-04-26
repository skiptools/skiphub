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

// MARK: Foundation Stubs

// These are the types names that are sufficient for the core foundation
// tests to compile and will eventually be implemented in SkipFoundation

#if SKIP


// MARK: Foundation Stubs

public protocol AnyClass {
}

public protocol NSObjectProtocol {
}

public class NSObject : NSObjectProtocol {
    public var description: String { "\(self)" }
    public func isEqual(_ other: Any?) -> Bool { false }
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

internal class NSCalendar : NSObject {
    struct Options {
    }

    enum Unit {
        case era
        case year
        case month
        case day
        case hour
        case minute
        case second
        case weekday
        case weekdayOrdinal
        case quarter
        case weekOfMonth
        case weekOfYear
        case yearForWeekOfYear
        case nanosecond
        case calendar
        case timeZone
    }

    enum Identifier {
        case gregorian
        case buddhist
        case chinese
        case coptic
        case ethiopicAmeteMihret
        case ethiopicAmeteAlem
        case hebrew
        case ISO8601
        case indian
        case islamic
        case islamicCivil
        case japanese
        case persian
        case republicOfChina
        case islamicTabular
        case islamicUmmAlQura
    }
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

internal protocol DateInterval {
}

internal protocol DateIntervalFormatter {
}

internal protocol DataProtocol {
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

internal protocol IndexSet {
}

internal protocol FileHandle {
}

internal class URLSession {
    class ResponseDisposition {
    }
}

internal protocol URLResponse {
}


internal protocol URLSessionTask {
}

internal protocol URLSessionDataTask : URLSessionTask {
}

protocol URLSessionDelegate : NSObjectProtocol {
}

internal protocol URLSessionTaskDelegate : URLSessionDelegate {
}

internal protocol URLSessionDataDelegate : URLSessionTaskDelegate {
}

internal protocol CharacterSet {
}

internal protocol AttributedString {
}

#endif


#if !SKIP
// The non-Skip version is in FoundationHelpers.kt
func foundationHelperDemo() -> String {
    return "Swift"
}
#endif
