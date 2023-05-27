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
    /// The global `processInfo` must be set manually at app launch with `skip.foundation.ProcessInfo.launch(context)`
    /// Otherwise error: `skip.lib.ErrorException: kotlin.UninitializedPropertyAccessException: lateinit property processInfo has not been initialized`
    public static var processInfo: SkipProcessInfo = SkipProcessInfo()

    init() {
    }

    /// The Android context for the process, which should have been set on app launch, and will fall back on using an Android test context.
    public var androidContext: android.content.Context! {
        launchContext ?? testContext
    }

    /// Called when an app is launched to store the global context from the `android.app.Application` subclass.
    public static func launch(context: android.content.Context) {
        SkipProcessInfo.processInfo.launchContext = context
    }

    private var testContext: android.content.Context {
        // fallback to assuming we are running in a test environment
        // we don't have a compile dependency on android test, so we need to load using reflection
        // androidx.test.core.app.ApplicationProvider.getApplicationContext()
        return Class.forName("androidx.test.core.app.ApplicationProvider")
            .getDeclaredMethod("getApplicationContext")
            .invoke(nil) as android.content.Context
    }

    private var launchContext: android.content.Context?

    #else
    public static var processInfo = SkipProcessInfo(rawValue: Foundation.ProcessInfo.processInfo)
    let rawValue: Foundation.ProcessInfo

    init(rawValue: Foundation.ProcessInfo) {
        self.rawValue = rawValue
    }
    #endif

    open var globallyUniqueString: String {
        #if !SKIP
        return rawValue.globallyUniqueString
        #else
        return UUID().description
        #endif
    }

    #if SKIP
    /// The system properties in a JVM consists of both the environment variables as well as the
    private let systemProperties: Dictionary<String, String> = Self.buildSystemProperties()

    private static func buildSystemProperties() -> Dictionary<String, String> {
        var dict: [String: String] = [:]
        for (key, value) in System.getenv() {
            dict[key] = value
        }
        for (key, value) in System.getProperties() {
            dict[key.toString()] = value.toString()
        }
        return dict
    }
    #endif

    open var environment: [String : String] {
        #if !SKIP
        return rawValue.environment
        #else
        return systemProperties
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
            // return java.lang.ProcessHandle.current().pid().toInt() // JDK9+, so doesn't compile
            // JMX name is "pid@hostname" (e.g., "57924@zap.local")
            // return java.lang.management.ManagementFactory.getRuntimeMXBean().getName().split("@").first?.toLong() ?? -1
            return -1
        }
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
        // Android 30+: NetworkOnMainThreadException
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

    open var processorCount: Int {
        #if !SKIP
        return rawValue.processorCount
        #else
        return Runtime.getRuntime().availableProcessors()
        #endif
    }

    open var operatingSystemVersionString: String {
        #if !SKIP
        return rawValue.operatingSystemVersionString
        #else
        return android.os.Build.VERSION.RELEASE
        #endif
    }
}
