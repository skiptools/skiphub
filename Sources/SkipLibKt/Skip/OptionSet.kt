// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
package skip.lib

interface OptionSet<T, R>: RawRepresentable<R>, SetAlgebra<T> where T: OptionSet<T, R> {
    val rawvaluelong: Long
    fun makeoptionset(rawvaluelong: Long): T
    fun assignoptionset(target: T)

    override fun contains(other: T): Boolean {
        return (rawvaluelong and other.rawvaluelong) == other.rawvaluelong
    }

    override fun insert(other: T): Tuple2<Boolean, T> {
        if (contains(other)) {
            return Tuple2(false, other)
        }
        val target = makeoptionset(rawvaluelong or other.rawvaluelong)
        assignoptionset(target)
        return Tuple2(true, other)
    }
}
