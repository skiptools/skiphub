// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
import Foundation
import XCTest
#if !SKIP
@testable import SkipFoundation
#endif

// Stand-in types for test case compilation.
// These types will all eventually be implemented in SkipFoundation, but by providing stubs here we enable to test case scaffold to compile

#if SKIP

// MARK: Foundation Stubs

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

internal protocol URLSessionTaskDelegate {
}

internal protocol URLSessionDataDelegate {
}

internal protocol CharacterSet {
}

internal protocol AttributedString {
}

// MARK: NextStep Foundation Stubs

internal protocol NSObjectProtocol {
}

internal class NSObject : NSObjectProtocol {
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

#endif
