// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

// THIS FILE IS NOT TRANSPILED
//
// This file only exists to provide symbols for implemented API to the transpiler.
//

#if !SKIP
public struct Dictionary<K, V> {
    public init() {
        fatalError()
    }

    public subscript(key: K?) -> V? {
        get {
            fatalError()
        }
        set {
            fatalError()
        }
    }

    public var keys: Array<K> {
        fatalError()
    }

    public var values: Array<V> {
        fatalError()
    }

    public var count: Int {
        fatalError()
    }
}
#endif
