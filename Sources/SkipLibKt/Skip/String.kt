// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
package skip.lib

// The String constructor that accepts a String
fun String(string: String): String {
	return string
}

// The String constructor that repeats a Character
fun String(repeating: String, count: Int): String {
	return StringBuilder().apply {
		repeat(count) {
			append(repeating)
		}
	}.toString()
}

// Pass the count property to the function count()
val String.count: Int
	get() = this.count()

// Pass the first property to the function first()
val String.first: Char
	get() = this.first()

// Pass the last property to the function last()
val String.last: Char
	get() = this.last()

// Pass the isEmpty property to the function isEmpty
val String.isEmpty: Boolean
	get() = this.isEmpty()

fun String.hasPrefix(prefix: String): Boolean {
	return this.startsWith(prefix)
}

fun String.hasSuffix(suffix: String): Boolean {
	return this.endsWith(suffix)
}

fun String.firstIndex(of: String): Int? {
	for (i in this.indices) {
		if (this.startsWith(of, startIndex = i)) {
			return i
		}
	}
	return null
}
