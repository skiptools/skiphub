// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
#if !SKIP
@testable import SkipFoundation
#endif
import Foundation
import OSLog
import XCTest

@available(macOS 11, iOS 14, watchOS 7, tvOS 14, *)
class TestJSON : XCTestCase {
    fileprivate let logger: Logger = Logger(subsystem: "test", category: "TestJSON")

    func checkJSON(_ json: String) throws {
        XCTAssertEqual(json, try JSONObject(json).stringify(pretty: false, sorted: true))
    }

    func testJSONParsing() throws {
        try checkJSON("""
        {"a":1}
        """)

        try checkJSON("""
        {"x":true}
        """)

        #if SKIP
        try checkJSON("""
        {"_":1.1}
        """)
        #else
        try checkJSON("""
        {"_":1.1000000000000001}
        """)
        #endif

        try checkJSON("""
        {"a":[1]}
        """)

        #if false // neither work
        try checkJSON("""
        {"a":[1,true,false,0.00001,"X"]}
        """)
        #endif

        #if SKIP
        // Android's version of org.json:json is different
        // try checkJSON("""
        // {"a":[1,true,false,1.0E-5,"X"]}
        // """)

        // latest org.json:json
        try checkJSON("""
        {"a":[1,true,false,0.00001,"X"]}
        """)
        #else
        try checkJSON("""
        {"a":[1,true,false,1.0000000000000001e-05,"X"]}
        """)
        #endif

        let jsonString = """
        {
          "age": 30,
          "isEmployed": true,
          "name": "John Smith"
        }
        """

        // note that unlike Swift JSON, the JSONObject key/values are in the same order as the document
        let jsonObject = try JSONObject(jsonString)

        let plainString = try jsonObject.stringify(pretty: false, sorted: true)

        XCTAssertTrue(plainString == #"{"age":30,"isEmployed":true,"name":"John Smith"}"# || plainString == #"{"name":"John Smith","isEmployed":true,"age":30}"#, "Unexpected JSON: \(plainString)")

        let prettyString = try jsonObject.stringify(pretty: true, sorted: true)

        // note Android differences:
        // 1. We do not yet support sorted keys on Android (we'd need to override the JSONStringer, or make a recursive copy of the tree)
        // 2. Swift pretty output has spaces in front of the colons
        #if SKIP
        // Android's version of org.json:json is different
        // XCTAssertEqual(prettyString, """
        // {
        //   "age": 30,
        //   "isEmployed": true,
        //   "name": "John Smith"
        // }
        // """)
        XCTAssertEqual(prettyString, """
        {
          "name": "John Smith",
          "isEmployed": true,
          "age": 30
        }
        """)
        #else
        XCTAssertEqual(prettyString, """
        {
          "age" : 30,
          "isEmployed" : true,
          "name" : "John Smith"
        }
        """)
        #endif

        let arrayify: (Int, String) -> (String) = { (count, str) in
            var s = str
            for _ in 0..<count {
                s += "," + str
            }
            return "{ \"x\": [" + s + "] }"
        }

        var bigString = arrayify(10, jsonString)
        bigString = arrayify(10, bigString)
        bigString = arrayify(10, bigString)
        bigString = arrayify(10, bigString)
        bigString = arrayify(10, bigString) // 100,000: 0.202 Swift, 0.095 Robo
        //bigString = arrayify(4, bigString) // 400,000 (~50M): 1.021 Swift macOS, 0.311 Java Robolectric
        //bigString = arrayify(…, bigString) // 10,000,000: 24.408 Swift,  OOME Robo

        // good timing test
        logger.info("parsing string: \(bigString.count)")
        let _ = try JSONObject(bigString)
        //let prettyBigString = try prettyBigObject.stringify(pretty: true, sorted: true)

    }
}
