// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

// THIS TRANSPILATION IS NOT USED
//
// This file only exists to provide symbols for implemented API to the transpiler.
//

public protocol OptionSet: RawRepresentable {
}

extension OptionSet {
    public func contains(_ member: Self) -> Bool {
        fatalError()
    }

    public mutating func insert(_ member: Self) {
        fatalError()
    }
}
