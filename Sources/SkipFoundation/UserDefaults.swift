// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
#if !SKIP
@_implementationOnly import class Foundation.UserDefaults
internal typealias PlatformUserDefaults = Foundation.UserDefaults
#else
internal typealias PlatformUserDefaults = android.content.SharedPreferences
#endif

/// An interface to the user’s defaults database, where you store key-value pairs persistently across launches of your app.
public class UserDefaults {
    let rawValue: PlatformUserDefaults

    init(rawValue: PlatformUserDefaults) {
        self.rawValue = rawValue
    }

    init(_ rawValue: PlatformUserDefaults) {
        self.rawValue = rawValue
    }
}

#if SKIP
extension UserDefaults {
    public static var standard: UserDefaults {
        // FIXME: uses androidx.test and
        UserDefaults(ProcessInfo.processInfo.androidContext.getSharedPreferences("defaults", android.content.Context.MODE_PRIVATE))
    }

    public func `set`(_ value: Int, forKey keyName: String) {
        let prefs = rawValue.edit()
        prefs.putInt(keyName, value)
        prefs.apply()
    }

    public func `set`(_ value: Boolean, forKey keyName: String) {
        let prefs = rawValue.edit()
        prefs.putBoolean(keyName, value)
        prefs.apply()
    }

    public func `set`(_ value: Double, forKey keyName: String) {
        let prefs = rawValue.edit()
        prefs.putFloat(keyName, value.toFloat())
        prefs.apply()
    }

    public func `set`(_ value: String, forKey keyName: String) {
        let prefs = rawValue.edit()
        prefs.putString(keyName, value)
        prefs.apply()
    }

    public func string(forKey keyName: String) -> String? {
        rawValue.getString(keyName, nil)
    }

    public func double(forKey keyName: String) -> Double? {
        !rawValue.contains(keyName) ? nil : rawValue.getFloat(keyName, 0.toFloat()).toDouble()
    }

    public func integer(forKey keyName: String) -> Int? {
        !rawValue.contains(keyName) ? nil : rawValue.getInt(keyName, 0)
    }

    public func bool(forKey keyName: String) -> Bool? {
        !rawValue.contains(keyName) ? nil : rawValue.getBoolean(keyName, false)
    }

}
#endif
