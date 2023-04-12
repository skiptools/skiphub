// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
package skip.lib

// This typealias is defined to satisfy references in Swift. All types have hashCode(). We cannot define this
// as a protocol because there is no way to make existing Kotlin types (e.g. kotlin.Int) conform to new protocols
typealias Hashable = Any
typealias AnyHashable = Hashable

val Any.hashValue: Int
    get() = hashCode()

class Hasher {
    private var result = 1

    fun combine(value: Any?) {
        result = Companion.combine(result, value)
    }

    fun finalize(): Int {
        return result
    }

    companion object {
        fun combine(result: Int, value: Any?): Int {
            return result * 17 + (value?.hashCode() ?: 0)
        }
    }
}
