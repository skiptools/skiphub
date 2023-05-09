// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
import Foundation
import XCTest

@available(macOS 11, iOS 14, watchOS 7, tvOS 14, *)
final class RegexTests: XCTestCase {
    
    func testRegularExpresionParity() throws {
        try XCTAssertEqual(1, matches(regex: "A.*", text: "ABC"))
    }

    // many of these tests are adapted from: https://blog.robertelder.org/regular-expression-test-cases/

    func testEmailValidationRegex() throws {
        let exp = "^([a-z0-9_\\.\\-]+)@([\\da-z\\.\\-]+)\\.([a-z\\.]{2,5})$"
        try XCTAssertEqual(1, matches(regex: exp, text: "john.doe@example.com"))
        try XCTAssertEqual(1, matches(regex: exp, text: "jane_doe@example.co.uk"))
        try XCTAssertEqual(0, matches(regex: exp, text: "john.doe@.com"))
        try XCTAssertEqual(0, matches(regex: exp, text: "john.doe@example"))
    }

    func testWordsWithMultipleSuffixesRegex() throws {
        let exp = "employ(|er|ee|ment|ing|able)"
        try XCTAssertEqual(1, matches(regex: exp, text: "employee"))
        try XCTAssertEqual(1, matches(regex: exp, text: "employer"))
        try XCTAssertEqual(1, matches(regex: exp, text: "employment"))
        try XCTAssertEqual(1, matches(regex: exp, text: "employ"))
        try XCTAssertEqual(0, matches(regex: exp, text: "emplox"))
    }

    func testHashValidationRegex() throws {
        let exp = "^[a-f0-9]{32}$"
        try XCTAssertEqual(1, matches(regex: exp, text: "5d41402abc4b2a76b9719d911017c592"))
        try XCTAssertEqual(1, matches(regex: exp, text: "e4da3b7fbbce2345d7772b0674a318d5"))
        try XCTAssertEqual(0, matches(regex: exp, text: "5d41402abc4b2a76b9719d911017c59"), "31 characters")
        //try XCTAssertEqual(0, matches(regex: exp, text: "5d41402abc4b2a76b9719d911017c5921"), "33 characters")
    }

    func testXMLTagRegex() throws {
        let exp = "<tag>[^<]*</tag>"
        try XCTAssertEqual(1, matches(regex: exp, text: "<tag>Content</tag>"))
        try XCTAssertEqual(1, matches(regex: exp, text: "<tag></tag>"))
        try XCTAssertEqual(0, matches(regex: exp, text: "<tag><nested>Content</nested></tag>"))
        try XCTAssertEqual(0, matches(regex: exp, text: "<tag attr=\"value\">Content</tag>"))
    }

    private func matches(regex expressionString: String, text: String) throws -> Int {
        #if SKIP
        return expressionString.toRegex().findAll(text).count()
        #else
        if #available(macOS 13, iOS 16, watchOS 9, tvOS 16, *) {
            return try text.matches(of: Regex(expressionString)).count
        } else {
            throw XCTSkip("unsupported platform")
        }
        #endif
    }
}
