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

public struct String: RandomAccessCollection {
    public typealias Element = Character
    // SKIP NOWARN
    public typealias Index = Int

    public init() {
        fatalError()
    }

    public init(_ string: String) {
        fatalError()
    }

    public init(_ substring: Substring) {
        fatalError()
    }

    public init(describing instance: Any?) {
        fatalError()
    }

    public init(repeating: String, count: Int) {
        fatalError()
    }

    public func lowercased() -> String {
        fatalError()
    }

    public func uppercased() -> String {
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

    public func dropFirst(_ k: Int = 1) -> String {
        fatalError()
    }

    public func dropLast(_ k: Int = 1) -> String {
        fatalError()
    }

    // SKIP NOWARN
    public subscript(bounds: Range<Index>) -> Substring {
        fatalError()
    }
}

public struct Substring: RandomAccessCollection {
    public typealias Element = Character

    public func lowercased() -> String {
        fatalError()
    }
    
    public func uppercased() -> String {
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

    public func dropFirst(_ k: Int = 1) -> String {
        fatalError()
    }

    public func dropLast(_ k: Int = 1) -> String {
        fatalError()
    }

    public func filter(_ isIncluded: (Character) throws -> Bool) rethrows -> String {
        fatalError()
    }

    // SKIP NOWARN
    public subscript(bounds: Range<Index>) -> Substring {
        fatalError()
    }
}

public struct Character {
    public init(_ character: Character) {
        fatalError()
    }
}

#endif
