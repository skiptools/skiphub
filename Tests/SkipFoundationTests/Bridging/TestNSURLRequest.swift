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

class TestNSURLRequest : XCTestCase {
    
    
    let url = URL(string: "http://swift.org")!
    
    func test_construction() {
        let request = NSURLRequest(url: url)
        // Match macOS Foundation responses
        XCTAssertEqual(request.url, url)
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertNil(request.allHTTPHeaderFields)
        XCTAssertNil(request.mainDocumentURL)
    }
    
    func test_mutableConstruction() {
        #if SKIP
        throw XCTSkip("TODO")
        #else
        let url = URL(string: "http://swift.org")!
        let request = NSMutableURLRequest(url: url)
        
        //Confirm initial state matches NSURLRequest responses
        XCTAssertEqual(request.url, url)
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertNil(request.allHTTPHeaderFields)
        XCTAssertNil(request.mainDocumentURL)
        
        request.mainDocumentURL = url
        XCTAssertEqual(request.mainDocumentURL, url)
        
        request.httpMethod = "POST"
        XCTAssertEqual(request.httpMethod, "POST")
        
        let newURL = URL(string: "http://github.com")!
        request.url = newURL
        XCTAssertEqual(request.url, newURL)
        #endif // !SKIP
    }
    
    func test_headerFields() {
        #if SKIP
        throw XCTSkip("TODO")
        #else
        let request = NSMutableURLRequest(url: url)
        
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        XCTAssertNotNil(request.allHTTPHeaderFields)
        XCTAssertEqual(request.allHTTPHeaderFields?["Accept"], "application/json")
        
        // Setting "accept" should update "Accept"
        request.setValue("application/xml", forHTTPHeaderField: "accept")
        XCTAssertNil(request.allHTTPHeaderFields?["accept"])
        XCTAssertEqual(request.allHTTPHeaderFields?["Accept"], "application/xml")
        
        // Adding to "Accept" should add to "Accept"
        request.addValue("text/html", forHTTPHeaderField: "Accept")
        XCTAssertEqual(request.allHTTPHeaderFields?["Accept"], "application/xml,text/html")
        #endif // !SKIP
    }
    
    func test_copy() {
        #if SKIP
        throw XCTSkip("TODO")
        #else
        let mutableRequest = NSMutableURLRequest(url: url)
        
        let urlA = URL(string: "http://swift.org")!
        let urlB = URL(string: "http://github.com")!
        let postBody = "here is body".data(using: .utf8)

        mutableRequest.mainDocumentURL = urlA
        mutableRequest.url = urlB
        mutableRequest.httpMethod = "POST"
        mutableRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        mutableRequest.httpBody = postBody

        guard let requestCopy1 = mutableRequest.copy() as? NSURLRequest else {
            XCTFail(); return
        }
        
        // Check that all attributes are copied and that the original ones are
        // unchanged:
        XCTAssertEqual(mutableRequest.mainDocumentURL, urlA)
        XCTAssertEqual(requestCopy1.mainDocumentURL, urlA)
        XCTAssertEqual(mutableRequest.httpMethod, "POST")
        XCTAssertEqual(requestCopy1.httpMethod, "POST")
        XCTAssertEqual(mutableRequest.url, urlB)
        XCTAssertEqual(requestCopy1.url, urlB)
        XCTAssertEqual(mutableRequest.allHTTPHeaderFields?["Accept"], "application/json")
        XCTAssertEqual(requestCopy1.allHTTPHeaderFields?["Accept"], "application/json")
        XCTAssertEqual(mutableRequest.httpBody, postBody)
        XCTAssertEqual(requestCopy1.httpBody, postBody)

        // Change the original, and check that the copy has unchanged
        // values:
        let urlC = URL(string: "http://apple.com")!
        let urlD = URL(string: "http://ibm.com")!
        mutableRequest.mainDocumentURL = urlC
        mutableRequest.url = urlD
        mutableRequest.httpMethod = "HEAD"
        mutableRequest.addValue("text/html", forHTTPHeaderField: "Accept")
        XCTAssertEqual(requestCopy1.mainDocumentURL, urlA)
        XCTAssertEqual(requestCopy1.httpMethod, "POST")
        XCTAssertEqual(requestCopy1.url, urlB)
        XCTAssertEqual(requestCopy1.allHTTPHeaderFields?["Accept"], "application/json")

        // Check that we can copy the copy:
        guard let requestCopy2 = requestCopy1.copy() as? NSURLRequest else {
            XCTFail(); return
        }
        XCTAssertEqual(requestCopy2.mainDocumentURL, urlA)
        XCTAssertEqual(requestCopy2.httpMethod, "POST")
        XCTAssertEqual(requestCopy2.url, urlB)
        XCTAssertEqual(requestCopy2.allHTTPHeaderFields?["Accept"], "application/json")
        #endif // !SKIP
    }

    func test_mutableCopy_1() {
        #if SKIP
        throw XCTSkip("TODO")
        #else
        let originalRequest = NSMutableURLRequest(url: url)
        
        let urlA = URL(string: "http://swift.org")!
        let urlB = URL(string: "http://github.com")!

        originalRequest.mainDocumentURL = urlA
        originalRequest.url = urlB
        originalRequest.httpMethod = "POST"
        originalRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        
        guard let requestCopy = originalRequest.mutableCopy() as? NSMutableURLRequest else {
            XCTFail(); return
        }
        
        // Change the original, and check that the copy has unchanged values:
        let urlC = URL(string: "http://apple.com")!
        let urlD = URL(string: "http://ibm.com")!
        originalRequest.mainDocumentURL = urlC
        originalRequest.url = urlD
        originalRequest.httpMethod = "HEAD"
        originalRequest.addValue("text/html", forHTTPHeaderField: "Accept")
        XCTAssertEqual(requestCopy.mainDocumentURL, urlA)
        XCTAssertEqual(requestCopy.httpMethod, "POST")
        XCTAssertEqual(requestCopy.url, urlB)
        XCTAssertEqual(requestCopy.allHTTPHeaderFields?["Accept"], "application/json")
        #endif // !SKIP
    }

    func test_mutableCopy_2() {
        #if SKIP
        throw XCTSkip("TODO")
        #else
        let originalRequest = NSMutableURLRequest(url: url)
        
        let urlA = URL(string: "http://swift.org")!
        let urlB = URL(string: "http://github.com")!
        originalRequest.mainDocumentURL = urlA
        originalRequest.url = urlB
        originalRequest.httpMethod = "POST"
        originalRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        
        guard let requestCopy = originalRequest.mutableCopy() as? NSMutableURLRequest else {
            XCTFail(); return
        }
        
        // Change the copy, and check that the original has unchanged values:
        let urlC = URL(string: "http://apple.com")!
        let urlD = URL(string: "http://ibm.com")!
        requestCopy.mainDocumentURL = urlC
        requestCopy.url = urlD
        requestCopy.httpMethod = "HEAD"
        requestCopy.addValue("text/html", forHTTPHeaderField: "Accept")
        XCTAssertEqual(originalRequest.mainDocumentURL, urlA)
        XCTAssertEqual(originalRequest.httpMethod, "POST")
        XCTAssertEqual(originalRequest.url, urlB)
        XCTAssertEqual(originalRequest.allHTTPHeaderFields?["Accept"], "application/json")
        #endif // !SKIP
    }

    func test_mutableCopy_3() {
        #if SKIP
        throw XCTSkip("TODO")
        #else
        let urlA = URL(string: "http://swift.org")!
        let originalRequest = NSURLRequest(url: urlA)
        
        guard let requestCopy = originalRequest.mutableCopy() as? NSMutableURLRequest else {
            XCTFail(); return
        }
        
        // Change the copy, and check that the original has unchanged values:
        let urlC = URL(string: "http://apple.com")!
        let urlD = URL(string: "http://ibm.com")!
        requestCopy.mainDocumentURL = urlC
        requestCopy.url = urlD
        requestCopy.httpMethod = "HEAD"
        requestCopy.addValue("text/html", forHTTPHeaderField: "Accept")
        XCTAssertNil(originalRequest.mainDocumentURL)
        XCTAssertEqual(originalRequest.httpMethod, "GET")
        XCTAssertEqual(originalRequest.url, urlA)
        XCTAssertNil(originalRequest.allHTTPHeaderFields)
        #endif // !SKIP
    }

    func test_hash() {
        #if SKIP
        throw XCTSkip("TODO")
        #else
        let url = URL(string: "https://example.org")!

        let r1 = NSURLRequest(url: url)
        let r2 = NSURLRequest(url: url)
        XCTAssertEqual(r1, r2)
        XCTAssertEqual(r1.hashValue, r2.hashValue)

        let urls: [URL?] = (0..<100).map { URL(string: "https://example.org/\($0)") }
        checkHashing_NSMutableCopying(
            initialValue: NSURLRequest(url: URL(string: "https://example.org")!),
            byMutating: \NSMutableURLRequest.url,
            throughValues: urls)
//        checkHashing_NSMutableCopying(
//            initialValue: NSURLRequest(url: URL(string: "https://example.org")!),
//            byMutating: \NSMutableURLRequest.mainDocumentURL,
//            throughValues: urls)
//        checkHashing_NSMutableCopying(
//            initialValue: NSURLRequest(url: URL(string: "https://example.org")!),
//            byMutating: \NSMutableURLRequest.httpMethod,
//            throughValues: [
//                "HEAD", "POST", "PUT", "DELETE", "CONNECT", "TWIZZLE",
//                "REFUDIATE", "BUY", "REJECT", "UNDO", "SYNERGIZE",
//                "BUMFUZZLE", "ELUCIDATE"])
        let inputStreams: [InputStream?] = (0..<100).map { value in
            InputStream(data: Data("\(value)".utf8))
        }
//        checkHashing_NSMutableCopying(
//            initialValue: NSURLRequest(url: URL(string: "https://example.org")!),
//            byMutating: \NSMutableURLRequest.httpBodyStream,
//            throughValues: inputStreams)
        // allowsCellularAccess and httpShouldHandleCookies do
        // not have enough values to test them here.
        #endif // !SKIP
    }

    func test_methodNormalization() {
        #if SKIP
        throw XCTSkip("TODO")
        #else
        let expectedNormalizations = [
            "GET": "GET",
            "get": "GET",
            "gEt": "GET",
            "HEAD": "HEAD",
            "hEAD": "HEAD",
            "head": "HEAD",
            "HEAd": "HEAD",
            "POST": "POST",
            "post": "POST",
            "pOST": "POST",
            "POSt": "POST",
            "PUT": "PUT",
            "put": "PUT",
            "PUt": "PUT",
            "DELETE": "DELETE",
            "delete": "DELETE",
            "DeleTE": "DELETE",
            "dELETe": "DELETE",
            "CONNECT": "CONNECT",
            "connect": "CONNECT",
            "Connect": "CONNECT",
            "cOnNeCt": "CONNECT",
            "OPTIONS": "OPTIONS",
            "options": "options",
            "TRACE": "TRACE",
            "trace": "trace",
            "PATCH": "PATCH",
            "patch": "patch",
            "foo": "foo",
            "BAR": "BAR",
        ]

        let request = NSMutableURLRequest(url: url)

        for n in expectedNormalizations {
            request.httpMethod = n.key
            XCTAssertEqual(request.httpMethod, n.value)
        }
        #endif // !SKIP
    }

    func test_description() {
        #if SKIP
        throw XCTSkip("TODO")
        #else
        let url = URL(string: "http://swift.org")!
        let request = NSMutableURLRequest(url: url)

        if request.description.range(of: "http://swift.org") == nil {
            XCTFail("description should contain URL")
        }

        request.url = nil
        if request.description.range(of: "(null)") == nil {
            XCTFail("description of nil URL should contain (null)")
        }
        #endif // !SKIP
    }

    func test_invalidHeaderValues() {
        #if SKIP
        throw XCTSkip("TODO")
        #else
        let url = URL(string: "http://swift.org")!
        let request = NSMutableURLRequest(url: url)

        let invalidHeaderValues = [
            "\r\nevil: hello\r\n\r\nGET /other HTTP/1.1\r\nevil: hello",
            "invalid\0NUL",
            "invalid\rCR",
            "invalidCR\r",
            "invalid\nLF",
            "invalidLF\n",
            "invalid\r\nCRLF",
            "invalidCRLF\r\n",
            "invalid\r\rCRCR"
        ]

        for (i, value) in invalidHeaderValues.enumerated() {
            request.setValue("Bar\(value)", forHTTPHeaderField: "Foo\(i)")
//            XCTAssertNil(request.value(forHTTPHeaderField: "Foo\(i)"))
            request.addValue("Bar\(value)", forHTTPHeaderField: "Foo\(i)")
//            XCTAssertNil(request.value(forHTTPHeaderField: "Foo\(i)"))
        }
        #endif // !SKIP
    }

    func test_validLineFoldedHeaderValues() {
        #if SKIP
        throw XCTSkip("TODO")
        #else
        let url = URL(string: "http://swift.org")!
        let request = NSMutableURLRequest(url: url)

        let validHeaderValueLineFoldedTab = "Bar\r\n\tBuz"
        request.setValue(validHeaderValueLineFoldedTab, forHTTPHeaderField: "FooTab")
        XCTAssertEqual(request.value(forHTTPHeaderField: "FooTab"), validHeaderValueLineFoldedTab)

        let validHeaderValueLineFoldedSpace = "Bar\r\n Buz"
        request.setValue(validHeaderValueLineFoldedSpace, forHTTPHeaderField: "FooSpace")
        XCTAssertEqual(request.value(forHTTPHeaderField: "FooSpace"), validHeaderValueLineFoldedSpace)
        #endif // !SKIP
    }
}


