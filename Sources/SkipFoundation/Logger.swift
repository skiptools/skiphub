// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
#if !SKIP
import os

public typealias OSLog = os.OSLog
public typealias OSLogType = os.OSLogType

#if canImport(Concurrency)
@available(macOS 11, iOS 14, watchOS 7, tvOS 14, *)
public typealias Logger = os.Logger
@available(macOS 11, iOS 14, watchOS 7, tvOS 14, *)
public typealias OSLogMessage = os.OSLogMessage
#else
//public typealias Logger = LoggerShim
//public typealias OSLogMessage = StaticString
#endif


/// Logger cover for versions before Logger was available (which coincides with Concurrency)
public final class LoggerShim {
    let log: os.OSLog

    public init(subsystem: String, category: String) {
        self.log = os.OSLog(subsystem: subsystem, category: category)
    }

    public func log(_ message: String) {
    }

    public func trace(_ message: String) {
    }

    public func debug(_ message: String) {
    }

    public func info(_ message: String) {
    }

    public func notice(_ message: String) {
    }

    public func warning(_ message: String) {
    }

    public func error(_ message: String) {
    }

    public func critical(_ message: String) {
    }

    public func fault(_ message: String) {
    }
}

#else
// SKIP INSERT: import java.util.logging.Logger
// SKIP INSERT: import java.util.logging.Level

/// The logger type in Java is just the logger itself
//public typealias Logger = java.util.logging.Logger

/// In swift, this is a custom type that does lazy interpolation
public typealias OSLogMessage = String


public extension Logger {
    // error: /opt/src/github/skiptools/skiphub/Sources/SkipFoundation/Logger.swift:105:5 Cannot use an extension to add additional constructors to a Kotlin type defined outside of this module
    //public init(subsystem: String, category: String) {
    //    self = Logger.getLogger(subsystem + "/" + category)
    //}
}

/// Simulate a constructor extension
public func Logger(subsystem: String, category: String) -> Logger {
    Logger.getLogger(subsystem + "/" + category)
}

// FIXME: workaround “Enum class cannot inherit from classes” when it inserts Hashable extension
// SKIP REPLACE: enum class OSLogType { default, info, debug, error, fault; companion object { } }
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
