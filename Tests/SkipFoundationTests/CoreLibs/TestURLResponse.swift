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
// Copyright (c) 2014 - 2019 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//

class TestURLResponse : XCTestCase {

    #if !SKIP
    let testURL = URL(string: "test")!
    #endif

    func test_URL() {
        #if SKIP
        throw XCTSkip("TODO")
        #else
        let url = URL(string: "a/test/path")!
        let res = URLResponse(url: url, mimeType: "txt", expectedContentLength: 0, textEncodingName: nil)
        XCTAssertEqual(res.url, url, "should be the expected url")
        #endif // !SKIP
    }

    func test_MIMEType() {
        #if SKIP
        throw XCTSkip("TODO")
        #else
        var mimetype: String? = "text/plain"
        var res = URLResponse(url: testURL, mimeType: mimetype, expectedContentLength: 0, textEncodingName: nil)
        XCTAssertEqual(res.mimeType, mimetype, "should be the passed in mimetype")

        mimetype = "APPlication/wordperFECT"
        res = URLResponse(url: testURL, mimeType: mimetype, expectedContentLength: 0, textEncodingName: nil)
        XCTAssertEqual(res.mimeType, mimetype, "should be the other mimetype")

        mimetype = nil
        res = URLResponse(url: testURL, mimeType: mimetype, expectedContentLength: 0, textEncodingName: nil)
//        XCTAssertEqual(res.mimeType, mimetype, "should be the other mimetype")
        #endif // !SKIP
    }

    func test_ExpectedContentLength() {
        #if SKIP
        throw XCTSkip("TODO")
        #else
        var contentLength = 100
        var res = URLResponse(url: testURL, mimeType: "text/plain", expectedContentLength: contentLength, textEncodingName: nil)
        XCTAssertEqual(res.expectedContentLength, Int64(contentLength), "should be positive Int64 content length")

        contentLength = 0
        res = URLResponse(url: testURL, mimeType: nil, expectedContentLength: contentLength, textEncodingName: nil)
        XCTAssertEqual(res.expectedContentLength, Int64(contentLength), "should be zero Int64 content length")

        contentLength = -1
        res = URLResponse(url: testURL, mimeType: nil, expectedContentLength: contentLength, textEncodingName: nil)
        XCTAssertEqual(res.expectedContentLength, Int64(contentLength), "should be invalid (-1) Int64 content length")
        #endif // !SKIP
    }

    func test_TextEncodingName() {
        #if SKIP
        throw XCTSkip("TODO")
        #else
        let encoding = "utf8"
        var res = URLResponse(url: testURL, mimeType: nil, expectedContentLength: 0, textEncodingName: encoding)
        XCTAssertEqual(res.textEncodingName, encoding, "should be the utf8 encoding")

        res = URLResponse(url: testURL, mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
        XCTAssertNil(res.textEncodingName)
        #endif // !SKIP
    }

    func test_suggestedFilename_1() {
        #if SKIP
        throw XCTSkip("TODO")
        #else
        let url = URL(string: "a/test/name.extension")!
        let res = URLResponse(url: url, mimeType: "txt", expectedContentLength: 0, textEncodingName: nil)
        XCTAssertEqual(res.suggestedFilename, "name.extension")
        #endif // !SKIP
    }

    func test_suggestedFilename_2() {
        #if SKIP
        throw XCTSkip("TODO")
        #else
        let url = URL(string: "a/test/name.extension?foo=bar")!
        let res = URLResponse(url: url, mimeType: "txt", expectedContentLength: 0, textEncodingName: nil)
        XCTAssertEqual(res.suggestedFilename, "name.extension")
        #endif // !SKIP
    }

    func test_suggestedFilename_3() {
        #if SKIP
        throw XCTSkip("TODO")
        #else
        let url = URL(string: "a://bar")!
        let res = URLResponse(url: url, mimeType: "txt", expectedContentLength: 0, textEncodingName: nil)
//        XCTAssertEqual(res.suggestedFilename, "Unknown")
        #endif // !SKIP
    }

    func test_copyWithZone() {
        #if SKIP
        throw XCTSkip("TODO")
        #else
        let url = URL(string: "a/test/path")!
        let res = URLResponse(url: url, mimeType: "txt", expectedContentLength: 0, textEncodingName: nil)
        XCTAssertTrue(res.isEqual(res.copy() as! NSObject))
        #endif // !SKIP
    }

    @available(*, deprecated)
    func test_NSCoding() {
        #if SKIP
        throw XCTSkip("TODO")
        #else
        let url = URL(string: "https://apple.com")!
        let responseA = URLResponse(url: url, mimeType: "txt", expectedContentLength: 0, textEncodingName: nil)
        let responseB = NSKeyedUnarchiver.unarchiveObject(with: NSKeyedArchiver.archivedData(withRootObject: responseA)) as! URLResponse

        //On macOS unarchived Archived then unarchived `URLResponse` is not equal.
        XCTAssertEqual(responseA.url, responseB.url, "Archived then unarchived url response must be equal.")
        XCTAssertEqual(responseA.mimeType, responseB.mimeType, "Archived then unarchived url response must be equal.")
        XCTAssertEqual(responseA.expectedContentLength, responseB.expectedContentLength, "Archived then unarchived url response must be equal.")
        XCTAssertEqual(responseA.textEncodingName, responseB.textEncodingName, "Archived then unarchived url response must be equal.")
        XCTAssertEqual(responseA.suggestedFilename, responseB.suggestedFilename, "Archived then unarchived url response must be equal.")
        #endif // !SKIP
    }

    func test_equalWithTheSameInstance() throws {
        #if SKIP
        throw XCTSkip("TODO")
        #else
        let url = try XCTUnwrap(URL(string: "http://example.com/"))
        let response = URLResponse(url: url, mimeType: nil, expectedContentLength: -1, textEncodingName: nil)

        XCTAssertTrue(response.isEqual(response))
        #endif // !SKIP
    }

    func test_equalWithUnrelatedObject() throws {
        #if SKIP
        throw XCTSkip("TODO")
        #else
        let url = try XCTUnwrap(URL(string: "http://example.com/"))
        let response = URLResponse(url: url, mimeType: nil, expectedContentLength: -1, textEncodingName: nil)

        XCTAssertFalse(response.isEqual(NSObject()))
        #endif // !SKIP
    }

    func test_equalCheckingURL() throws {
        #if SKIP
        throw XCTSkip("TODO")
        #else
        let url1 = try XCTUnwrap(URL(string: "http://example.com/"))
        let response1 = URLResponse(url: url1, mimeType: nil, expectedContentLength: -1, textEncodingName: nil)

        let url2 = try XCTUnwrap(URL(string: "http://example.com/second"))
        let response2 = URLResponse(url: url2, mimeType: nil, expectedContentLength: -1, textEncodingName: nil)

        let response3 = URLResponse(url: url1, mimeType: nil, expectedContentLength: -1, textEncodingName: nil)

        XCTAssertFalse(response1.isEqual(response2))
        XCTAssertFalse(response2.isEqual(response1))
//        XCTAssertTrue(response1.isEqual(response3))
//        XCTAssertTrue(response3.isEqual(response1))
        #endif // !SKIP
    }

    func test_equalCheckingMimeType() throws {
        #if SKIP
        throw XCTSkip("TODO")
        #else
        let url = try XCTUnwrap(URL(string: "http://example.com/"))
        let response1 = URLResponse(url: url, mimeType: "mimeType1", expectedContentLength: -1, textEncodingName: nil)

        let response2 = URLResponse(url: url, mimeType: "mimeType2", expectedContentLength: -1, textEncodingName: nil)

        let response3 = URLResponse(url: url, mimeType: "mimeType1", expectedContentLength: -1, textEncodingName: nil)

        XCTAssertFalse(response1.isEqual(response2))
        XCTAssertFalse(response2.isEqual(response1))
//        XCTAssertTrue(response1.isEqual(response3))
//        XCTAssertTrue(response3.isEqual(response1))
        #endif // !SKIP
    }

    func test_equalCheckingExpectedContentLength() throws {
        #if SKIP
        throw XCTSkip("TODO")
        #else
        let url = try XCTUnwrap(URL(string: "http://example.com/"))
        let response1 = URLResponse(url: url, mimeType: nil, expectedContentLength: 100, textEncodingName: nil)

        let response2 = URLResponse(url: url, mimeType: nil, expectedContentLength: 200, textEncodingName: nil)

        let response3 = URLResponse(url: url, mimeType: nil, expectedContentLength: 100, textEncodingName: nil)

        XCTAssertFalse(response1.isEqual(response2))
        XCTAssertFalse(response2.isEqual(response1))
//        XCTAssertTrue(response1.isEqual(response3))
//        XCTAssertTrue(response3.isEqual(response1))
        #endif // !SKIP
    }

    func test_equalCheckingTextEncodingName() throws {
        #if SKIP
        throw XCTSkip("TODO")
        #else
        let url = try XCTUnwrap(URL(string: "http://example.com/"))
        let response1 = URLResponse(url: url, mimeType: nil, expectedContentLength: -1, textEncodingName: "textEncodingName1")

        let response2 = URLResponse(url: url, mimeType: nil, expectedContentLength: -1, textEncodingName: "textEncodingName2")

        let response3 = URLResponse(url: url, mimeType: nil, expectedContentLength: -1, textEncodingName: "textEncodingName1")

        XCTAssertFalse(response1.isEqual(response2))
        XCTAssertFalse(response2.isEqual(response1))
//        XCTAssertTrue(response1.isEqual(response3))
//        XCTAssertTrue(response3.isEqual(response1))
        #endif // !SKIP
    }

    func test_hash() throws {
        #if SKIP
        throw XCTSkip("TODO")
        #else
        let url1 = try XCTUnwrap(URL(string: "http://example.com/"))
        let response1 = URLResponse(url: url1, mimeType: "mimeType1", expectedContentLength: 100, textEncodingName: "textEncodingName1")

        let url2 = try XCTUnwrap(URL(string: "http://example.com/"))
        let response2 = URLResponse(url: url2, mimeType: "mimeType1", expectedContentLength: 100, textEncodingName: "textEncodingName1")

        let url3 = try XCTUnwrap(URL(string: "http://example.com/second"))
        let response3 = URLResponse(url: url3, mimeType: "mimeType3", expectedContentLength: 200, textEncodingName: "textEncodingName3")

//        XCTAssertEqual(response1.hash, response2.hash)
        XCTAssertNotEqual(response1.hash, response3.hash)
        XCTAssertNotEqual(response2.hash, response3.hash)
        #endif // !SKIP
    }

    #if !SKIP
    @available(*, deprecated)
    static var allTests: [(String, (TestURLResponse) -> () throws -> Void)] {
        return [
            ("test_URL", test_URL),
            ("test_MIMEType", test_MIMEType),
            ("test_ExpectedContentLength", test_ExpectedContentLength),
            ("test_TextEncodingName", test_TextEncodingName),
            ("test_suggestedFilename_1", test_suggestedFilename_1),
            ("test_suggestedFilename_2", test_suggestedFilename_2),
            ("test_suggestedFilename_3", test_suggestedFilename_3),
            ("test_copywithzone", test_copyWithZone),
            ("test_NSCoding", test_NSCoding),
            ("test_equalWithTheSameInstance", test_equalWithTheSameInstance),
            ("test_equalWithUnrelatedObject", test_equalWithUnrelatedObject),
            ("test_equalCheckingURL", test_equalCheckingURL),
            ("test_equalCheckingMimeType", test_equalCheckingMimeType),
            ("test_equalCheckingExpectedContentLength", test_equalCheckingExpectedContentLength),
            ("test_equalCheckingTextEncodingName", test_equalCheckingTextEncodingName),
            ("test_hash", test_hash),
        ]
    }
    #endif // SKIP
}


