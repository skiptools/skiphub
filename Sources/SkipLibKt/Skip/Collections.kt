// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
package skip.lib

interface IteratorProtocol<Element> {
    fun next(): Element?
}

// A Kotlin iterator wrapped around an IteratorProtocol
class IteratorProtocolIterator<Element>(val iter: IteratorProtocol<Element>): Iterator<Element> {
    private var next = iter.next()

    override fun hasNext(): Boolean {
        return next != null
    }

    override fun next(): Element {
        val ret = next
        if (ret != null) {
            next = iter.next()
            return ret
        } else {
            throw NoSuchElementException()
        }
    }
}

interface Sequence<Element>: Iterable<Element> {
    fun makeIterator(): IteratorProtocol<Element>

    val underestimatedCount: Int
        get() = 0

    fun <T> withContiguousStorageIfAvailable(body: (Any) -> T): T? {
        return null
    }

    fun <RE> map(transform: (Element) -> RE): Array<RE> {
        return Array((this as Iterable<Element>).map(transform), nocopy = true)
    }

    fun filter(isIncluded: (Element) -> Boolean): Array<Element> {
        return Array((this as Iterable<Element>).filter(isIncluded), nocopy = true)
    }

    // Iterable.forEach does not need modification

    fun first(where: (Element) -> Boolean): Element? {
        return firstOrNull(where).sref()
    }

    // Warning: although 'initialResult' is not a labeled parameter in Swift, the transpiler inserts it
    // into our Kotlin call sites to differentiate between calls to the two reduce() functions. Do not change
    fun <R> reduce(initialResult: R, nextPartialResult: (R, Element) -> R): R {
        return fold(initialResult, nextPartialResult)
    }

    fun <R> reduce(unusedp: Nothing? = null, into: R, updateAccumulatingResult: (InOut<R>, Element) -> Unit): R {
        return fold(into) { result, element ->
            var accResult = result
            val inoutAccResult = InOut<R>({ accResult }, { accResult = it })
            updateAccumulatingResult(inoutAccResult, element)
            accResult
        }
    }

    fun <RE> flatMap(transform: (Element) -> Iterable<RE>): Array<RE> {
        return Array((this as Iterable<Element>).flatMap(transform), nocopy = true)
    }

    fun <RE> compactMap(transform: (Element) -> RE?): Array<RE> {
        return Array(mapNotNull(transform), nocopy = true)
    }

    // Add to transpiled custom sequences:
    // override fun iterator(): Iterator<Element> {
    //     return IteratorProtocolIterator(makeIterator())
    // }
}

interface Collection<Element>: Sequence<Element> {
    val count: Int
        get() = count()

    val isEmpty: Boolean
        get() = count == 0
}

interface BidirectionalCollection<Element>: Collection<Element> {
    fun last(where: (Element) -> Boolean): Element? {
        return lastOrNull(where).sref()
    }
}

interface RandomAccessCollection<Element>: BidirectionalCollection<Element> {

}

interface MutableCollection<Element>: Collection<Element> {

}

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

interface RandomNumberGenerator {
	fun next(): ULong
}
