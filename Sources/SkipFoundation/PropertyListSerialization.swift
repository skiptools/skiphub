// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
#if SKIP
public class PropertyListSerialization {
    private static var plistRegex = getPlistRegex().toRegex()

    private static func getPlistRegex() -> String {
        // SKIP REPLACE: return """(?<!\\)"(.*?)(?<!\\)"\s*=\s*"(.*?)(?<!\\)";"""
        return null
    }

    /// Creates and returns a property list from the specified data.
    ///
    /// NOTE: this currenly only supports the strings format ("key" = "value"). XML and binary plists are TODO.
    public static func propertyList(from: Data, format: String?) -> Map<String, String>? {
        // SKIP REPLACE: return plistRegex.findAll(String(from.rawValue)).map { it.groupValues[1].replace("\\\\\\\"", "\"") to it.groupValues[2].replace("\\\\\\\"", "\"") }.toMap()
        return nil
    }
}
#endif
