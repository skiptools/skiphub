// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
package skip.lib

// We convert array literals [...] into arrayOf(...)
fun <Element> arrayOf(vararg elements: Element): Array<Element> {
    val storage = ArrayList<Element>()
    for (element in elements) {
        storage.add(element.sref())
    }
    return Array(storage, nocopy = true)
}

class Array<Element>: RandomAccessCollection<Element>, RangeReplaceableCollection<Element>, MutableCollection<Element>, MutableStruct {
    private var isStorageShared = false
    private var _mutableListStorage: MutableList<Element>? = null
    private var _collectionStorage: List<Element>? = null

    override val collectionStorage: kotlin.collections.Collection<Element>
        get() = _mutableListStorage ?: _collectionStorage!!

    override val mutableListStorage: MutableList<Element>
        get() {
            if (!isStorageShared) {
                var storage = _mutableListStorage
                if (storage != null) {
                    return storage
                }
            }
            val storage = ArrayList(collectionStorage)
            isStorageShared = false
            _mutableListStorage = storage
            _collectionStorage = null
            return storage
        }

    override fun willSliceStorage() {
        isStorageShared = true // Shared with slice
    }
    override fun willMutateStorage() = willmutate()
    override fun didMutateStorage() = didmutate()

    constructor() {
        _mutableListStorage = ArrayList()
    }

    @Suppress("UNCHECKED_CAST")
    constructor(collection: Sequence<Element>, nocopy: Boolean = false, shared: Boolean = false) {
        if (nocopy) {
            if (collection is Array<Element>) {
                // Share storage with the given array, marking it as shared in both
                val storage = collection._mutableListStorage
                if (storage != null) {
                    if (shared) {
                        collection.isStorageShared = true
                        isStorageShared = true
                    }
                    _mutableListStorage = storage
                } else {
                    _collectionStorage= collection._collectionStorage
                }
            } else if (collection is MutableListStorage<*> && collection.storageStartIndex == 0 && collection.storageEndIndex == null) {
                _mutableListStorage = collection.mutableListStorage as MutableList<Element>
                isStorageShared = shared
            } else if (collection is CollectionStorage<*> && collection.storageStartIndex == 0 && collection.storageEndIndex == null) {
                val collectionStorage = collection.collectionStorage
                if (collectionStorage is List<*>) {
                    _collectionStorage = collectionStorage as List<Element>
                }
            }
        }
        if (_mutableListStorage == null && _collectionStorage == null) {
            val storage = ArrayList<Element>()
            storage.addAll(collection)
            _mutableListStorage = storage
        }
    }

    constructor(collection: Iterable<Element>, nocopy: Boolean = false, shared: Boolean = false) {
        if (nocopy) {
            if (collection is MutableList<Element>) {
                _mutableListStorage = collection
                isStorageShared = shared
            } else if (collection is List<Element>) {
                _collectionStorage = collection
            }
        }
        if (_mutableListStorage == null && _collectionStorage == null) {
            val storage = ArrayList<Element>()
            collection.forEach { storage.add(it.sref()) }
            _mutableListStorage = storage
        }
    }

    constructor(vararg elements: Element) {
        val storage = ArrayList<Element>()
        for (element in elements) {
            storage.add(element.sref())
        }
        _mutableListStorage = storage
    }

    override operator fun get(position: Int): Element {
        return collectionStorage.elementAt(position).sref({
            set(position, it)
        })
    }

    override fun equals(other: Any?): Boolean {
        if (other === this) {
            return true
        }
        if (other as? Array<*> == null) {
            return false
        }
        return other.collectionStorage == collectionStorage
    }

    override var supdate: ((Any) -> Unit)? = null
    override var smutatingcount = 0
    override fun scopy(): MutableStruct = Array(this, nocopy = true, shared = true)
}
