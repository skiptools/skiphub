// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
import Foundation
import XCTest

// These tests are adapted from https://github.com/apple/swift-corelibs-foundation/blob/main/Tests/Foundation/Tests which have the following license:


// This source file is part of the Swift.org open source project
//
// Copyright (c) 2014 - 2016 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See http://swift.org/LICENSE.txt for license information
// See http://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//

class TestUUID : XCTestCase {
    
    #if !SKIP
    static var allTests: [(String, (TestUUID) -> () throws -> Void)] {
        return [
            ("test_UUIDEquality", test_UUIDEquality),
            ("test_UUIDInvalid", test_UUIDInvalid),
            ("test_UUIDuuidString", test_UUIDuuidString),
            ("test_UUIDdescription", test_UUIDdescription),
            ("test_UUIDNSCoding", test_UUIDNSCoding),
            ("test_hash", test_hash),
        ]
    }
    #endif // SKIP
    
    func test_UUIDEquality() {
        #if SKIP
        throw XCTSkip("TODO")
        #else
        let uuidA = UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E5F")
        let uuidB = UUID(uuidString: "e621e1f8-c36c-495a-93fc-0c247a3e6e5f")
        let uuidC = UUID(uuid: (0xe6,0x21,0xe1,0xf8,0xc3,0x6c,0x49,0x5a,0x93,0xfc,0x0c,0x24,0x7a,0x3e,0x6e,0x5f))
        let uuidD = UUID()
        
        XCTAssertEqual(uuidA, uuidB, "String case must not matter.")
        XCTAssertEqual(uuidA, uuidC, "A UUID initialized with a string must be equal to the same UUID initialized with its UnsafePointer<UInt8> equivalent representation.")
        XCTAssertNotEqual(uuidC, uuidD, "Two different UUIDs must not be equal.")
        #endif // !SKIP
    }
    
    func test_UUIDInvalid() {
        #if SKIP
        throw XCTSkip("TODO")
        #else
        let uuid = UUID(uuidString: "Invalid UUID")
        XCTAssertNil(uuid, "The convenience initializer `init?(uuidString string:)` must return nil for an invalid UUID string.")
        #endif // !SKIP
    }
    
    // `uuidString` should return an uppercase string
    // See: https://bugs.swift.org/browse/SR-865
    func test_UUIDuuidString() {
        #if SKIP
        throw XCTSkip("TODO")
        #else
        let uuid = UUID(uuid: (0xe6,0x21,0xe1,0xf8,0xc3,0x6c,0x49,0x5a,0x93,0xfc,0x0c,0x24,0x7a,0x3e,0x6e,0x5f))
        XCTAssertEqual(uuid.uuidString, "E621E1F8-C36C-495A-93FC-0C247A3E6E5F", "The uuidString representation must be uppercase.")
        #endif // !SKIP
    }
    
    func test_UUIDdescription() {
        #if SKIP
        throw XCTSkip("TODO")
        #else
        let uuid = UUID()
        XCTAssertEqual(uuid.description, uuid.uuidString, "The description must be the same as the uuidString.")
        #endif // !SKIP
    }
    
    func test_UUIDNSCoding() {
        #if SKIP
        throw XCTSkip("TODO")
        #else
        let uuidA = UUID()
        let uuidB = NSKeyedUnarchiver.unarchiveObject(with: NSKeyedArchiver.archivedData(withRootObject: uuidA)) as! UUID
        XCTAssertEqual(uuidA, uuidB, "Archived then unarchived uuid must be equal.")
        #endif // !SKIP
    }

    func test_hash() {
        #if SKIP
        throw XCTSkip("TODO")
        #else
        let values: [UUID] = [
            // This list takes a UUID and tweaks every byte while
            // leaving the version/variant intact.
            UUID(uuidString: "a53baa1c-b4f5-48db-9467-9786b76b256c")!,
            UUID(uuidString: "a63baa1c-b4f5-48db-9467-9786b76b256c")!,
            UUID(uuidString: "a53caa1c-b4f5-48db-9467-9786b76b256c")!,
            UUID(uuidString: "a53bab1c-b4f5-48db-9467-9786b76b256c")!,
            UUID(uuidString: "a53baa1d-b4f5-48db-9467-9786b76b256c")!,
            UUID(uuidString: "a53baa1c-b5f5-48db-9467-9786b76b256c")!,
            UUID(uuidString: "a53baa1c-b4f6-48db-9467-9786b76b256c")!,
            UUID(uuidString: "a53baa1c-b4f5-49db-9467-9786b76b256c")!,
            UUID(uuidString: "a53baa1c-b4f5-48dc-9467-9786b76b256c")!,
            UUID(uuidString: "a53baa1c-b4f5-48db-9567-9786b76b256c")!,
            UUID(uuidString: "a53baa1c-b4f5-48db-9468-9786b76b256c")!,
            UUID(uuidString: "a53baa1c-b4f5-48db-9467-9886b76b256c")!,
            UUID(uuidString: "a53baa1c-b4f5-48db-9467-9787b76b256c")!,
            UUID(uuidString: "a53baa1c-b4f5-48db-9467-9786b86b256c")!,
            UUID(uuidString: "a53baa1c-b4f5-48db-9467-9786b76c256c")!,
            UUID(uuidString: "a53baa1c-b4f5-48db-9467-9786b76b266c")!,
            UUID(uuidString: "a53baa1c-b4f5-48db-9467-9786b76b256d")!,
        ]
        checkHashable(values, equalityOracle: { $0 == $1 })
        #endif // !SKIP
    }
}


