// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
package skip.lib

interface IteratorProtocol<E> {
    fun next(): E?
}

interface Sequence<E>: Iterable<E> {
    fun makeIterator(): IteratorProtocol<E>

    val underestimatedCount: Int
        get() = 0

    fun <T> withContiguousStorageIfAvailable(body: (Any) -> T): T? {
        return null
    }

    // Iterable.forEach does not need modification

    fun <RE> map(transform: (E) -> RE): Array<RE> {
        return Array((this as Iterable<E>).map(transform), nocopy = true)
    }

    fun <RE> compactMap(transform: (E) -> RE?): Array<RE> {
        return Array(mapNotNull(transform), nocopy = true)
    }

    fun <RE> flatMap(transform: (E) -> Iterable<RE>): Array<RE> {
        return Array((this as Iterable<E>).flatMap(transform), nocopy = true)
    }

    fun <R> reduce(initialResult: R, nextPartialResult: (R, E) -> R): R {
        return fold(initialResult, nextPartialResult)
    }

/*~~~
    fun <R> reduce(into: R, unusedp: Nothing? = null, updateAccumulatingResult: (InOut<R>, E) -> Unit): R {
        return fold(into) { result, element ->
            var accResult = result
            val inoutAccResult = InOut<R>({ accResult }, { accResult = it })
            updateAccumulatingResult(inoutAccResult, element)
            accResult
        }
    }
*/

    fun filter(isIncluded: (E) -> Boolean): Array<E> {
        return Array((this as Iterable<E>).filter(isIncluded), nocopy = true)
    }

    fun first(where: (E) -> Boolean): E? {
        return firstOrNull(where)
    }

    // Generate for transpiled custom sequences:
//    override fun iterator(): Iterator<E> {
//        val iter = makeIterator()
//        return object: Iterator<E> {
//            var next = iter.next()
//
//            override fun hasNext(): Boolean {
//                return next != null
//            }
//
//            override fun next(): E {
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

interface Collection<E>: Sequence<E> {
    val count: Int
        get() = count()
}

interface MutableCollection<E>: Collection<E> {

}

interface BidirectionalCollection<E>: Collection<E> {
    fun last(where: (E) -> Boolean): E? {
        return lastOrNull(where)
    }
}

interface RandomAccessCollection<E>: BidirectionalCollection<E> {

}

typealias Slice<E> = Array<E>

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
