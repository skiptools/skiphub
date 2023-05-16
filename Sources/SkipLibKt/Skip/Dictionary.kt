// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
package skip.lib

import java.lang.UnsupportedOperationException

// We convert dictionary literals [...] into dictionaryOf(...)
fun <K, V> dictionaryOf(vararg entries: Tuple2<K, V>): Dictionary<K, V> {
    val dictionary = Dictionary<K, V>()
    for (entry in entries) {
        dictionary[entry.element0] = entry.element1
    }
    return dictionary
}

class Dictionary<K, V>: Collection<Tuple2<K, V>>, MutableStruct {
    private var isStorageShared = false
    private var storage: LinkedHashMap<K, V>
    private val mutableStorage: LinkedHashMap<K, V>
        get() {
            if (isStorageShared) {
                storage = LinkedHashMap(storage)
                isStorageShared = false
            }
            return storage
        }
    private val _collectionStorage: EntryCollection<K, V>

    override val collectionStorage: kotlin.collections.Collection<Tuple2<K, V>>
        get() = _collectionStorage
    override val mutableCollectionStorage: kotlin.collections.MutableCollection<Tuple2<K, V>>
        get() {
            mutableStorage // Accessing will copy storage if needed
            return _collectionStorage
        }

    override fun willSliceStorage() {
        isStorageShared = true // Shared with slice
    }
    override fun willMutateStorage() = willmutate()
    override fun didMutateStorage() = didmutate()

    constructor(minimumCapacity: Int = 0) {
        storage = LinkedHashMap()
        _collectionStorage = EntryCollection(this)
    }

    @Suppress("UNCHECKED_CAST")
    constructor(uniqueKeysWithValues: Sequence<Tuple2<K, V>>, nocopy: Boolean = false) {
        if (nocopy && uniqueKeysWithValues is EntryCollection<*, *>) {
            // Share storage with the given dictionary, marking it as shared in both
            storage = (uniqueKeysWithValues as EntryCollection<K, V>).dictionary.storage
            uniqueKeysWithValues.dictionary.isStorageShared = true
            isStorageShared = true
        } else {
            storage = LinkedHashMap()
            for (entry in uniqueKeysWithValues.iterableStorage) {
                if (nocopy) {
                    storage[entry._e0] = entry._e1
                } else {
                    storage[entry.element0] = entry.element1
                }
            }
        }
        _collectionStorage = EntryCollection(this)
    }

    @Suppress("UNCHECKED_CAST")
    constructor(map: Map<K, V>, nocopy: Boolean = false, shared: Boolean = false) {
        if (nocopy && map is LinkedHashMap<*, *>) {
            storage = map as LinkedHashMap<K, V>
            isStorageShared = shared
        } else {
            storage = LinkedHashMap()
            for (entry in map) {
                if (nocopy) {
                    storage[entry.key] = entry.value
                } else {
                    storage[entry.key.sref()] = entry.value.sref()
                }
            }
        }
        _collectionStorage = EntryCollection(this)
    }

    fun filter(isIncluded: (Tuple2<K, V>) -> Boolean): Dictionary<K, V> {
        return Dictionary(storage.filter { isIncluded(Tuple2(it.key, it.value)) }, nocopy = true)
    }

    operator fun get(key: K): V? {
        return storage[key]?.sref({
            set(key, it)
        })
    }

    operator fun set(key: K, value: V?) {
        willmutate()
        if (value == null) {
            mutableStorage.remove(key)
        } else {
            mutableStorage[key.sref()] = value.sref()
        }
        didmutate()
    }

    val keys: Collection<K>
        get() {
            return object: Collection<K> {
                override val collectionStorage = KeyCollection(this@Dictionary)
                override val mutableCollectionStorage: kotlin.collections.MutableCollection<K>
                    get() = throw UnsupportedOperationException()
            }
        }
    val values: Collection<V>
        get() {
            return object: Collection<V> {
                override val collectionStorage = ValueCollection(this@Dictionary)
                override val mutableCollectionStorage: kotlin.collections.MutableCollection<V>
                    get() = throw UnsupportedOperationException()
            }
        }

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

    // MutableStruct

    override var supdate: ((Any) -> Unit)? = null
    override var smutatingcount = 0
    override fun scopy(): MutableStruct = Dictionary(this, nocopy = true)

    private class EntryCollection<K, V>(val dictionary: Dictionary<K, V>): AbstractMutableCollection<Tuple2<K, V>>() {
        override val size: Int
            get() = dictionary.storage.size

        override fun add(element: Tuple2<K, V>): Boolean {
            dictionary.storage[element.key] = element.value
            return true
        }

        override fun iterator(): MutableIterator<Tuple2<K, V>> {
            val storageIterator = dictionary.storage.iterator()
            return object: MutableIterator<Tuple2<K, V>> {
                private lateinit var lastEntry: MutableMap.MutableEntry<K, V>
                override fun hasNext(): Boolean {
                    return storageIterator.hasNext()
                }
                override fun next(): Tuple2<K, V> {
                    lastEntry = storageIterator.next()
                    return Tuple2(lastEntry.key, lastEntry.value)
                }
                override fun remove() {
                    dictionary.storage.remove(lastEntry.key)
                }
            }
        }

        override fun contains(element: Tuple2<K, V>): Boolean = dictionary.storage[element._e0] == element._e1
        override fun clear() = dictionary.storage.clear()
    }

    private class KeyCollection<K, V>(val dictionary: Dictionary<K, V>): AbstractCollection<K>() {
        override val size: Int
            get() = dictionary.storage.size

        override fun iterator(): Iterator<K> {
            val storageIterator = dictionary.storage.iterator()
            return object: Iterator<K> {
                override fun hasNext(): Boolean {
                    return storageIterator.hasNext()
                }
                override fun next(): K {
                    val entry = storageIterator.next()
                    return entry.key
                }
            }
        }

        override fun contains(element: K): Boolean = dictionary.storage.containsKey(element)
    }

    private class ValueCollection<K, V>(val dictionary: Dictionary<K, V>): AbstractCollection<V>() {
        override val size: Int
            get() = dictionary.storage.size

        override fun iterator(): Iterator<V> {
            val storageIterator = dictionary.storage.iterator()
            return object: Iterator<V> {
                override fun hasNext(): Boolean {
                    return storageIterator.hasNext()
                }
                override fun next(): V {
                    val entry = storageIterator.next()
                    return entry.value
                }
            }
        }

        override fun contains(element: V): Boolean = dictionary.storage.containsValue(element)
    }
}

val <K, V> Tuple2<K, V>.key
    get() = element0
val <K, V> Tuple2<K, V>.value
    get() = element1