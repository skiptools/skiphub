// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
#if !SKIP
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
typealias NSNumber = java.lang.Number

struct NSNull {
}

fileprivate extension java.lang.Number {
    var doubleValue: Double { doubleValue() }
    var intValue: Int { intValue() }
    var longValue: Int64 { longValue() }
}

#endif


struct CannotConvertString: Error { }

// SKIP REPLACE: internal typealias AnyArrayType = skip.lib.Array<*>
typealias AnyArrayType = Array<Any>
// SKIP REPLACE: internal typealias AnyMapType = skip.lib.Dictionary<*, *>
typealias AnyMapType = [String: Any]

// SKIP DECLARE: public class PlatformJSONSerialization
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

    public static func jsonObject(with jsonData: Data, options: ReadingOptions) throws -> Any {
        // TODO: permit all 5 UTF encodings as per JSONSerialization behavior
        guard let string = String(data: jsonData, encoding: String.Encoding.utf8) else {
            throw CannotConvertString()
        }

        // org.json expects that you will know which type of JSON container is being parsed, but `jsonObject` permits either object or array values, so we try both
        do {
            let arr = try JSONArray(json: string)
            return convert(fromJSONArray: arr) as Any
        } catch {
            let obj = try JSONObject(json: string)
            return convert(fromJSONObject: obj) as Any
        }
    }

    public static func data(withJSONObject obj: Any, options opt: WritingOptions) throws -> Data {
        // "Unresolved reference. None of the following candidates is applicable because of receiver type mismatch"
        // SKIP REPLACE: val pretty = opt.rawValue == WritingOptions.prettyPrinted.rawValue
        let pretty = opt.contains(WritingOptions.prettyPrinted)

        let string = convertToJsonString(obj, indent: pretty ? 0 : nil)
        return Data(string.utf8)
    }

    private static func convert(fromJSONObject obj: JSONObject) -> Any? {
        var result: [String: Any] = [:]
        for key in obj.keys() {
            if obj.isNull(key: key) {
                result[key] = nil
            } else if let value = obj.get(key: key) {
                result[key] = convert(fromJSONValue: value)
            }
        }
        let resultValue: [String: Any]? = result
        return resultValue
    }

    private static func convert(fromJSONArray arr: JSONArray) -> Any? {
        var result: [Any?] = []
        for index in 0..<arr.count {
            result.append(convert(fromJSONValue: arr.get(index)))
        }
        return result
    }


    private static func convert(fromJSONValue value: Any) -> Any? {
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
            return convert(fromJSONObject: JSONObject(obj))
        } else if let array = (value as? PlatformJSONArray) {
            return Array(array.map(convert(fromJSONValue:)))
        } else {
            return value
        }
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
final class JSONObject {
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
        self.json = (try JSONSerialization.jsonObject(with: Data(json.utf8), options: [.mutableLeaves, .mutableContainers]) as? PlatformJSONObject) ?? [:]
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
final class JSONArray {
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
        self.json = (try JSONSerialization.jsonObject(with: Data(json.utf8), options: [.mutableLeaves, .mutableContainers]) as? PlatformJSONArray) ?? []
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
extension JSONObject {
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
