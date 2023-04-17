// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
package skip.lib

import kotlin.reflect.*

// Convert the Swift `description` to Java's `toString()`
val Any.description: String
	get() = this.toString()

val Any.debugDescription: String
	get() = this.toString()

// Global functions:

fun fatalError(message: String = "fatalError"): Nothing = error(message)

fun type(of: Any): KClass<*> {
    return of::class
}

fun <T> swap(a: InOut<T>, b: InOut<T>) {
    val t = a.value
    a.value = b.value
    b.value = t
}

fun <T : Comparable<T>> min(a: T, b: T): T {
	return if (a <= b) a else b
}

fun <T : Comparable<T>> max(a: T, b: T): T {
	return if (a >= b) a else b
}
