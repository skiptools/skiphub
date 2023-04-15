// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
#if !SKIP
import SkipFoundation
#endif

internal func SkipDeviceInternalModuleName() -> String {
    return "SkipDevice"
}

public func SkipDevicePublicModuleName() -> String {
    return "SkipDevice"
}

#if SKIP
/// Access the current global android Context.
///
/// NOTE: this only works in Robolectric testing for now – we do not yet have a plan for how Context access should be done, since many things (SharedPreferences, WebKit, etc) rely on having one, whereas Swift counterparts do not
public func androidContext() -> android.content.Context {
    // we don't have a compile dependency on android test, so we need to load using reflection
    //androidx.test.core.app.ApplicationProvider.getApplicationContext()
    Class.forName("androidx.test.core.app.ApplicationProvider")
        .getDeclaredMethod("getApplicationContext")
        .invoke(nil) as android.content.Context
}
#endif

