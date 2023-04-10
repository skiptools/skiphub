// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
package skip.lib

interface Hashable: Equatable {
    val hashValue: Int
        get() = hashCode()

    // Note that while the transpiler uses user-defined `hash(into:)` functions, we do not include that function in
    // this interface. Doing so would require us to synthesize less efficient code in some cases than we can by taking
    // advantage of `hashCode()`. We're relying on `hash(into:)` not typically being invoked manually
}

typealias AnyHashable = Any

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
