// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
package skip.lib

// WARNING: Replicate all implemented immutable Sequence, Collections API in String.kt

// Note: We use a Storage model wrapping internal Kotlin collections to be able to control when we sref() efficiently

// Base iterable support on which we can implement Swift.Sequence
interface IterableStorage<Element>: Iterable<Element> {
    // Kotlin iterable, not sref'd
    val iterableStorage: Iterable<Element>

    // Iterator to use when content is exposed to consuming code - elements are sref'd
    override fun iterator(): Iterator<Element> {
        val iter = iterableStorage.iterator()
        return object: Iterator<Element> {
            override fun hasNext(): Boolean = iter.hasNext()
            override fun next(): Element = iter.next().sref()
        }
    }
}

// Extended collection support on which we can implement Swift.Collection
interface CollectionStorage<Element>: IterableStorage<Element> {
    // Kotlin collection, not sref'd
    val collectionStorage: kotlin.collections.Collection<Element>

    // Indexing to support slices
    val storageStartIndex: Int
        get() = 0
    val storageEndIndex: Int? // Exclusive
        get() = null
    val effectiveStorageEndIndex: Int
        get() = storageEndIndex ?: collectionStorage.size
    fun willSliceStorage() = Unit

    override val iterableStorage: Iterable<Element>
        get() {
            // If we're not a slice, we can return the native Kotlin collection
            if (storageStartIndex == 0 && storageEndIndex == null) {
                return collectionStorage
            }
            return object: Iterable<Element> {
                override fun iterator(): Iterator<Element> {
                    return object: Iterator<Element> {
                        private var index = storageStartIndex
                        override fun hasNext(): Boolean = index < effectiveStorageEndIndex
                        override fun next(): Element = collectionStorage.elementAt(index++)
                    }
                }
            }
        }
}

// Extended mutable support on which we can implement Swift.MutableCollection
interface MutableListStorage<Element>: CollectionStorage<Element> {
    val mutableListStorage: MutableList<Element>

    override val collectionStorage: kotlin.collections.Collection<Element>
        get() = mutableListStorage

    fun willMutateStorage() = Unit
    fun didMutateStorage() = Unit
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

    fun <T> withContiguousStorageIfAvailable(body: (Any) -> T): T? = null

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

    fun dropFirst(k: Int = 1): Array<Element> {
        return Array(iterableStorage.drop(k), nocopy = true)
    }

    fun dropLast(k: Int = 1): Array<Element> {
        return Array(iterableStorage.toList().dropLast(k), nocopy = true)
    }

    fun enumerated(): Sequence<Tuple2<Int, Element>> {
        val iterable = object: Iterable<Tuple2<Int, Element>> {
            override fun iterator(): Iterator<Tuple2<Int, Element>> {
                var offset = 0
                val iter = this@Sequence.iterator()
                return object: Iterator<Tuple2<Int, Element>> {
                    override fun hasNext(): Boolean = iter.hasNext()
                    override fun next(): Tuple2<Int, Element> = Tuple2(offset++, iter.next())
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

    fun reversed(): Array<Element> {
        return Array(iterableStorage.reversed(), nocopy = true)
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
    val startIndex: Int
        get() = storageStartIndex
    val endIndex: Int
        get() = storageEndIndex ?: count

    operator fun get(position: Int): Element {
        return collectionStorage.elementAt(position).sref()
    }

    val isEmpty: Boolean
        get() = storageStartIndex >= effectiveStorageEndIndex
    val count: Int
        get() = effectiveStorageEndIndex - storageStartIndex

    fun index(i: Int, offsetBy: Int): Int  = i + offsetBy
    fun distance(from: Int, to: Int): Int  = to - from
    fun index(after: Int): Int = after + 1

    val first: Element?
        get() = if (isEmpty) null else get(storageStartIndex)

    fun firstIndex(of: Element): Int? {
        val index = indexOf(of)
        return if (index == -1) null else index
    }

    operator fun get(range: IntRange): Collection<Element> {
        // We translate open ranges to use Int.min and Int.max in Kotlin
        val lowerBound = if (range.start == Int.min) 0 else range.start
        val upperBound = if (range.endInclusive == Int.max) null else range.endInclusive + 1

        willSliceStorage()
        val collection = this
        return object: Collection<Element> {
            override val collectionStorage = collection.collectionStorage
            override val storageStartIndex = lowerBound
            override val storageEndIndex = upperBound
        }
    }
}

interface BidirectionalCollection<Element>: Collection<Element> {
    fun last(where: (Element) -> Boolean): Element? {
        // If we're not a slice we can use the collection directly, otherwise use our sliced iterator
        if (storageStartIndex == 0 && storageEndIndex == null) {
            return collectionStorage.lastOrNull(where).sref()
        } else {
            return iterableStorage.lastOrNull(where).sref()
        }
    }

    val last: Element?
        get() = if (isEmpty) null else elementAt(effectiveStorageEndIndex - 1).sref()
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

    operator fun set(bounds: IntRange, elements: Collection<Element>) {
        // We translate open ranges to use Int.min and Int.max in Kotlin
        val lowerBound = if (bounds.start == Int.min) 0 else bounds.start
        val upperBound = if (bounds.endInclusive == Int.max) mutableListStorage.size else bounds.endInclusive + 1

        willMutateStorage()
        mutableListStorage.subList(lowerBound, upperBound).clear()
        mutableListStorage.addAll(lowerBound, elements.collectionStorage.map { it.sref() })
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
