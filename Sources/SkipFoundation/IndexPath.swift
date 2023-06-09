// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP
@_implementationOnly import struct Foundation.IndexPath
internal typealias PlatformIndexPath = Foundation.IndexPath
#else
public typealias PlatformIndexPath = skip.lib.Array<Int>
#endif

public typealias PlatformIndexPathElement = Int

/// A list of indexes that together represent the path to a specific location in a tree of nested arrays.
public struct IndexPath : Hashable, CustomStringConvertible {
    //public typealias Element = Int // "Kotlin does not support typealias declarations within functions and types. Consider moving this to a top level declaration"

    internal var platformValue: PlatformIndexPath

    internal init(platformValue: PlatformIndexPath) {
        self.platformValue = platformValue
    }

//    public init(indexes: Array<PlatformIndexPathElement>) {
//        self.platformValue = PlatformIndexPath(indexes: indexes)
//    }

    public init(index: PlatformIndexPathElement) {
        self.platformValue = [index]
    }

    public var description: String {
        return platformValue.description
    }

//    public typealias Index = Array<Int>.Index
//    public typealias Indices = DefaultIndices<IndexPath>
//    public init<ElementSequence>(indexes: ElementSequence) where ElementSequence : Sequence, ElementSequence.Element == Int
//    public init(arrayLiteral indexes: IndexPath.Element...)
//    public init(indexes: [IndexPath.Element])
//    public init(index: IndexPath.Element)
//    public func dropLast() -> IndexPath
//    public mutating func append(_ other: IndexPath)
//    public mutating func append(_ other: IndexPath.Element)
//    public mutating func append(_ other: [IndexPath.Element])
//    public func appending(_ other: IndexPath.Element) -> IndexPath
//    public func appending(_ other: IndexPath) -> IndexPath
//    public func appending(_ other: [IndexPath.Element]) -> IndexPath
//    public subscript(index: IndexPath.Index) -> IndexPath.Element
//    public subscript(range: Range<IndexPath.Index>) -> IndexPath
//    public func makeIterator() -> IndexingIterator<IndexPath>
//    public var count: Int { get }
//    public var startIndex: IndexPath.Index { get }
//    public var endIndex: IndexPath.Index { get }
//    public func index(before i: IndexPath.Index) -> IndexPath.Index
//    public func index(after i: IndexPath.Index) -> IndexPath.Index
//    public func compare(_ other: IndexPath) -> ComparisonResult
//    public func hash(into hasher: inout Hasher)
//    public static func == (lhs: IndexPath, rhs: IndexPath) -> Bool
//    public static func + (lhs: IndexPath, rhs: IndexPath) -> IndexPath
//    public static func += (lhs: inout IndexPath, rhs: IndexPath)
//    public static func < (lhs: IndexPath, rhs: IndexPath) -> Bool
//    public static func <= (lhs: IndexPath, rhs: IndexPath) -> Bool
//    public static func > (lhs: IndexPath, rhs: IndexPath) -> Bool
//    public static func >= (lhs: IndexPath, rhs: IndexPath) -> Bool
//    public typealias ArrayLiteralElement = IndexPath.Element
//    public typealias Iterator = IndexingIterator<IndexPath>
//    public typealias SubSequence = IndexPath
//    public var hashValue: Int { get }
}
