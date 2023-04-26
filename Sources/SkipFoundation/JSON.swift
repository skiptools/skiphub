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

#if SKIP
public typealias JSONSerialization = PlatformJSONSerialization
private typealias NSNumber = java.lang.Number

fileprivate extension java.lang.Number {
    var doubleValue: Double { doubleValue() }
    var intValue: Int { intValue() }
    var longValue: Int64 { longValue() }
}
#endif

struct CannotConvertString: Error { }

// SKIP DECLARE: public class PlatformJSONSerialization
internal class PlatformJSONSerialization {
    public enum ReadingOptions : Int {
        case mutableContainers
        case mutableLeaves
        case fragmentsAllowed
        case json5Allowed
        case topLevelDictionaryAssumed
        case allowFragments
    }

    public static func jsonObject(with jsonData: Data, options: [PlatformJSONSerialization.ReadingOptions] = []) throws -> Any? {
        guard let string = String(data: jsonData, encoding: String.Encoding.utf8) else {
            throw CannotConvertString()
        }
        let obj = try JSONObject(json: string)
        return convert(obj: obj)
    }

    private static func convert(obj: JSONObject) -> Any? {
        var result: [String: Any] = [:]
        for key in obj.keys() {
            if obj.isNull(key: key) {
                result[key] = nil
            } else if let value = obj.get(key: key) {
                result[key] = convert(value: value)
            }
        }
        let resultValue: [String: Any]? = result
        return resultValue
    }

    private static func convert(value: Any) -> Any? {
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
            return convert(obj: JSONObject(obj))
        } else if let array = (value as? PlatformJSONArray) {
            return Array(array.map(convert(value:)))
        } else {
            return value
        }
    }
}

/// A Swift JSON parsing API to match the `org.json.JSONObject` Java API.
final class JSONObject {
    /// The internal JSON object, which will be a `org.json.JSONObject` in Kotlin and an `NSMutableDictionary` in Swift
    var json: PlatformJSONObject

    init(_ json: PlatformJSONObject) {
        self.json = json
    }

    init() {
        #if SKIP
        self.json = org.json.JSONObject()
        #else
        self.json = [String: Any]()
        #endif
    }

    /// Parse the JSON using the system parser.
    init(json: String) throws {
        #if SKIP
        self.json = try org.json.JSONObject(json)
        #else
        self.json = (try JSONSerialization.jsonObject(with: Data(json.utf8), options: [.mutableLeaves, .mutableContainers]) as? [String: Any]) ?? [:]
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
