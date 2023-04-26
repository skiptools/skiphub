// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
package skip.lib

import kotlin.reflect.*

fun fatalError(message: String = "fatalError"): Nothing = error(message)

fun type(of: Any): KClass<*> {
    return of::class
}

fun <T> swap(a: InOut<T>, b: InOut<T>) {
    val t = a.value
    a.value = b.value
    b.value = t
}

fun <T : Comparable<T>> min(a: T, b: T): T {
	return if (a <= b) a else b
}

fun <T : Comparable<T>> max(a: T, b: T): T {
	return if (a >= b) a else b
}

class NullReturnException: Exception() {
}

fun print(arg1: Any?, arg2: Any? = null, arg3: Any? = null, arg4: Any? = null, arg5: Any? = null, arg6: Any? = null, arg7: Any? = null, arg8: Any? = null, arg9: Any? = null, separator: String = " ", terminator: String = "\n") {
	arg1?.let { a -> kotlin.io.print(a) }
	arg2?.let { a -> kotlin.io.print(separator); kotlin.io.print(a) }
	arg3?.let { a -> kotlin.io.print(separator); kotlin.io.print(a) }
	arg4?.let { a -> kotlin.io.print(separator); kotlin.io.print(a) }
	arg5?.let { a -> kotlin.io.print(separator); kotlin.io.print(a) }
	arg6?.let { a -> kotlin.io.print(separator); kotlin.io.print(a) }
	arg7?.let { a -> kotlin.io.print(separator); kotlin.io.print(a) }
	arg8?.let { a -> kotlin.io.print(separator); kotlin.io.print(a) }
	arg9?.let { a -> kotlin.io.print(separator); kotlin.io.print(a) }
	kotlin.io.print(terminator)
}

fun debugPrint(arg1: Any?, arg2: Any? = null, arg3: Any? = null, arg4: Any? = null, arg5: Any? = null, arg6: Any? = null, arg7: Any? = null, arg8: Any? = null, arg9: Any? = null, separator: String = " ", terminator: String = "\n") {
	arg1?.let { a -> kotlin.io.print(a) }
	arg2?.let { a -> kotlin.io.print(separator); kotlin.io.print(a) }
	arg3?.let { a -> kotlin.io.print(separator); kotlin.io.print(a) }
	arg4?.let { a -> kotlin.io.print(separator); kotlin.io.print(a) }
	arg5?.let { a -> kotlin.io.print(separator); kotlin.io.print(a) }
	arg6?.let { a -> kotlin.io.print(separator); kotlin.io.print(a) }
	arg7?.let { a -> kotlin.io.print(separator); kotlin.io.print(a) }
	arg8?.let { a -> kotlin.io.print(separator); kotlin.io.print(a) }
	arg9?.let { a -> kotlin.io.print(separator); kotlin.io.print(a) }
	kotlin.io.print(terminator)
}
