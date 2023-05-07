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

/// Unconditionally prints a given message and stops execution.
public func fatalError(message: String = "fatalError") -> Never {
    Swift.fatalError()
}

/// Performs a traditional C-style assert with an optional message.
public func assert(_ condition: Bool, _ message: String? = nil) {
    fatalError()
}

/// Checks a necessary condition for making forward progress.
public func precondition(_ condition: Bool, _ message: String? = nil) {
    fatalError()
}

/// Indicates that an internal sanity check failed.
@inlinable public func assertionFailure(_ message: String? = nil) {
    fatalError()
}

/// Indicates that a precondition was violated.
public func preconditionFailure(_ message: String? = nil) -> Never {
    fatalError()
}

public func type(of: Any) -> Any.Type {
    fatalError()
}

public func swap<T>(_ a: inout T, _ b: inout T) {
    fatalError()
}

public func min<T>(_ x: T, _ y: T) -> T where T : Comparable {
    fatalError()
}

public func max<T>(_ x: T, _ y: T) -> T where T : Comparable {
    fatalError()
}

public func round(_ x: Double) -> Double {
    fatalError()
}

public func round(_ x: Float) -> Float {
    fatalError()
}

#endif
