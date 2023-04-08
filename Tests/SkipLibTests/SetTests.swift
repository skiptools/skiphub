// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
import XCTest

final class SetTests: XCTestCase {
    func testInit() {
        let set1 = Set<Int>()
        XCTAssertEqual(set1.count, 0)

        let set2 = Set([1, 2, 3])
        XCTAssertEqual(set2.count, 3)
    }

    func testInsert() {
        var set = Set<Int>()
        XCTAssertTrue(set.isEmpty)

        set.insert(1)
        XCTAssertEqual(set.count, 1)
        XCTAssertTrue(set.contains(1))

        set.insert(2)
        XCTAssertEqual(set.count, 2)
        XCTAssertTrue(set.contains(2))
    }

    func testRemove() {
        var set = Set([1, 2, 3])
        XCTAssertEqual(set.count, 3)

        set.remove(2)
        XCTAssertEqual(set.count, 2)
        XCTAssertFalse(set.contains(2))

        set.remove(4)
        XCTAssertEqual(set.count, 2)
    }

    func testUnion() {
        let set1 = Set([1, 2, 3])
        let set2 = Set([3, 4, 5])
        let unionSet = set1.union(set2)

        XCTAssertEqual(unionSet.count, 5)
        XCTAssertTrue(unionSet.contains(1))
        XCTAssertTrue(unionSet.contains(2))
        XCTAssertTrue(unionSet.contains(3))
        XCTAssertTrue(unionSet.contains(4))
        XCTAssertTrue(unionSet.contains(5))
    }

    func testIntersection() {
        let set1 = Set([1, 2, 3])
        let set2 = Set([2, 3, 4])
        let intersectionSet = set1.intersection(set2)

        XCTAssertEqual(intersectionSet.count, 2)
        XCTAssertTrue(intersectionSet.contains(2))
        XCTAssertTrue(intersectionSet.contains(3))
    }

    func testSymmetricDifference() {
        let set1 = Set([1, 2, 3])
        let set2 = Set([2, 3, 4])
        let symmetricDifferenceSet = set1.symmetricDifference(set2)

        XCTAssertEqual(symmetricDifferenceSet.count, 2)
        XCTAssertTrue(symmetricDifferenceSet.contains(1))
        XCTAssertTrue(symmetricDifferenceSet.contains(4))
    }

    func testSubsetSuperset() {
        let set1 = Set([1, 2, 3])
        let set2 = Set([2, 3])
        XCTAssertTrue(set2.isSubset(of: set1))
        XCTAssertTrue(set1.isSuperset(of: set2))
        XCTAssertFalse(set1.isDisjoint(with: set2))
        XCTAssertFalse(set2.isDisjoint(with: set1))
    }

    func testIsDisjoint() {
        let set1 = Set([1, 2, 3])
        let set2 = Set([4, 5, 6])
        XCTAssertTrue(set1.isDisjoint(with: set2))
    }
}
