// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
#if SKIP
/// Skip `Logger` aliases to `SkipLogger` type and wraps `java.util.logging.Logger`
public typealias Logger = SkipLogger
public typealias LogMessage = String
#else
import os
/// Non-skip `Logger` is an alias to `os.Logger`
public typealias Logger = os.Logger
public typealias LogMessage = os.OSLogMessage
public typealias OSLog = os.OSLog
public typealias OSLogType = os.OSLogType
#endif

/// Logger cover for versions before Logger was available (which coincides with Concurrency)
///
/// - Note: Unlike other Foundation equivalent wrappers, `SkipLogger` cannot be exposed in
/// in Swift because `os.Logger` cannot be wrapped, as their string interpolation functions
/// must be literals.
public final class SkipLogger {
    #if SKIP
    let log: java.util.logging.Logger
    //let log: android.util.Log
    // TODO: use reflection to see if android.util.Log is available and use that instead
    // TODO: alernatively, implememnt a java.util.logging.Handler to pass logger calls through to android.util.Log
    #else
    let log: os.Logger
    #endif

    public enum LogType {
        case `default`
        case info
        case debug
        case error
        case fault
    }

    public init(subsystem: String, category: String) {
        #if SKIP
        // self.log = System.getLogger(subsystem + "." + category) // unavailable on Android
        self.log = java.util.logging.Logger.getLogger(subsystem + "." + category)
        #else
        self.log = os.Logger(subsystem: subsystem, category: category)
        #endif
    }

    public func log(_ message: LogMessage) {
        #if SKIP
        log.log(java.util.logging.Level.INFO, message)
        #else
        //log.log(message) // error in Swift: “Argument must be a string interpolation”
        print("LOG:", message)
        #endif
    }

    public func trace(_ message: LogMessage) {
        #if SKIP
        log.log(java.util.logging.Level.FINER, message)
        #else
        //log.trace(message) // error in Swift: “Argument must be a string interpolation”
        print("TRACE:", message)
        #endif
    }

    public func debug(_ message: LogMessage) {
        #if SKIP
        log.log(java.util.logging.Level.FINE, message)
        #else
        //log.debug(message) // error in Swift: “Argument must be a string interpolation”
        print("DEBUG:", message)
        #endif
    }

    public func info(_ message: LogMessage) {
        #if SKIP
        log.log(java.util.logging.Level.INFO, message)
        #else
        //log.info(message) // error in Swift: “Argument must be a string interpolation”
        print("INFO:", message)
        #endif
    }

    public func notice(_ message: LogMessage) {
        #if SKIP
        log.log(java.util.logging.Level.CONFIG, message)
        #else
        //log.notice(message) // error in Swift: “Argument must be a string interpolation”
        print("NOTICE:", message)
        #endif
    }

    public func warning(_ message: LogMessage) {
        #if SKIP
        log.log(java.util.logging.Level.WARNING, message)
        #else
        //log.warning(message) // error in Swift: “Argument must be a string interpolation”
        print("WARNING:", message)
        #endif
    }

    public func error(_ message: LogMessage) {
        #if SKIP
        log.log(java.util.logging.Level.SEVERE, message)
        #else
        //log.error(message) // error in Swift: “Argument must be a string interpolation”
        print("ERROR:", message)
        #endif
    }

    public func critical(_ message: LogMessage) {
        #if SKIP
        log.log(java.util.logging.Level.SEVERE, message)
        #else
        //log.critical(message) // error in Swift: “Argument must be a string interpolation”
        print("CRITICAL:", message)
        #endif
    }

    public func fault(_ message: LogMessage) {
        #if SKIP
        log.log(java.util.logging.Level.SEVERE, message)
        #else
        //log.fault(message) // error in Swift: “Argument must be a string interpolation”
        print("FAULT:", message)
        #endif
    }
}

