// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
import XCTest

private struct TestOptionSet: OptionSet {
    let rawValue: Int

    static let s1 = TestOptionSet(rawValue: 1 << 0)
    static let s2 = TestOptionSet(rawValue: 1 << 1)
    static let s3 = TestOptionSet(rawValue: 1 << 2)

    static let all: TestOptionSet = [.s1, .s2, .s3]
}

final class OptionSetTests: XCTestCase {
    func testContains() {
        let set: TestOptionSet = [.s1, .s3]
        XCTAssertTrue(set.contains(.s1))
        XCTAssertFalse(set.contains(.s2))
        XCTAssertTrue(set.contains(.s3))
        XCTAssertFalse(set.contains(.all))

        XCTAssertTrue(TestOptionSet.all.contains(.s1))
        XCTAssertTrue(TestOptionSet.all.contains(.s2))
        XCTAssertTrue(TestOptionSet.all.contains(.s3))
        XCTAssertTrue(TestOptionSet.all.contains(.all))
    }

    func testInsert() {
        var set: TestOptionSet = []
        XCTAssertFalse(set.contains(.s1))
        //~~~set.insert(.s1)
    }
}