// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
package skip.lib

import kotlin.coroutines.*
import kotlinx.coroutines.*

class Task<T> {
    private var deferred: Deferred<T>

    // WARNING: We currently run any non-detached Task on the main thread rather than the current thread.
    // Kotlin does not have a built-in Dispatcher with stay-on-current-thread behavior
    constructor(priority: TaskPriority? = null, operation: suspend () -> T): this(priority, Dispatchers.Main, operation) {
    }

    constructor(priority: TaskPriority? = null, context: CoroutineContext, operation: suspend () -> T) {
        // TODO: Priority
        @OptIn(DelicateCoroutinesApi::class)
        deferred = GlobalScope.async(context) {
            operation()
        }
    }

    suspend fun value(): T = deferred.await()

    companion object {
        fun <T> detached(priority: TaskPriority? = null,
            operation: suspend () -> T): Task<T> {
            return Task(priority, Dispatchers.Default, operation)
        }

        //~~~
        suspend fun <T> run(operation: suspend () -> T): T {
            return withContext(Dispatchers.Default) {
                operation()
            }
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

suspend fun <T, R> T.mainactor(perform: suspend (T) -> R): R {
    //~~~ MainActor.run equivalent
    return perform(this)
}