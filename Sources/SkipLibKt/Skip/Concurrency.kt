// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
package skip.lib

import kotlinx.coroutines.*

class Task<Success, Failure> where Failure: Error {
//    private val job: Job

    constructor(priority: TaskPriority? = null, operation: () -> Success) {
//        @OptIn(DelicateCoroutinesApi::class)
//        job = GlobalScope.launch(operation)
    }

    companion object {
        fun <Success, Failure> detached(priority: TaskPriority? = null,
            operation: () -> Success): Task<Success, Failure> where Failure: Error {
            //~~~
            return Task(priority, operation)
        }
    }
}

class TaskPriority(override val rawValue: Int): RawRepresentable<Int> {
    override fun equals(other: Any?): Boolean {
        return rawValue == (other as? TaskPriority)?.rawValue
    }

    override fun hashCode(): Int = rawValue.hashCode()

    companion object {
        val high: TaskPriority = TaskPriority(25)
        val medium: TaskPriority = TaskPriority(21)
        val low: TaskPriority = TaskPriority(17)
        val userInitiated: TaskPriority = high
        val utility: TaskPriority = low
        val background: TaskPriority = TaskPriority(9)
    }
}