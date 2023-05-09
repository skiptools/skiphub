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

public struct Dictionary<Key, Value>: Collection {
    // SKIP NOWARN
    public typealias Element = (key: Key, value: Value)

    public init() {
        fatalError()
    }

    @available(*, unavailable)
    public init(minimumCapacity: Int) {
        fatalError()
    }

    @available(*, unavailable)
    public init(uniqueKeysWithValues keysAndValues: any Sequence<(Key, Value)>) {
        fatalError()
    }

    @available(*, unavailable)
    public init(_ keysAndValues: any Sequence<(Key, Value)>, uniquingKeysWith combine: (Value, Value) throws -> Value) rethrows {
        fatalError()
    }

    @available(*, unavailable)
    public init(grouping values: any Sequence<Value>, by keyForValue: (Value) throws -> Key) rethrows {
        fatalError()
    }

    @available(*, unavailable)
    public func filter(_ isIncluded: ((Key, Value)) throws -> Bool) rethrows -> Dictionary<Key, Value> {
        fatalError()
    }

    // SKIP NOWARN
    public subscript(key: Key) -> Value? {
        get {
            fatalError()
        }
        set {
            fatalError()
        }
    }

    // SKIP NOWARN
    @available(*, unavailable)
    public subscript(key: Key, default defaultValue: /* @autoclosure () -> Value */ Value) -> Value {
        fatalError()
    }

    @available(*, unavailable)
    public func mapValues<T>(_ transform: (Value) throws -> T) rethrows -> Dictionary<Key, T> {
        fatalError()
    }

    @available(*, unavailable)
    public func compactMapValues<T>(_ transform: (Value) throws -> T?) rethrows -> Dictionary<Key, T> {
        fatalError()
    }

    @available(*, unavailable)
    public mutating func updateValue(_ value: Value, forKey key: Key) -> Value? {
        fatalError()
    }

    @available(*, unavailable)
    public mutating func merge(_ other: any Sequence<(Key, Value)>, uniquingKeysWith combine: (Value, Value) throws -> Value) rethrows {
        fatalError()
    }

    @available(*, unavailable)
    public mutating func merge(_ other: Dictionary<Key, Value>, uniquingKeysWith combine: (Value, Value) throws -> Value) rethrows {
        fatalError()
    }

    @available(*, unavailable)
    public func merging(_ other: any Sequence<(Key, Value)>, uniquingKeysWith combine: (Value, Value) throws -> Value) rethrows -> Dictionary<Key, Value> {
        fatalError()
    }

    @available(*, unavailable)
    public func merging(_ other: Dictionary<Key, Value>, uniquingKeysWith combine: (Value, Value) throws -> Value) rethrows -> Dictionary<Key, Value> {
        fatalError()
    }

    @available(*, unavailable)
    public mutating func removeValue(forKey key: Key) -> Value? {
        fatalError()
    }

    public var keys: any Collection<Key> {
        fatalError()
    }

    @available(*, unavailable)
    public var values: any Collection<Value> {
        fatalError()
    }

    @available(*, unavailable)
    public var capacity: Int {
        fatalError()
    }

    @available(*, unavailable)
    public mutating func reserveCapacity(_ minimumCapacity: Int) {
        fatalError()
    }
}

#endif
