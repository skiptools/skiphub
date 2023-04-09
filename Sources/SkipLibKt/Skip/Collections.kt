// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
package skip.lib

// Forward Swift's `count` property Kotlin's `count()` function
val <T> Iterable<T>.count: Int
	get() = this.count()

// Forward Swift's `isEmpty` property Kotlin's `none()` function
val <T> Iterable<T>.isEmpty: Boolean
	get() = this.none()

// Forward Swift's `lazy` property Kotlin's `asSequence()` function
val <T> Iterable<T>.lazy: Sequence<T>
	get() = this.asSequence()

// Forward Swift's `reduce()` function to Kotlin's `fold()` function
fun <T, R> Iterable<T>.reduce(initial: R, operation: (acc: R, T) -> R): R {
	return this.fold(initial, operation)
}
// Forward Swift's `reduce()` function to Kotlin's `fold()` function
fun <T, R> Sequence<T>.reduce(initial: R, operation: (acc: R, T) -> R): R {
	return this.fold(initial, operation)
}

// Forward Swift's `first` property to Kotlin's `first()` function
val <T> Iterable<T>.first: T
	get() = this.first()

fun <T> Iterable<T>.first(where: (acc: T) -> Boolean): T? {
	for (element in this) {
		if (where(element) == true) {
			return element
		}
	}
	return null
}

// Forward Swift's `last` property to Kotlin's `last()` function
val <T> Array<T>.last: T
	get() = this.last()

fun <T> Iterable<T>.last(where: (acc: T) -> Boolean): T? {
	for (element in this.reversed()) {
		if (where(element) == true) {
			return element
		}
	}
	return null
}

fun <T> Iterable<T>.contains(where: (acc: T) -> Boolean): Boolean {
	for (element in this) {
		if (where(element) == true) {
			return true
		}
	}
	return false
}

fun <T : Comparable<T>> Iterable<T>.sorted(): Array<T> {
	return Array(this.sortedWith(compareBy { it }))
}
