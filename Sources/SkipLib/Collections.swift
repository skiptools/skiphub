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

public protocol IteratorProtocol<Element> {
    associatedtype Element
    mutating func next() -> Element?
}

public protocol Sequence<Element> {
    associatedtype Element
    func makeIterator() -> any IteratorProtocol<Element>
}

public protocol Collection<Element>: Sequence {
    associatedtype Element
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

    public func forEach(_ body: (Element) throws -> Void) rethrows {
        Swift.fatalError()
    }

    public func map<RE>(_ transform: (Element) throws -> RE) rethrows -> [RE] {
        Swift.fatalError()
    }

    public func compactMap<RE>(_ transform: (Element) throws -> RE?) rethrows -> [RE] {
        Swift.fatalError()
    }

    public func flatMap<RE>(_ transform: (Element) throws -> any Sequence<RE>) rethrows -> [RE] {
        Swift.fatalError()
    }

    public func reduce<R>(_ initialResult: R, _ nextPartialResult: (_ partialResult: R, Element) throws -> R) rethrows -> R {
        Swift.fatalError()
    }

    public func reduce<R>(into initialResult: R, _ updateAccumulatingResult: (_ partialResult: inout R, Element) throws -> Void) rethrows -> R {
        Swift.fatalError()
    }

    public func filter(_ isIncluded: (Element) throws -> Bool) rethrows -> [Element] {
        Swift.fatalError()
    }

    public func contains(where predicate: ((Element) throws -> Bool) = { _ in false }) rethrows -> Bool {
        Swift.fatalError()
    }

    public func contains(_ element: Element) -> Bool {
        Swift.fatalError()
    }

    public func first(where predicate: (Element) throws -> Bool) rethrows -> Element? {
        Swift.fatalError()
    }

    public func split(separator: Element, maxSplits: Int = Int.max, omittingEmptySubsequences: Bool = true, whereSeparator isSeparator: (Element) throws -> Bool) rethrows -> [Element] /* ArraySlice<Element> */ {
        Swift.fatalError()
    }

    public func suffix(_ maxLength: Int) -> [Element] {
        Swift.fatalError()
    }

    public func dropFirst(_ k: Int = 1) -> [Element] /* DropFirstSequence<Self> */ {
        Swift.fatalError()
    }

    public func dropLast(_ k: Int = 1) -> [Element] {
        Swift.fatalError()
    }

    public func drop(while predicate: (Element) throws -> Bool) rethrows -> [Element] /* DropWhileSequence<Self> */ {
        Swift.fatalError()
    }

    public func prefix(_ maxLength: Int) -> [Element] /* PrefixSequence<Self> */ {
        Swift.fatalError()
    }

    public func prefix(while predicate: (Element) throws -> Bool) rethrows -> [Element] {
        Swift.fatalError()
    }

    public func enumerated() -> [(Int, Element)] /* EnumeratedSequence<Self> */ {
        Swift.fatalError()
    }

    public func min(by areInIncreasingOrder: ((Element, Element) throws -> Bool) = { _, _ in false }) rethrows -> Element? {
        Swift.fatalError()
    }

    public func max(by areInIncreasingOrder: ((Element, Element) throws -> Bool) = { _, _ in false }) rethrows -> Element? {
        Swift.fatalError()
    }

    public func starts(with possiblePrefix: Any, by areEquivalent: ((Element, Element) throws -> Bool) = { _, _ in false }) rethrows -> Bool {
        Swift.fatalError()
    }

    public func elementsEqual(_ other: Any, by areEquivalent: ((Element, Element) throws -> Bool) = { _, _ in false }) rethrows -> Bool {
        Swift.fatalError()
    }

    public func lexicographicallyPrecedes(_ other: Any, by areInIncreasingOrder: ((Element, Element) throws -> Bool) = { _, _ in false}) rethrows -> Bool {
        Swift.fatalError()
    }

    public func allSatisfy(_ predicate: (Element) throws -> Bool) rethrows -> Bool {
        Swift.fatalError()
    }

    public func reversed() -> [Element] {
        Swift.fatalError()
    }

    public func sorted() -> [Element] {
        Swift.fatalError()
    }

    public func sorted(by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows -> [Element] {
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
    public subscript(position: Int) -> Element {
        Swift.fatalError()
    }

    // SKIP NOWARN
    public subscript(bounds: Range<Int>) -> [Element] /* Collection<Element> */ {
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

    public func randomElement() -> Element? {
        Swift.fatalError()
    }

    public mutating func popFirst() -> Element? {
        Swift.fatalError()
    }

    public var first: Element? {
        Swift.fatalError()
    }

    public func prefix(upTo end: Int) -> [Element] /* Collection<Element> */ {
        Swift.fatalError()
    }

    public func suffix(from start: Int) -> [Element] /* Collection<Element> */ {
        Swift.fatalError()
    }

    public func prefix(through end: Int) -> [Element] /* Collection<Element> */ {
        Swift.fatalError()
    }

    public mutating func removeFirst() -> Element {
        Swift.fatalError()
    }

    public mutating func removeFirst(_ k: Int) {
        Swift.fatalError()
    }

    public func firstIndex(of element: Element) -> Int? {
        Swift.fatalError()
    }

    public func firstIndex(where predicate: (Element) throws -> Bool) rethrows -> Int? {
        Swift.fatalError()
    }

    public func shuffled() -> [Element] {
        Swift.fatalError()
    }

    public mutating func shuffle() {
        Swift.fatalError()
    }

    public mutating func sort() {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public func randomElement<T: RandomNumberGenerator>(using generator: inout T) -> Element? {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public mutating func partition(by belongsInSecondPartition: (Element) throws -> Bool) rethrows -> Int {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public func shuffled<T: RandomNumberGenerator>(using generator: inout T) -> [Element] {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public mutating func shuffle<T: RandomNumberGenerator>(using generator: inout T) {
        Swift.fatalError()
    }
}

extension MutableCollection {
    // SKIP NOWARN
    public subscript(position: Int) -> Element {
        get {
            Swift.fatalError()
        }
        set {
            Swift.fatalError()
        }
    }

    // SKIP NOWARN
    public subscript(bounds: Range<Int>) -> [Element] /* Collection<Element> */ {
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
    public var last: Element? {
        Swift.fatalError()
    }

    public func last(where predicate: (Element) throws -> Bool) rethrows -> Element? {
        Swift.fatalError()
    }

    public func lastIndex(where predicate: (Element) throws -> Bool) rethrows -> Int? {
        Swift.fatalError()
    }

    public func lastIndex(of element: Element) -> Int? {
        Swift.fatalError()
    }
}

//~~~ TODO: There are many more types in Swift.Collection to process
// Move this
public protocol RandomNumberGenerator {
    mutating func next() -> UInt64
}

@available(*, unavailable)
public struct DropWhileSequence<Base: Sequence> {
    // SKIP NOWARN
    public typealias Element = Base.Element
    public func makeIterator() -> any IteratorProtocol<Element> {
        Swift.fatalError()
    }
}

@available(*, unavailable)
public struct EnumeratedSequence<Base: Sequence> {
    // SKIP NOWARN
    public typealias Element = Base.Element
    public func makeIterator() -> any IteratorProtocol<Element> {
        Swift.fatalError()
    }
}

@available(*, unavailable)
public struct IndexingIterator<Elements: Collection>: Sequence {
    // SKIP NOWARN
    public typealias Element = Elements.Element
    public func makeIterator() -> any IteratorProtocol<Element> {
        Swift.fatalError()
    }
}

@available(*, unavailable)
public struct IteratorSequence<Base: IteratorProtocol>: Sequence {
    // SKIP NOWARN
    public typealias Element = Base.Element
    public func makeIterator() -> any IteratorProtocol<Element> {
        Swift.fatalError()
    }
}

@available(*, unavailable)
public struct PrefixSequence<Base: Sequence> {
    // SKIP NOWARN
    public typealias Element = Base.Element
    public func makeIterator() -> any IteratorProtocol<Element> {
        Swift.fatalError()
    }
}

// References to "String.Index" are convert to "StringIndex" which is an integer in Kotlin
public typealias StringIndex = Int
