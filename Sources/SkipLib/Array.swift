// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

// THIS TRANSPILATION IS NOT USED
//
// This file only exists to provide symbols for implemented API to the transpiler.
//

public struct Array<Element>: MutableCollection, RandomAccessCollection {
    public init() {
        Swift.fatalError()
    }

    public init<S: Sequence<Element>>(_ sequence: S) {
        Swift.fatalError()
    }

    public mutating func append(_ element: Element) {
        Swift.fatalError()
    }

    // Sequence

    public func makeIterator() -> any IteratorProtocol<Element> {
        Swift.fatalError()
    }
}

