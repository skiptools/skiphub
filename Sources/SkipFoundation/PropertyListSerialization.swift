// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
#if !SKIP
import class Foundation.PropertyListSerialization
public typealias PropertyListSerialization = Foundation.PropertyListSerialization
#else
public typealias PropertyListSerialization = SkipPropertyListSerialization
#endif

// SKIP DECLARE: open class SkipPropertyListSerialization
public class SkipPropertyListSerialization {
    public enum PropertyListFormat {
        case openStep
        case xml
        case binary
    }

    /// Creates and returns a property list from the specified data.
    ///
    /// NOTE: this currenly only supports the strings format ("key" = "value"). XML and binary plists are TODO.
    @available(macOS 13, iOS 16, watchOS 9, tvOS 16, *)
    public static func propertyList(from: Data, format: PropertyListFormat? = nil) throws -> Dictionary<String, String>? {
        var dict: Dictionary<String, String> = [:]
        let re = "\"(.*)\"[ ]*=[ ]*\"(.*)\";"
        //let re = #"(?<!\\)"(.*?)(?<!\\)"\s*=\s*"(.*?)(?<!\\)";"# // Swift Regex error: "lookbehind is not currently supported"

        let text = String(data: from, encoding: String.Encoding.utf8) ?? ""

        #if SKIP
        let exp: kotlin.text.Regex = re.toRegex()
        let matches = exp.findAll(text)
        for match in matches {
            if match.groupValues.size == 3,
               let key = match.groupValues[1],
               let value = match.groupValues[2] {
                dict[key.replacingOccurrences(of: "\\\\\\\"", with: "\"")] = value.replacingOccurrences(of: "\\\\\\\"", with: "\"")
            }
        }
        #else
        let exp = try Regex(re)

        for line in text.components(separatedBy: "\n") {
            let matches = line.matches(of: exp)
            for match in matches {
                if match.count == 3,
                   let key = match[1].substring,
                   let value = match[2].substring {
                    dict[key.replacingOccurrences(of: "\\\"", with: "\"")] = value.replacingOccurrences(of: "\\\"", with: "\"")
                }
            }
        }
        #endif
        return dict
    }
}
