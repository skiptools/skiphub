// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
#if !SKIP
@testable import SkipKit
#endif
import Foundation
import OSLog
import XCTest

// SKIP INSERT: @org.junit.runner.RunWith(org.robolectric.RobolectricTestRunner::class)
// SKIP INSERT: @org.robolectric.annotation.Config(manifest=org.robolectric.annotation.Config.NONE, sdk = [33])
class TestJSON : XCTestCase {
    fileprivate let logger = Logger(subsystem: "test", category: "TestJSON")

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
        try checkJSON("""
        {"a":[1,true,false,1.0E-5,"X"]}
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

        XCTAssertEqual(plainString, #"{"age":30,"isEmployed":true,"name":"John Smith"}"#)

        let prettyString = try jsonObject.stringify(pretty: true, sorted: true)

        // note Android differences:
        // 1. We do not yet support sorted keys on Android (we'd need to override the JSONStringer, or make a recursive copy of the tree)
        // 2. Swift pretty output has spaces in front of the colons
        #if SKIP
        XCTAssertEqual(prettyString, """
        {
          "age": 30,
          "isEmployed": true,
          "name": "John Smith"
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


/// A Swift JSON parsing API to match the `org.json.JSONObject` Java API.
public final class JSONObject {
    #if SKIP
    /// The internal JSON object, which is an `org.json.JSONObject` instance.
    var json: org.json.JSONObject
    #else
    /// The internal JSON object, which will be either an `NSMutableDictionary` or an `NSMutableArray`
    var json: Any
    #endif

    /// Parse the JSON using the system parser.
    public init(_ json: String) throws {
        #if SKIP
        self.json = try org.json.JSONObject(json)
        #else
        self.json = try JSONSerialization.jsonObject(with: Data(json.utf8), options: [.mutableLeaves, .mutableContainers])
        #endif
    }
}

public extension JSONObject {
    /// Returns the JSON string representing this Object.
    func stringify(pretty: Bool = false, sorted: Bool = false) throws -> String {
        #if !SKIP
        return String(data: try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions([.withoutEscapingSlashes] + (pretty ? [.prettyPrinted] : []) + (sorted ? [.sortedKeys] : []))), encoding: .utf8) ?? ""
        #else
        // TODO: there isn't any simple way to output sorted keys, but we want to be able to support it for consistent output
        // one way to support this would be to make a recurisve copy of the tree with clones of any JSONObject instances with their keys in sorted order; this would be expensive for large trees
        if pretty {
            return json.toString(2)
        } else {
            return json.toString()
        }
        #endif
    }
}
