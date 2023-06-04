// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
#if !SKIP
/* @_implementationOnly */import class Foundation.JSONSerialization
/* @_implementationOnly */import struct Foundation.Data
public typealias PlatformJSONObject = [String: Any]
public typealias PlatformJSONArray = [Any]
let PlatformJSONNull = NSNull()
#else
public typealias PlatformJSONObject = org.json.JSONObject
public typealias PlatformJSONArray = org.json.JSONArray
let PlatformJSONNull: Any = org.json.JSONObject.NULL
#endif

// A general constraint for a numeric type
#if SKIP
typealias PlatformNumeric = kotlin.Number
#else
typealias PlatformNumeric = Swift.Numeric
#endif


#if SKIP
public typealias JSONSerialization = PlatformJSONSerialization
#endif


struct CannotConvertString: Error { }

// SKIP REPLACE: internal typealias AnyArrayType = skip.lib.Array<*>
typealias AnyArrayType = Array<Any>
// SKIP REPLACE: internal typealias AnyMapType = skip.lib.Dictionary<*, *>
typealias AnyMapType = [String: Any]

// SKIP DECLARE: open class PlatformJSONSerialization
internal class PlatformJSONSerialization {
    public struct WritingOptions : OptionSet {
        public let rawValue: Int

        public init(rawValue: Int) {
            self.rawValue = rawValue
        }

        /// Specifies that the output uses white space and indentation to make the resulting data more readable.
        public static let prettyPrinted: WritingOptions = WritingOptions(rawValue: 1 << 0)
        /// Specifies that the output sorts keys in lexicographic order.
        public static let sortedKeys: WritingOptions = WritingOptions(rawValue: 1 << 1)
        /// Specifies that the parser should allow top-level objects that aren’t arrays or dictionaries.
        public static let fragmentsAllowed: WritingOptions = WritingOptions(rawValue: 1 << 2)
        /// Specifies that the output doesn’t prefix slash characters with escape characters.
        public static let withoutEscapingSlashes: WritingOptions = WritingOptions(rawValue: 1 << 3)

        //public static let none: WritingOptions = []
    }

    public struct ReadingOptions : OptionSet {
        public let rawValue: Int

        public static var mutableContainers: ReadingOptions = ReadingOptions(rawValue: 1 << 0)
        public static var mutableLeaves: ReadingOptions = ReadingOptions(rawValue: 1 << 1)
        public static var fragmentsAllowed: ReadingOptions = ReadingOptions(rawValue: 1 << 2)
        public static var json5Allowed: ReadingOptions = ReadingOptions(rawValue: 1 << 3)
        public static var topLevelDictionaryAssumed: ReadingOptions = ReadingOptions(rawValue: 1 << 4)
        public static var allowFragments: ReadingOptions = ReadingOptions(rawValue: 1 << 5)

        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
    }

    /// Attempt to create a String from the data using one of the 5 supported JSON encodings: `[.utf8, .utf16, .utf16BigEndian, .utf32, .utf32BigEndian]`
    private static func createString(from jsonData: Data) throws -> String {
        var string: String? = nil

        // check for each of the 5 supported encodings
        // FIXME: very inefficient; use optimized heuristics
        for encoding: String.Encoding in [.utf8, .utf16, .utf16BigEndian, .utf32LittleEndian, .utf32BigEndian] {
            //string = String(data: jsonData, encoding: encoding)
            //print("### DATA", jsonData.count, "IN ENCODING:", encoding, string != nil)
            //if jsonData == string?.data(using: encoding) {
            //    break
            //}

            do {
#if SKIP
                string = jsonData.rawValue.toString(encoding.rawValue)
                //print("### DATA", jsonData.count, " IN ENCODING:", encoding, string.count)
                break
#endif
            } catch {
                // invalid encoding
                //print("### DATA", jsonData.count, " NOT IN ENCODING:", encoding, error)

            }
        }

        guard let string = string else {
            throw CannotConvertString()
        }
        return string
    }

    // MARK: Conversion of JSONObject/JSONArray to Any

    public static func jsonObject(with jsonData: Data, options: ReadingOptions) throws -> Any {
        let string = try createString(from: jsonData)

        // org.json expects that you will know which type of JSON container is being parsed, but `jsonObject` permits either object or array values, so we try both
        do {
            let arr = try JSONArrayAny(json: string)
            return convertToAny(fromJSONArray: arr) as Any
        } catch {
            let obj = try JSONObjectAny(json: string)
            return convertToAny(fromJSONObject: obj) as Any
        }
    }

    private static func convertToAny(fromJSONObject obj: JSONObjectAny) -> Any? {
        var result: [String: Any] = [:]
        for key in obj.keys() {
            if obj.isNull(key: key) {
                result[key] = nil
            } else if let value = obj.get(key: key) {
                result[key] = convertToAny(fromJSONValue: value)
            }
        }
        let resultValue: [String: Any]? = result
        return resultValue
    }

    private static func convertToAny(fromJSONArray arr: JSONArrayAny) -> Any? {
        var result: [Any?] = []
        for index in 0..<arr.count {
            result.append(convertToAny(fromJSONValue: arr.get(index)))
        }
        return result
    }


    private static func convertToAny(fromJSONValue value: Any) -> Any? {
#if SKIP
        if value === PlatformJSONNull {
            return nil
        }
#else
        if value is NSNull {
            return nil
        }
#endif
        if let number = (value as? NSNumber) {
            return number.doubleValue
        } else if let obj = (value as? PlatformJSONObject) {
            return convertToAny(fromJSONObject: JSONObjectAny(obj))
        } else if let array = (value as? PlatformJSONArray) {
            #if !SKIP
            return Array(array.map(convertToAny(fromJSONValue:)))
            #else
            var array = Array<Any?>()
            for element in array.iterator() {
                let value = convertToAny(fromJSONValue: element as Any)
                array.append(value)
            }
            return array
            #endif
        } else {
            return value
        }
    }
}

extension PlatformJSONSerialization {
    /// Create a JSON instance from to given String.
    public static func json(from jsonString: any StringProtocol) throws -> JSON {
        // org.json expects that you will know which type of JSON container is being parsed, but `jsonObject` permits either object or array values, so we try both
        #if SKIP
        let trimmedText = jsonString.trimStart()
        #else
        let trimmedText = jsonString.trimmingCharacters(in: .whitespacesAndNewlines)
        #endif

        #if SKIP
        let startsWithCurlyBrace = trimmedText.startsWith("{")
        let startsWithSquareBrace = trimmedText.startsWith("[")
        #else
        let startsWithCurlyBrace = trimmedText.hasPrefix("{")
        let startsWithSquareBrace = trimmedText.hasPrefix("[")
        #endif

        if startsWithCurlyBrace {
            let obj = try JSONObjectAny(json: jsonString.description)
            return convertToJSON(fromJSONObject: obj)
        } else if startsWithSquareBrace {
            let arr = try JSONArrayAny(json: jsonString.description)
            return convertToJSON(fromJSONArray: arr)
        } else {
            // neither array nor object, so
            // parse as an Array, then return the initial instance
            let arr = try JSONArrayAny(json: "[" + jsonString + "]")
            return convertToJSON(fromJSONArray: arr).array![0]
        }
    }

    private static func convertToJSON(fromJSONObject obj: JSONObjectAny) -> JSON {
        var result: JSONObject = [:]
        for key in obj.keys() {
            if obj.isNull(key: key) {
                result[key] = JSON.null
            } else if let value = obj.get(key: key) {
                result[key] = convertToJSON(fromJSONValue: value)
            }
        }
        return JSON.obj(result)
    }

    private static func convertToJSON(fromJSONArray arr: JSONArrayAny) -> JSON {
        var result: JSONArray = []
        for index in 0..<arr.count {
            result.append(convertToJSON(fromJSONValue: arr.get(index)))
        }
        return JSON.array(result)
    }


    private static func convertToJSON(fromJSONValue value: Any) -> JSON {
        #if SKIP
        if value === PlatformJSONNull {
            return JSON.null
        }
        #else
        if value is NSNull {
            return JSON.null
        }
        #endif
        if let number = (value as? NSNumber) {
            #if !SKIP
            // when parsing into Any instances, JSONSerialization treats booleans as NSNumbers with a value of 1, so we need to check for this and correctly return a boolean
            let booleanType = String(cString: NSNumber(value: true).objCType)
            if String(cString: number.objCType) == booleanType {
                return JSON.bool(number.boolValue)
            }
            #endif
            return JSON.number(number.doubleValue)
        } else if let boolean = (value as? Bool) {
            return JSON.bool(boolean)
        } else if let str = (value as? JSONString) {
            return JSON.string(str)
        } else if let obj = (value as? PlatformJSONObject) {
            return convertToJSON(fromJSONObject: JSONObjectAny(obj))
        } else if let array = (value as? PlatformJSONArray) {
            return convertToJSON(fromJSONArray: JSONArrayAny(array))
        } else {
            return JSON.null
        }
    }
}

// MARK: Conversion of Any to a JSON String

extension PlatformJSONSerialization {

    public static func data(withJSONObject obj: Any, options opt: WritingOptions) throws -> Data {
        // "Unresolved reference. None of the following candidates is applicable because of receiver type mismatch"
        // SKIP REPLACE: val pretty = opt.rawValue == WritingOptions.prettyPrinted.rawValue
        let pretty = opt.contains(WritingOptions.prettyPrinted)

        let string = convertToJsonString(obj, indent: pretty ? 0 : nil)
        return string.utf8Data
    }

    private static func convertToJsonString(_ value: Any?, indent: Int?) -> String {
        let nextIndent = indent == nil ? nil : indent! + 2

        switch value {
        case let value as any PlatformNumeric:
            return "\(value)"
        case let value as Bool:
            return value ? "true" : "false"
        case let value as String:
            return serializeString(value)
        case let value as AnyArrayType:
            return toJsonString(array: value, indent: nextIndent)
        case let value as AnyMapType:
            return toJsonString(dictionary: value, indent: nextIndent)
        default:
            return "null"
        }
    }

    private static func toJsonString(dictionary: AnyMapType, indent: Int?) -> String {
        let nextIndent = indent == nil ? nil : indent! + 2

        var reifiedMap: [String: Any?] = [:]
        let keyList = dictionary.keys.map({ "\($0)" })
        let valueList = Array(dictionary.values)
        for (index, key) in keyList.enumerated() {
            let value: Any? = valueList[index]
            reifiedMap[key] = value
        }

        var json = "{"
        if indent != nil { json += "\n" }

        let sortedKeys = keyList.sorted()
        let keyCount = sortedKeys.count
        for (index, key) in sortedKeys.enumerated() {
            let value = reifiedMap[key] as Any?
            let jsonString = convertToJsonString(value, indent: nextIndent)
            if let indent = indent {
                for _ in 1...indent {
                    json += " "
                }
            }
            json += "\""
            json += key
            json += "\""
            if indent != nil { json += " " }
            json += ":"
            if indent != nil { json += " " }
            json += jsonString

            if index < keyCount - 1 {
                json += ","
            }
            if indent != nil { json += "\n" }
        }

        json += "}"
        return json
    }

    private static func toJsonString(array: AnyArrayType, indent: Int?) -> String {
        let nextIndent = indent == nil ? nil : indent! + 2
        var json = "["
        if indent != nil { json += "\n" }
        for (index, value) in array.enumerated() {
            if let indent = indent {
                for _ in 1...indent {
                    json += " "
                }
            }
            json += convertToJsonString(value, indent: nextIndent)
            if index < array.count - 1 {
                json += ","
            }
            if indent != nil { json += "\n" }
        }
        json += "]"
        return json
    }

    private static func serializeString(_ str: String, withoutEscapingSlashes: Bool = false) -> String {
        var json = ""
        json += "\""

        for c in str {
            switch "\(c)" {
            case "\"":
                json += "\\\""
            case "\\":
                json += "\\\\"
            case "/":
                if withoutEscapingSlashes {
                    json += "/"
                } else {
                    json += "\\/"
                }
            //case 0x8:
            //    json += "\\b"
            //case 0xc:
            //    json += "\\f"
            case "\n":
                json += "\\n"
            case "\r":
                json += "\\r"
            case "\t":
                json += "\\t"
            // case 0x0...0xf:
            //     json += "\\u000\(String(cursor.pointee, radix: 16))"
            // case 0x10...0x1f:
            //     json += "\\u00\(String(cursor.pointee, radix: 16))"
            default:
                json += "\(c)"
            }
        }

        json += "\""
        return json
    }
}

/// A Swift JSON parsing API to match the `org.json.JSONObject` Java API.
final class JSONObjectAny {
    /// The internal JSON object, which will be a `org.json.JSONObject` in Kotlin and an `NSMutableDictionary` in Swift
    var json: PlatformJSONObject

    init(_ json: PlatformJSONObject = PlatformJSONObject()) {
        self.json = json
    }

    /// Parse the JSON using the system parser.
    init(json: String) throws {
        #if SKIP
        self.json = try PlatformJSONObject(json)
        #else
        self.json = (try JSONSerialization.jsonObject(with: Foundation.Data(json.utf8), options: [.mutableLeaves, .mutableContainers]) as? PlatformJSONObject) ?? [:]
        #endif
    }

    func keys() -> [String] {
        #if SKIP
        //Array(json.keys())
        //json.keys().map({ $0 })
        var keys = [String]()
        for key in json.keys() {
            keys.append(key)
        }
        return keys
        #else
        json.keys.map({ $0 })
        #endif
    }

    func get(key: String) -> Any? {
        #if SKIP
        json.get(key)
        #else
        json[key]
        #endif
    }

    func isNull(key: String) -> Bool {
        #if SKIP
        json.isNull(key)
        #else
        json[key] == nil
        #endif
    }
}

/// A Swift JSON parsing API to match the `org.json.JSONArray` Java API.
final class JSONArrayAny {
    /// The internal JSON object, which will be a `org.json.JSONArray` in Kotlin and an `NSMutableDictionary` in Swift
    var json: PlatformJSONArray

    init(_ json: PlatformJSONArray = PlatformJSONArray()) {
        self.json = json
    }

    /// Parse the JSON using the system parser.
    init(json: String) throws {
        #if SKIP
        self.json = try PlatformJSONArray(json)
        #else
        self.json = (try JSONSerialization.jsonObject(with: Foundation.Data(json.utf8), options: [.mutableLeaves, .mutableContainers]) as? PlatformJSONArray) ?? []
        #endif
    }

    var count: Int {
        #if SKIP
        return self.json.length()
        #else
        return self.json.count
        #endif
    }

    func get(_ index: Int) -> Any {
        #if SKIP
        return self.json[index]
        #else
        return self.json[index]
        #endif
    }
}

@available(macOS 11, iOS 14, watchOS 7, tvOS 14, *)
extension JSONObjectAny {
    /// Returns the JSON string representing this Object.
    func stringify(pretty: Bool = false, sorted: Bool = false) throws -> String {
        #if !SKIP
        return String(data: try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions([.withoutEscapingSlashes] + (pretty ? [.prettyPrinted] : []) + (sorted ? [.sortedKeys] : []))), encoding: .utf8) ?? ""
        #else
        // TODO: there isn't any simple way to output sorted keys, but we want to be able to support it for consistent output
        // one way to support this would be to make a recursive copy of the tree with clones of any JSONObject instances with their keys in sorted order; this would be expensive for large trees
        if pretty {
            return json.toString(2)
        } else {
            return json.toString()
        }
        #endif
    }
}
