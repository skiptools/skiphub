// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

// THIS TRANSPILATION IS NOT USED
//
// This file only exists to provide symbols for implemented API to the transpiler.
//

public struct Dictionary<Key, Value> {
    public init() {
        Swift.fatalError()
    }

    #if !SKIP // Skip does not support this Swift syntax [subscriptDecl]
    public subscript(key: Key?) -> Value? {
        get {
            Swift.fatalError()
        }
        set {
            Swift.fatalError()
        }
    }
    #endif

    public var keys: Array<Key> {
        Swift.fatalError()
    }

    public var values: Array<Value> {
        Swift.fatalError()
    }

    public var count: Int {
        Swift.fatalError()
    }
}
