// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
#if !SKIP
import class Foundation.ProcessInfo
public typealias ProcessInfo = Foundation.ProcessInfo
#else
public typealias ProcessInfo = SkipProcessInfo
#endif

public class SkipProcessInfo {
    #if SKIP
    public static let processInfo = SkipProcessInfo()
    #else
    public static var processInfo = SkipProcessInfo(rawValue: Foundation.ProcessInfo.processInfo)

    init(rawValue: Foundation.ProcessInfo) {
        self.rawValue = rawValue
    }

    let rawValue: Foundation.ProcessInfo
    #endif

    open var globallyUniqueString: String {
        #if !SKIP
        return rawValue.globallyUniqueString
        #else
        return UUID().description
        #endif
    }

    open var environment: [String : String] {
        #if !SKIP
        return rawValue.environment
        #else
        //return Dictionary(System.getenv())
        var env: [String: String] = [:]
        for (key, value) in System.getenv() {
            env[key] = value
        }
        return env
        #endif
    }

    open var processIdentifier: Int32 {
        #if !SKIP
        return rawValue.processIdentifier
        #else
        do {
            return android.os.Process.myPid()
        } catch {
            // seems to happen in Robolectric tests
            return -1
        }
        //return java.lang.ProcessHandle.current().pid().toInt()
        #endif
    }

    open var arguments: [String] {
        #if !SKIP
        return rawValue.arguments
        #else
        return [] // no arguments on Android
        #endif
    }

    open var hostName: String {
        #if !SKIP
        return rawValue.hostName
        #else
        return java.net.InetAddress.getLocalHost().hostName
        #endif
    }

    open var processName: String {
        #if !SKIP
        return rawValue.processName
        #else
        fatalError("TODO: ProcessInfo")
        #endif
    }

    open var operatingSystemVersionString: String {
        #if !SKIP
        return rawValue.operatingSystemVersionString
        #else
        fatalError("TODO: ProcessInfo")
        #endif
    }
}
