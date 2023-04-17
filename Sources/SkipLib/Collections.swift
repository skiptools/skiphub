// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

// THIS TRANSPILATION IS NOT USED
//
// This file only exists to provide symbols for implemented API to the transpiler.
//

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

    public func map<ElementOfResult>(_ transform: (Element) throws -> ElementOfResult) rethrows -> [ElementOfResult] {
        Swift.fatalError()
    }

    public func filter(_ isIncluded: (Element) throws -> Bool) rethrows -> [Element] {
        Swift.fatalError()
    }

    public func forEach(_ body: (Element) throws -> Void) rethrows {
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

    public func contains(where predicate: ((Element) throws -> Bool) = { _ in false }) rethrows -> Bool {
        Swift.fatalError()
    }

    public func allSatisfy(_ predicate: (Element) throws -> Bool) rethrows -> Bool {
        Swift.fatalError()
    }

    public func reduce<Result>(_ initialResult: Result, _ nextPartialResult: (_ partialResult: Result, Element) throws -> Result) rethrows -> Result {
        Swift.fatalError()
    }

    public func reduce<Result>(into initialResult: Result, _ updateAccumulatingResult: (_ partialResult: inout Result, Element) throws -> ()) rethrows -> Result {
        Swift.fatalError()
    }

    public func reversed() -> [Element] {
        Swift.fatalError()
    }

    public func flatMap<ElementOfResult>(_ transform: (Element) throws -> any Sequence<ElementOfResult>) rethrows -> [ElementOfResult] {
        Swift.fatalError()
    }

    public func compactMap<ElementOfResult>(_ transform: (Element) throws -> ElementOfResult?) rethrows -> [ElementOfResult] {
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

    // UNSUPPORTED:
    // public func randomElement<T: RandomNumberGenerator>(using generator: inout T) -> Element?
    // public mutating func partition(by belongsInSecondPartition: (Element) throws -> Bool) rethrows -> Index
    // public mutating func partition(by belongsInSecondPartition: (Element) throws -> Bool) rethrows -> Index
    // public func shuffled<T: RandomNumberGenerator>(using generator: inout T) -> [Element] {
    // public mutating func shuffle<T: RandomNumberGenerator>(using generator: inout T)
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

// UNSUPPORTED:
// public struct DropFirstSequence<Base: Sequence>
// public struct PrefixSequence<Base: Sequence>
// public struct DropWhileSequence<Base: Sequence>
// public struct IteratorSequence<Base: IteratorProtocol>
// public struct EnumeratedSequence<Base: Sequence>
// public struct IndexingIterator<Elements: Collection>
