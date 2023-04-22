// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
#if !SKIP
@_exported import SkipFoundation
@_exported import OSLog
#endif

internal func SkipKitInternalModuleName() -> String {
    return "SkipKit"
}

public func SkipKitPublicModuleName() -> String {
    return "SkipKit"
}

#if SKIP

/// Access the current global android Context.
///
/// NOTE: this only works in Robolectric testing for now – we do not yet have a plan for how Context access should be done, since many things (SharedPreferences, WebKit, etc) rely on having one, whereas Swift counterparts do not
public func androidContext() -> android.content.Context {
    // fall back on trying to get the
    // we don't have a compile dependency on android test, so we need to load using reflection
    //androidx.test.core.app.ApplicationProvider.getApplicationContext()
    Class.forName("androidx.test.core.app.ApplicationProvider")
        .getDeclaredMethod("getApplicationContext")
        .invoke(nil) as android.content.Context
}

// TODO: to handle global access to context in a real Android app, we can implement something like this and configure `AndroidManifest.xml` as so:
//
// <application android:name=".ApplicationContextProvider" android:label="@string/app_name">
//
// after which we should be able to obtain the global app context with: `ApplicationContextProvider.getContext()`
//

//public class ApplicationContextProvider extends Application {
//    private static Context mContext;
//
//    @Override
//    public void onCreate() {
//        super.onCreate();
//        mContext = getApplicationContext();
//    }
//
//    public static Context getContext() {
//        return mContext;
//    }
//}

#endif

