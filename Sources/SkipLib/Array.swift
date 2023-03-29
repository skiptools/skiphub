// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

// THIS FILE IS NOT TRANSPILED
//
// This file only exists to provide symbols for implemented API to the transpiler.
//

public struct Array<T> {
    public init() {
        fatalError()
    }

    #if !SKIP // Skip does not support this Swift syntax [subscriptDecl]
    public subscript(index: Int) -> T {
        get {
            fatalError()
        }
        set {
            fatalError()
        }
    }
    #endif

    public mutating func append(_ element: T) {
        fatalError()
    }

    public var count: Int {
        fatalError()
    }
}

