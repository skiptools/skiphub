// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

// THIS FILE IS NOT TRANSPILED
//
// This file only exists to provide symbols for implemented API to the transpiler.
//

public protocol Hashable: Equatable {
    var hashValue: Int { get }
}

typealias AnyHashable = Hashable

public struct Hasher {
    public init() {
        Swift.fatalError()
    }

    public mutating func combine(_ value: Any?) {
        Swift.fatalError()
    }

    public func finalize() -> Int {
        Swift.fatalError()
    }

    static func combine(result: Int, value: Any?) -> Int {
        Swift.fatalError()
    }
}
