// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
import XCTest

final class ArrayTests: XCTestCase {
    func testArrayLiteralInit() {
        let emptyArray: [Int] = []
        XCTAssertEqual(emptyArray.count, 0)

        let emptyArray2: Array<Int> = []
        XCTAssertEqual(emptyArray2.count, 0)

        let emptyArray3 = [Int]()
        XCTAssertEqual(emptyArray3.count, 0)

        let emptyArray4 = Array<Int>()
        XCTAssertEqual(emptyArray4.count, 0)
        
        let singleElementArray = [1]
        XCTAssertEqual(singleElementArray.count, 1)
        XCTAssertEqual(singleElementArray[0], 1)

        let multipleElementArray = [1, 2]
        XCTAssertEqual(multipleElementArray.count, 2)
        XCTAssertEqual(multipleElementArray[0], 1)
        XCTAssertEqual(multipleElementArray[1], 2)
    }

    func testArrayAppend() {
        var array = [1, 2]
        array.append(3)
        XCTAssertEqual(array.count, 3)
        XCTAssertEqual(array[2], 3)

        var array2 = array
        array2.append(4)
        XCTAssertEqual(array2.count, 4)
        XCTAssertEqual(array2[3], 4)

        XCTAssertEqual(array.count, 3)
    }

    func testAppendDidSet() {
        let holder = ArrayHolder()
        XCTAssertEqual(holder.arraySetCount, 0)

        holder.array.append(1)
        XCTAssertEqual(holder.array.count, 1)
        XCTAssertEqual(holder.arraySetCount, 1)

        var array = holder.array
        XCTAssertEqual(array.count, 1)
        array.append(2)
        XCTAssertEqual(array.count, 2)
        XCTAssertEqual(holder.array.count, 1)
        XCTAssertEqual(holder.arraySetCount, 1)

        holder.array.append(3)
        holder.array.append(4)
        XCTAssertEqual(holder.array.count, 3)
        XCTAssertEqual(holder.arraySetCount, 3)
        XCTAssertEqual(array.count, 2)
    }

    func testSubscriptDidSet() {
        let holder = ArrayHolder()
        holder.array.append(1)
        XCTAssertEqual(holder.array.count, 1)
        XCTAssertEqual(holder.arraySetCount, 1)

        var array = holder.array
        array[0] = 100
        XCTAssertEqual(holder.array[0], 1)
        XCTAssertEqual(holder.array.count, 1)
        XCTAssertEqual(holder.arraySetCount, 1)

        holder.array[0] = 99
        XCTAssertEqual(holder.array[0], 99)
        XCTAssertEqual(holder.array.count, 1)
        XCTAssertEqual(holder.arraySetCount, 2)
        XCTAssertEqual(array[0], 100)
    }

    func testNestedSubscriptDidSet() {
        let holder = ArrayHolder()
        holder.arrayOfArrays.append([1, 2, 3])
        XCTAssertEqual(holder.arrayOfArrays.count, 1)
        XCTAssertEqual(holder.arraySetCount, 1)

        var array = holder.arrayOfArrays
        array[0][1] = 200
        XCTAssertEqual(holder.arrayOfArrays[0], [1, 2, 3])
        XCTAssertEqual(holder.arrayOfArrays.count, 1)
        XCTAssertEqual(holder.arraySetCount, 1)

        holder.arrayOfArrays[0][1] = 199
        XCTAssertEqual(holder.arrayOfArrays[0][1], 199)
        XCTAssertEqual(holder.arrayOfArrays.count, 1)
        XCTAssertEqual(holder.arraySetCount, 2)
        XCTAssertEqual(array[0][1], 200)
    }

    func testDeepNestedArrays() {
        var nested: [[[[[Int]]]]] = [[[[[1]]]]]
        let nested0: [[[Int]]] = [[[-1]]]

        nested[0][0][0][0][0] = nested[0][0][0][0][0] + 1
        nested[0][0] = nested0
        nested[0][0][0][0][0] = nested[0][0][0][0][0] + 1
        XCTAssertEqual(nested[0][0][0][0][0], 0)
    }

    func testArrayReferences() {
        var arr: [Int] = []
        arr.append(1)
        var arr2 = arr
        arr2.append(2)
        var arr3 = arr2
        arr3.append(3)

        arr.append(0)

        XCTAssertEqual(arr.count, 2)
        XCTAssertEqual(arr2.count, 2)
        XCTAssertEqual(arr3.count, 3)

    }

    func testArrayMap() {
        let strings = ["A", "Z", "M"]
        let strings2 = strings.map {
            $0 + $0
        }
        XCTAssertEqual(Array(strings2), ["AA", "ZZ", "MM"])
    }

    func testArrayFilter() {
        let strings = ["A", "Z", "M"]
        let strings2 = strings.filter {
            $0 != "M"
        }
        XCTAssertEqual(Array(strings2), ["A", "Z"])

        #if !SKIP
        XCTAssertEqual(Array(strings.filter { $0 != "Z" }), ["A", "M"]) // java.lang.AssertionError: expected:<skip.lib.Array@51399530> but was:<kotlin.collections.CollectionsKt___CollectionsKt$asSequence$$inlined$Sequence$1@6b2ea799>
        XCTAssertEqual(strings2, ["A", "Z"]) // testProjectGradle(): java.lang.AssertionError: expected:<skip.lib.Array@128d2484> but was:<[A, Z]>
        #endif
    }

    func testArrayReduceFold() {
        let strings = ["K", "I", "P"]
        XCTAssertEqual(strings.reduce("S", { $0 + $1 }), "SKIP")
        XCTAssertEqual(strings.lazy.reduce("S", { $0 + $1 }), "SKIP")
        #if !SKIP
        XCTAssertEqual(strings.reduce("S", +), "SKIP") // ArrayTests.kt:157:45 Expecting an element
        XCTAssertEqual(strings.lazy.lazy.reduce("S", { $0 + $1 }), "SKIP") // Cannot infer a type for this parameter. Please specify it explicitly.
        #endif
    }

    func testArraySort() {
        let strings = ["A", "Z", "M"]
        let strings2 = strings.sorted()
        XCTAssertEqual(strings, ["A", "Z", "M"])
        XCTAssertEqual(strings2, ["A", "M", "Z"])
    }

    func testArrayFirstLast() {
        let strings = ["A", "Z", "M"]

        XCTAssertEqual("A", strings.first)
        XCTAssertEqual("Z", strings.first(where: { $0 == "Z" }))
        XCTAssertEqual(nil, strings.first(where: { $0 == "Q" }))

        XCTAssertEqual("M", strings.last)
        XCTAssertEqual("Z", strings.last(where: { $0 == "Z" }))
        XCTAssertEqual(nil, strings.last(where: { $0 == "Q" }))

        XCTAssertEqual(true, strings.contains(where: { $0 == "Z" }))
        XCTAssertEqual(false, strings.contains(where: { $0 == "Q" }))
    }

    func testArrayFilterMapReduce() {
        let numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
        let result = numbers.filter { $0 % 2 == 0 }
                            .map { $0 * 2 }
                            .reduce(0, { $0 + $1 })
        XCTAssertEqual(result, 60)
    }

    func testDictionaryForEach() {
        let dictionary = ["apple": 3, "banana": 5, "cherry": 2]
        var count = 0
        dictionary.forEach { count += $0.value }
        XCTAssertEqual(count, 10)
    }

    func testZipCompactMap() {
//        let names = ["Alice", "Bob", "Charlie"]
//        let ages = [25, nil, 35]
//        let result = zip(names, ages)
//                        .compactMap { $0.1.map { "\($0) year old \($0 < 30 ? "youth" : "adult") \($0 > 1 ? "s" : "") named \($0.0)" } }
//        XCTAssertEqual(result, ["25 year old youth named Alice", "35 year old adult named Charlie"])
    }

    func testLazyFilterMap() {
//        let numbers = sequence(first: 0, next: { $0 + 1 })
//        let result = numbers.lazy.filter { $0 % 2 == 0 }
//                                .map { $0 * 3 }
//                                .prefix(10)
//        XCTAssertEqual(Array(result), [0, 6, 12, 18, 24, 30, 36, 42, 48, 54])
    }

}


private class ArrayHolder {
    var array: [Int] = [] {
        didSet {
            arraySetCount += 1
        }
    }
    var arraySetCount = 0

    var arrayOfArrays: [[Int]] = [] {
        didSet {
            arraySetCount += 1
        }
    }
}
