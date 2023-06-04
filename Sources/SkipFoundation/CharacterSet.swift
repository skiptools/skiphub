// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP
@_implementationOnly import struct Foundation.CharacterSet
internal typealias PlatformCharacterSet = Foundation.CharacterSet
#else
internal typealias PlatformCharacterSet = skip.lib.Set<Character>
#endif

public struct CharacterSet : Hashable {
    internal var platformValue: PlatformCharacterSet

    internal init(platformValue: PlatformCharacterSet) {
        self.platformValue = platformValue
    }

    public init() {
        self.platformValue = PlatformCharacterSet()
    }

    public var description: String {
        return platformValue.description
    }
}
