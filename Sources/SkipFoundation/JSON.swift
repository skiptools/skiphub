// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
#if !SKIP
public typealias PlatformJSONObject = Any
#else
public typealias PlatformJSONObject = org.json.JSONObject
#endif

/// A Swift JSON parsing API to match the `org.json.JSONObject` Java API.
final class JSONObject {
    /// The internal JSON object, which will be a `org.json.JSONObject` in Kotlin and an `NSMutableDictionary` in Swift
    var json: PlatformJSONObject

    /// Parse the JSON using the system parser.
    init(_ json: String) throws {
        #if SKIP
        self.json = try org.json.JSONObject(json)
        #else
        self.json = try JSONSerialization.jsonObject(with: Data(json.utf8), options: [.mutableLeaves, .mutableContainers])
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
        // one way to support this would be to make a recurisve copy of the tree with clones of any JSONObject instances with their keys in sorted order; this would be expensive for large trees
        if pretty {
            return json.toString(2)
        } else {
            return json.toString()
        }
        #endif
    }
}
