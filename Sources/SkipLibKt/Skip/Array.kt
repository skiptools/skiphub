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

class Array<Element>: AbstractMutableList<Element>, RandomAccessCollection<Element>, MutableCollection<Element>, MutableStruct {
    private var isStorageShared = false
    private var _mutableStorage: MutableList<Element>? = null
    private var _immutableStorage: List<Element>? = null

    // Use for read operations
    private val readStorage: List<Element>
        get() = _mutableStorage ?: _immutableStorage!!

    // Use for write operations. Copies our internal storage as needed
    private val writeStorage: MutableList<Element>
        get() {
            if (!isStorageShared) {
                var storage = _mutableStorage
                if (storage != null) {
                    return storage
                }
            }
            val storage = ArrayList(readStorage)
            isStorageShared = false
            _mutableStorage = storage
            _immutableStorage = null
            return storage
        }

    constructor() {
        _mutableStorage = ArrayList()
    }

        //~~~
//    init(repeating repeatedValue: Self.Element, count: Int)

    constructor(collection: Iterable<Element>, nocopy: Boolean = false, shared: Boolean = false) {
        // Don't use another of our Sequence impls as internal storage because we'll double-sref() elements
        if (nocopy) {
            if (collection is Array<*>) {
                // Share storage with the given array, marking it as shared in both
                val storage = collection._mutableStorage
                if (storage != null) {
                    if (shared) {
                        collection.isStorageShared = true
                        isStorageShared = true
                    }
                    _mutableStorage = storage as MutableList<Element>
                } else {
                    _immutableStorage = collection._immutableStorage as List<Element>
                }
            } else if (collection is MutableList<*>) {
                _mutableStorage = collection as MutableList<Element>
                isStorageShared = shared
            } else if (collection is List<*>) {
                _immutableStorage = collection as List<Element>
            }
        }
        if (_mutableStorage == null && _immutableStorage == null) {
            val storage = ArrayList<Element>()
            storage.addAll(collection)
            _mutableStorage = storage
        }
    }

    constructor(vararg elements: Element) {
        val storage = ArrayList<Element>()
        for (element in elements) {
            storage.add(element.sref())
        }
        _mutableStorage = storage
    }

    fun append(newElement: Element) {
        add(newElement)
    }

    // Overrides

    override val size: Int
        get() = readStorage.size

    override fun add(index: Int, element: Element) {
        willmutate()
        writeStorage.add(index, element.sref())
        didmutate()
    }

    override fun removeAt(index: Int): Element {
        willmutate()
        val ret = writeStorage.removeAt(index)
        didmutate()
        return ret
    }

    override fun get(index: Int): Element {
        return readStorage[index].sref({
            set(index, it)
        })
    }

    override fun set(index: Int, element: Element): Element {
        willmutate()
        val ret = writeStorage.set(index, element.sref())
        didmutate()
        return ret
    }

    override fun makeIterator(): IteratorProtocol<Element> {
        val iter = iterator()
        return object: IteratorProtocol<Element> {
            override fun next(): Element? {
                return if (iter.hasNext()) iter.next() else null
            }
        }
    }

    override fun equals(other: Any?): Boolean {
        if (other === this) {
            return true
        }
        if (other as? Array<*> == null) {
            return false
        }
        return other.readStorage == readStorage
    }

    // MutableStruct

    override var supdate: ((Any) -> Unit)? = null
    override var smutatingcount = 0
    override fun scopy(): MutableStruct {
        return Array(this, nocopy = true, shared = true)
    }
}
