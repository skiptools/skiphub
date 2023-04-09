// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
package skip.lib

typealias Int8 = kotlin.Byte
typealias UInt8 = kotlin.UByte

typealias Int16 = kotlin.Short
typealias UInt16 = kotlin.UShort

typealias Int32 = kotlin.Int
typealias UInt32 = kotlin.UInt

typealias Int64 = kotlin.Long
typealias UInt64 = kotlin.ULong

//typealias Int = kotlin.Int64
//typealias UInt = kotlin.UInt64
typealias Int = kotlin.Int
typealias UInt = kotlin.UInt

typealias Float = kotlin.Float
typealias Double = kotlin.Double

val kotlin.Byte.Companion.max: Int8 get() = Int8.MAX_VALUE
val kotlin.Byte.Companion.min: Int8 get() = Int8.MIN_VALUE
val kotlin.UByte.Companion.max: UInt8 get() = UInt8.MAX_VALUE
val kotlin.UByte.Companion.min: UInt8 get() = UInt8.MIN_VALUE

val kotlin.Short.Companion.max: Int16 get() = Int16.MAX_VALUE
val kotlin.Short.Companion.min: Int16 get() = Int16.MIN_VALUE
val kotlin.UShort.Companion.max: UInt16 get() = UInt16.MAX_VALUE
val kotlin.UShort.Companion.min: UInt16 get() = UInt16.MIN_VALUE

val kotlin.Int.Companion.max: Int32 get() = Int32.MAX_VALUE
val kotlin.Int.Companion.min: Int32 get() = Int32.MIN_VALUE
val kotlin.UInt.Companion.max: UInt32 get() = UInt32.MAX_VALUE
val kotlin.UInt.Companion.min: UInt32 get() = UInt32.MIN_VALUE

val kotlin.Long.Companion.max: Int64 get() = Int64.MAX_VALUE
val kotlin.Long.Companion.min: Int64 get() = Int64.MIN_VALUE
val kotlin.ULong.Companion.max: UInt64 get() = UInt64.MAX_VALUE
val kotlin.ULong.Companion.min: UInt64 get() = UInt64.MIN_VALUE

fun Int(number: Number): Int = number.toInt()
fun Int8(number: Number): Int8 = number.toInt().toByte()
fun Int16(number: Number): Int16 = number.toInt().toShort()
fun Int32(number: Number): Int32 = number.toInt().toInt()
fun Int64(number: Number): Int64 = number.toLong()

fun UInt(number: Number): UInt = number.toLong().toULong().toUInt()
fun UInt8(number: Number): UInt8 = number.toLong().toULong().toUByte()
fun UInt16(number: Number): UInt16 = number.toLong().toULong().toUShort()
fun UInt32(number: Number): UInt32 = number.toLong().toULong().toUInt()
fun UInt64(number: Number): UInt64 = number.toLong().toULong()

fun Float(number: Number): Float = number.toFloat()
fun Double(number: Number): Double = number.toDouble()
