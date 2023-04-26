// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
package skip.lib

interface Error {
}

fun Throwable.aserror(): Error {
    if (this is Error) {
        return this
    } else {
        return ErrorException(this)
    }
}

class ErrorException(cause: Throwable): Exception(cause), Error {
}
