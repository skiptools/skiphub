// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
package skip.lib

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

class Set<T>: MutableStruct, Iterable<T> {
    private var storage: SetStorage<T>
    private var isStorageShared = false

    constructor() {
        storage = SetStorage()
    }

    constructor(collection: Collection<T>) {
        storage = SetStorage()
        for (element in collection) {
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
        val storageIterator = storage.iterator()
        return object: Iterator<T> {
            override fun hasNext(): Boolean {
                return storageIterator.hasNext()
            }
            override fun next(): T {
                return storageIterator.next().sref()
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

    fun isSubset(of: Set<T>): Boolean {
        return of.storage.containsAll(this.storage)
    }

    fun isSubset(of: Collection<T>): Boolean {
        return of.containsAll(this.storage)
    }

	fun isStrictSubset(of: Set<T>): Boolean {
        return of.count > this.count && isSubset(of)
    }

	fun isStrictSubset(of: Collection<T>): Boolean {
        return of.count > this.count && isSubset(of)
    }

    fun isSuperset(of: Set<T>): Boolean {
        return this.storage.containsAll(of.storage)
    }

    fun isSuperset(of: Collection<T>): Boolean {
        return this.storage.containsAll(of)
    }

    fun isStrictSuperset(of: Set<T>): Boolean {
        return of.count < this.count && isSuperset(of)
    }

    fun isStrictSuperset(of: Collection<T>): Boolean {
        return of.count < this.count && isSuperset(of)
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

    val count: Int
        get() = storage.count().toLong()

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
    override var smutatingcount = Int(0)
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

