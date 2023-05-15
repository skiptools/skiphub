// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
package skip.lib

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
    private val _collectionStorage: EntryCollection<K, V>
    private val mutableStorage: LinkedHashMap<K, V>
        get() {
            if (isStorageShared) {
                storage = LinkedHashMap(storage)
                isStorageShared = false
            }
            return storage
        }

    override val collectionStorage: kotlin.collections.Collection<Tuple2<K, V>>
        get() = _collectionStorage
    override fun willSliceStorage() {
        isStorageShared = true // Shared with slice
    }

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
    constructor(entries: Iterable<Tuple2<K, V>>, nocopy: Boolean = false, shared: Boolean = false) {
        if (nocopy && entries is LinkedHashMap<*, *>) {
            storage = entries as LinkedHashMap<K, V>
            isStorageShared = shared
        } else {
            storage = LinkedHashMap()
            for (entry in entries) {
                if (nocopy) {
                    storage[entry._e0] = entry._e1
                } else {
                    storage[entry.element0] = entry.element1
                }
            }
        }
        _collectionStorage = EntryCollection(this)
    }

    fun filter(isIncluded: (Tuple2<K, V>) -> Boolean): Dictionary<K, V> {
        return Dictionary(_collectionStorage.filter(isIncluded), nocopy = true)
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
            }
        }
    val values: Collection<V>
        get() {
            return object: Collection<V> {
                override val collectionStorage = ValueCollection(this@Dictionary)
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

    private class EntryCollection<K, V>(val dictionary: Dictionary<K, V>): kotlin.collections.Collection<Tuple2<K, V>> {
        override val size: Int
            get() = dictionary.storage.size

        override fun isEmpty(): Boolean = dictionary.storage.isEmpty()

        override fun iterator(): Iterator<Tuple2<K, V>> {
            val storageIterator = dictionary.storage.iterator()
            return object: Iterator<Tuple2<K, V>> {
                override fun hasNext(): Boolean {
                    return storageIterator.hasNext()
                }
                override fun next(): Tuple2<K, V> {
                    val entry = storageIterator.next()
                    return Tuple2(entry.key, entry.value)
                }
            }
        }

        override fun containsAll(elements: kotlin.collections.Collection<Tuple2<K, V>>): Boolean {
            elements.forEach { if (!contains(it)) return false }
            return true
        }

        override fun contains(element: Tuple2<K, V>): Boolean = dictionary.storage[element._e0] == element._e1
    }

    private class KeyCollection<K, V>(val dictionary: Dictionary<K, V>): kotlin.collections.Collection<K> {
        override val size: Int
            get() = dictionary.storage.size

        override fun isEmpty(): Boolean = dictionary.storage.isEmpty()

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

        override fun containsAll(elements: kotlin.collections.Collection<K>): Boolean {
            elements.forEach { if (!contains(it)) return false }
            return true
        }

        override fun contains(element: K): Boolean = dictionary.storage.containsKey(element)
    }

    private class ValueCollection<K, V>(val dictionary: Dictionary<K, V>): kotlin.collections.Collection<V> {
        override val size: Int
            get() = dictionary.storage.size

        override fun isEmpty(): Boolean = dictionary.storage.isEmpty()

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

        override fun containsAll(elements: kotlin.collections.Collection<V>): Boolean {
            elements.forEach { if (!contains(it)) return false }
            return true
        }

        override fun contains(element: V): Boolean = dictionary.storage.containsValue(element)
    }
}

val <K, V> Tuple2<K, V>.key
    get() = element0
val <K, V> Tuple2<K, V>.value
    get() = element1