// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
package skip.lib

// Use a Storage model wrapping an internal Kotlin iterable to be able to control when we sref() efficiently

interface IterableStorage<Element>: Iterable<Element> {
    val iterableStorage: Iterable<Element>

    override fun iterator(): Iterator<Element> {
        val iter = iterableStorage.iterator()
        return object: Iterator<Element> {
            override fun hasNext(): Boolean {
                return iter.hasNext()
            }

            override fun next(): Element {
                return iter.next().sref()
            }
        }
    }
}

interface CollectionStorage<Element>: IterableStorage<Element> {
    val collectionStorage: kotlin.collections.Collection<Element>

    override val iterableStorage: Iterable<Element>
        get() = collectionStorage
}

interface MutableListStorage<Element>: CollectionStorage<Element> {
    val mutableListStorage: MutableList<Element>

    override val collectionStorage: kotlin.collections.Collection<Element>
        get() = mutableListStorage

    fun willMutateStorage() {
    }

    fun didMutateStorage() {
    }
}

interface Sequence<Element>: IterableStorage<Element> {
    fun makeIterator(): IteratorProtocol<Element> {
        val iter = iterator()
        return object: IteratorProtocol<Element> {
            override fun next(): Element? {
                return if (iter.hasNext()) iter.next() else null
            }
        }
    }
    
    val underestimatedCount: Int
        get() = 0

    fun <T> withContiguousStorageIfAvailable(body: (Any) -> T): T? {
        return null
    }

    fun <RE> map(transform: (Element) -> RE): Array<RE> {
        return Array(iterableStorage.map(transform), nocopy = true)
    }

    fun filter(isIncluded: (Element) -> Boolean): Array<Element> {
        return Array(iterableStorage.filter(isIncluded), nocopy = true)
    }

    fun forEach(body: (Element) -> Unit) {
        iterableStorage.forEach(body)
    }

    fun first(where: (Element) -> Boolean): Element? {
        return iterableStorage.firstOrNull(where).sref()
    }

    fun enumerated(): Sequence<Tuple2<Int, Element>> {
        val iterable = object: Iterable<Tuple2<Int, Element>> {
            override fun iterator(): Iterator<Tuple2<Int, Element>> {
                var index = 0
                val iter = this@Sequence.iterator()
                return object: Iterator<Tuple2<Int, Element>> {
                    override fun hasNext(): Boolean = iter.hasNext()
                    override fun next(): Tuple2<Int, Element> = Tuple2(index++, iter.next())
                }
            }
        }
        return object: Sequence<Tuple2<Int, Element>> {
            override val iterableStorage: Iterable<Tuple2<Int, Element>>
                get() = iterable
        }
    }

    fun contains(where: (Element) -> Boolean): Boolean {
        iterableStorage.forEach { if (where(it)) return true }
        return false
    }

    // Warning: Although 'initialResult' is not a labeled parameter in Swift, the transpiler inserts it
    // into our Kotlin call sites to differentiate between calls to the two reduce() functions. Do not change
    fun <R> reduce(initialResult: R, nextPartialResult: (R, Element) -> R): R {
        return iterableStorage.fold(initialResult, nextPartialResult)
    }

    fun <R> reduce(unusedp: Nothing? = null, into: R, updateAccumulatingResult: (InOut<R>, Element) -> Unit): R {
        return iterableStorage.fold(into) { result, element ->
            var accResult = result
            val inoutAccResult = InOut<R>({ accResult }, { accResult = it })
            updateAccumulatingResult(inoutAccResult, element)
            accResult
        }
    }

    fun <RE> flatMap(transform: (Element) -> Sequence<RE>): Array<RE> {
        return Array(iterableStorage.flatMap { transform(it).iterableStorage }, nocopy = true)
    }

    fun <RE> compactMap(transform: (Element) -> RE?): Array<RE> {
        return Array(iterableStorage.mapNotNull(transform), nocopy = true)
    }

    @Suppress("UNCHECKED_CAST")
    fun sorted(): Array<Element> {
        return Array(iterableStorage.sortedWith(compareBy { it as Comparable<Element> }), nocopy = true)
    }

    fun contains(element: Element): Boolean {
        return iterableStorage.contains(element)
    }
}

interface Collection<Element>: Sequence<Element>, CollectionStorage<Element> {
    operator fun get(position: Int): Element {
        return collectionStorage.elementAt(position).sref()
    }

    val isEmpty: Boolean
        get() = collectionStorage.size == 0

    val count: Int
        get() = collectionStorage.size

    val first: Element?
        get() = collectionStorage.first().sref()
}

interface BidirectionalCollection<Element>: Collection<Element> {
    fun last(where: (Element) -> Boolean): Element? {
        return collectionStorage.lastOrNull(where).sref()
    }

    val last: Element?
        get() = collectionStorage.last().sref()
}

interface RandomAccessCollection<Element>: BidirectionalCollection<Element> {
}

interface RangeReplaceableCollection<Element>: Collection<Element>, MutableListStorage<Element> {
    fun append(newElement: Element) {
        willMutateStorage()
        mutableListStorage.add(newElement.sref())
        didMutateStorage()
    }

	fun insert(newElement: Element, at: Int) {
		willMutateStorage()
		mutableListStorage.add(at, newElement.sref())
		didMutateStorage()
	}

	fun popLast(): Element? {
		willMutateStorage()
		val lastElement = mutableListStorage.removeLast().sref()
		didMutateStorage()
		return lastElement
	}

	fun removeLast(k: Int = 1) {
		if (k > 0) {
			willMutateStorage()
			mutableListStorage.subList(mutableListStorage.size - k, mutableListStorage.size).clear()
			didMutateStorage()
		}
	}
}

interface MutableCollection<Element>: Collection<Element>, MutableListStorage<Element> {
    operator fun set(position: Int, element: Element) {
        willMutateStorage()
        mutableListStorage[position] = element.sref()
        didMutateStorage()
    }
}

interface IteratorProtocol<Element> {
    fun next(): Element?
}

//~~~

// Forward Swift's `lazy` property Kotlin's `asSequence()` function
val <T> Iterable<T>.lazy: kotlin.sequences.Sequence<T>
    get() = this.asSequence()
