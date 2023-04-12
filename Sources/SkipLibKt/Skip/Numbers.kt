// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
package skip.lib

val Byte.Companion.max: Byte get() = Byte.MAX_VALUE
val Byte.Companion.min: Byte get() = Byte.MIN_VALUE
val UByte.Companion.max: Byte get() = Byte.MAX_VALUE
val UByte.Companion.min: UByte get() = UByte.MIN_VALUE

val Short.Companion.max: Short get() = Short.MAX_VALUE
val Short.Companion.min: Short get() = Short.MIN_VALUE
val UShort.Companion.max: UShort get() = UShort.MAX_VALUE
val UShort.Companion.min: UShort get() = UShort.MIN_VALUE

val Int.Companion.max: Int get() = Int.MAX_VALUE
val Int.Companion.min: Int get() = Int.MIN_VALUE
val UInt.Companion.max: UInt get() = UInt.MAX_VALUE
val UInt.Companion.min: UInt get() = UInt.MIN_VALUE

val Long.Companion.max: Long get() = Long.MAX_VALUE
val Long.Companion.min: Long get() = Long.MIN_VALUE
val ULong.Companion.max: ULong get() = ULong.MAX_VALUE
val ULong.Companion.min: ULong get() = ULong.MIN_VALUE

fun Int(number: Number): Int = number.toInt()
fun Byte(number: Number): Byte = number.toInt().toByte()
fun Short(number: Number): Short = number.toInt().toShort()
fun Long(number: Number): Long = number.toLong()

fun UInt(number: Number): UInt = number.toLong().toULong().toUInt()
fun UByte(number: Number): UByte = number.toLong().toULong().toUByte()
fun UShort(number: Number): UShort = number.toLong().toULong().toUShort()
fun ULong(number: Number): ULong = number.toLong().toULong()

fun Float(number: Number): Float = number.toFloat()
fun Double(number: Number): Double = number.toDouble()
