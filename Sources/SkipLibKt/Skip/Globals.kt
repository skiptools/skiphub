// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
package skip.lib

// Convert the Swift `description` to Java's `toString()`
val Any.description: String
	get() = this.toString()

val Any.debugDescription: String
	get() = this.toString()

// Global functions:

// `Swift.fatalError` function calls `Kotlin.error`
fun fatalError(message: String = "fatalError"): Nothing = error(message)

fun <T : Comparable<T>> min(a: T, b: T): T {
	return if (a <= b) a else b
}

fun <T : Comparable<T>> max(a: T, b: T): T {
	return if (a >= b) a else b
}
