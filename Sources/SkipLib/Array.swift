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

public struct Array<Element>: RandomAccessCollection, RangeReplaceableCollection, MutableCollection {
    public init() {
        fatalError()
    }

    public init<S: Sequence<Element>>(_ sequence: S) {
        fatalError()
    }
}

#endif
