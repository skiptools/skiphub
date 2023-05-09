// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
import XCTest

final class StringTests: XCTestCase {
    func testCreation() {
        let str1 = "Hello, world!"
        XCTAssertEqual(str1, "Hello, world!")

        let str2 = String(repeating: "a", count: 5)
        XCTAssertEqual(str2, "aaaaa")

        let str3 = "Hello, world!".reversed()
        XCTAssertEqual(String(str3), "!dlrow ,olleH")
    }

    func testCharacterFunctions() {
        let str1 = "Hello, world!"

        let first = str1.first
        XCTAssertEqual(first, Character("H"))

        let last = str1.last
        XCTAssertEqual(last, Character("!"))
    }

    func testMultibyteCharacterFunctions() {
        let str1 = "你好，世界"

        let first = str1.first
        XCTAssertEqual(first, Character("你"))

        let firstLast = str1.reversed().last
        XCTAssertEqual(first, firstLast)

        let last = str1.last

        #if !SKIP
        XCTAssertEqual(last, "界")
        XCTAssertEqual(last?.isASCII, false)
        XCTAssertEqual(last?.isCased, false)
        XCTAssertEqual(last?.isCurrencySymbol, false)
        XCTAssertEqual(last?.isHexDigit, false)
        XCTAssertEqual(last?.isLetter, true)
        XCTAssertEqual(last?.isLowercase, false)
        XCTAssertEqual(last?.isUppercase, false)
        XCTAssertEqual(last?.isMathSymbol, false)
        XCTAssertEqual(last?.isNewline, false)
        XCTAssertEqual(last?.isNumber, false)
        XCTAssertEqual(last?.isPunctuation, false)
        XCTAssertEqual(last?.isHexDigit, false)
        XCTAssertEqual(last?.isCurrencySymbol, false)
        XCTAssertEqual(last?.isWholeNumber, false)
        XCTAssertEqual(last?.wholeNumberValue, nil)
        #endif
        XCTAssertEqual(last, Character("界"))

        let lastFirst = str1.reversed().first
        XCTAssertEqual(last, lastFirst)
    }

    func testManipulation() {
        var str = "Hello, world!"
        XCTAssertEqual(str.count, 13)

        XCTAssertEqual(str.isEmpty, false)

        #if !SKIP
        str.append(contentsOf: " How are you?")
        XCTAssertEqual(str, "Hello, world! How are you?")

        str.removeLast(13)
        XCTAssertEqual(str, "Hello, world!")
        #endif

        let index = str.firstIndex(of: ",")!
        let substring = str[..<index]
        XCTAssertEqual(String(substring), "Hello")
    }

    func testStringSearching() {
        let str = "The quick brown fox jumps over the lazy dog."

        XCTAssertTrue(str.hasPrefix("The"))
        XCTAssertTrue(str.hasSuffix("."))
        XCTAssertTrue(str.contains("fox"))

        let index = str.firstIndex(of: "b")!
        XCTAssertEqual(str.distance(from: str.startIndex, to: index), 10)
    }

    func testFirstDropFirst() {
        let str = "hello, world!"
        let firstChar = str.first
        XCTAssertEqual(firstChar?.description, "h")
        let rest = str.dropFirst()
        XCTAssertEqual(rest, "ello, world!")
        let rest2 = str.dropFirst(2)
        XCTAssertEqual(rest2, "llo, world!")
        let frst = str.dropLast()
        XCTAssertEqual(frst, "hello, world")
        let frst2 = str.dropLast(2)
        XCTAssertEqual(frst2, "hello, worl")
    }

    func testMultlineStrings() {
        let str = """
        Hello there,

        How do you do?

            Bye!
        """
        let str2 = "Hello there,\n\nHow do you do?\n\n    Bye!"
        XCTAssertEqual(str, str2)
    }

    func testSlice() {
        let str = "abcdef"
        let bindex: String.Index = str.firstIndex(of: "b")!
        let char = str[bindex]
        XCTAssertTrue(char == "b")

        let sub1 = str[bindex..<str.index(str.startIndex, offsetBy: 3)]
        XCTAssertEqual(String(sub1), "bc")

        let sub2 = str[sub1.startIndex...sub1.endIndex]
        XCTAssertEqual(String(sub2), "bcd")

        let str2 = str + sub2
        XCTAssertEqual(str2, "abcdefbcd")
    }
}
