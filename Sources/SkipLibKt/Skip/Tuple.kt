// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
package skip.lib

data class Tuple2<A, B>(val value0: A, val value1: B)

// These types are not themselves mutable, but their members might be, and a destructuring assignment can
// access members without calling sref() on them. So support sref() on the tuples themselves. Note that
// because the tuples aren't mutable, we can ignore the onUpdate closures

data class Tuple2<E0, E1>(val element0: E0, val element1: E1) {
    fun sref(onUpdate: ((Tuple2<E0, E1>) -> Unit)? = null): Tuple2<E0, E1> {
        val e0 = element0.sref()
        val e1 = element1.sref()
        if (e0 !== element0 || e1 !== element1) {
            return Tuple2(e0, e1)
        }
        return this
    }
}

data class Tuple3<E0, E1, E2>(val element0: E0, val element1: E1, val element2: E2) {
    fun sref(onUpdate: ((Tuple3<E0, E1, E2>) -> Unit)? = null): Tuple3<E0, E1, E2> {
        val e0 = element0.sref()
        val e1 = element1.sref()
        val e2 = element2.sref()
        if (e0 !== element0 || e1 !== element1 || e2 !== element2) {
            return Tuple3(e0, e1, e2)
        }
        return this
    }
}

data class Tuple4<E0, E1, E2, E3>(val element0: E0, val element1: E1, val element2: E2, val element3: E3) {
    fun sref(onUpdate: ((Tuple4<E0, E1, E2, E3>) -> Unit)? = null): Tuple4<E0, E1, E2, E3> {
        val e0 = element0.sref()
        val e1 = element1.sref()
        val e2 = element2.sref()
        val e3 = element3.sref()
        if (e0 !== element0 || e1 !== element1 || e2 !== element2 || e3 !== element3) {
            return Tuple4(e0, e1, e2, e3)
        }
        return this
    }
}

data class Tuple5<E0, E1, E2, E3, E4>(val element0: E0, val element1: E1, val element2: E2, val element3: E3, val element4: E4) {
    fun sref(onUpdate: ((Tuple5<E0, E1, E2, E3, E4>) -> Unit)? = null): Tuple5<E0, E1, E2, E3, E4> {
        val e0 = element0.sref()
        val e1 = element1.sref()
        val e2 = element2.sref()
        val e3 = element3.sref()
        val e4 = element4.sref()
        if (e0 !== element0 || e1 !== element1 || e2 !== element2 || e3 !== element3 || e4 !== element4) {
            return Tuple5(e0, e1, e2, e3, e4)
        }
        return this
    }
}
