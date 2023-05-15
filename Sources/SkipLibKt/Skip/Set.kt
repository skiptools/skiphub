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

class Set<Element>: Collection<Element>, SetAlgebra<Set<Element>, Element>, MutableStruct {
    private var isStorageShared = false
    private var _collectionStorage: LinkedHashSet<Element>

    override val collectionStorage: kotlin.collections.Collection<Element>
        get() = _collectionStorage

    constructor(minimumCapacity: Int = 0) {
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

    fun filter(isIncluded: (Element) -> Boolean): Set<Element> {
        return Set(_collectionStorage.filter(isIncluded), nocopy = true)
    }

    override val isEmpty: Boolean
        get() = count == 0

    // MARK: - SetAlgebra

    override fun contains(element: Element): Boolean {
        return _collectionStorage.contains(element)
    }

    override fun union(other: Set<Element>): Set<Element> {
        val union = _collectionStorage.union(other.collectionStorage)
        return Set(union, nocopy = true)
    }

    override fun intersection(other: Set<Element>): Set<Element> {
        val intersection = _collectionStorage.intersect(other.iterableStorage)
        return Set(intersection, nocopy = true)
    }

    override fun symmetricDifference(other: Set<Element>): Set<Element> {
        val ret = Set(other)
        for (element in _collectionStorage) {
            if (ret.remove(element) == null) {
                ret.insert(element)
            }
        }
        return ret
    }

    override fun insert(element: Element): Tuple2<Boolean, Element> {
        val indexOf = _collectionStorage.indexOf(element)
        if (indexOf != -1) {
            return Tuple2(false, _collectionStorage.elementAt(indexOf))
        }
        willmutate()
        _collectionStorage.add(element.sref())
        didmutate()
        return Tuple2(true, element)
    }

    override fun remove(element: Element): Element? {
        willmutate()
        val index = _collectionStorage.indexOf(element)
        val ret: Element?
        if (index == -1) {
            ret = null
        } else {
            ret = _collectionStorage.elementAt(index)
            _collectionStorage.remove(element)
        }
        didmutate()
        return ret
    }

    override fun update(with: Element): Element? {
        willmutate()
        val index = _collectionStorage.indexOf(with)
        val ret: Element?
        if (index == -1) {
            ret = null
        } else {
            ret = _collectionStorage.elementAt(index)
            _collectionStorage.remove(with)
        }
        _collectionStorage.add(with.sref())
        didmutate()
        return ret
    }

    override fun formUnion(other: Set<Element>) {
        willmutate()
        other.collectionStorage.forEach { _collectionStorage.add(it.sref()) }
        didmutate()
    }

    override fun formIntersection(other: Set<Element>) {
        willmutate()
        other.collectionStorage.forEach { _collectionStorage.remove(it) }
        didmutate()
    }

    override fun formSymmetricDifference(other: Set<Element>) {
        willmutate()
        for (element in other.collectionStorage) {
            if (!_collectionStorage.remove(element)) {
                _collectionStorage.add(element.sref())
            }
        }
        didmutate()
    }

    override fun subtracting(other: Set<Element>): Set<Element> {
        val subtraction = _collectionStorage.subtract(other.collectionStorage)
        return Set(subtraction, nocopy = true)
    }

    override fun isSubset(of: Set<Element>): Boolean {
        return of.collectionStorage.containsAll(_collectionStorage)
    }

    override fun isDisjoint(with: Set<Element>): Boolean {
        for (element in with.collectionStorage) {
            if (contains(element)) {
                return false
            }
        }
        return true
    }

    override fun isSuperset(of: Set<Element>): Boolean {
        return _collectionStorage.containsAll(of.collectionStorage)
    }

    override fun subtract(other: Set<Element>) {
        willmutate()
        _collectionStorage.removeAll(other.collectionStorage)
        didmutate()
    }

    override fun isStrictSubset(of: Set<Element>): Boolean {
        return count < of.count && isSubset(of)
    }

    override fun isStrictSuperset(of: Set<Element>): Boolean {
        return count > of.count && isSuperset(of)
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
    override fun scopy(): MutableStruct = Set(this, nocopy = true)
}
