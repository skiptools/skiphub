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

extension Sequence {
    public var underestimatedCount: Int {
        Swift.fatalError()
    }

    public func withContiguousStorageIfAvailable<R>(_ body: (Any) throws -> R) rethrows -> R? {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public func shuffled<T: RandomNumberGenerator>(using generator: inout T) -> [Element] {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public func shuffled() -> [Element] {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public var lazy: any Sequence<Element> {
        Swift.fatalError()
    }

    public func map<RE>(_ transform: (Element) throws -> RE) rethrows -> [RE] {
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

    @available(*, unavailable)
    public func split(maxSplits: Int = Int.max, omittingEmptySubsequences: Bool = true, whereSeparator isSeparator: (Element) throws -> Bool) rethrows -> [Element] /* ArraySlice<Element> */ {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public func suffix(_ maxLength: Int) -> [Element] {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public func dropFirst(_ k: Int = 1) -> [Element] /* DropFirstSequence<Self> */ {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public func dropLast(_ k: Int = 1) -> [Element] {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public func drop(while predicate: (Element) throws -> Bool) rethrows -> [Element] /* DropWhileSequence<Self> */ {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public func prefix(_ maxLength: Int) -> [Element] /* PrefixSequence<Self> */ {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public func prefix(while predicate: (Element) throws -> Bool) rethrows -> [Element] {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public func enumerated() -> [(Int, Element)] /* EnumeratedSequence<Self> */ {
        Swift.fatalError()
    }
    
    @available(*, unavailable)
    public func min(by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows -> Element? {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public func max(by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows -> Element? {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public func starts(with possiblePrefix: Any, by areEquivalent: (Element, Element) throws -> Bool) rethrows -> Bool {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public func elementsEqual(_ other: Any, by areEquivalent: (Element, Element) throws -> Bool) rethrows -> Bool {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public func lexicographicallyPrecedes(_ other: Any, by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows -> Bool {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public func contains(where predicate: (Element) throws -> Bool) rethrows -> Bool {
        Swift.fatalError()
    }

    public func reduce<R>(_ initialResult: R, _ nextPartialResult: (_ partialResult: R, Element) throws -> R) rethrows -> R {
        Swift.fatalError()
    }

    public func reduce<R>(into initialResult: R, _ updateAccumulatingResult: (_ partialResult: inout R, Element) throws -> Void) rethrows -> R {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public func allSatisfy(_ predicate: (Element) throws -> Bool) rethrows -> Bool {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public func reversed() -> [Element] {
        Swift.fatalError()
    }

    public func flatMap<RE>(_ transform: (Element) throws -> any Sequence<RE>) rethrows -> [RE] {
        Swift.fatalError()
    }

    public func compactMap<RE>(_ transform: (Element) throws -> RE?) rethrows -> [RE] {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public func sorted(by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows -> [Element] {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public func joined() -> any Sequence<Element> /* FlattenSequence<Self> */ {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public func joined(separator: any Sequence<Element>) -> any Sequence<Element> /* JoinedSequence<Self> */ {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public func split(separator: Element, maxSplits: Int = Int.max, omittingEmptySubsequences: Bool = true) -> [Element] /* ArraySlice<Element> */ {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public func starts(with possiblePrefix: Any) -> Bool {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public func elementsEqual(_ other: Any) -> Bool {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public func contains(_ element: Element) -> Bool {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public func min() -> Element? {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public func max() -> Element? {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public func lexicographicallyPrecedes(_ other: Any) -> Bool {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public func sorted() -> [Element] {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public func joined(separator: String = "") -> String {
        Swift.fatalError()
    }
}

public protocol Collection<Element> : Sequence {
    associatedtype Element
    // SKIP NOWARN
    typealias Index = Int
}

extension Collection {

    // NOTE: All index functions used type Self.Index rather than the Int we use here

    @available(*, unavailable)
    public var startIndex: Int {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public var endIndex: Int {
        Swift.fatalError()
    }

    // SKIP NOWARN
    public subscript(position: Int) -> Element {
        Swift.fatalError()
    }

    // SKIP NOWARN
    @available(*, unavailable)
    public subscript(bounds: Range<Int>) -> [Element] /* Collection<Element> */ {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public var indices: [Int] /* Collection<Int> */ {
        Swift.fatalError()
    }

    public var isEmpty: Bool {
        Swift.fatalError()
    }

    public var count: Int {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public func index(_ i: Int, offsetBy distance: Int) -> Int {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public func index(_ i: Int, offsetBy distance: Int, limitedBy limit: Int) -> Int? {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public func distance(from start: Int, to end: Int) -> Int {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public func index(after i: Int) -> Int {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public func formIndex(after i: inout Int) {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public func formIndex(_ i: inout Int, offsetBy distance: Int) {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public func formIndex(_ i: inout Int, offsetBy distance: Int, limitedBy limit: Int) -> Bool {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public func randomElement() -> Element? {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public func randomElement(using generator: inout any RandomNumberGenerator) -> Element? {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public mutating func popFirst() -> Element? {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public var first: Element? {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public func prefix(upTo end: Int) -> [Element] /* Collection<Element> */ {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public func suffix(from start: Int) -> [Element] /* Collection<Element> */ {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public func prefix(through end: Int) -> [Element] /* Collection<Element> */ {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public mutating func removeFirst() -> Element {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public mutating func removeFirst(_ k: Int) {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public func firstIndex(of element: Element) -> Int? {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public func firstIndex(where predicate: (Element) throws -> Bool) rethrows -> Int? {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public mutating func shuffle() {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public mutating func sort() {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public mutating func partition(by belongsInSecondPartition: (Element) throws -> Bool) rethrows -> Int {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public mutating func shuffle<T: RandomNumberGenerator>(using generator: inout T) {
        Swift.fatalError()
    }

    // SKIP NOWARN
    @available(*, unavailable)
    public subscript(bounds: any RangeExpression<Int>) -> [Element] /* Collection<Element> */ {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public func trimmingPrefix(while predicate: (Element) throws -> Bool) rethrows -> [Element] /* Collection<Element> */ {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public mutating func trimPrefix(while predicate: (Element) throws -> Bool) throws {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public func firstRange(of other: Any) -> Range<Int>? {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public func ranges(of other: Any) -> [Range<Int>] {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public func split(separator: any Collection<Element>, maxSplits: Int = Int.max, omittingEmptySubsequences: Bool = true) -> [[Element]] /* Collection<Collection<Element>> */ {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public func trimmingPrefix(_ prefix: any Sequence<Element>) -> [Element] /* Collection<Element> */ {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public mutating func trimPrefix(_ prefix: any Sequence<Element>) {
        Swift.fatalError()
    }
}

public protocol BidirectionalCollection : Collection {
}

extension BidirectionalCollection {

    // NOTE: All index functions used type Self.Index rather than the Int we use here

    @available(*, unavailable)
    public func index(before i: Int) -> Int {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public func formIndex(before i: inout Int) {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public var last: Element? {
        Swift.fatalError()
    }

    public func last(where predicate: (Element) throws -> Bool) rethrows -> Element? {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public func lastIndex(of element: Element) -> Int? {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public func lastIndex(where predicate: (Element) throws -> Bool) rethrows -> Int? {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public func difference(from other: Any) -> CollectionDifference<Element> {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public func difference(from other: any Collection<Element>, by areEquivalent: (Element, Element) -> Bool) -> CollectionDifference<Element> {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public mutating func popLast() -> Element? {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public mutating func removeLast(_ k: Int = 1) {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public func contains(_ regex: some RegexComponent) -> Bool {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public func firstRange(of regex: some RegexComponent) -> Range<Int>? {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public func ranges(of regex: some RegexComponent) -> [Range<Int>] {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public func trimmingPrefix(_ regex: some RegexComponent) -> [Element] {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public func firstMatch(of r: some RegexComponent) -> Any? {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public func matches(of r: some RegexComponent) -> [Any] {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public func split(separator: some RegexComponent, maxSplits: Int = Int.max, omittingEmptySubsequences: Bool = true) -> [[Element]] {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public func starts(with regex: some RegexComponent) -> Bool {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public func wholeMatch(of r: some RegexComponent) -> Any {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public func prefixMatch(of r: some RegexComponent) -> Any {
        Swift.fatalError()
    }
}

public protocol RandomAccessCollection : BidirectionalCollection {
}

public protocol RangeReplaceableCollection : Collection {
}

extension RangeReplaceableCollection {
    @available(*, unavailable)
    public mutating func replaceSubrange(_ subrange: any RangeExpression<Int>, with newElements: any Collection<Element>) {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public mutating func reserveCapacity(_ n: Int) {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public mutating func append(_ newElement: Element) {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public mutating func append(contentsOf newElements: any Sequence<Element>) {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public mutating func insert(_ newElement: Element, at i: Int) {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public mutating func insert(contentsOf newElements: any Sequence<Element>, at i: Int) {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public mutating func remove(at i: Int) -> Element {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public mutating func removeSubrange(_ bounds: any RangeExpression<Int>) {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public mutating func removeAll(keepingCapacity keepCapacity: Bool) {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public mutating func removeAll(where shouldBeRemoved: (Element) throws -> Bool) rethrows {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public func applying(_ difference: CollectionDifference<Element>) -> Self? {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public func replacing(_ other: any Collection<Element>, with replacement: any Collection<Element>, subrange: Range<Int>, maxReplacements: Int = Int.max) -> Self {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public func replacing(_ other: any Collection<Element>, with replacement: any Collection<Element>, maxReplacements: Int = Int.max) -> Self {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public mutating func replace(_ other: any Collection<Element>, with replacement: any Collection<Element>, maxReplacements: Int = Int.max) {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public func replacing(_ regex: some RegexComponent, with replacement: any Collection<Character>, maxReplacements: Int = Int.max) -> Self {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public func replacing(_ regex: some RegexComponent, with replacement: any Collection<Character>, subrange: Range<Int>, maxReplacements: Int = Int.max) -> Self {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public mutating func replace(_ regex: some RegexComponent, with replacement: any Collection<Character>, maxReplacements: Int = Int.max) -> Self {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public func replacing(_ regex: some RegexComponent, maxReplacements: Int = Int.max, with replacement: (Any) throws -> any Collection<Character>) rethrows {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public func replacing(_ regex: some RegexComponent, subrange: Range<Int>, maxReplacements: Int = Int.max, with replacement: (Any) throws -> any Collection<Character>) rethrows -> Self {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public mutating func replace(_ regex: some RegexComponent, maxReplacements: Int = Int.max, with replacement: (Any) throws -> any Collection<Character>) rethrows {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public mutating func trimPrefix(_ regex: some RegexComponent) {
        Swift.fatalError()
    }
}

public protocol MutableCollection : Collection {
}

extension MutableCollection {
    // SKIP NOWARN
    subscript(position: Int) -> Element {
        get {
            Swift.fatalError()
        }
        set {
            Swift.fatalError()
        }
    }

    // SKIP NOWARN
    @available(*, unavailable)
    subscript(bounds: Range<Int>) -> [Element] /* Collection<Element> */ {
        get {
            Swift.fatalError()
        }
        set {
            Swift.fatalError()
        }
    }

    // SKIP NOWARN
    @available(*, unavailable)
    subscript(bounds: any RangeExpression<Int>) -> [Element] /* Collection<Element> */ {
        get {
            Swift.fatalError()
        }
        set {
            Swift.fatalError()
        }
    }

    @available(*, unavailable)
    mutating func swapAt(_ i: Int, _ j: Int) {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public mutating func reverse() {
        Swift.fatalError()
    }
}

public protocol RangeExpression<Bound> {
    associatedtype Bound
}

@available(*, unavailable)
public struct Range<Bound>: RangeExpression /* CustomStringConvertible, CustomDebugStringConvertible, Hashable, Codable */ where Bound : Comparable {
    public let lowerBound: Bound
    public let upperBound: Bound

    @available(*, unavailable)
    public init(uncheckedBounds bounds: (lower: Bound, upper: Bound)) {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public func contains(_ element: Bound) -> Bool {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public var isEmpty: Bool {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public func clamped(to limits: Range<Bound>) -> Range<Bound> {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public func overlaps(_ other: Range<Bound>) -> Bool {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public func overlaps(_ other: ClosedRange<Bound>) -> Bool {
        Swift.fatalError()
    }

    @available(*, unavailable)
    public func relative(to collection: any Collection) -> Range<Bound> {
        Swift.fatalError()
    }
}

// MARK: - Functions

@available(*, unavailable)
public func repeatElement<T>(_ element: T, count n: Int) -> [T] /* Repeated<T> */ {
    Swift.fatalError()
}

@available(*, unavailable)
public func sequence<T>(first: T, next: @escaping (T) -> T?) -> [T] /* UnfoldFirstSequence<T> */ {
    Swift.fatalError()
}

@available(*, unavailable)
public func sequence<T, State>(state: State, next: @escaping (inout State) -> T?) -> [T] /* UnfoldSequence<T, State> */ {
    Swift.fatalError()
}

@available(*, unavailable)
public func stride<T>(from start: T, to end: T, by stride: T) -> any Sequence<T> {
    Swift.fatalError()
}

@available(*, unavailable)
public func stride<T>(from start: T, through end: T, by stride: T) -> any Sequence<T> {
    Swift.fatalError()
}

// MARK: - Helpers

@available(*, unavailable)
public struct ClosedRange<Bound> {
}

@available(*, unavailable)
public struct CollectionOfOne<Element> {
}

@available(*, unavailable)
public struct CollectionDifference<ChangeElement> {
}

@available(*, unavailable)
public struct DefaultIndices<Elements> {
}

@available(*, unavailable)
public struct DropFirstSequence<Base> {
}

@available(*, unavailable)
public struct DropWhileSequence<Base> {
}

@available(*, unavailable)
public struct EmptyCollection<Element> {
}

@available(*, unavailable)
public struct FlattenSequence<Element> {
}

@available(*, unavailable)
public struct IndexingIterator<Elements> {
}

@available(*, unavailable)
public struct IteratorSequence<Base> {
}

@available(*, unavailable)
public struct JoinedSequence<Element> {
}

@available(*, unavailable)
public struct KeyValuePairs<Key, Value> {
}

@available(*, unavailable)
public struct PartialRangeFrom<Bound>: RangeExpression where Bound : Comparable {
    public let lowerBound: Bound
}

@available(*, unavailable)
public struct PartialRangeThrough<Bound>: RangeExpression where Bound : Comparable {
    public let upperBound: Bound
}

@available(*, unavailable)
public struct PartialRangeUpTo<Bound>: RangeExpression where Bound : Comparable {
    public let upperBound: Bound
}

@available(*, unavailable)
public struct PrefixSequence<Base> {
}

@available(*, unavailable)
public struct Repeated<Element> {
}

@available(*, unavailable)
public protocol Strideable {
}

@available(*, unavailable)
public struct StrideThrough<Element> {
}

@available(*, unavailable)
public struct StrideThroughIterator<Element> {
}

@available(*, unavailable)
public struct StrideTo<Element> {
}

@available(*, unavailable)
public struct StrideToIterator<Element> {
}

@available(*, unavailable)
public struct UnfoldSequence<Element, State> {
}

// References to "String.Index" are convert to "StringIndex" which is an integer in Kotlin
public typealias StringIndex = Int
