// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP
import struct Foundation.CharacterSet
public typealias CharacterSet = Foundation.CharacterSet
internal typealias PlatformCharacterSet = Foundation.CharacterSet
#else
public typealias CharacterSet = SkipCharacterSet
public typealias PlatformCharacterSet = skip.lib.Set<Character>
#endif

// override the Kotlin type to be public while keeping the Swift version internal:
// SKIP DECLARE: class SkipCharacterSet: RawRepresentable<PlatformCharacterSet>, MutableStruct
internal struct SkipCharacterSet : RawRepresentable, Hashable {
    public var rawValue: PlatformCharacterSet

    public init(rawValue: PlatformCharacterSet) {
        self.rawValue = rawValue
    }

    public init(_ rawValue: PlatformCharacterSet = PlatformCharacterSet()) {
        self.rawValue = rawValue
    }

    var description: String {
        return rawValue.description
    }
}
