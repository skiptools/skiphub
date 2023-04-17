// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

// THIS TRANSPILATION IS NOT USED
//
// This file only exists to provide symbols for implemented API to the transpiler.
//

public func fatalError(message: String = "fatalError") -> Never {
    Swift.fatalError()
}

public func type(of: Any) -> Any.Type {
    Swift.fatalError()
}

public func swap<T>(_ a: inout T, _ b: inout T) {
    Swift.fatalError()
}

public func min<T>(_ x: T, _ y: T) -> T where T : Comparable {
    Swift.fatalError()
}

public func max<T>(_ x: T, _ y: T) -> T where T : Comparable {
    Swift.fatalError()
}
