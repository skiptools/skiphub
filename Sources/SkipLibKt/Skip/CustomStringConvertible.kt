// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
package skip.lib

// This typealias is defined to satisfy references in Swift. All types have toString(). We cannot define this
// as a protocol because there is no way to make existing Kotlin types (e.g. kotlin.Int) conform to new protocols
typealias CustomStringConvertible = Any

// Handle builtin types by defaulting all description calls to toString(). For types that implement a custom
// description property, the transpiler synthesizes a toString() override to return their property value
val Any.description: String
    get() = toString()

interface CustomDebugStringConvertible {
    val debugDescription: String
}
