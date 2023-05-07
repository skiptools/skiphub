// Copyright 2023 Skip
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

public struct Dictionary<Key, Value> {
    public init() {
        fatalError()
    }

    // SKIP NOWARN
    public subscript(key: Key?) -> Value? {
        get {
            fatalError()
        }
        set {
            fatalError()
        }
    }

    public var keys: Array<Key> {
        fatalError()
    }

    public var values: Array<Value> {
        fatalError()
    }

    public var count: Int {
        fatalError()
    }
}

#endif
