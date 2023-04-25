// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
package skip.lib

// We convert array literals assigned to Set vars [...] into setOf(...)
fun <Element> setOf(vararg elements: Element): Set<Element> {
    val storage = LinkedHashSet<Element>()
    for (element in elements) {
        storage.add(element.sref())
    }
    return Set(storage, nocopy = true)
}

class Set<Element>: Collection<Element>, MutableStruct {
    private var isStorageShared = false
    private var _collectionStorage: LinkedHashSet<Element>

    override val collectionStorage: kotlin.collections.Collection<Element>
        get() = _collectionStorage

    constructor() {
        _collectionStorage = LinkedHashSet()
    }

    constructor(collection: Sequence<Element>, nocopy: Boolean = false) {
        if (nocopy && collection is Set<Element>) {
            // Share storage with the given set, marking it as shared in both
            _collectionStorage = collection._collectionStorage
            collection.isStorageShared = true
            isStorageShared = true
        } else {
            _collectionStorage = LinkedHashSet()
            _collectionStorage.addAll(collection)
        }
    }

    constructor(collection: Iterable<Element>, nocopy: Boolean = false, shared: Boolean = false) {
        if (nocopy && collection is LinkedHashSet<Element>) {
            _collectionStorage = collection
            isStorageShared = shared
        } else {
            _collectionStorage = LinkedHashSet()
            if (nocopy) {
                _collectionStorage.addAll(collection)
            } else {
                collection.forEach { _collectionStorage.add(it.sref()) }
            }
        }
    }

    constructor(vararg elements: Element) {
        val storage = LinkedHashSet<Element>()
        for (element in elements) {
            storage.add(element.sref())
        }
        _collectionStorage = storage
    }

    fun insert(element: Element): Tuple2<Boolean, Element> {
        val indexOf = _collectionStorage.indexOf(element)
        if (indexOf != -1) {
            return Tuple2(false, _collectionStorage.elementAt(indexOf))
        }
        willmutate()
        _collectionStorage.add(element.sref())
        didmutate()
        return Tuple2(true, element)
    }

    fun remove(element: Element): Boolean {
        willmutate()
        val removed = _collectionStorage.remove(element)
        didmutate()
        return removed
    }

    fun union(other: Sequence<Element>): Set<Element> {
        val union = _collectionStorage.union(other.iterableStorage)
        return Set(union, nocopy = true)
    }

    fun intersection(other: Sequence<Element>): Set<Element> {
        val intersection = _collectionStorage.intersect(other.iterableStorage)
        return Set(intersection, nocopy = true)
    }

    fun isSubset(of: Sequence<Element>): Boolean {
        val otherSet = of as? Set<Element> ?: Set(of, nocopy = true)
        return otherSet.isSuperset(this)
    }

    fun isStrictSubset(of: Sequence<Element>): Boolean {
        return of.iterableStorage.count() > count && isSubset(of)
    }

    fun isSuperset(of: Sequence<Element>): Boolean {
        for (element in of.iterableStorage) {
            if (!contains(element)) {
                return false
            }
        }
        return true
    }

    fun isStrictSuperset(of: Sequence<Element>): Boolean {
        return of.iterableStorage.count() < count && isSuperset(of)
    }

    fun isDisjoint(with: Sequence<Element>): Boolean {
        for (element in with.iterableStorage) {
            if (contains(element)) {
                return false
            }
        }
        return true
    }

    fun symmetricDifference(other: Sequence<Element>): Set<Element> {
        val otherSet = other as? Set<Element> ?: Set(other)
        for (element in _collectionStorage) {
            if (otherSet.remove(element) == false) {
                otherSet.insert(element)
            }
        }
        return otherSet
    }

    override fun equals(other: Any?): Boolean {
        if (other === this) {
            return true
        }
        if (other as? Set<*> == null) {
            return false
        }
        return other.collectionStorage == collectionStorage
    }

    // MutableStruct

    override var supdate: ((Any) -> Unit)? = null
    override var smutatingcount = 0
    override fun scopy(): MutableStruct {
        return Set(this, nocopy = true)
    }
}
