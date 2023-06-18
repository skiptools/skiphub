// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
import OSLog
import XCTest

#if SKIP
//import Foundation
#else
import class SkipFoundation.JSONEncoder
import class SkipFoundation.JSONDecoder
import struct SkipFoundation.Date
import struct SkipFoundation.Data
import struct SkipFoundation.URL
import struct SkipFoundation.UUID
import class SkipFoundation.DateFormatter
#endif

// SKIP INSERT: @org.junit.runner.RunWith(androidx.test.ext.junit.runners.AndroidJUnit4::class)
// SKIP INSERT: @org.robolectric.annotation.Config(manifest=org.robolectric.annotation.Config.NONE, sdk = [33])
@available(macOS 11, iOS 14, watchOS 7, tvOS 14, *)
class TestJSON : XCTestCase {
    fileprivate let logger: Logger = Logger(subsystem: "test", category: "TestJSON")

    struct StringField : Equatable, Encodable {
        var stringField: String
    }

    struct IntField : Equatable, Encodable {
        var intField: Int
    }

    struct BoolField : Equatable, Encodable {
        var boolField: Bool
    }

    struct FloatField : Equatable, Encodable {
        var floatField: Float
    }

    struct DoubleField : Equatable, Encodable {
        var doubleField: Double
    }

    struct DataField : Equatable, Encodable {
        var dataField: Data
    }

    struct DateField : Equatable, Encodable {
        var dateField: Date
    }

    struct URLField : Equatable, Encodable {
        var urlField: URL
    }

    struct UUIDField : Equatable, Encodable {
        var uuidField: UUID
    }

    struct StringArrayField : Equatable, Encodable {
        var stringArrayField: Array<String>
    }

    #if !SKIP
    // SKIP TODO: implement container.encode(stringArrayField, forKey = CodingKeys.stringArrayField)
    struct StringSetField : Equatable, Encodable {
        var stringSetField: Set<String>
    }
    #endif

    struct EntityDefaultKeys : Equatable, Encodable {
        var firstName: String
        var lastName: String
        var age: Int?
        var height: Double?
        var isStudent: Bool?
        //var friends: [EntityDefaultKeys]?
    }

    func testJSONCodable() throws {
        func enc<T: Encodable>(_ value: T, fmt: JSONEncoder.OutputFormatting? = nil, data: JSONEncoder.DataEncodingStrategy? = nil, date: JSONEncoder.DateEncodingStrategy? = nil, floats: JSONEncoder.NonConformingFloatEncodingStrategy? = nil, keys: JSONEncoder.KeyEncodingStrategy? = nil) throws -> String {
            let encoder = JSONEncoder()
            if let fmt = fmt {
                encoder.outputFormatting = fmt
            }
            if let data = data {
                encoder.dataEncodingStrategy = data
            }
            if let date = date {
                encoder.dateEncodingStrategy = date
            }
            if let floats = floats {
                encoder.nonConformingFloatEncodingStrategy = floats
            }
            if let keys = keys {
                encoder.keyEncodingStrategy = keys
            }
            let data = try encoder.encode(value)
            return data.utf8String ?? ""
            //return String(data: data, encoding: .utf8) ?? ""
        }

        XCTAssertEqual(#"{"intField":1}"#, try enc(IntField(intField: Int(1))))
        // difference between ObjC and native Swift JSONEncoder
        //XCTAssertEqual(#"{"floatField":1.1000000238418579}"#, try enc(FloatField(floatField: Float(1.1))))
        XCTAssertEqual(#"{"floatField":1.2}"#, try enc(FloatField(floatField: Float(1.2))))
        XCTAssertEqual(#"{"stringField":"ABC"}"#, try enc(StringField(stringField: "ABC")))
        XCTAssertEqual(#"{"stringField":"ABC\/XYZ"}"#, try enc(StringField(stringField: "ABC/XYZ")))

        XCTAssertEqual(#"{"dataField":"AQI="}"#, try enc(DataField(dataField: Data([UInt8(0x01), UInt8(0x02)]))))
        XCTAssertEqual(#"{"dataField":"AQI="}"#, try enc(DataField(dataField: Data([UInt8(0x01), UInt8(0x02)])), data: .base64 as JSONEncoder.DataEncodingStrategy))
        XCTAssertEqual(#"{"dataField":3}"#, try enc(DataField(dataField: Data([UInt8(0x01), UInt8(0x02), UInt8(0x03)])), data: .custom({ data, encoder in var container = encoder.singleValueContainer(); try container.encode(data.count) }) as JSONEncoder.DataEncodingStrategy))
        XCTAssertEqual(#"{"dataField":[1,2]}"#, try enc(DataField(dataField: Data([UInt8(0x01), UInt8(0x02)])), data: .deferredToData as JSONEncoder.DataEncodingStrategy))

        XCTAssertEqual(#"{"dateField":-1}"#, try enc(DateField(dateField: Date(timeIntervalSinceReferenceDate: -1.0))))

        XCTAssertEqual(#"{"dateField":1.0}"#, try enc(DateField(dateField: Date(timeIntervalSince1970: 1.0)), date: .secondsSince1970 as JSONEncoder.DateEncodingStrategy))
        XCTAssertEqual(#"{"dateField":"1970-01-01T00:00:01Z"}"#, try enc(DateField(dateField: Date(timeIntervalSince1970: 1.0)), date: .iso8601 as JSONEncoder.DateEncodingStrategy))

        let df = DateFormatter()
        df.dateFormat = "YYYY"
        XCTAssertEqual(#"{"dateField":"1970"}"#, try enc(DateField(dateField: Date(timeIntervalSince1970: 1.0)), date: .formatted(df) as JSONEncoder.DateEncodingStrategy))

        XCTAssertEqual(#"{"dateField":true}"#, try enc(DateField(dateField: Date(timeIntervalSince1970: 1.0)), date: .custom({ date, encoder in var container = encoder.singleValueContainer(); try container.encode(true) }) as JSONEncoder.DateEncodingStrategy))

        XCTAssertEqual(#"{"uuidField":"A53BAA1C-B4F5-48DB-9567-9786B76B256C"}"#, try enc(UUIDField(uuidField: UUID(uuidString: "a53baa1c-b4f5-48db-9567-9786b76b256c")!)))

        XCTAssertEqual(#"{"stringArrayField":["ABC","XYZ"]}"#, try enc(StringArrayField(stringArrayField: ["ABC", "XYZ"])))

        #if !SKIP
        // TODO: convertToSnakeCase
        XCTAssertEqual(#"{"int_field":1}"#, try enc(IntField(intField: Int(1)), keys: .convertToSnakeCase as JSONEncoder.KeyEncodingStrategy))


        let person = EntityDefaultKeys(firstName: "Jon", lastName: "Doe", height: 180.5)

        //XCTAssertEqual(#"{"firstName":"Jon","height":180.5,"lastName":"Doe"}"#, try enc().encode(person))

        //let person2 = try JSONDecoder().decode(EntityDefaultKeys.self, from: jsonData)
        //XCTAssertEqual(person, person)
        #endif
    }

    struct EntityCustomKeys : Encodable {
        var nameFirst: String
        var nameLast: String
        var age: Int

        enum CodingKeys : String, RawRepresentable, CodingKey {
            case nameFirst = "firstName"
            case nameLast = "lastName"
            case age
        }
    }

    func testEncodeToJSON() throws {
        let person = EntityCustomKeys(nameFirst: "Jon", nameLast: "Doe", age: 44)

        XCTAssertEqual("firstName", EntityCustomKeys.CodingKeys.nameFirst.rawValue)
        XCTAssertEqual("Jon", person.nameFirst)
        XCTAssertEqual("Doe", person.nameLast)
        XCTAssertEqual(44, person.age)

//        let json: JSON = try person.json()
//        XCTAssertEqual(JSON.number(44.0), json.obj?["age"])
//        XCTAssertEqual(JSON.string("Jon"), json.obj?["firstName"])
//        XCTAssertEqual(JSON.string("Doe"), json.obj?["lastName"])
//        XCTAssertEqual(#"{"age":44.0,"firstName":"Jon","lastName":"Doe"}"#, json.stringify())
    }

    func testJSONParse() throws {
//        XCTAssertEqual(JSON.null, try JSON.parse("null"))
//        XCTAssertEqual(JSON.string("ABC"), try JSON.parse(#""ABC""#))
//        XCTAssertEqual(JSON.bool(true), try JSON.parse("true"))
//        XCTAssertEqual(JSON.bool(false), try JSON.parse("false"))
//        XCTAssertEqual(JSON.number(0.1), try JSON.parse("0.1"))
//        #if SKIP
//        XCTAssertEqual(JSON.number(0.0), try JSON.parse("0"))
//        #else
//        XCTAssertEqual(JSON.number(0), try JSON.parse("0"))
//        #endif
//
//        let json = try JSON.parse("""
//        {
//            "a": 1.1,
//            "b": true,
//            "d": "XYZ",
//            "e": [-9, true, null, {
//                "x": "q",
//                "y": 0.1,
//                "z": [[[[[false]]], true]]
//            }, [null]]
//        }
//        """)
//
//        #if !SKIP // TODO: subscripts and literal initializers
//        XCTAssertEqual(1.1, json["a"])
//        XCTAssertEqual(true, json["b"])
//        XCTAssertEqual(nil, json["c"])
//        XCTAssertEqual("XYZ", json["d"])
//        XCTAssertEqual(5, json["e"]?.count)
//        #endif
//
//        // equivalent (but more verbose) comparisons
//        XCTAssertEqual(JSON.number(1.1), json.obj?["a"])
//        XCTAssertEqual(JSON.bool(true), json.obj?["b"])
//        XCTAssertEqual(nil, json.obj?["c"])
//        XCTAssertEqual(JSON.string("XYZ"), json.obj?["d"])
//        XCTAssertEqual(5, json.obj?["e"]?.count)
//
//
//        let json2 = try JSON.parse(json.stringify(pretty: false))
//        XCTAssertEqual(json, json2, "re-parsed plain JSON should have been equal")
//        XCTAssertEqual(json.stringify(), #"{"a":1.1,"b":true,"d":"XYZ","e":[-9.0,true,null,{"x":"q","y":0.1,"z":[[[[[false]]],true]]},[null]]}"#)
//
//        let json3 = try JSON.parse(json.stringify(pretty: true))
//        XCTAssertEqual(json, json3, "re-parsed pretty JSON should have been equal")
//        XCTAssertEqual(json.stringify(pretty: true), """
//        {
//          "a" : 1.1,
//          "b" : true,
//          "d" : "XYZ",
//          "e" : [
//            -9.0,
//            true,
//            null,
//            {
//              "x" : "q",
//              "y" : 0.1,
//              "z" : [
//                [
//                  [
//                    [
//                      [
//                        false
//                      ]
//                    ]
//                  ],
//                  true
//                ]
//              ]
//            },
//            [
//              null
//            ]
//          ]
//        }
//        """)
    }

    func checkJSON(_ json: String) throws {
//        XCTAssertEqual(json, try JSONObjectAny(json: json).stringify(pretty: false, sorted: true))
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
        // try checkJSON("""
        // {"a":[1,true,false,0.00001,"X"]}
        // """)

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

        // note that unlike Swift JSON, the JSONObjectAny key/values are in the same order as the document
//        let jsonObject = try JSONObjectAny(json: jsonString)
//
//        let plainString = try jsonObject.stringify(pretty: false, sorted: true)
//
//        XCTAssertTrue(plainString == #"{"age":30,"isEmployed":true,"name":"John Smith"}"# || plainString == #"{"name":"John Smith","isEmployed":true,"age":30}"#, "Unexpected JSON: \(plainString)")
//
//        let prettyString = try jsonObject.stringify(pretty: true, sorted: true)
//
//        // note Android differences:
//        // 1. We do not yet support sorted keys on Android (we'd need to override the JSONStringer, or make a recursive copy of the tree)
//        // 2. Swift pretty output has spaces in front of the colons
//        #if SKIP
//        // Android's version of org.json:json is different
//        XCTAssertEqual(prettyString, """
//        {
//          "age": 30,
//          "isEmployed": true,
//          "name": "John Smith"
//        }
//        """)
//        //XCTAssertEqual(prettyString, """
//        //{
//        //  "name": "John Smith",
//        //  "isEmployed": true,
//        //  "age": 30
//        //}
//        //""")
//        #else
//        XCTAssertEqual(prettyString, """
//        {
//          "age" : 30,
//          "isEmployed" : true,
//          "name" : "John Smith"
//        }
//        """)
//        #endif
//
//        let arrayify: (Int, String) -> (String) = { (count, str) in
//            var s = str
//            for _ in 0..<count {
//                s += "," + str
//            }
//            return "{ \"x\": [" + s + "] }"
//        }
//
//        var bigString = arrayify(10, jsonString)
//        bigString = arrayify(10, bigString)
//        bigString = arrayify(10, bigString)
//        bigString = arrayify(10, bigString)
//        bigString = arrayify(10, bigString) // 100,000: 0.202 Swift, 0.095 Robo
//        //bigString = arrayify(4, bigString) // 400,000 (~50M): 1.021 Swift macOS, 0.311 Java Robolectric
//        //bigString = arrayify(…, bigString) // 10,000,000: 24.408 Swift,  OOME Robo
//
//        // good timing test
//        logger.info("parsing string: \(bigString.count)")
//        let _ = try JSONObjectAny(json: bigString)
//        //let prettyBigString = try prettyBigObject.stringify(pretty: true, sorted: true)

    }

    #if !SKIP
    func testJSONDeserialization() throws {
//        let object = try XCTUnwrap(JSONSerialization.jsonObject(with: Data("""
//            {
//                "a": 1.1,
//                "b": true,
//                "d": "XYZ",
//                "e": [-9, true, null, {
//                    "x": "q",
//                    "y": 0.1,
//                    "z": [[[[[false]]], true]]
//                }, [null]]
//            }
//            """.utf8), options: JSONSerialization.ReadingOptions.fragmentsAllowed))
//
//        let obj = try XCTUnwrap(object as? [String: Any])
//
//        XCTAssertEqual(1.1, obj["a"] as? Double)
//        XCTAssertEqual(true, obj["b"] as? Bool)
//        XCTAssertEqual("XYZ", obj["d"] as? String)
//
//        let ex = try XCTUnwrap(obj["e"])
//        let e = try XCTUnwrap(obj["e"] as? [Any])
//        XCTAssertEqual(5, e.count)
//
//        XCTAssertEqual(-9.0, e[0] as? Double)
//        XCTAssertEqual(true, e[1] as? Bool)
//
//        //XCTAssertNil(e[2])
//        //XCTAssertEqual("<null>", "\(e[2])")
//
//        guard let e3 = e[3] as? [String: Any] else {
//            return XCTFail("bad type: \(type(of: e[3]))")
//        }
//
//        XCTAssertEqual("q", (e3["x"] as? String))
//        XCTAssertEqual(0.1, (e3["y"] as? Double))
//
//        XCTAssertEqual(1, (e[4] as? [Any])?.count)
    }
    #endif
}
