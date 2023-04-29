// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP
import struct Foundation.IndexSet
public typealias IndexSet = Foundation.IndexSet
public typealias PlatformIndexSet = Foundation.IndexSet
#else
public typealias IndexSet = SkipIndexSet
public typealias PlatformIndexSet = skip.lib.Set<Int>
#endif


public struct SkipIndexSet : RawRepresentable, Hashable {
    public let rawValue: PlatformIndexSet

    public init(rawValue: PlatformIndexSet) {
        self.rawValue = rawValue
    }

    public init(_ rawValue: PlatformIndexSet = PlatformIndexSet()) {
        self.rawValue = rawValue
    }

//    public typealias Element = Int
//    public init(integersIn range: Range<IndexSet.Element>)
//    public init<R>(integersIn range: R) where R : RangeExpression, R.Bound == Int
//    public init(integer: IndexSet.Element)
//    public init()
//    public var count: Int { get }
//    public func makeIterator() -> IndexingIterator<IndexSet>
//    public var rangeView: IndexSet.RangeView { get }
//    public func rangeView(of range: Range<IndexSet.Element>) -> IndexSet.RangeView
//    public func rangeView<R>(of range: R) -> IndexSet.RangeView where R : RangeExpression, R.Bound == Int
//    public var startIndex: IndexSet.Index { get }
//    public var endIndex: IndexSet.Index { get }
//    public subscript(index: IndexSet.Index) -> IndexSet.Element { get }
//    public subscript(bounds: Range<IndexSet.Index>) -> Slice<IndexSet> { get }
//    public func integerGreaterThan(_ integer: IndexSet.Element) -> IndexSet.Element?
//    public func integerGreaterThanOrEqualTo(_ integer: IndexSet.Element) -> IndexSet.Element?
//    public func integerLessThanOrEqualTo(_ integer: IndexSet.Element) -> IndexSet.Element?
//    public func indexRange(in range: Range<IndexSet.Element>) -> Range<IndexSet.Index>
//    public func indexRange<R>(in range: R) -> Range<IndexSet.Index> where R : RangeExpression, R.Bound == Int
//    public func count<R>(in range: R) -> Int where R : RangeExpression, R.Bound == Int
//    public func contains(_ integer: IndexSet.Element) -> Bool
//    public func contains(integersIn range: Range<IndexSet.Element>) -> Bool
//    public func contains<R>(integersIn range: R) -> Bool where R : RangeExpression, R.Bound == Int
//    public func contains(integersIn indexSet: IndexSet) -> Bool
//    public func intersects(integersIn range: Range<IndexSet.Element>) -> Bool
//    public func intersects<R>(integersIn range: R) -> Bool where R : RangeExpression, R.Bound == Int
//    public func index(after i: IndexSet.Index) -> IndexSet.Index
//    public func formIndex(after i: inout IndexSet.Index)
//    public func index(before i: IndexSet.Index) -> IndexSet.Index
//    public func formIndex(before i: inout IndexSet.Index)
//    public mutating func formUnion(_ other: IndexSet)
//    public func union(_ other: IndexSet) -> IndexSet
//    public func symmetricDifference(_ other: IndexSet) -> IndexSet
//    public mutating func formSymmetricDifference(_ other: IndexSet)
//    public func intersection(_ other: IndexSet) -> IndexSet
//    public mutating func formIntersection(_ other: IndexSet)
//    public mutating func insert(_ integer: IndexSet.Element) -> (inserted: Bool, memberAfterInsert: IndexSet.Element)
//    public mutating func update(with integer: IndexSet.Element) -> IndexSet.Element?
//    public mutating func remove(_ integer: IndexSet.Element) -> IndexSet.Element?
//    public mutating func removeAll()
//    public mutating func insert(integersIn range: Range<IndexSet.Element>)
//    public mutating func insert<R>(integersIn range: R) where R : RangeExpression, R.Bound == Int
//    public mutating func remove(integersIn range: Range<IndexSet.Element>)
//    public mutating func remove(integersIn range: ClosedRange<IndexSet.Element>)
//    public var isEmpty: Bool { get }
//    public func filteredIndexSet(in range: Range<IndexSet.Element>, includeInteger: (IndexSet.Element) throws -> Bool) rethrows -> IndexSet
//    public func filteredIndexSet(in range: ClosedRange<IndexSet.Element>, includeInteger: (IndexSet.Element) throws -> Bool) rethrows -> IndexSet
//    public func filteredIndexSet(includeInteger: (IndexSet.Element) throws -> Bool) rethrows -> IndexSet
//    public mutating func shift(startingAt integer: IndexSet.Element, by delta: Int)
//    public typealias ArrayLiteralElement = IndexSet.Element
//    public typealias Indices = DefaultIndices<IndexSet>
//    public typealias Iterator = IndexingIterator<IndexSet>
//    public typealias SubSequence = Slice<IndexSet>
//    public var hashValue: Int { get }
}

#if !SKIP
extension SkipIndexSet {
}
#else
extension SkipIndexSet {
}
#endif
