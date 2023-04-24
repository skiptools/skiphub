// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
import Foundation
import XCTest

// These tests are adapted from https://github.com/apple/swift-corelibs-foundation/blob/main/Tests/Foundation/Tests which have the following license:

#if !SKIP

// This source file is part of the Swift.org open source project
//
// Copyright (c) 2014 - 2016 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See http://swift.org/LICENSE.txt for license information
// See http://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//

class TestHost: XCTestCase {
    
#if !os(iOS)
    static var allTests: [(String, (TestHost) -> () throws -> Void)] {
        return [
            ("test_addressesDoNotGrow", test_addressesDoNotGrow),
            ("test_isEqual", test_isEqual),
            ("test_localNamesNonEmpty", test_localNamesNonEmpty),
        ]
    }
    
    // SR-6391
    func test_addressesDoNotGrow() {
        let local = Host.current()
        let localAddressesFirst = local.addresses
        let localAddressesSecond = local.addresses
        XCTAssertEqual(localAddressesSecond.count, localAddressesFirst.count)
        
        let dns = Host(address: "8.8.8.8")
        let dnsAddressesFirst = dns.addresses
        let dnsAddressesSecond = dns.addresses
        XCTAssertEqual(dnsAddressesSecond.count, dnsAddressesFirst.count)
        
        let swift = Host(name: "localhost")
        let swiftAddressesFirst = swift.addresses
        let swiftAddressesSecond = swift.addresses
        XCTAssertEqual(swiftAddressesSecond.count, swiftAddressesFirst.count)
    }

    func test_isEqual() {
        let host0 = Host(address: "8.8.8.8")
        let host1 = Host(address: "8.8.8.8")
        XCTAssertTrue(host0.isEqual(to: host1))

        let host2 = Host(address: "8.8.8.9")
        XCTAssertFalse(host0.isEqual(to: host2))

        let swift0 = Host(name: "localhost")
        let swift1 = Host(name: "localhost")
        XCTAssertTrue(swift0.isEqual(to: swift1))

        let google = Host(name: "google.com")
        XCTAssertFalse(swift0.isEqual(to: google))
    }

    // SR-14197
    func test_localNamesNonEmpty() {
        let local = Host.current()
        XCTAssertTrue(local.names.count > 0)

        let swift = Host(name: "localhost")
        XCTAssertTrue(swift.names.count > 0)
    }
#endif
}

#endif
