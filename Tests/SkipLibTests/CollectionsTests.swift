// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
import XCTest

final class CollectionsTests: XCTestCase {
    func testStride() {
        var ints: [Int] = []
        for i in stride(from: 2, to: 6, by: 2) {
            ints.append(i)
        }
        XCTAssertEqual(ints, [2, 4])

        ints = []
        for i in stride(from: 6, to: 2, by: -2) {
            ints.append(i)
        }
        XCTAssertEqual(ints, [6, 4])
    }

    func testStrideThrough() {
        var ints: [Int] = []
        for i in stride(from: 2, through: 6, by: 2) {
            ints.append(i)
        }
        XCTAssertEqual(ints, [2, 4, 6])

        ints = []
        for i in stride(from: 6, through: 2, by: -2) {
            ints.append(i)
        }
        XCTAssertEqual(ints, [6, 4, 2])
    }

    func testEmptyStride() {
        for _ in stride(from: 1, to: 1, by: 1) {
            XCTFail()
        }
        for _ in stride(from: 3, to: 0, by: 1) {
            XCTFail()
        }
    }

    func testDoubleStride() {
        var doubles: [Double] = []
        for d in stride(from: 1.0, through: 2.5, by: 0.5) {
            doubles.append(d)
        }
        XCTAssertEqual(doubles, [1.0, 1.5, 2.0, 2.5])
    }
}
