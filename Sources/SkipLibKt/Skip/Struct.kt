// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
package skip.lib

interface MutableStruct {
    fun scopy(): MutableStruct
    var supdate: ((Any) -> Unit)?
    var smutatingcount: Int

    fun willmutate() {
        smutatingcount += 1
    }

    fun didmutate() {
        smutatingcount -= 1
        if (smutatingcount <= 0) {
            supdate?.invoke(this)
        }
    }
}

@Suppress("UNCHECKED_CAST")
fun <T> T.sref(onUpdate: ((T) -> Unit)? = null): T {
    if (this is MutableStruct) {
        val copy = scopy()
        copy.supdate = {
            if (onUpdate != null) {
                onUpdate(it as T)
            }
        }
        return copy as T
    }
    return this
}
