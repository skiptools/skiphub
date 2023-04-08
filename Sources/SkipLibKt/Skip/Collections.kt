// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
package skip.lib

/// Forward Swift's `reduce` to Kotlin's `fold`
fun <T, R> Iterable<T>.reduce(initial: R, operation: (acc: R, T) -> R): R {
	return this.fold(initial, operation)
}

/// Forward Swift's `reduce` to Kotlin's `fold`
fun <T, R> Sequence<T>.reduce(initial: R, operation: (acc: R, T) -> R): R {
	return this.fold(initial, operation)
}

val <T> Iterable<T>.lazy: Sequence<T>
	get() = this.asSequence()

val <T> Collection<T>.count: Int
	get() = this.count()

val <T> Collection<T>.isEmpty: Boolean
	get() = this.isEmpty()

//fun <T> Collection<T>.firstIndex(of: T): Int? {
//	for (i in this.indices) {
//		if (this[i] == element) {
//			return i
//		}
//	}
//	return null
//}
