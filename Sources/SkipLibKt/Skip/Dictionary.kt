// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
package skip.lib

// We convert dictionary literals [...] into dictionaryOf(...)
fun <K: Any, V: Any> dictionaryOf(vararg entries: Tuple2<K, V>): Dictionary<K, V> {
    val dictionary = Dictionary<K, V>()
    for (entry in entries) {
        dictionary[entry.element0] = entry.element1
    }
    return dictionary
}

class Dictionary<K: Any, V: Any>: MutableStruct, Iterable<Tuple2<K, V>>, Hashable {
    private var storage: DictionaryStorage<K, V>
    private var isStorageShared = false

    constructor() {
        storage = DictionaryStorage()
    }

    constructor(map: Map<K, V>) {
        storage = DictionaryStorage()
        for (entry in map) {
            this[entry.key] = entry.value
        }
    }

    constructor(vararg entries: Tuple2<K, V>) {
        storage = DictionaryStorage()
        for (entry in entries) {
            this[entry.element0] = entry.element1
        }
    }

    private constructor(storage: DictionaryStorage<K, V>) {
        this.storage = storage
        isStorageShared = true
    }

    override fun iterator(): Iterator<Tuple2<K, V>> {
        val storageIterator = storage.iterator()
        return object: Iterator<Tuple2<K, V>> {
            override fun hasNext(): Boolean {
                return storageIterator.hasNext()
            }
            override fun next(): Tuple2<K, V> {
                val entry = storageIterator.next()
                return Tuple2(entry.key.sref(), entry.value.sref())
            }
        }
    }

    operator fun get(key: K): V? {
        return storage[key]?.sref({
            set(key, it)
        })
    }

    operator fun set(key: K, value: V?) {
        copyStorageIfNeeded()
        willmutate()
        if (value == null) {
            storage.remove(key)
        } else {
            storage[key] = value.sref()
        }
        didmutate()
    }

    // TODO: Duplicate Swift's Collection and Sequence types

    val keys: Array<K>
        get() = Array(storage.keys)

    val values: Array<V>
        get() = Array(storage.values)

    val count: Int
        get() = storage.count()

    override fun equals(other: Any?): Boolean {
        if (other === this) {
            return true
        }
        if (other as? Dictionary<*, *> == null) {
            return false
        }
        return other.storage == storage
    }

    override fun hashCode(): Int {
        return storage.hashCode()
    }

    override var supdate: ((Any) -> Unit)? = null
    override var smutatingcount = 0
    override fun scopy(): MutableStruct {
        isStorageShared = true
        return Dictionary(storage = storage)
    }

    private fun copyStorageIfNeeded() {
        if (isStorageShared) {
            storage = DictionaryStorage(storage)
            isStorageShared = false
        }
    }

    private class DictionaryStorage<K, V>(): HashMap<K, V>() {
        constructor(map: Map<K, V>) : this() {
            putAll(map)
        }
    }
}

// Tuple2 extension functions to mimic a dictionary entry tuple
val <K, V> Tuple2<K, V>.key: K
    get() = element0
val <K, V> Tuple2<K, V>.value: V
    get() = element1
