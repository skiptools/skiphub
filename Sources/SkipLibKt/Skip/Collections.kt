// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
package skip.lib

interface IteratorProtocol<Element: Any> {
    fun next(): Element?
}

interface Sequence<Element: Any>: Iterable<Element> {
    fun makeIterator(): IteratorProtocol<Element>

    val underestimatedCount: Int
        get() = 0

    fun <T> withContiguousStorageIfAvailable(body: (Any) -> T): T? {
        return null
    }

    // Iterable.forEach does not need modification

    fun <ElementOfResult: Any> map(transform: (Element) -> ElementOfResult): Array<ElementOfResult> {
        return Array((this as Iterable<Element>).map(transform), nocopy = true)
    }

    fun <ElementOfResult: Any> compactMap(transform: (Element) -> ElementOfResult?): Array<ElementOfResult> {
        return Array(mapNotNull(transform), nocopy = true)
    }

    fun filter(isIncluded: (Element) -> Boolean): Array<Element> {
        return Array((this as Iterable<Element>).filter(isIncluded), nocopy = true)
    }

    fun first(where: (Element) -> Boolean): Element? {
        return firstOrNull(where)
    }

    // Generate for transpiled custom sequences:
//    override fun iterator(): Iterator<Element> {
//        val iter = makeIterator()
//        return object: Iterator<Element> {
//            var next = iter.next()
//
//            override fun hasNext(): Boolean {
//                return next != null
//            }
//
//            override fun next(): Element {
//                val ret = next
//                if (ret != null) {
//                    next = iter.next()
//                    return ret
//                } else {
//                    throw NoSuchElementException()
//                }
//            }
//        }
//    }
}

interface Collection<Element: Any>: Sequence<Element> {
    val count: Int
        get() = count()
}

interface MutableCollection<Element: Any>: Collection<Element> {

}

interface BidirectionalCollection<Element: Any>: Collection<Element> {
    fun last(where: (Element) -> Boolean): Element? {
        return lastOrNull(where)
    }
}

interface RandomAccessCollection<Element: Any>: BidirectionalCollection<Element> {

}

typealias Slice<Element> = Array<Element>

//~~~

// Forward Swift's `count` property Kotlin's `count()` function
val <T> Iterable<T>.count: Int
	get() = this.count()

// Forward Swift's `isEmpty` property Kotlin's `none()` function
val <T> Iterable<T>.isEmpty: Boolean
	get() = this.none()

// Forward Swift's `lazy` property Kotlin's `asSequence()` function
val <T> Iterable<T>.lazy: kotlin.sequences.Sequence<T>
    get() = this.asSequence()

// Forward Swift's `reduce()` function to Kotlin's `fold()` function
fun <T, R> Iterable<T>.reduce(initial: R, operation: (acc: R, T) -> R): R {
	return this.fold(initial, operation)
}
// Forward Swift's `reduce()` function to Kotlin's `fold()` function
fun <T, R> kotlin.sequences.Sequence<T>.reduce(initial: R, operation: (acc: R, T) -> R): R {
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
val <T: Any> Array<T>.last: T
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
