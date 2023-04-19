// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

// THIS TRANSPILATION IS NOT USED
//
// This file only exists to provide symbols for implemented API to the transpiler.
//

// Support these lower-level Swift protocols to transpile code that may use them.
// We move the majority of the API into extensions, however, to allow ourselves to communicate
// e.g. default function parameter values to the type inference engine. We're also overly
// non-specific with some parameter types and overly specific with some return types to simplify
// type inference - we can rely on the Swift compiler to prevent any type mismatches

public protocol IteratorProtocol<E> {
    associatedtype E
    mutating func next() -> E?
}

public protocol Sequence<E> {
    associatedtype E
    func makeIterator() -> any IteratorProtocol<E>
}

public protocol Collection<E>: Sequence {
    associatedtype E
    // SKIP NOWARN
    typealias Index = Int
}

public protocol MutableCollection: Collection {
}

public protocol BidirectionalCollection: Collection {
}

public protocol RandomAccessCollection: BidirectionalCollection {
}

public typealias Slice = Array

extension Sequence {
    public var underestimatedCount: Int {
        Swift.fatalError()
    }

    public func withContiguousStorageIfAvailable<T>(_ body: (Any) throws -> T) rethrows -> T? {
        Swift.fatalError()
    }

    public func forEach(_ body: (E) throws -> Void) rethrows {
        Swift.fatalError()
    }

    public func map<RE>(_ transform: (E) throws -> RE) rethrows -> [RE] {
        Swift.fatalError()
    }

    public func compactMap<RE>(_ transform: (E) throws -> RE?) rethrows -> [RE] {
        Swift.fatalError()
    }

    public func flatMap<RE>(_ transform: (E) throws -> any Sequence<RE>) rethrows -> [RE] {
        Swift.fatalError()
    }

    public func reduce<R>(_ initialResult: R, _ nextPartialResult: (_ partialResult: R, E) throws -> R) rethrows -> R {
        Swift.fatalError()
    }

    public func reduce<R>(into initialResult: R, _ updateAccumulatingResult: (_ partialResult: inout R, E) throws -> ()) rethrows -> R {
        Swift.fatalError()
    }

    public func filter(_ isIncluded: (E) throws -> Bool) rethrows -> [E] {
        Swift.fatalError()
    }

    public func first(where predicate: (E) throws -> Bool) rethrows -> E? {
        Swift.fatalError()
    }

    public func split(separator: E, maxSplits: Int = Int.max, omittingEmptySubsequences: Bool = true, whereSeparator isSeparator: (E) throws -> Bool) rethrows -> [E] /* ArraySlice<E> */ {
        Swift.fatalError()
    }

    public func suffix(_ maxLength: Int) -> [E] {
        Swift.fatalError()
    }

    public func dropFirst(_ k: Int = 1) -> [E] /* DropFirstSequence<Self> */ {
        Swift.fatalError()
    }

    public func dropLast(_ k: Int = 1) -> [E] {
        Swift.fatalError()
    }

    public func drop(while predicate: (E) throws -> Bool) rethrows -> [E] /* DropWhileSequence<Self> */ {
        Swift.fatalError()
    }

    public func prefix(_ maxLength: Int) -> [E] /* PrefixSequence<Self> */ {
        Swift.fatalError()
    }

    public func prefix(while predicate: (E) throws -> Bool) rethrows -> [E] {
        Swift.fatalError()
    }

    public func enumerated() -> [(Int, E)] /* EnumeratedSequence<Self> */ {
        Swift.fatalError()
    }

    public func min(by areInIncreasingOrder: ((E, E) throws -> Bool) = { _, _ in false }) rethrows -> E? {
        Swift.fatalError()
    }

    public func max(by areInIncreasingOrder: ((E, E) throws -> Bool) = { _, _ in false }) rethrows -> E? {
        Swift.fatalError()
    }

    public func starts(with possiblePrefix: Any, by areEquivalent: ((E, E) throws -> Bool) = { _, _ in false }) rethrows -> Bool {
        Swift.fatalError()
    }

    public func elementsEqual(_ other: Any, by areEquivalent: ((E, E) throws -> Bool) = { _, _ in false }) rethrows -> Bool {
        Swift.fatalError()
    }

    public func lexicographicallyPrecedes(_ other: Any, by areInIncreasingOrder: ((E, E) throws -> Bool) = { _, _ in false}) rethrows -> Bool {
        Swift.fatalError()
    }

    public func contains(where predicate: ((E) throws -> Bool) = { _ in false }) rethrows -> Bool {
        Swift.fatalError()
    }

    public func contains(_ element: E) -> Bool {
        Swift.fatalError()
    }

    public func allSatisfy(_ predicate: (E) throws -> Bool) rethrows -> Bool {
        Swift.fatalError()
    }

    public func reversed() -> [E] {
        Swift.fatalError()
    }

    public func sorted() -> [E] {
        Swift.fatalError()
    }

    public func sorted(by areInIncreasingOrder: (E, E) throws -> Bool) rethrows -> [E] {
        Swift.fatalError()
    }
}

extension Collection {
    public var startIndex: Int {
        Swift.fatalError()
    }

    public var endIndex: Int {
        Swift.fatalError()
    }

    // SKIP NOWARN
    public subscript(position: Int) -> E {
        Swift.fatalError()
    }

    // SKIP NOWARN
    public subscript(bounds: Range<Int>) -> [E] /* Collection<Element> */ {
        Swift.fatalError()
    }

    public var indices: [Int] /* Collection<Int> */ {
        Swift.fatalError()
    }

    public var isEmpty: Bool {
        Swift.fatalError()
    }

    public var count: Int {
        Swift.fatalError()
    }

    public func index(_ i: Int, offsetBy distance: Int) -> Int {
        Swift.fatalError()
    }

    public func index(_ i: Int, offsetBy distance: Int, limitedBy limit: Int) -> Int? {
        Swift.fatalError()
    }

    public func distance(from start: Int, to end: Int) -> Int {
        Swift.fatalError()
    }

    public func index(after i: Int) -> Int {
        Swift.fatalError()
    }

    public func formIndex(after i: inout Int) {
        Swift.fatalError()
    }

    public func formIndex(_ i: inout Int, offsetBy distance: Int, limitedBy limit: Int) -> Bool {
        Swift.fatalError()
    }

    public func randomElement() -> E? {
        Swift.fatalError()
    }

    public mutating func popFirst() -> E? {
        Swift.fatalError()
    }

    public var first: E? {
        Swift.fatalError()
    }

    public func prefix(upTo end: Int) -> [E] /* Collection<Element> */ {
        Swift.fatalError()
    }

    public func suffix(from start: Int) -> [E] /* Collection<Element> */ {
        Swift.fatalError()
    }

    public func prefix(through end: Int) -> [E] /* Collection<Element> */ {
        Swift.fatalError()
    }

    public mutating func removeFirst() -> E {
        Swift.fatalError()
    }

    public mutating func removeFirst(_ k: Int) {
        Swift.fatalError()
    }

    public func firstIndex(of element: E) -> Int? {
        Swift.fatalError()
    }

    public func firstIndex(where predicate: (E) throws -> Bool) rethrows -> Int? {
        Swift.fatalError()
    }

    public func shuffled() -> [E] {
        Swift.fatalError()
    }

    public mutating func shuffle() {
        Swift.fatalError()
    }

    public mutating func sort() {
        Swift.fatalError()
    }

    // UNSUPPORTED:
    // public func randomElement<T: RandomNumberGenerator>(using generator: inout T) -> Element?
    // public mutating func partition(by belongsInSecondPartition: (Element) throws -> Bool) rethrows -> Index
    // public func shuffled<T: RandomNumberGenerator>(using generator: inout T) -> [Element] {
    // public mutating func shuffle<T: RandomNumberGenerator>(using generator: inout T)
}

extension MutableCollection {
    // SKIP NOWARN
    public subscript(position: Int) -> E {
        get {
            Swift.fatalError()
        }
        set {
            Swift.fatalError()
        }
    }

    // SKIP NOWARN
    public subscript(bounds: Range<Int>) -> [E] /* Collection<Element> */ {
        get {
            Swift.fatalError()
        }
        set {
            Swift.fatalError()
        }
    }

    public mutating func swapAt(_ i: Index, _ j: Index) {
        Swift.fatalError()
    }
}

extension BidirectionalCollection {
    public var last: E? {
        Swift.fatalError()
    }

    public func last(where predicate: (E) throws -> Bool) rethrows -> E? {
        Swift.fatalError()
    }

    public func lastIndex(where predicate: (E) throws -> Bool) rethrows -> Int? {
        Swift.fatalError()
    }

    public func lastIndex(of element: E) -> Int? {
        Swift.fatalError()
    }
}

// UNSUPPORTED:
// public struct DropFirstSequence<Base: Sequence>
// public struct PrefixSequence<Base: Sequence>
// public struct DropWhileSequence<Base: Sequence>
// public struct IteratorSequence<Base: IteratorProtocol>
// public struct EnumeratedSequence<Base: Sequence>
// public struct IndexingIterator<Elements: Collection>
