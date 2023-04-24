// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
package skip.lib

// We convert array literals assigned to Set vars [...] into setOf(...)
fun <T> setOf(vararg elements: T): Set<T> {
	val set = Set<T>()
	for (element in elements) {
		set.insert(element)
	}
	return set
}

fun <T> Set(elements: Array<T>): Set<T> {
	val set = Set<T>()
	for (element in elements) {
		set.insert(element)
	}
	return set
}

class Set<T>: MutableStruct, BidirectionalCollection<T>, Iterable<T>, Hashable {
    private var storage: SetStorage<T>
    private var isStorageShared = false

    constructor() {
        storage = SetStorage()
    }

    constructor(items: Iterable<T>) {
        storage = SetStorage()
        for (element in items) {
			insert(element)
        }
    }

    constructor(vararg elements: T) {
        storage = SetStorage()
        for (element in elements) {
			insert(element)
        }
    }

    private constructor(storage: SetStorage<T>) {
        this.storage = storage
        isStorageShared = true
    }

    override fun iterator(): Iterator<T> {
        return IteratorProtocolIterator(makeIterator())
    }

    override fun makeIterator(): IteratorProtocol<T> {
        val storageIterator = storage.iterator()
        return object: IteratorProtocol<T> {
            override fun next(): T? {
                return if (storageIterator.hasNext()) storageIterator.next() else null
            }
        }
    }

    fun insert(element: T) {
        copyStorageIfNeeded()
        willmutate()
        storage.add(element.sref())
        didmutate()
    }

    fun remove(element: T): Boolean {
        copyStorageIfNeeded()
        willmutate()
        val removed = storage.remove(element.sref())
        didmutate()
		return removed
    }

	fun intersection(other: Iterable<T>): Set<T> {
		val result = Set<T>()
		for (element in other) {
			if (contains(element)) {
				result.insert(element)
			}
		}
		return result
	}

    fun isSubset(of: Iterable<T>): Boolean {
        return Set(of).isSuperset(this)
    }

	fun isStrictSubset(of: Iterable<T>): Boolean {
        return of.count() > this.count && isSubset(of)
    }

    fun isSuperset(of: Iterable<T>): Boolean {
        for (element in of) {
            if (!contains(element)) {
                return false
            }
        }
        return true
    }

    fun isStrictSuperset(of: Iterable<T>): Boolean {
        return of.count() < this.count && isSuperset(of)
    }

	fun isDisjoint(with: Iterable<T>): Boolean {
		for (element in with) {
			if (contains(element)) {
				return false
			}
		}
		return true
	}

	fun symmetricDifference(other: Iterable<T>): Set<T> {
		val otherSet = Set<T>()
		for (element in other) {
			otherSet.insert(element)
		}
		for (element in this.storage) {
			if (otherSet.remove(element) == false) {
				otherSet.insert(element)
			}
		}
        return otherSet
	}

    override val count: Int
        get() = storage.count()

    val isEmpty: Boolean
        get() = storage.isEmpty()

    override fun equals(other: Any?): Boolean {
        if (other === this) {
            return true
        }
        if (other as? Set<*> == null) {
            return false
        }
        return other.storage == storage
    }

    override var supdate: ((Any) -> Unit)? = null
    override var smutatingcount = 0
    override fun scopy(): MutableStruct {
        isStorageShared = true
        return Set(storage = storage)
    }

    private fun copyStorageIfNeeded() {
        if (isStorageShared) {
            storage = SetStorage(storage)
            isStorageShared = false
        }
    }

    private class SetStorage<T>(): HashSet<T>() {
        constructor(set: HashSet<T>) : this() {
            addAll(set)
        }
    }
}

