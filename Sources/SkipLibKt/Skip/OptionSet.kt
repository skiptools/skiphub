// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
package skip.lib

interface OptionSet<T, R>: RawRepresentable<R> {
    val rawvaluelong: Long
    fun makeoptionset(rawvaluelong: Long): T
    fun assignoptionset(target: T)
}

fun <T: OptionSet<T, R>, R> T.contains(other: T): Boolean {
    return (rawvaluelong and other.rawvaluelong) == other.rawvaluelong
}

fun <T: OptionSet<T, R>, R> T.insert(other: T): Tuple2<Boolean, T> {
    if (contains(other)) {
        return Tuple2(false, other)
    }
    val target = makeoptionset(rawvaluelong or other.rawvaluelong)
    assignoptionset(target)
    return Tuple2(true, other)
}
