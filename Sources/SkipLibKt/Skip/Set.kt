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

typealias SetIndex = Int

class Set<Element>: Collection<Element>, SetAlgebra<Set<Element>, Element>, MutableStruct {
    private var isStorageShared = false
    private var storage: LinkedHashSet<Element>
    private val mutableStorage: LinkedHashSet<Element>
        get() {
            if (isStorageShared) {
                storage = LinkedHashSet(storage)
                isStorageShared = false
            }
            return storage
        }

    override val collectionStorage: kotlin.collections.Collection<Element>
        get() = storage
    override val mutableCollectionStorage: kotlin.collections.MutableCollection<Element>
        get() = mutableStorage

    override fun willSliceStorage() {
        isStorageShared = true // Shared with slice
    }
    override fun willMutateStorage() = willmutate()
    override fun didMutateStorage() = didmutate()

    constructor(minimumCapacity: Int = 0) {
        storage = LinkedHashSet()
    }

    constructor(collection: Sequence<Element>, nocopy: Boolean = false) {
        if (nocopy && collection is Set<Element>) {
            // Share storage with the given set, marking it as shared in both
            storage = collection.storage
            collection.isStorageShared = true
            isStorageShared = true
        } else {
            storage = LinkedHashSet()
            storage.addAll(collection)
        }
    }

    constructor(collection: Iterable<Element>, nocopy: Boolean = false, shared: Boolean = false) {
        if (nocopy && collection is LinkedHashSet<Element>) {
            storage = collection
            isStorageShared = shared
        } else {
            storage = LinkedHashSet()
            if (nocopy) {
                storage.addAll(collection)
            } else {
                collection.forEach { storage.add(it.sref()) }
            }
        }
    }

    fun filter(isIncluded: (Element) -> Boolean): Set<Element> {
        return Set(storage.filter(isIncluded), nocopy = true)
    }

    override val isEmpty: Boolean
        get() = count == 0

    fun union(other: Sequence<Element>): Set<Element> {
        val union = storage.union(other.iterableStorage)
        return Set(union, nocopy = true)
    }

    fun intersection(other: Sequence<Element>): Set<Element> {
        val intersection = storage.intersect(other.iterableStorage)
        return Set(intersection, nocopy = true)
    }

    fun symmetricDifference(other: Sequence<Element>): Set<Element> {
        val ret = Set(other)
        for (element in storage) {
            if (ret.remove(element) == null) {
                ret.insert(element)
            }
        }
        return ret
    }

    fun formUnion(other: Sequence<Element>) {
        willmutate()
        other.iterableStorage.forEach { mutableStorage.add(it.sref()) }
        didmutate()
    }

    fun formIntersection(other: Sequence<Element>) {
        willmutate()
        other.iterableStorage.forEach { mutableStorage.remove(it) }
        didmutate()
    }

    fun formSymmetricDifference(other: Sequence<Element>) {
        willmutate()
        for (element in other.iterableStorage) {
            if (!mutableStorage.remove(element)) {
                mutableStorage.add(element.sref())
            }
        }
        didmutate()
    }

    fun subtracting(other: Sequence<Element>): Set<Element> {
        val subtraction = storage.subtract(other.iterableStorage)
        return Set(subtraction, nocopy = true)
    }

    fun isSubset(of: Sequence<Element>): Boolean {
        for (element in storage) {
            if (!of.contains(element)) {
                return false
            }
        }
        return true
    }

    fun isDisjoint(with: Sequence<Element>): Boolean {
        for (element in with.iterableStorage) {
            if (contains(element)) {
                return false
            }
        }
        return true
    }

    fun isSuperset(of: Sequence<Element>): Boolean {
        for (element in of.iterableStorage) {
            if (!storage.contains(element)) {
                return false
            }
        }
        return true
    }

    fun subtract(other: Sequence<Element>) {
        willmutate()
        mutableStorage.removeAll(other.iterableStorage)
        didmutate()
    }

    fun isStrictSubset(of: Sequence<Element>): Boolean {
        return count < of.iterableStorage.count() && isSubset(of)
    }

    fun isStrictSuperset(of: Sequence<Element>): Boolean {
        return count > of.iterableStorage.count() && isSuperset(of)
    }

    // MARK: - SetAlgebra

    override fun contains(element: Element): Boolean = storage.contains(element)
    override fun union(other: Set<Element>): Set<Element> = union(other as Sequence<Element>)
    override fun intersection(other: Set<Element>): Set<Element> = intersection(other as Sequence<Element>)
    override fun symmetricDifference(other: Set<Element>): Set<Element> = symmetricDifference(other as Sequence<Element>)

    override fun insert(element: Element): Tuple2<Boolean, Element> {
        val indexOf = storage.indexOf(element)
        if (indexOf != -1) {
            return Tuple2(false, storage.elementAt(indexOf))
        }
        willmutate()
        mutableStorage.add(element.sref())
        didmutate()
        return Tuple2(true, element)
    }

    override fun remove(element: Element): Element? {
        willmutate()
        val index = storage.indexOf(element)
        val ret: Element?
        if (index == -1) {
            ret = null
        } else {
            ret = storage.elementAt(index)
            mutableStorage.remove(element)
        }
        didmutate()
        return ret
    }

    override fun update(with: Element): Element? {
        willmutate()
        val index = storage.indexOf(with)
        val ret: Element?
        if (index == -1) {
            ret = null
        } else {
            ret = storage.elementAt(index)
            mutableStorage.remove(with)
        }
        mutableStorage.add(with.sref())
        didmutate()
        return ret
    }

    override fun formUnion(other: Set<Element>) = formUnion(other as Sequence<Element>)
    override fun formIntersection(other: Set<Element>) = formIntersection(other as Sequence<Element>)
    override fun formSymmetricDifference(other: Set<Element>) = formSymmetricDifference(other as Sequence<Element>)
    override fun subtracting(other: Set<Element>): Set<Element> = subtracting(other as Sequence<Element>)
    override fun isSubset(of: Set<Element>): Boolean = isSubset(of as Sequence<Element>)
    override fun isDisjoint(with: Set<Element>): Boolean = isDisjoint(with as Sequence<Element>)
    override fun isSuperset(of: Set<Element>): Boolean = isSuperset(of as Sequence<Element>)
    override fun subtract(other: Set<Element>) = subtract(other as Sequence<Element>)
    override fun isStrictSubset(of: Set<Element>): Boolean = isStrictSubset(of as Sequence<Element>)
    override fun isStrictSuperset(of: Set<Element>): Boolean = isStrictSuperset(of as Sequence<Element>)

    override fun equals(other: Any?): Boolean {
        if (other === this) {
            return true
        }
        if (other as? Set<*> == null) {
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
    override fun scopy(): MutableStruct = Set(this, nocopy = true)
}
