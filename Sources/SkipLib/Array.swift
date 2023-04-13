// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

// THIS FILE IS NOT TRANSPILED
//
// This file only exists to provide symbols for implemented API to the transpiler.
//

public struct Array<Element> {
    public init() {
        Swift.fatalError()
    }

    #if !SKIP // Skip does not support this Swift syntax [subscriptDecl]
    public subscript(index: Int) -> Element {
        get {
            Swift.fatalError()
        }
        set {
            Swift.fatalError()
        }
    }
    #endif

    public mutating func append(_ element: Element) {
        Swift.fatalError()
    }

    public var count: Int {
        Swift.fatalError()
    }
}

