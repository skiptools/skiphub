// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP
/* @_implementationOnly */import struct Foundation.CharacterSet
public typealias PlatformCharacterSet = Foundation.CharacterSet
#else
public typealias PlatformCharacterSet = skip.lib.Set<Character>
#endif

public struct CharacterSet : RawRepresentable, Hashable {
    public var rawValue: PlatformCharacterSet

    public init(rawValue: PlatformCharacterSet) {
        self.rawValue = rawValue
    }

    public init(_ rawValue: PlatformCharacterSet = PlatformCharacterSet()) {
        self.rawValue = rawValue
    }

    public var description: String {
        return rawValue.description
    }
}
