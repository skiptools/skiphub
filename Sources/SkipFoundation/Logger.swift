// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
#if !SKIP
import os

public typealias Logger = os.Logger
public typealias OSLogType = os.OSLogType
public typealias OSLogMessage = os.OSLogMessage
public typealias OSLog = os.OSLog

#elseif SKIP_LOGGING_ANDROID // skip.foundation does not rely on Android

// https://developer.android.com/reference/android/util/Log
// os.log.Logger to android.util.Log
// SKIP INSERT: import android.util.Log
/// In swift, this is a custom type that does lazy interpolation
public typealias OSLogMessage = String

// TODO: remove once we have constructors
// SKIP REPLACE: public class Logger(val subsystem: String, val category: String) { }
public final class Logger {
    public let subsystem: String
    public let category: String

    public init(subsystem: String, category: String) {
        self.subsystem = subsystem
        self.category = category
    }
}

// TODO: fix once we have enums
// SKIP REPLACE: public enum class OSLogType { default, info, debug, error, fault }
public enum OSLogType {
    case `default`
    case info
    case debug
    case error
    case fault
}

extension Logger {
    public func log(level: OSLogType, message: OSLogMessage) {
        if (level == OSLogType.default) {
            log(message)
        } else if (level == OSLogType.info) {
            info(message)
        } else if (level == OSLogType.debug) {
            debug(message)
        } else if (level == OSLogType.error) {
            error(message)
        } else if (level == OSLogType.fault) {
            fault(message)
        }
    }

    public func log(message: OSLogMessage) {
        Log.i(subsystem + "/" + category, message)
    }

    public func trace(message: OSLogMessage) {
        Log.v(subsystem + "/" + category, message)
    }

    public func debug(message: OSLogMessage) {
        Log.d(subsystem + "/" + category, message)
    }

    public func info(message: OSLogMessage) {
        Log.i(subsystem + "/" + category, message)
    }

    public func notice(message: OSLogMessage) {
        Log.i(subsystem + "/" + category, message)
    }

    public func warning(message: OSLogMessage) {
        Log.w(subsystem + "/" + category, message)
    }

    public func error(message: OSLogMessage) {
        Log.e(subsystem + "/" + category, message)
    }

    public func critical(message: OSLogMessage) {
        Log.wtf(subsystem + "/" + category, message)
    }

    public func fault(message: OSLogMessage) {
        Log.wtf(subsystem + "/" + category, message)
    }
}
#else
// SKIP INSERT: import java.util.logging.Logger
// SKIP INSERT: import java.util.logging.Level

/// In swift, this is a custom type that does lazy interpolation
public typealias OSLogMessage = String

public extension Logger {
    // error: /opt/src/github/skiptools/skip-core/Sources/SkipFoundation/Logger.swift:105:5 Cannot use an extension to add additional constructors to a Kotlin type defined outside of this module
    //public init(subsystem: String, category: String) {
    //    self = Logger.getLogger(subsystem + "/" + category)
    //}
}

/// Simulate a constructor extension
public func Logger(subsystem: String, category: String) -> Logger {
    Logger.getLogger(subsystem + "/" + category)
}

public enum OSLogType {
    case `default`
    case info
    case debug
    case error
    case fault
}

extension Logger {
    public func log(level: OSLogType, message: OSLogMessage) {
        if (level == OSLogType.default) {
            log(message)
        } else if (level == OSLogType.info) {
            info(message)
        } else if (level == OSLogType.debug) {
            debug(message)
        } else if (level == OSLogType.error) {
            error(message)
        } else if (level == OSLogType.fault) {
            fault(message)
        }
    }

    /// Log a message at `OSLogType.info`, which is logged in Java as `java.util.logging.Level.INFO`
    public func log(message: OSLogMessage) {
        log(Level.INFO, message)
    }

    /// Log a message at `OSLogType.debug`, which is logged in Java as `java.util.logging.Level.FINEST`
    public func trace(message: OSLogMessage) {
        log(Level.FINEST, message)
    }

    /// Log a message at `OSLogType.debug`, which is logged in Java as `java.util.logging.Level.FINE`
    public func debug(message: OSLogMessage) {
        log(Level.FINE, message)
    }

    /// Log a message at `OSLogType.info`, which is logged in Java as `java.util.logging.Level.INFO`
    public func info(message: OSLogMessage) {
        log(Level.INFO, message)
    }

    /// Log a message at `OSLogType.info`, which is logged in Java as `java.util.logging.Level.CONFIG`
    public func notice(message: OSLogMessage) {
        log(Level.CONFIG, message)
    }

    /// Log a message at `OSLogType.warning`, which is logged in Java as `java.util.logging.Level.WARNING`
    public func warning(message: OSLogMessage) {
        log(Level.WARNING, message)
    }

    /// Log a message at `OSLogType.error`, which is logged in Java as `java.util.logging.Level.SEVERE`
    public func error(message: OSLogMessage) {
        log(Level.SEVERE, message)
    }

    /// Log a message at `OSLogType.error`, which is logged in Java as `java.util.logging.Level.SEVERE`
    public func critical(message: OSLogMessage) {
        log(Level.SEVERE, message)
    }

    /// Log a message at `OSLogType.fault`, which is logged in Java as `java.util.logging.Level.SEVERE`
    public func fault(message: OSLogMessage) {
        log(Level.SEVERE, message)
    }
}

#endif
