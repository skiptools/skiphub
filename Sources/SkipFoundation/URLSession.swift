// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

//#if !SKIP
//import struct Foundation.XXX
//public typealias XXX = Foundation.XXX
//internal typealias PlatformXXX = Foundation.XXX
//#else
//public typealias XXX = SkipXXX
//public typealias PlatformXXX = java.util.XXX
//#endif
//
//
//// override the Kotlin type to be public while keeping the Swift version internal:
//// SKIP DECLARE: class SkipXXX: RawRepresentable<PlatformXXX>, MutableStruct
//internal struct SkipXXX : RawRepresentable, Hashable, CustomStringConvertible {
//    public var rawValue: PlatformXXX
//
//    public init(rawValue: PlatformXXX) {
//        self.rawValue = rawValue
//    }
//
//    public init(_ rawValue: PlatformXXX = PlatformXXX()) {
//        self.rawValue = rawValue
//    }
//
//    var description: String {
//        return rawValue.description
//    }
//}

internal class URLSession {
    class ResponseDisposition {
    }
}
