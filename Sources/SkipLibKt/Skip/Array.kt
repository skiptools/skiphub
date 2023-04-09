// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
package skip.lib

fun <T> arrayOf(vararg elements: T): Array<T> {
    val array = Array<T>()
    for (element in elements) {
        array.append(element)
    }
    return array
}

class Array<T>: MutableStruct, Iterable<T> {
    private var storage: ArrayStorage<T>
    private var isStorageShared = false

    constructor() {
        storage = ArrayStorage()
    }

    constructor(collection: Collection<T>) {
        storage = ArrayStorage()
        for (element in collection) {
            append(element)
        }
    }

    constructor(vararg elements: T) {
        storage = ArrayStorage()
        for (element in elements) {
            append(element)
        }
    }

    private constructor(storage: ArrayStorage<T>) {
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

    operator fun get(index: Int): T {
        return storage[index.toInt()].sref({
            set(index, it)
        })
    }

    operator fun set(index: Int, element: T) {
        copyStorageIfNeeded()
        willmutate()
        storage[index.toInt()] = element.sref()
        didmutate()
    }

    fun append(element: T) {
        copyStorageIfNeeded()
        willmutate()
        storage.add(element.sref())
        didmutate()
    }

    val count: Int
        get() = storage.count().toLong()

    override fun equals(other: Any?): Boolean {
        if (other === this) {
            return true
        }
        if (other as? Array<*> == null) {
            return false
        }
        return other.storage == storage
    }

    override var supdate: ((Any) -> Unit)? = null
    override var smutatingcount = Int(0)
    override fun scopy(): MutableStruct {
        isStorageShared = true
        return Array(storage = storage)
    }

    private fun copyStorageIfNeeded() {
        if (isStorageShared) {
            storage = ArrayStorage(storage)
            isStorageShared = false
        }
    }

    private class ArrayStorage<T>(): ArrayList<T>() {
        constructor(list: List<T>) : this() {
            addAll(list)
        }
    }
}
