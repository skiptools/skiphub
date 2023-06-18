// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

// SKIP SYMBOLFILE

#if SKIP

public struct String: RandomAccessCollection {
    public typealias Element = Character
    public typealias Index = Int

    public init() {
    }

    public init(_ string: String) {
    }

    public init(_ substring: Substring) {
    }

    public init(describing instance: Any?) {
    }

    public init(repeating: String, count: Int) {
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

    public subscript(bounds: Range<Index>) -> Substring {
        fatalError()
    }

    // Support in String although it is not yet supported in Collection
    public func split(separator: String, maxSplits: Int = Int.max) -> [String] {
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

    public subscript(bounds: Range<Index>) -> Substring {
        fatalError()
    }

    // Support in String although it is not yet supported in Collection
    public func split(separator: String, maxSplits: Int = Int.max) -> [String] {
        fatalError()
    }
}

public struct Character {
    public init(_ character: Character) {
    }
}

#endif
