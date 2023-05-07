// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

// THIS TRANSPILATION IS NOT USED
//
// This file only exists to provide symbols for implemented API to the transpiler.
//

#if SKIP

// References to "String.Index" are convert to "StringIndex" which is an integer in Kotlin
public typealias StringIndex = Int
public typealias Substring = String

public struct String: RandomAccessCollection {
    public typealias Element = Character

    public init() {
        fatalError()
    }

    public init(_ string: String) {
        fatalError()
    }

    public init(repeating: String, count: Int) {
        fatalError()
    }

    public func hasPrefix(_ prefix: String) -> Bool {
        fatalError()
    }

    public func hasSuffix(_ suffix: String) -> Bool {
        fatalError()
    }

    public func contains(_ string: String) -> Bool {
        fatalError()
    }

    // SKIP NOWARN
    public subscript(bounds: Range<Index>) -> String {
        fatalError()
    }
}

#endif
