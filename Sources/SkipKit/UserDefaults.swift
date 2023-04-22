// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
#if !SKIP
import class Foundation.UserDefaults
public typealias UserDefaults = Foundation.UserDefaults
#else
public typealias UserDefaults = SkipUserDefaults
#endif

// let prefs: android.content.SharedPreferences = androidContext().getSharedPreferences("app_prefs", android.content.Context.MODE_PRIVATE)

#if SKIP

public struct SkipUserDefaults : RawRepresentable, Hashable {
    public let rawValue: android.content.SharedPreferences

    public init(rawValue: android.content.SharedPreferences) {
        self.rawValue = rawValue
    }

    public init(_ rawValue: android.content.SharedPreferences) {
        self.rawValue = rawValue
    }
}

extension SkipUserDefaults {
    public static var standard: SkipUserDefaults {
        // FIXME: uses androidx.test and
        SkipUserDefaults(androidContext().getSharedPreferences("defaults", android.content.Context.MODE_PRIVATE))
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

