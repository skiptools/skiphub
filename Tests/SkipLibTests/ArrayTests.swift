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

    func testArrayIndex() {
        let a = [1, 2, 3]
        let index: Array.Index? = a.firstIndex(of: 2)
        XCTAssertEqual(index, 1)
    }

    func testOptionalElements() {
        var optionalArray: [Int?] = [1, nil, 2]
        XCTAssertEqual(optionalArray.count, 3)
        XCTAssertEqual(optionalArray[0], 1)
        XCTAssertNil(optionalArray[1])
        XCTAssertEqual(optionalArray[2], 2)

        optionalArray.append(nil)
        XCTAssertNil(optionalArray[3])
    }

    func testAppend() {
        var array = [1, 2]
        array.append(3)
        XCTAssertEqual(array.count, 3)
        XCTAssertEqual(array[2], 3)

        var array2 = array
        array2.append(4)
        XCTAssertEqual(array2.count, 4)
        XCTAssertEqual(array2[3], 4)
        XCTAssertEqual(array.count, 3)

        var combined: [Int] = []
        combined.append(contentsOf: array)
        XCTAssertEqual(combined, [1, 2, 3])
        combined.append(contentsOf: array2)
        XCTAssertEqual(combined, [1, 2, 3, 1, 2, 3, 4])
    }

    func testAdd() {
        let array1 = [1, 2, 3]
        let array2 = [4, 5, 6]
        var combined = array1 + array2
        XCTAssertEqual(combined, [1, 2, 3, 4, 5, 6])
        combined += [7, 8]
        XCTAssertEqual(combined, [1, 2, 3, 4, 5, 6, 7, 8])
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

    func testAddDidSet() {
        let holder = ArrayHolder()
        XCTAssertEqual(holder.arraySetCount, 0)

        holder.array += [1, 2, 3]
        XCTAssertEqual(holder.array, [1, 2, 3])
        XCTAssertEqual(holder.arraySetCount, 1)

        var array = holder.array
        array += [4]
        XCTAssertEqual(array.count, 4)
        XCTAssertEqual(holder.array.count, 3)
        XCTAssertEqual(holder.arraySetCount, 1)

        holder.array += [4, 5]
        XCTAssertEqual(holder.array.count, 5)
        XCTAssertEqual(holder.arraySetCount, 2)
        XCTAssertEqual(array.count, 4)
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

    func testMap() {
        let strings = ["A", "Z", "M"]
        let strings2 = strings.map {
            $0 + $0
        }
        XCTAssertEqual(strings2, ["AA", "ZZ", "MM"])

        let raws = [1, 2, 3].map { ElementEnum(rawValue: $0) }
        XCTAssertEqual(raws[0], .one)
        XCTAssertEqual(raws[1], .two)
        XCTAssertEqual(raws[2], .three)

        let cases = [0, 1, 2].map { ElementEnum.allCases[$0] }
        XCTAssertEqual(cases[0], .one)
        XCTAssertEqual(cases[1], .two)
        XCTAssertEqual(cases[2], .three)
    }

    func testCompactMap() {
        let strings = ["A", "Z", "M"]
        let strings2 = strings.compactMap {
            $0 == "Z" ? nil : $0 + $0
        }
        XCTAssertEqual(strings2, ["AA", "MM"])

        let raws = [1, 5, 3].compactMap { ElementEnum(rawValue: $0) }
        XCTAssertEqual(2, raws.count)
        XCTAssertEqual(raws[0], .one)
        XCTAssertEqual(raws[1], .three)
    }

    func testFlatMap() {
        let strings = [["A", "a"], ["B", "b"], ["C", "c"]]
        let strings2 = strings.flatMap { $0 }
        XCTAssertEqual(strings2, ["A", "a", "B", "b", "C", "c"])

        let enums = [1, 2].flatMap { _ in ElementEnum.allCases }
        XCTAssertEqual(enums, [.one, .two, .three, .one, .two, .three])
    }

    func testReduce() {
        let strings = ["K", "I", "P"]
        XCTAssertEqual(strings.reduce("S", { $0 + $1 }), "SKIP")
        XCTAssertEqual(strings.reduce("S", +), "SKIP")

        let dict = [1, 2, 3].reduce(into: [Int: ElementEnum]()) { result, i in
            result[i] = ElementEnum(rawValue: i)!
        }
        XCTAssertEqual(dict[1], .one)
        XCTAssertEqual(dict[2], .two)
        XCTAssertEqual(dict[3], .three)

        #if !SKIP
        XCTAssertEqual(strings.lazy.reduce("S", { $0 + $1 }), "SKIP")
        XCTAssertEqual(strings.lazy.lazy.reduce("S", { $0 + $1 }), "SKIP") // Cannot infer a type for this parameter. Please specify it explicitly.
        #endif
    }

    func testFilter() {
        let strings = ["A", "Z", "M"]
        let strings2 = strings.filter {
            $0 != "M"
        }
        XCTAssertEqual(strings2, ["A", "Z"])

        let filtered = [ElementEnum.one, ElementEnum.two, ElementEnum.three].filter { $0.rawValue % 2 == 1 }
        XCTAssertEqual(2, filtered.count)
        XCTAssertEqual(filtered[0], .one)
        XCTAssertEqual(filtered[1], .three)
    }

    func testEnumerated() {
        var enumerated: [(Int, String)] = []
        for (index, string) in ["A", "Z", "M"].enumerated() {
            enumerated.append((index, string))
        }
        XCTAssertEqual(enumerated.count, 3)
        XCTAssertEqual(enumerated[0].0, 0)
        XCTAssertEqual(enumerated[0].1, "A")
        XCTAssertEqual(enumerated[1].0, 1)
        XCTAssertEqual(enumerated[1].1, "Z")
        XCTAssertEqual(enumerated[2].0, 2)
        XCTAssertEqual(enumerated[2].1, "M")
    }

    func testSort() {
        let strings = ["A", "Z", "M"]
        let strings2 = strings.sorted()
        XCTAssertEqual(strings, ["A", "Z", "M"])
        XCTAssertEqual(strings2, ["A", "M", "Z"])
    }

    func testFirstLast() {
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

    func testRemoveFirst() {
        var strings = ["A", "Z"]
        XCTAssertEqual("A", strings.removeFirst())
        XCTAssertEqual(["Z"], strings)
        XCTAssertEqual("Z", strings.removeFirst())
        XCTAssertTrue(strings.isEmpty)
    }

    func testFilterMapReduce() {
        let numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
        let result = numbers.filter { $0 % 2 == 0 }
                            .map { $0 * 2 }
                            .reduce(0, { $0 + $1 })
        XCTAssertEqual(result, 60)
    }

    func testReadSlice() {
        var numbers = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

        func copy<T: Collection<Int>>(_ c: T) -> [Int] {
            var a: [Int] = []
            for i in c {
                a.append(i)
            }
            return a
        }

        let closedSlice = numbers[1...3]
        XCTAssertEqual(Array(closedSlice), [1, 2, 3])
        XCTAssertEqual(copy(closedSlice), [1, 2, 3])

        XCTAssertEqual(3, closedSlice.count)
        XCTAssertEqual(closedSlice[1], 1)
        XCTAssertEqual(closedSlice[2], 2)
        XCTAssertEqual(closedSlice[3], 3)

        let openUpperSlice = numbers[7...]
        let openUpperSliceCopy = Array(openUpperSlice)
        XCTAssertEqual(openUpperSliceCopy, [7, 8, 9])

        XCTAssertEqual(3, openUpperSlice.count)
        XCTAssertEqual(openUpperSlice[7], 7)
        XCTAssertEqual(openUpperSlice[8], 8)
        XCTAssertEqual(openUpperSlice[9], 9)

        let openLowerSlice = numbers[..<3]
        let openLowerSliceCopy = Array(openLowerSlice)
        XCTAssertEqual(openLowerSliceCopy, [0, 1, 2])

        XCTAssertEqual(3, openLowerSlice.count)
        XCTAssertEqual(openLowerSlice[0], 0)
        XCTAssertEqual(openLowerSlice[1], 1)
        XCTAssertEqual(openLowerSlice[2], 2)

        // Check that mutating the source does not affect the slice
        numbers.append(10)
        XCTAssertEqual(3, openUpperSlice.count)

        let enums: [ElementEnum] = [.one, .two, .three]
        let enumSlice = enums[1...]
        XCTAssertEqual(enumSlice[1], .two)
    }

    func testWriteSlice() {
        var numbers = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
        numbers[1..<5] = []
        XCTAssertEqual(numbers, [0, 5, 6, 7, 8, 9])

        numbers = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
        numbers[1..<5] = [99, 100]
        XCTAssertEqual(numbers, [0, 99, 100, 5, 6, 7, 8, 9])

        numbers = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
        numbers[5...] = [99, 100]
        XCTAssertEqual(numbers, [0, 1, 2, 3, 4, 99, 100])

        numbers = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
        numbers[..<5] = [99, 100]
        XCTAssertEqual(numbers, [99, 100, 5, 6, 7, 8, 9])
    }

    func testDictionaryForEach() {
        let dictionary = ["apple": 3, "banana": 5, "cherry": 2]
        var count = 0
        dictionary.forEach { count += $0.value }
        XCTAssertEqual(count, 10)
    }

    func testInsert() {
        var array = [1, 2]
        array.insert(3, at: 1)
        XCTAssertEqual(array.count, 3)
        XCTAssertEqual(array[0], 1)
        XCTAssertEqual(array[1], 3)
        XCTAssertEqual(array[2], 2)

        var array2 = array
        array2.insert(4, at: 2)
        XCTAssertEqual(array2.count, 4)
        XCTAssertEqual(array2[0], 1)
        XCTAssertEqual(array2[1], 3)
        XCTAssertEqual(array2[2], 4)
        XCTAssertEqual(array2[3], 2)

        XCTAssertEqual(array.count, 3)
    }

    func testZipCompactMap() {
        #if SKIP
        throw XCTSkip("testZipCompactMap")
        #else
        let names = ["Alice", "Bob", "Charlie"]
        let ages = [25, nil, 35]
        let result = zip(names, ages)
            .compactMap { (name, age) in
                age.map { "\($0) year old \($0 < 30 ? "youth" : "adult") named \(name)" }
            }
        XCTAssertEqual(result, ["25 year old youth named Alice", "35 year old adult named Charlie"])
        #endif
    }

    func testLazyFilterMap() {
        #if SKIP
        throw XCTSkip("testLazyFilterMap")
        #else
        let numbers = sequence(first: 0, next: { $0 + 1 })
        let result = numbers.lazy.filter { $0 % 2 == 0 }
                                .map { $0 * 3 }
                                .prefix(10)
        XCTAssertEqual(Array(result), [0, 6, 12, 18, 24, 30, 36, 42, 48, 54])
        #endif
    }
}

// Ensure that array generic extensions are transpiled correctly
extension Array {
    var forceFirst: Element? {
        return self[0]
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

private enum ElementEnum: Int, CaseIterable {
    case one = 1
    case two
    case three
}
