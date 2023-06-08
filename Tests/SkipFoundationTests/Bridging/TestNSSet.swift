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

class TestNSSet : XCTestCase {
    func test_BasicConstruction() {
        #if SKIP
        throw XCTSkip("TODO")
        #else
        let set = NSSet()
        let set2 = NSSet(array: ["foo", "bar"])
        XCTAssertEqual(set.count, 0)
        XCTAssertEqual(set2.count, 2)

        let set3 = NSMutableSet(capacity: 3)
        set3.add(1)
        set3.add("foo")
        let set4 = NSSet(set: set3)
        XCTAssertEqual(set3, set4)
        set3.remove(1)
        XCTAssertNotEqual(set3, set4)

        let set5 = NSMutableSet(set: set3)
        XCTAssertEqual(set5, set3)
        set5.add(2)
        XCTAssertNotEqual(set5, set3)

        let set6 = NSSet(objects: "foo", "bar")
        XCTAssertEqual(set6.count, 2)
        XCTAssertEqual(set2, set6)
        #endif // !SKIP
    }

    func testInitWithSet() {
        #if SKIP
        throw XCTSkip("TODO")
        #else
        let genres: Set<AnyHashable> = ["Rock", "Classical", "Hip hop"]
        let set1 = NSSet(set: genres)
        let set2 = NSSet(set: genres, copyItems: false)
        XCTAssertEqual(set1.count, 3)
        XCTAssertEqual(set2.count, 3)
        XCTAssertEqual(set1, set2)

        let set3 = NSSet(set: genres, copyItems: true)
        XCTAssertEqual(set3.count, 3)
        XCTAssertEqual(set3, set2)
        #endif // !SKIP
    }
    
    func test_enumeration() {
        #if SKIP
        throw XCTSkip("TODO")
        #else
        let set = NSSet(array: ["foo", "bar", "baz"])
        let e = set.objectEnumerator()
        var result = Set<String>()
        result.insert((e.nextObject()! as! String))
        result.insert((e.nextObject()! as! String))
        result.insert((e.nextObject()! as! String))
        XCTAssertEqual(result, Set(["foo", "bar", "baz"]))
        
        let empty = NSSet().objectEnumerator()
        XCTAssertNil(empty.nextObject())
        XCTAssertNil(empty.nextObject())
        #endif // !SKIP
    }
    
    func test_sequenceType() {
        #if SKIP
        throw XCTSkip("TODO")
        #else
        let set = NSSet(array: ["foo", "bar", "baz"])
        var res = Set<String>()
        for obj in set {
            res.insert((obj as! String))
        }
        XCTAssertEqual(res, Set(["foo", "bar", "baz"]))
        #endif // !SKIP
    }
    
    func test_setOperations() {
        #if SKIP
        throw XCTSkip("TODO")
        #else
        let set = NSMutableSet(array: ["foo", "bar"])
        set.union(["bar", "baz"])
        #if !os(iOS)
        XCTAssertTrue(set.isEqual(to: NSMutableSet(array: ["foo", "bar", "baz"])))
        #endif
        #endif // !SKIP
    }

    func test_equality() {
        #if SKIP
        throw XCTSkip("TODO")
        #else
        let inputArray1 = ["this", "is", "a", "test", "of", "equality", "with", "strings"]
        let inputArray2 = ["this", "is", "a", "test", "of", "equality", "with", "objects"]
        let set1 = NSSet(array: inputArray1)
        let set2 = NSSet(array: inputArray1)
        let set3 = NSSet(array: inputArray2)

        XCTAssertTrue(set1 == set2)
        XCTAssertTrue(set1.isEqual(set2))
        XCTAssertTrue(set1.isEqual(to: Set(inputArray1)))
        XCTAssertEqual(set1.hash, set2.hash)
        XCTAssertEqual(set1.hashValue, set2.hashValue)

        XCTAssertFalse(set1 == set3)
        XCTAssertFalse(set1.isEqual(set3))
        XCTAssertFalse(set1.isEqual(to: Set(inputArray2)))

        XCTAssertFalse(set1.isEqual(nil))
        XCTAssertFalse(set1.isEqual(NSObject()))
        #endif // !SKIP
    }

    func test_copying() {
        #if SKIP
        throw XCTSkip("TODO")
        #else
        let inputArray = ["this", "is", "a", "test", "of", "copy", "with", "strings"]
        
        let set = NSSet(array: inputArray)
        let setCopy1 = set.copy() as! NSSet
        XCTAssertTrue(set === setCopy1)

        let setMutableCopy = set.mutableCopy() as! NSMutableSet
        let setCopy2 = setMutableCopy.copy() as! NSSet
//        XCTAssertTrue(type(of: setCopy2) === NSSet.self)
        XCTAssertFalse(setMutableCopy === setCopy2)
        for entry in setCopy2 {
            XCTAssertTrue(NSArray(array: setMutableCopy.allObjects).index(of: entry) != NSNotFound)
        }
        #endif // !SKIP
    }

    func test_mutableCopying() {
        #if SKIP
        throw XCTSkip("TODO")
        #else
        let inputArray = ["this", "is", "a", "test", "of", "mutableCopy", "with", "strings"]
        let set = NSSet(array: inputArray)

        let setMutableCopy1 = set.mutableCopy() as! NSMutableSet
//        XCTAssertTrue(type(of: setMutableCopy1) === NSMutableSet.self)
        XCTAssertFalse(set === setMutableCopy1)
        for entry in setMutableCopy1 {
            XCTAssertTrue(NSArray(array: set.allObjects).index(of: entry) != NSNotFound)
        }

        let setMutableCopy2 = setMutableCopy1.mutableCopy() as! NSMutableSet
//        XCTAssertTrue(type(of: setMutableCopy2) === NSMutableSet.self)
        XCTAssertFalse(setMutableCopy2 === setMutableCopy1)
        for entry in setMutableCopy2 {
            XCTAssertTrue(NSArray(array: setMutableCopy1.allObjects).index(of: entry) != NSNotFound)
        }
        #endif // !SKIP
    }

    func test_CountedSetBasicConstruction() {
        #if SKIP
        throw XCTSkip("TODO")
        #else
        let v1 = "v1"
        let v2 = "v2"
        let v3asv1 = "v1"
        let set = NSCountedSet()
        let set2 = NSCountedSet(array: [v1, v1, v2,v3asv1])
        let set3 = NSCountedSet(set: [v1, v1, v2,v3asv1])
        let set4 = NSCountedSet(capacity: 4)

        XCTAssertEqual(set.count, 0)
        XCTAssertEqual(set2.count, 2)
        XCTAssertEqual(set3.count, 2)
        XCTAssertEqual(set4.count, 0)

        #endif // !SKIP
    }

    func test_CountedSetObjectCount() {
        #if SKIP
        throw XCTSkip("TODO")
        #else
        let v1 = "v1"
        let v2 = "v2"
        let v3asv1 = "v1"
        let set = NSCountedSet()
        let set2 = NSCountedSet(array: [v1, v1, v2,v3asv1])
        let set3 = NSCountedSet(set: [v1, v1, v2,v3asv1])

        XCTAssertEqual(set.count(for: v1), 0)
        XCTAssertEqual(set2.count(for: v1), 3)
        XCTAssertEqual(set2.count(for: v2), 1)
        XCTAssertEqual(set2.count(for: v3asv1), 3)
        XCTAssertEqual(set3.count(for: v1), 1)
        XCTAssertEqual(set3.count(for: v2), 1)
        XCTAssertEqual(set3.count(for: v3asv1), 1)
        #endif // !SKIP
    }

    func test_CountedSetAddObject() {
        #if SKIP
        throw XCTSkip("TODO")
        #else
        let v1 = "v1"
        let v2 = "v2"
        let v3asv1 = "v1"
        let set = NSCountedSet(array: [v1, v1, v2])

        XCTAssertEqual(set.count(for: v1), 2)
        XCTAssertEqual(set.count(for: v2), 1)
        set.add(v3asv1)
        XCTAssertEqual(set.count(for: v1), 3)
        set.addObjects(from: [v1,v2])
        XCTAssertEqual(set.count(for: v1), 4)
        XCTAssertEqual(set.count(for: v2), 2)
        #endif // !SKIP
    }


    func test_CountedSetRemoveObject() {
        #if SKIP
        throw XCTSkip("TODO")
        #else
        let v1 = "v1"
        let v2 = "v2"
        let set = NSCountedSet(array: [v1, v1, v2])

        XCTAssertEqual(set.count(for: v1), 2)
        XCTAssertEqual(set.count(for: v2), 1)
        set.remove(v2)
        XCTAssertEqual(set.count(for: v2), 0)
        XCTAssertEqual(set.count(for: v1), 2)
        set.remove(v2)
        XCTAssertEqual(set.count(for: v2), 0)
        XCTAssertEqual(set.count(for: v1), 2)
        set.removeAllObjects()
        XCTAssertEqual(set.count(for: v2), 0)
        XCTAssertEqual(set.count(for: v1), 0)
        #endif // !SKIP
    }

    func test_CountedSetCopying() {
        #if SKIP
        throw XCTSkip("TODO")
        #else
        let inputArray = ["this", "is", "a", "test", "of", "copy", "with", "strings"]

        let set = NSCountedSet(array: inputArray)
        let setCopy = set.copy() as! NSCountedSet
        XCTAssertFalse(set === setCopy)

        let setMutableCopy = set.mutableCopy() as! NSCountedSet
        XCTAssertFalse(set === setMutableCopy)
        XCTAssertTrue(type(of: setCopy) === NSCountedSet.self)
        XCTAssertTrue(type(of: setMutableCopy) === NSCountedSet.self)
        for entry in setCopy {
            XCTAssertTrue(NSArray(array: setMutableCopy.allObjects).index(of: entry) != NSNotFound)
        }
        #endif // !SKIP
    }
    
    func test_mutablesetWithDictionary() {
        #if SKIP
        throw XCTSkip("TODO")
        #else
        let aSet = NSMutableSet()
        let dictionary = NSMutableDictionary()
        let key = NSString(string: "Hello")
        aSet.add(["world": "again"])
        dictionary.setObject(aSet, forKey: key)
        XCTAssertNotNil(dictionary.description) //should not crash
        #endif // !SKIP
    }

    func test_Subsets() {
        #if SKIP
        throw XCTSkip("TODO")
        #else
        let set = NSSet(array: ["foo", "bar", "baz"])
        let otherSet = NSSet(array: ["foo", "bar"])
        let otherOtherSet = Set<AnyHashable>(["foo", "bar", "baz", "123"])
        let newSet = Set<AnyHashable>(["foo", "bin"])
        XCTAssert(otherSet.isSubset(of: set as! Set<AnyHashable>))
        XCTAssertFalse(set.isSubset(of: otherSet as! Set<AnyHashable>))
        XCTAssert(set.isSubset(of: otherOtherSet))
        XCTAssert(otherSet.isSubset(of: otherOtherSet))
        XCTAssertFalse(newSet.isSubset(of: otherSet as! Set<AnyHashable>))
        #endif // !SKIP
    }
    
    func test_description() {
        #if SKIP
        throw XCTSkip("TODO")
        #else
        let array = NSArray(array: ["array_element1", "arrayElement2", "", "!@#$%^&*()", "a+b"])
        let dictionary = NSDictionary(dictionary: ["key1": "value1", "key2": "value2"])
        let innerSet = NSSet(array: [4444, 5555])
        let set: NSSet = NSSet(array: [array, dictionary, innerSet, 1111, 2222, 3333])
        
        let description = NSString(string: set.description)

        XCTAssertTrue(description.hasPrefix("{("))
        XCTAssertTrue(description.hasSuffix(")}"))
        XCTAssertTrue(description.contains("        (\n        \"array_element1\",\n        arrayElement2,\n        \"\",\n        \"!@#$%^&*()\",\n        \"a+b\"\n    )"))
        XCTAssertTrue(description.contains("        key1 = value1"))
        XCTAssertTrue(description.contains("        key2 = value2"))
        XCTAssertTrue(description.contains("        4444"))
        XCTAssertTrue(description.contains("        5555"))
        XCTAssertTrue(description.contains("    1111"))
        XCTAssertTrue(description.contains("    2222"))
        XCTAssertTrue(description.contains("    3333"))
        #endif // !SKIP
    }
    
    #if !SKIP
    let setFixtures = [
        Fixtures.setOfNumbers,
        Fixtures.setEmpty,
    ]
    
    let mutableSetFixtures = [
        Fixtures.mutableSetOfNumbers,
        Fixtures.mutableSetEmpty,
    ]
    
    let countedSetFixtures = [
        Fixtures.countedSetOfNumbersAppearingOnce,
        Fixtures.countedSetOfNumbersAppearingSeveralTimes,
        Fixtures.countedSetEmpty,
    ]
    #endif
    
    func test_codingRoundtrip() throws {
        #if SKIP
        throw XCTSkip("TODO")
        #else
        for fixture in setFixtures {
            try fixture.assertValueRoundtripsInCoder()
        }
        for fixture in mutableSetFixtures {
            try fixture.assertValueRoundtripsInCoder()
        }
        for fixture in countedSetFixtures {
            try fixture.assertValueRoundtripsInCoder()
        }
        #endif // !SKIP
    }
    
    func test_loadedValuesMatch() throws {
        #if SKIP
        throw XCTSkip("TODO")
        #else
        for fixture in setFixtures {
//            try fixture.assertLoadedValuesMatch()
        }
        for fixture in mutableSetFixtures {
            try fixture.assertLoadedValuesMatch()
        }
        for fixture in countedSetFixtures {
            try fixture.assertLoadedValuesMatch()
        }
        #endif // !SKIP
    }
    
    
}


