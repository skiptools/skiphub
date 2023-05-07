// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
package skip.lib

fun String(string: String): String = string
fun String(character: Char): String = character.toString()

fun String(sequence: Sequence<Char>): String {
    return StringBuilder().apply {
        sequence.forEach { append(it) }
    }.toString()
}

fun String(repeating: String, count: Int): String {
    return StringBuilder().apply {
        repeat(count) {
            append(repeating)
        }
    }.toString()
}

fun String.hasPrefix(prefix: String): Boolean = startsWith(prefix)

fun String.hasSuffix(suffix: String): Boolean = endsWith(suffix)

// String.contains(String) used as-is

// MARK: - Sequence

fun String.makeIterator(): IteratorProtocol<Char> {
    val iter = iterator()
    return object: IteratorProtocol<Char> {
        override fun next(): Char? {
            return if (iter.hasNext()) iter.next() else null
        }
    }
}

val String.underestimatedCount: Int
    get() = 0

fun <T> String.withContiguousStorageIfAvailable(body: (Any) -> T): T? = null

fun <RE> String.map(transform: (Char) -> RE): Array<RE> {
    return Array(map(transform), nocopy = true)
}

fun String.filter(isIncluded: (Char) -> Boolean): Array<Char> {
    return Array(filter(isIncluded), nocopy = true)
}

// String.forEach used as-is

fun String.first(where: (Char) -> Boolean): Char? = firstOrNull(where)

fun String.dropFirst(k: Int = 1): String = drop(k)

// String.dropLast(k) used as-is
fun String.dropLast(): String = dropLast(1)

fun String.enumerated(): Sequence<Tuple2<Int, Char>> {
    val stringIterator = { iterator() }
    val iterable = object: Iterable<Tuple2<Int, Char>> {
        override fun iterator(): Iterator<Tuple2<Int, Char>> {
            var offset = 0
            val iter = stringIterator()
            return object: Iterator<Tuple2<Int, Char>> {
                override fun hasNext(): Boolean = iter.hasNext()
                override fun next(): Tuple2<Int, Char> = Tuple2(offset++, iter.next())
            }
        }
    }
    return object: Sequence<Tuple2<Int, Char>> {
        override val iterableStorage: Iterable<Tuple2<Int, Char>>
        get() = iterable
    }
}

fun String.contains(where: (Char) -> Boolean): Boolean {
    for (c in this) {
        if (where(c)) return true
    }
    return false
}

// Warning: Although 'initialResult' is not a labeled parameter in Swift, the transpiler inserts it
// into our Kotlin call sites to differentiate between calls to the two reduce() functions. Do not change
fun <R> String.reduce(initialResult: R, nextPartialResult: (R, Char) -> R): R {
    return fold(initialResult, nextPartialResult)
}

fun <R> String.reduce(unusedp: Nothing? = null, into: R, updateAccumulatingResult: (InOut<R>, Char) -> Unit): R {
    return fold(into) { result, element ->
        var accResult = result
        val inoutAccResult = InOut<R>({ accResult }, { accResult = it })
        updateAccumulatingResult(inoutAccResult, element)
        accResult
    }
}

// String.reversed() used as-is

fun <RE> String.flatMap(transform: (Char) -> Sequence<RE>): Array<RE> {
    return Array(flatMap { transform(it) }, nocopy = true)
}

fun <RE> String.compactMap(transform: (Char) -> RE?): Array<RE> {
    return Array(mapNotNull(transform), nocopy = true)
}

fun String.sorted(): Array<Char> {
    return Array(sorted(), nocopy = true)
}

// String.contains(char: Char) used as-is

// MARK: - Collection

val String.startIndex: Int
    get() = 0
val String.endIndex: Int
    get() = count()

// String.get(position: int) used as-is

val String.isEmpty: Boolean
    get() = isEmpty()

val String.count: Int
    get() = count()

fun String.index(i: Int, offsetBy: Int): Int  = i + offsetBy
fun String.distance(from: Int, to: Int): Int  = to - from
fun String.index(after: Int): Int = after + 1

val String.first: Char?
    get() = firstOrNull()

fun String.firstIndex(of: Char): Int? {
    val index = indexOf(of)
    return if (index == -1) null else index
}
// Skip can't differentiate between Char and String args
fun String.firstIndex(of: String): Int? {
    return firstIndex(of[0])
}

operator fun String.get(range: IntRange): String {
    // We translate open ranges to use Int.MIN_VALUE and MAX_VALUE in Kotlin
    val lowerBound = if (range.start == Int.MIN_VALUE) 0 else range.start
    val upperBound = if (range.endInclusive == Int.MAX_VALUE) count() else range.endInclusive + 1
    return slice(lowerBound until upperBound).toString()
}

// MARK: - BidirectionalCollection

fun String.last(where: (Char) -> Boolean): Char? = lastOrNull(where)

val String.last: Char?
    get() = lastOrNull()
