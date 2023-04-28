// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
package skip.lib

interface OptionSet<T, R>: RawRepresentable<R> {
    val rawvaluelong: Long
    fun optionset(rawvaluelong: Long): T
}

fun <T: OptionSet<T, R>, R> T.contains(other: T): Boolean {
    return (rawvaluelong and other.rawvaluelong) == other.rawvaluelong
}
