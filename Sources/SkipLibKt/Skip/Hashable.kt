// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
package skip.lib

interface Hashable {
    fun hash(into: InOut<Hasher>)
    val hashValue: Int
        get() {
            var hasher = Hasher()
            this.hash(InOut<Hasher>({ hasher }, { hasher = it }))
            return hasher.finalize()
        }
}

class Hasher {
    private var hashCode = 1

    fun combine(value: Any?) {
        hashCode = hashCode * 17 + (value?.hashCode() ?: 0)
    }

    fun finalize(): Int {
        return hashCode
    }
}
