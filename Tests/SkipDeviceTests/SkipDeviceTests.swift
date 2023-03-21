// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
#if !SKIP
@testable import SkipDevice
#endif
import XCTest
import SkipFoundation

// SKIP INSERT: @org.junit.runner.RunWith(org.robolectric.RobolectricTestRunner::class)
// SKIP INSERT: @org.robolectric.annotation.Config(manifest=org.robolectric.annotation.Config.NONE)
final class SkipDeviceTests: XCTestCase {
    var logger = Logger(subsystem: "test", category: "BundleTests")

    // SKIP INSERT: @Test
    func testSkipDevice() throws {
        print("Running: testSkipDevice…")
        logger.log("running testSkipDevice")
        
        XCTAssertEqual(3.0 + 1.5, 9.0/2)
        XCTAssertEqual("SkipDevice", SkipDeviceInternalModuleName())
        XCTAssertEqual("SkipDevice", SkipDevicePublicModuleName())
        XCTAssertEqual("SkipFoundation", SkipFoundationPublicModuleName())

        // load some interesting Android classes that are available via robolectric…
        #if SKIP
        Class.forName("android.Manifest")

        Class.forName("android.animation.Animator")
        Class.forName("android.animation.AnimatorSet")
        Class.forName("android.animation.ArgbEvaluator")
        Class.forName("android.animation.ObjectAnimator")
        Class.forName("android.animation.TimeInterpolator")
        Class.forName("android.animation.TypeEvaluator")
        Class.forName("android.animation.ValueAnimator")
        Class.forName("android.annotation.SuppressLint")
        Class.forName("android.annotation.TargetApi")

        Class.forName("android.app.Activity")
        Class.forName("android.app.ActivityManager")
        Class.forName("android.app.AlarmManager")
        Class.forName("android.app.AlertDialog")
        Class.forName("android.app.Application")
        Class.forName("android.app.DatePickerDialog")
        Class.forName("android.app.Dialog")
        Class.forName("android.app.DownloadManager")
        Class.forName("android.app.IntentService")
        Class.forName("android.app.KeyguardManager")
        Class.forName("android.app.Notification")
        Class.forName("android.app.NotificationChannel")
        Class.forName("android.app.NotificationChannelGroup")
        Class.forName("android.app.NotificationManager")
        Class.forName("android.app.PendingIntent")
        Class.forName("android.app.RemoteInput")
        Class.forName("android.app.Service")
        Class.forName("android.app.TimePickerDialog")
        Class.forName("android.app.UiModeManager")

        Class.forName("android.app.job.JobInfo")
        Class.forName("android.app.job.JobParameters")
        Class.forName("android.app.job.JobScheduler")
        Class.forName("android.app.job.JobService")

        Class.forName("android.content.ActivityNotFoundException")
        Class.forName("android.content.BroadcastReceiver")
        Class.forName("android.content.ClipData")
        Class.forName("android.content.ClipDescription")
        Class.forName("android.content.ClipboardManager")
        Class.forName("android.content.ComponentCallbacks")
        Class.forName("android.content.ComponentName")
        Class.forName("android.content.ContentProvider")
        Class.forName("android.content.ContentProviderOperation")
        Class.forName("android.content.ContentProviderResult")
        Class.forName("android.content.ContentResolver")
        Class.forName("android.content.ContentUris")
        Class.forName("android.content.ContentValues")
        Class.forName("android.content.Context")
        Class.forName("android.content.ContextWrapper")
        Class.forName("android.content.DialogInterface")
        Class.forName("android.content.Intent")
        Class.forName("android.content.IntentFilter")
        Class.forName("android.content.IntentSender")
        Class.forName("android.content.ServiceConnection")
        Class.forName("android.content.SharedPreferences")

        Class.forName("android.content.pm.ActivityInfo")
        Class.forName("android.content.pm.ApplicationInfo")
        Class.forName("android.content.pm.LabeledIntent")
        Class.forName("android.content.pm.PackageInfo")
        Class.forName("android.content.pm.PackageManager")
        Class.forName("android.content.pm.PermissionInfo")
        Class.forName("android.content.pm.ProviderInfo")
        Class.forName("android.content.pm.ResolveInfo")

        Class.forName("android.content.res.AssetManager")
        Class.forName("android.content.res.ColorStateList")
        Class.forName("android.content.res.Configuration")
        Class.forName("android.content.res.Resources")
        Class.forName("android.content.res.TypedArray")

        Class.forName("android.database.ContentObserver")
        Class.forName("android.database.Cursor")
        Class.forName("android.database.DatabaseErrorHandler")
        Class.forName("android.database.MatrixCursor")

        Class.forName("android.database.sqlite.SQLiteConstraintException")
        Class.forName("android.database.sqlite.SQLiteDatabase")
        Class.forName("android.database.sqlite.SQLiteDatabase$CursorFactory")
        Class.forName("android.database.sqlite.SQLiteException")
        Class.forName("android.database.sqlite.SQLiteOpenHelper")
        Class.forName("android.database.sqlite.SQLiteStatement")

        Class.forName("android.graphics.Bitmap")
        Class.forName("android.graphics.BitmapFactory")
        Class.forName("android.graphics.BitmapShader")
        Class.forName("android.graphics.Canvas")
        Class.forName("android.graphics.Color")
        Class.forName("android.graphics.ColorFilter")
        Class.forName("android.graphics.DashPathEffect")
        Class.forName("android.graphics.ImageDecoder")
        Class.forName("android.graphics.ImageFormat")
        Class.forName("android.graphics.LinearGradient")
        Class.forName("android.graphics.Matrix")
        Class.forName("android.graphics.Outline")
        Class.forName("android.graphics.Paint")
        Class.forName("android.graphics.Path")
        Class.forName("android.graphics.PathMeasure")
        Class.forName("android.graphics.Picture")
        Class.forName("android.graphics.PixelFormat")
        Class.forName("android.graphics.Point")
        Class.forName("android.graphics.PointF")
        Class.forName("android.graphics.PorterDuff")
        Class.forName("android.graphics.PorterDuffColorFilter")
        Class.forName("android.graphics.PorterDuffXfermode")
        Class.forName("android.graphics.RadialGradient")
        Class.forName("android.graphics.Rect")
        Class.forName("android.graphics.RectF")
        Class.forName("android.graphics.Region")
        Class.forName("android.graphics.Shader")
        Class.forName("android.graphics.SurfaceTexture")
        Class.forName("android.graphics.Typeface")

        Class.forName("android.graphics.drawable.Animatable")
        Class.forName("android.graphics.drawable.BitmapDrawable")
        Class.forName("android.graphics.drawable.ColorDrawable")
        Class.forName("android.graphics.drawable.Drawable")
        Class.forName("android.graphics.drawable.GradientDrawable")
        Class.forName("android.graphics.drawable.LayerDrawable")
        Class.forName("android.graphics.drawable.PaintDrawable")
        Class.forName("android.graphics.drawable.PictureDrawable")
        Class.forName("android.graphics.drawable.RippleDrawable")
        Class.forName("android.graphics.drawable.ShapeDrawable")
        Class.forName("android.graphics.drawable.shapes.RectShape")

        Class.forName("android.hardware.Camera")
        Class.forName("android.hardware.Sensor")
        Class.forName("android.hardware.SensorManager")
        Class.forName("android.hardware.SensorEvent")
        Class.forName("android.hardware.SensorEventListener")
        Class.forName("android.hardware.SensorEventListener2")
        Class.forName("android.hardware.GeomagneticField")

        Class.forName("android.icu.util.LocaleData")
        Class.forName("android.icu.util.ULocale")

        Class.forName("android.location.Address")
        Class.forName("android.location.Geocoder")
        Class.forName("android.location.Location")
        Class.forName("android.location.LocationManager")
        Class.forName("android.location.LocationListener")

        Class.forName("android.media.AudioAttributes")
        Class.forName("android.media.AudioDeviceInfo")
        Class.forName("android.media.AudioManager")
        Class.forName("android.media.CamcorderProfile")
        Class.forName("android.media.MediaMetadataRetriever")
        Class.forName("android.media.MediaPlayer")
        Class.forName("android.media.MediaRecorder")
        Class.forName("android.media.MediaScannerConnection")
        Class.forName("android.media.PlaybackParams")
        Class.forName("android.media.RingtoneManager")
        Class.forName("android.media.audiofx.Visualizer")

        Class.forName("android.net.ConnectivityManager")
        Class.forName("android.net.LinkProperties")
        Class.forName("android.net.Network")
        Class.forName("android.net.NetworkCapabilities")
        Class.forName("android.net.NetworkInfo")
        Class.forName("android.net.Uri")
        Class.forName("android.net.http.SslError")
        Class.forName("android.net.sip.SipManager")
        Class.forName("android.net.wifi.WifiInfo")
        Class.forName("android.net.wifi.WifiManager")

        Class.forName("android.nfc.NfcAdapter")

        Class.forName("android.opengl.EGL14")
        Class.forName("android.opengl.GLUtils")

        Class.forName("android.os.AsyncTask")
        Class.forName("android.os.BaseBundle")
        Class.forName("android.os.BatteryManager")
        Class.forName("android.os.Binder")
        Class.forName("android.os.Build")
        Class.forName("android.os.Bundle")
        Class.forName("android.os.CancellationSignal")
        Class.forName("android.os.Debug")
        Class.forName("android.os.Environment")
        Class.forName("android.os.Handler")
        Class.forName("android.os.HandlerThread")
        Class.forName("android.os.IBinder")
        Class.forName("android.os.Looper")
        Class.forName("android.os.Message")
        Class.forName("android.os.OperationCanceledException")
        Class.forName("android.os.Parcel")
        Class.forName("android.os.ParcelFileDescriptor")
        Class.forName("android.os.Parcelable")
        Class.forName("android.os.PersistableBundle")
        Class.forName("android.os.PowerManager")
        Class.forName("android.os.Process")
        Class.forName("android.os.RemoteException")
        Class.forName("android.os.ResultReceiver")
        Class.forName("android.os.StatFs")
        Class.forName("android.os.StrictMode")
        Class.forName("android.os.SystemClock")
        Class.forName("android.os.UserManager")
        Class.forName("android.os.VibrationEffect")
        Class.forName("android.os.Vibrator")

        Class.forName("android.preference.PreferenceManager")

        Class.forName("android.print.PageRange")
        Class.forName("android.print.PrintAttributes")
        Class.forName("android.print.PrintDocumentAdapter")
        Class.forName("android.print.PrintDocumentInfo")
        Class.forName("android.print.PrintManager")

        Class.forName("android.provider.CalendarContract")
        Class.forName("android.provider.ContactsContract")
        Class.forName("android.provider.DocumentsContract")
        Class.forName("android.provider.MediaStore")
        Class.forName("android.provider.MediaStore$Files$FileColumns")
        Class.forName("android.provider.MediaStore$Images$Media")
        Class.forName("android.provider.MediaStore$MediaColumns")
        Class.forName("android.provider.OpenableColumns")
        Class.forName("android.provider.Settings")
        Class.forName("android.provider.Telephony")
        Class.forName("android.security.KeyPairGeneratorSpec")
        Class.forName("android.security.keystore.KeyGenParameterSpec")
        Class.forName("android.security.keystore.KeyProperties")

        Class.forName("android.service.notification.StatusBarNotification")

        Class.forName("android.speech.tts.TextToSpeech")
        Class.forName("android.speech.tts.UtteranceProgressListener")
        Class.forName("android.speech.tts.Voice")

        Class.forName("android.telephony.TelephonyManager")

        Class.forName("android.text.Editable")
        Class.forName("android.text.Html")
        Class.forName("android.text.InputFilter")
        Class.forName("android.text.InputType")
        Class.forName("android.text.Layout")
        Class.forName("android.text.SpannableString")
        Class.forName("android.text.Spanned")
        Class.forName("android.text.StaticLayout")
        Class.forName("android.text.TextPaint")
        Class.forName("android.text.TextUtils")
        Class.forName("android.text.TextWatcher")
        Class.forName("android.text.format.DateFormat")
        Class.forName("android.text.format.DateUtils")

        Class.forName("android.util.AttributeSet")
        Class.forName("android.util.Base64")
        Class.forName("android.util.DisplayMetrics")
        Class.forName("android.util.LayoutDirection")
        Class.forName("android.util.Log")
        Class.forName("android.util.LruCache")
        Class.forName("android.util.Pair")
        Class.forName("android.util.Property")
        Class.forName("android.util.Size")
        Class.forName("android.util.SparseArray")
        Class.forName("android.util.TypedValue")

        Class.forName("android.view.Choreographer")
        Class.forName("android.view.ContextThemeWrapper")
        Class.forName("android.view.GestureDetector")
        Class.forName("android.view.Gravity")
        Class.forName("android.view.KeyCharacterMap")
        Class.forName("android.view.KeyEvent")
        Class.forName("android.view.LayoutInflater")
        Class.forName("android.view.Menu")
        Class.forName("android.view.MenuInflater")
        Class.forName("android.view.MenuItem")
        Class.forName("android.view.MotionEvent")
        Class.forName("android.view.MotionEvent$PointerCoords")
        Class.forName("android.view.MotionEvent$PointerProperties")
        Class.forName("android.view.OrientationEventListener")
        Class.forName("android.view.PixelCopy")
        Class.forName("android.view.ScaleGestureDetector")
        Class.forName("android.view.ScaleGestureDetector$OnScaleGestureListener")
        Class.forName("android.view.Surface")
        Class.forName("android.view.SurfaceView")
        Class.forName("android.view.TextureView")
        Class.forName("android.view.TextureView$SurfaceTextureListener")
        Class.forName("android.view.VelocityTracker")
        Class.forName("android.view.View")
        Class.forName("android.view.View$OnAttachStateChangeListener")
        Class.forName("android.view.View$OnClickListener")
        Class.forName("android.view.View$OnFocusChangeListener")
        Class.forName("android.view.ViewConfiguration")
        Class.forName("android.view.ViewGroup")
        Class.forName("android.view.ViewGroup$LayoutParams")
        Class.forName("android.view.ViewOutlineProvider")
        Class.forName("android.view.ViewParent")
        Class.forName("android.view.ViewTreeObserver")
        Class.forName("android.view.Window")
        Class.forName("android.view.WindowInsets")
        Class.forName("android.view.WindowManager")

        Class.forName("android.view.accessibility.AccessibilityEvent")
        Class.forName("android.view.accessibility.AccessibilityManager")
        Class.forName("android.view.accessibility.AccessibilityNodeInfo")

        Class.forName("android.view.animation.AccelerateDecelerateInterpolator")
        Class.forName("android.view.animation.AccelerateInterpolator")
        Class.forName("android.view.animation.AlphaAnimation")
        Class.forName("android.view.animation.Animation")
        Class.forName("android.view.animation.AnimationSet")
        Class.forName("android.view.animation.DecelerateInterpolator")
        Class.forName("android.view.animation.LinearInterpolator")
        Class.forName("android.view.animation.Transformation")

        Class.forName("android.view.inputmethod.InputMethodManager")

        Class.forName("android.webkit.ConsoleMessage")
        Class.forName("android.webkit.CookieManager")
        Class.forName("android.webkit.DownloadListener")
        Class.forName("android.webkit.GeolocationPermissions")
        Class.forName("android.webkit.HttpAuthHandler")
        Class.forName("android.webkit.JavascriptInterface")
        Class.forName("android.webkit.MimeTypeMap")
        Class.forName("android.webkit.PermissionRequest")
        Class.forName("android.webkit.RenderProcessGoneDetail")
        Class.forName("android.webkit.SslErrorHandler")
        Class.forName("android.webkit.ValueCallback")
        Class.forName("android.webkit.WebChromeClient")
        Class.forName("android.webkit.WebResourceRequest")
        Class.forName("android.webkit.WebResourceResponse")
        Class.forName("android.webkit.WebSettings")
        Class.forName("android.webkit.WebView")
        Class.forName("android.webkit.WebViewClient")

        Class.forName("android.widget.AdapterView")
        Class.forName("android.widget.ArrayAdapter")
        Class.forName("android.widget.BaseAdapter")
        Class.forName("android.widget.Button")
        Class.forName("android.widget.CheckedTextView")
        Class.forName("android.widget.DatePicker")
        Class.forName("android.widget.EditText")
        Class.forName("android.widget.FrameLayout")
        Class.forName("android.widget.HorizontalScrollView")
        Class.forName("android.widget.ImageButton")
        Class.forName("android.widget.ImageView")
        Class.forName("android.widget.LinearLayout")
        Class.forName("android.widget.ListView")
        Class.forName("android.widget.MediaController")
        Class.forName("android.widget.NumberPicker")
        Class.forName("android.widget.PopupWindow")
        Class.forName("android.widget.ProgressBar")
        Class.forName("android.widget.RelativeLayout")
        Class.forName("android.widget.RemoteViews")
        Class.forName("android.widget.ScrollView")
        Class.forName("android.widget.SeekBar")
        Class.forName("android.widget.Spinner")
        Class.forName("android.widget.Switch")
        Class.forName("android.widget.TextView")
        Class.forName("android.widget.TimePicker")
        Class.forName("android.widget.Toast")

        Class.forName("androidx.annotation.AnyThread")
        Class.forName("androidx.annotation.ColorInt")
        Class.forName("androidx.annotation.ColorRes")
        Class.forName("androidx.annotation.FloatRange")
        Class.forName("androidx.annotation.IntDef")
        Class.forName("androidx.annotation.IntRange")
        Class.forName("androidx.annotation.MainThread")
        Class.forName("androidx.annotation.NonNull")
        Class.forName("androidx.annotation.Nullable")
        Class.forName("androidx.annotation.RequiresApi")
        Class.forName("androidx.annotation.Size")
        Class.forName("androidx.annotation.StringDef")
        Class.forName("androidx.annotation.UiThread")
        Class.forName("androidx.annotation.VisibleForTesting")
        Class.forName("androidx.annotation.WorkerThread")

        //Class.forName("androidx.activity.ComponentActivity")
        //Class.forName("androidx.activity.OnBackPressedCallback")
        //Class.forName("androidx.activity.result.ActivityResult")
        //Class.forName("androidx.activity.result.ActivityResultCallback")
        //Class.forName("androidx.activity.result.IntentSenderRequest")
        //Class.forName("androidx.activity.result.contract.ActivityResultContract")

        //Class.forName("androidx.appcompat.R")
        //Class.forName("androidx.appcompat.app.AppCompatActivity")
        //Class.forName("androidx.appcompat.app.AppCompatDelegate")
        //Class.forName("androidx.appcompat.content.res.AppCompatResources")
        //Class.forName("androidx.appcompat.widget.AppCompatImageButton")
        //Class.forName("androidx.appcompat.widget.AppCompatImageView")
        //Class.forName("androidx.appcompat.widget.AppCompatSeekBar")
        //Class.forName("androidx.appcompat.widget.AppCompatSpinner")
        //Class.forName("androidx.appcompat.widget.SearchView")
        //Class.forName("androidx.appcompat.widget.Toolbar")

        //Class.forName("androidx.arch.core.util.Function")

        //Class.forName("androidx.biometric.BiometricManager")
        //Class.forName("androidx.biometric.BiometricPrompt")
        //Class.forName("androidx.browser.customtabs.CustomTabsClient")
        //Class.forName("androidx.browser.customtabs.CustomTabsIntent")
        //Class.forName("androidx.browser.customtabs.CustomTabsService")
        //Class.forName("androidx.browser.customtabs.CustomTabsServiceConnection")
        //Class.forName("androidx.browser.customtabs.CustomTabsSession")

        //Class.forName("androidx.collection.ArrayMap")
        //Class.forName("androidx.collection.ArraySet")

        //Class.forName("androidx.coordinatorlayout.widget.CoordinatorLayout")

        //Class.forName("androidx.core.app.ActivityCompat")
        //Class.forName("androidx.core.app.AlarmManagerCompat")
        //Class.forName("androidx.core.app.ComponentActivity")
        //Class.forName("androidx.core.app.NotificationCompat")
        //Class.forName("androidx.core.app.NotificationManagerCompat")
        //Class.forName("androidx.core.app.RemoteInput")
        //Class.forName("androidx.core.content.ContextCompat")
        //Class.forName("androidx.core.content.FileProvider")
        //Class.forName("androidx.core.content.PermissionChecker")
        //Class.forName("androidx.core.graphics.drawable.DrawableCompat")
        //Class.forName("androidx.core.os.LocaleListCompat")
        //Class.forName("androidx.core.util.Pair")
        //Class.forName("androidx.core.util.Pools")
        //Class.forName("androidx.core.util.Supplier")
        //Class.forName("androidx.core.view.AccessibilityDelegateCompat")
        //Class.forName("androidx.core.view.GestureDetectorCompat")
        //Class.forName("androidx.core.view.MotionEventCompat")
        //Class.forName("androidx.core.view.ViewCompat")
        //Class.forName("androidx.core.view.WindowCompat")
        //Class.forName("androidx.core.view.WindowInsetsAnimationCompat")
        //Class.forName("androidx.core.view.WindowInsetsCompat")
        //Class.forName("androidx.core.view.WindowInsetsControllerCompat")
        //Class.forName("androidx.core.view.accessibility.AccessibilityNodeInfoCompat")
        //Class.forName("androidx.documentfile.provider.DocumentFile")
        //Class.forName("androidx.exifinterface.media.ExifInterface")
        //Class.forName("androidx.fragment.app.DialogFragment")
        //Class.forName("androidx.fragment.app.Fragment")
        //Class.forName("androidx.fragment.app.FragmentActivity")
        //Class.forName("androidx.fragment.app.FragmentManager")
        //Class.forName("androidx.fragment.app.FragmentPagerAdapter")
        //Class.forName("androidx.fragment.app.FragmentTransaction")
        //Class.forName("androidx.lifecycle.Lifecycle")
        //Class.forName("androidx.lifecycle.LifecycleEventObserver")
        //Class.forName("androidx.lifecycle.LifecycleObserver")
        //Class.forName("androidx.lifecycle.LifecycleOwner")
        //Class.forName("androidx.lifecycle.OnLifecycleEvent")
        //Class.forName("androidx.lifecycle.ProcessLifecycleOwner")
        //Class.forName("androidx.localbroadcastmanager.content.LocalBroadcastManager")
        //Class.forName("androidx.multidex.MultiDexApplication")
        //Class.forName("androidx.recyclerview.widget.RecyclerView$Adapter")
        //Class.forName("androidx.recyclerview.widget.RecyclerView$ViewHolder")

        //Class.forName("androidx.room.ColumnInfo")
        //Class.forName("androidx.room.Dao")
        //Class.forName("androidx.room.Database")
        //Class.forName("androidx.room.Entity")
        //Class.forName("androidx.room.ForeignKey")
        //Class.forName("androidx.room.Index")
        //Class.forName("androidx.room.Insert")
        //Class.forName("androidx.room.OnConflictStrategy")
        //Class.forName("androidx.room.PrimaryKey")
        //Class.forName("androidx.room.Query")
        //Class.forName("androidx.room.Room")
        //Class.forName("androidx.room.RoomDatabase")
        //Class.forName("androidx.room.Transaction")
        //Class.forName("androidx.room.TypeConverter")
        //Class.forName("androidx.room.TypeConverters")
        //Class.forName("androidx.room.migration.Migration")
        //Class.forName("androidx.room.testing.MigrationTestHelper")

        //Class.forName("androidx.sqlite.db.SupportSQLiteDatabase")
        //Class.forName("androidx.sqlite.db.framework.FrameworkSQLiteOpenHelperFactory")

        //Class.forName("androidx.transition.ChangeBounds")
        //Class.forName("androidx.transition.ChangeTransform")
        //Class.forName("androidx.transition.Fade")
        //Class.forName("androidx.transition.SidePropagation")
        //Class.forName("androidx.transition.Slide")
        //Class.forName("androidx.transition.Transition")
        //Class.forName("androidx.transition.TransitionListenerAdapter")
        //Class.forName("androidx.transition.TransitionManager")
        //Class.forName("androidx.transition.TransitionPropagation")
        //Class.forName("androidx.transition.TransitionSet")
        //Class.forName("androidx.transition.TransitionValues")
        //Class.forName("androidx.transition.Visibility")

        //Class.forName("androidx.viewpager.widget.ViewPager")
        //Class.forName("androidx.viewpager2.widget.ViewPager2")
        //Class.forName("androidx.webkit.WebSettingsCompat")
        //Class.forName("androidx.webkit.WebViewFeature")

        //Class.forName("androidx.work.Constraints")
        //Class.forName("androidx.work.Data")
        //Class.forName("androidx.work.ExistingWorkPolicy")
        //Class.forName("androidx.work.NetworkType")
        //Class.forName("androidx.work.OneTimeWorkRequest")
        //Class.forName("androidx.work.Operation")
        //Class.forName("androidx.work.WorkInfo")
        //Class.forName("androidx.work.WorkManager")
        //Class.forName("androidx.work.WorkRequest")
        //Class.forName("androidx.work.Worker")
        //Class.forName("androidx.work.WorkerParameters")
        #endif
    }
}
