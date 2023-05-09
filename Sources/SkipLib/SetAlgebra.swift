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

public protocol SetAlgebra<Element> {
    associatedtype Element
}

extension SetAlgebra {
    public func contains(_ element: Element) -> Bool {
        fatalError()
    }

    @available(*, unavailable)
    public func union(_ other: Self) -> Self {
        fatalError()
    }

    @available(*, unavailable)
    public func intersection(_ other: Self) -> Self {
        fatalError()
    }

    @available(*, unavailable)
    func symmetricDifference(_ other: Self) -> Self {
        fatalError()
    }

    public mutating func insert(_ newMember: Element) -> (inserted: Bool, memberAfterInsert: Element) {
        fatalError()
    }

    @available(*, unavailable)
    public mutating func remove(_ member: Element) -> Element? {
        fatalError()
    }

    @available(*, unavailable)
    public mutating func update(with newMember: Element) -> Element? {
        fatalError()
    }

    @available(*, unavailable)
    public mutating func formUnion(_ other: Self) {
        fatalError()
    }

    @available(*, unavailable)
    public mutating func formIntersection(_ other: Self) {
        fatalError()
    }

    @available(*, unavailable)
    public mutating func formSymmetricDifference(_ other: Self) {
        fatalError()
    }

    @available(*, unavailable)
    public func subtracting(_ other: Self) -> Self {
        fatalError()
    }

    @available(*, unavailable)
    public func isSubset(of other: Self) -> Bool {
        fatalError()
    }

    @available(*, unavailable)
    public func isDisjoint(with other: Self) -> Bool {
        fatalError()
    }

    @available(*, unavailable)
    public func isSuperset(of other: Self) -> Bool {
        fatalError()
    }

    @available(*, unavailable)
    public var isEmpty: Bool {
        fatalError()
    }

    @available(*, unavailable)
    public mutating func subtract(_ other: Self) {
        fatalError()
    }
}

#endif
