// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
package skip.lib

import android.provider.Settings.Global
import kotlinx.coroutines.*
import java.lang.IllegalStateException
import java.util.concurrent.ThreadPoolExecutor
import kotlin.coroutines.CoroutineContext
import kotlin.coroutines.EmptyCoroutineContext
import kotlin.coroutines.coroutineContext

class Task<T> {
    private var deferred: Deferred<T>

    constructor(priority: TaskPriority? = null, operation: suspend () -> T): this(priority, Dispatchers.Main, operation) {
    }

    constructor(priority: TaskPriority? = null, context: CoroutineContext, operation: suspend () -> T) {
        print("IN CONSTRUCTOR: ${Thread.currentThread().hashCode()}")
        @OptIn(DelicateCoroutinesApi::class)
        deferred = GlobalScope.async(context) {
            print("IN ASYNC: ${Thread.currentThread().hashCode()}")
            operation()
        }
        print("DONE CONSTRUCTOR ${Thread.currentThread().hashCode()}")
    }

    //~~~
    suspend fun value(): T {
        print("IN VALUE(): ${Thread.currentThread().hashCode()}")
        val value = deferred.await()
        print("AFTER AWAIT ${Thread.currentThread().hashCode()}")
        return value
    }

    companion object {
        fun <T> detached(priority: TaskPriority? = null,
            operation: suspend () -> T): Task<T> {
            return Task(priority, Dispatchers.Default, operation)
        }
    }
}

class TaskPriority(override val rawValue: Int): RawRepresentable<Int> {
    override fun equals(other: Any?): Boolean {
        return rawValue == (other as? TaskPriority)?.rawValue
    }

    override fun hashCode(): Int = rawValue.hashCode()

    companion object {
        val high = TaskPriority(25)
        val medium = TaskPriority(21)
        val low = TaskPriority(17)
        val userInitiated = high
        val utility = low
        val background = TaskPriority(9)
    }
}