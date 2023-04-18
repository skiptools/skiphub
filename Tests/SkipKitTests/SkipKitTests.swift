// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
#if !SKIP
@testable import SkipKit
#endif
import OSLog
import Foundation
import XCTest

// SKIP INSERT: @org.junit.runner.RunWith(org.robolectric.RobolectricTestRunner::class)
// SKIP INSERT: @org.robolectric.annotation.Config(manifest=org.robolectric.annotation.Config.NONE, sdk = [33])
@available(macOS 11, iOS 14, watchOS 7, tvOS 14, *)
final class SkipKitTests: XCTestCase {
    fileprivate let logger = Logger(subsystem: "test", category: "SkipKitTests")
    
    func testSkipKit() throws {
        print("Running: testSkipKit…")
        logger.log("running testSkipKit")

        XCTAssertEqual(3.0 + 1.5, 9.0/2)
        XCTAssertEqual("SkipKit", SkipKitInternalModuleName())
        XCTAssertEqual("SkipKit", SkipKitPublicModuleName())
        //XCTAssertEqual("SkipFoundation", SkipFoundationPublicModuleName())
    }

    #if SKIP
    // get an Android context from the current test environment
    let context: android.content.Context = androidx.test.core.app.ApplicationProvider.getApplicationContext()

    func testUserDefaults() throws {
        let prefs: android.content.SharedPreferences = context.getSharedPreferences("app_prefs", android.content.Context.MODE_PRIVATE)

        do {
            let prefsEditable: android.content.SharedPreferences.Editor = prefs.edit()
            prefsEditable.putString("username", "johndoe")
            prefsEditable.putInt("age", 30)
            prefsEditable.apply()
        }

        let username = prefs.getString("username", "")
        XCTAssertEqual("johndoe", username)

        let age = prefs.getInt("age", 0)
        XCTAssertEqual(30, age)
    }

    func testSQLite() throws {
        let db = context.openOrCreateDatabase("mydb", 0, nil, nil)
        defer { db.close() }
        XCTAssertEqual(3, db.compileStatement("SELECT 1 + 2").simpleQueryForLong().toInt())
    }

    func testCanvas() throws {
        var width = 500
        var height = 500

        // Create a Bitmap object with the desired width and height
        let bitmap = android.graphics.Bitmap.createBitmap(width, height, android.graphics.Bitmap.Config.ARGB_8888)

        // Create a Canvas object with the Bitmap object as its parameter
        let canvas = android.graphics.Canvas(bitmap)

        // Draw on the canvas using the draw methods
        canvas.drawColor(android.graphics.Color.WHITE)
        canvas.drawText("Hello, World!", 100.toFloat(), 100.toFloat(), android.graphics.Paint())

        // Compress the Bitmap object to a byte array
        let outputStream = java.io.ByteArrayOutputStream()
        bitmap.compress(android.graphics.Bitmap.CompressFormat.PNG, 100, outputStream)
        let byteArray = outputStream.toByteArray()

        XCTAssertLessThan(100 * 1024, byteArray.size, "PNG \(width)x\(height) unexpected size: \(byteArray.size)")
        XCTAssertGreaterThan(2 * 1024 * 1024, byteArray.size, "PNG \(width)x\(height) unexpected size: \(byteArray.size)")

        // Convert the byte array to a Bitmap object if needed
        let generatedBitmap = android.graphics.BitmapFactory.decodeByteArray(byteArray, 0, byteArray.size)
        XCTAssertNotNil(generatedBitmap, "bitmap was null")
    }

    func testACTIVITY_SERVICE() {
        let service = context.getSystemService(android.content.Context.ACTIVITY_SERVICE) as android.app.ActivityManager
        XCTAssertNotNil(service)
        //let tasks = service.getAppTasks()
        let processes = service.getRunningAppProcesses()

        // “Return the approximate per-application memory class of the current device. This gives you an idea of how hard a memory limit you should impose on your application to let the overall system work best. The returned value is in megabytes; the baseline Android memory class is 16 (which happens to be the Java heap limit of those devices); some device with more memory may return 24 or even higher numbers.”
        let memoryClass = service.getMemoryClass()
        XCTAssertEqual(16, memoryClass)

        let largeMemoryClass = service.getMemoryClass()
        XCTAssertEqual(16, largeMemoryClass)

        XCTAssertEqual(false, android.app.ActivityManager.isRunningInTestHarness())
        XCTAssertEqual(false, android.app.ActivityManager.isUserAMonkey())

    }

    func testALARM_SERVICE() {
        let service = context.getSystemService(android.content.Context.ALARM_SERVICE) as android.app.AlarmManager
        XCTAssertNotNil(service)
    }

    func testAUDIO_SERVICE() {
        let service = context.getSystemService(android.content.Context.AUDIO_SERVICE) as android.media.AudioManager
        XCTAssertNotNil(service)
    }

    func testCLIPBOARD_SERVICE() {
        let service = context.getSystemService(android.content.Context.CLIPBOARD_SERVICE) as android.content.ClipboardManager
        XCTAssertNotNil(service)
    }

    func testCONNECTIVITY_SERVICE() {
        let service = context.getSystemService(android.content.Context.CONNECTIVITY_SERVICE) as android.net.ConnectivityManager
        XCTAssertNotNil(service)
    }

    func testKEYGUARD_SERVICE() {
        let service = context.getSystemService(android.content.Context.KEYGUARD_SERVICE) as android.app.KeyguardManager
        XCTAssertNotNil(service)
    }

    func testLOCATION_SERVICE() {
        let service = context.getSystemService(android.content.Context.LOCATION_SERVICE) as android.location.LocationManager
        XCTAssertNotNil(service)
    }

    func testNOTIFICATION_SERVICE() {
        let service = context.getSystemService(android.content.Context.NOTIFICATION_SERVICE) as android.app.NotificationManager
        XCTAssertNotNil(service)
    }

    func testPOWER_SERVICE() {
        let service = context.getSystemService(android.content.Context.POWER_SERVICE) as android.os.PowerManager
        XCTAssertNotNil(service)
    }

    func testSEARCH_SERVICE() {
        let service = context.getSystemService(android.content.Context.SEARCH_SERVICE) as android.app.SearchManager
        XCTAssertNotNil(service)
    }

    func testSENSOR_SERVICE() {
        let service = context.getSystemService(android.content.Context.SENSOR_SERVICE) as android.hardware.SensorManager // as android.hardware.SystemSensorManager
        XCTAssertNotNil(service)
    }

    func testTELEPHONY_SERVICE() {
        let telephonyManager = context.getSystemService(android.content.Context.TELEPHONY_SERVICE) as android.telephony.TelephonyManager
        XCTAssertNotNil(telephonyManager)
    }

    func testWALLPAPER_SERVICE() {
        let wallpaperManager = context.getSystemService(android.content.Context.WALLPAPER_SERVICE) as android.app.WallpaperManager
        XCTAssertNotNil(wallpaperManager)
    }

    func testWIFI_SERVICE() {
        let wifiManager = context.getSystemService(android.content.Context.WIFI_SERVICE) as android.net.wifi.WifiManager
        XCTAssertNotNil(wifiManager)
    }

    func testWINDOW_SERVICE() {
        let service = context.getSystemService(android.content.Context.WINDOW_SERVICE) // as android.view.WindowManagerImpl$CompatModeWrapper
        XCTAssertNotNil(service)
    }

    func testINPUT_METHOD_SERVICE() {
        let inputMethodManager = context.getSystemService(android.content.Context.INPUT_METHOD_SERVICE) as android.view.inputmethod.InputMethodManager
        XCTAssertNotNil(inputMethodManager)
    }

    func testACCESSIBILITY_SERVICE() {
        let accessibilityManager = context.getSystemService(android.content.Context.ACCESSIBILITY_SERVICE) as android.view.accessibility.AccessibilityManager
        XCTAssertNotNil(accessibilityManager)
    }

    func testACCOUNT_SERVICE() {
        let accountManager = context.getSystemService(android.content.Context.ACCOUNT_SERVICE) as android.accounts.AccountManager
        XCTAssertNotNil(accountManager)
    }

    func testDEVICE_POLICY_SERVICE() {
        let devicePolicyManager = context.getSystemService(android.content.Context.DEVICE_POLICY_SERVICE) as android.app.admin.DevicePolicyManager
        XCTAssertNotNil(devicePolicyManager)
    }

    func testDROPBOX_SERVICE() {
        // The android.os.DropBoxManager class is used for writing diagnostic logs to the system dropbox. This can be useful for debugging purposes, as it allows you to collect and analyze diagnostic information from your application.
        let dropBoxManager = context.getSystemService(android.content.Context.DROPBOX_SERVICE) as android.os.DropBoxManager
        XCTAssertNotNil(dropBoxManager)
    }

    func testUI_MODE_SERVICE() {
        let uiModeManager = context.getSystemService(android.content.Context.UI_MODE_SERVICE) as android.app.UiModeManager
        XCTAssertNotNil(uiModeManager)
    }

    func testDOWNLOAD_SERVICE() {
        let downloadManager = context.getSystemService(android.content.Context.DOWNLOAD_SERVICE) as android.app.DownloadManager
        XCTAssertNotNil(downloadManager)

        let request = android.app.DownloadManager.Request(android.net.Uri.parse("http://example.com/file.mp3"))
            .setTitle("My Download")
            .setDescription("Downloading a file")
            .setNotificationVisibility(android.app.DownloadManager.Request.VISIBILITY_VISIBLE_NOTIFY_COMPLETED)
            .setDestinationInExternalPublicDir(android.os.Environment.DIRECTORY_DOWNLOADS, "file.mp3")

        let downloadId = downloadManager.enqueue(request)

    }

    func testSTORAGE_SERVICE() {
        // The android.os.storage.StorageManager class provides methods for interacting with the device's storage subsystem, such as mounting and unmounting volumes, querying for storage details, and getting a list of available storage volumes.
        let storageManager = context.getSystemService(android.content.Context.STORAGE_SERVICE) as android.os.storage.StorageManager
        XCTAssertNotNil(storageManager)
        //let storageVolumes = storageManager.storageVolumes
        //let storageVolume = storageVolumes.firstOrNull()
        //let uuid = storageVolume?.uuid
        //let path = storageVolume?.getPath()
        //let isRemovable = storageVolume?.isRemovable
        //let state = storageManager.getVolumeState(storageVolume?.getUuid())
    }

    func testNFC_SERVICE() {
        let nfcManager = context.getSystemService(android.content.Context.NFC_SERVICE) as android.nfc.NfcManager
        XCTAssertNotNil(nfcManager)
    }

    func testUSB_SERVICE() {
        let usbManager = context.getSystemService(android.content.Context.USB_SERVICE) as android.hardware.usb.UsbManager
        XCTAssertNotNil(usbManager)
        let deviceList = usbManager.deviceList
        let device = deviceList.values.firstOrNull()
        let intent = android.content.Intent("com.android.example.USB_PERMISSION")
        //let pendingIntent = android.app.PendingIntent.getBroadcast(self, 0, intent, 0)
        //usbManager.requestPermission(device, pendingIntent)
        //let connection = usbManager.openDevice(device)
    }

    func testWIFI_P2P_SERVICE() {
        let wifiP2pManager = context.getSystemService(android.content.Context.WIFI_P2P_SERVICE) as android.net.wifi.p2p.WifiP2pManager
        XCTAssertNotNil(wifiP2pManager)
    }

    func testINPUT_SERVICE() {
        let inputManager = context.getSystemService(android.content.Context.INPUT_SERVICE) as android.hardware.input.InputManager
        XCTAssertNotNil(inputManager)
    }

    func testMEDIA_ROUTER_SERVICE() {
        let mediaRouter = context.getSystemService(android.content.Context.MEDIA_ROUTER_SERVICE) as android.media.MediaRouter
        XCTAssertNotNil(mediaRouter)
    }

    func testNSD_SERVICE() {
        let nsdManager = context.getSystemService(android.content.Context.NSD_SERVICE) as android.net.nsd.NsdManager
        XCTAssertNotNil(nsdManager)
    }

    func testAndroidServices() throws {
        // show the various services
        /* Added in API level 1 */
        logger.info("ACTIVITY_SERVICE: \(context.getSystemService(android.content.Context.ACTIVITY_SERVICE))") // android.app.ActivityManager
        logger.info("ALARM_SERVICE: \(context.getSystemService(android.content.Context.ALARM_SERVICE))") // android.app.AlarmManager
        logger.info("AUDIO_SERVICE: \(context.getSystemService(android.content.Context.AUDIO_SERVICE))") // android.media.AudioManager
        logger.info("CLIPBOARD_SERVICE: \(context.getSystemService(android.content.Context.CLIPBOARD_SERVICE))") // android.content.ClipboardManager
        logger.info("CONNECTIVITY_SERVICE: \(context.getSystemService(android.content.Context.CONNECTIVITY_SERVICE))") // android.net.ConnectivityManager
        logger.info("KEYGUARD_SERVICE: \(context.getSystemService(android.content.Context.KEYGUARD_SERVICE))") // android.app.KeyguardManager
        logger.info("LAYOUT_INFLATER_SERVICE: \(context.getSystemService(android.content.Context.LAYOUT_INFLATER_SERVICE))") // com.android.internal.policy.impl.PhoneLayoutInflater
        logger.info("LOCATION_SERVICE: \(context.getSystemService(android.content.Context.LOCATION_SERVICE))") // android.location.LocationManager
        logger.info("NOTIFICATION_SERVICE: \(context.getSystemService(android.content.Context.NOTIFICATION_SERVICE))") // android.app.NotificationManager
        logger.info("POWER_SERVICE: \(context.getSystemService(android.content.Context.POWER_SERVICE))") // android.os.PowerManager
        logger.info("SEARCH_SERVICE: \(context.getSystemService(android.content.Context.SEARCH_SERVICE))") // android.app.SearchManager
        logger.info("SENSOR_SERVICE: \(context.getSystemService(android.content.Context.SENSOR_SERVICE))") // android.hardware.SystemSensorManager
        logger.info("TELEPHONY_SERVICE: \(context.getSystemService(android.content.Context.TELEPHONY_SERVICE))") // android.telephony.TelephonyManager
        //logger.info("VIBRATOR_SERVICE: \(context.getSystemService(android.content.Context.VIBRATOR_SERVICE))") // deprecated
        logger.info("WALLPAPER_SERVICE: \(context.getSystemService(android.content.Context.WALLPAPER_SERVICE))") // android.app.WallpaperManager
        logger.info("WIFI_SERVICE: \(context.getSystemService(android.content.Context.WIFI_SERVICE))") // android.net.wifi.WifiManager
        logger.info("WINDOW_SERVICE: \(context.getSystemService(android.content.Context.WINDOW_SERVICE))") // android.view.WindowManagerImpl$CompatModeWrapper

        /* Added in API level 3 */
        logger.info("INPUT_METHOD_SERVICE: \(context.getSystemService(android.content.Context.INPUT_METHOD_SERVICE))") // android.view.inputmethod.InputMethodManager

        /* Added in API level 4 */
        logger.info("ACCESSIBILITY_SERVICE: \(context.getSystemService(android.content.Context.ACCESSIBILITY_SERVICE))") // android.view.accessibility.AccessibilityManager

        /* Added in API level 5 */
        logger.info("ACCOUNT_SERVICE: \(context.getSystemService(android.content.Context.ACCOUNT_SERVICE))") // android.accounts.AccountManager

        /* Added in API level 8 */
        logger.info("DEVICE_POLICY_SERVICE: \(context.getSystemService(android.content.Context.DEVICE_POLICY_SERVICE))") // android.app.admin.DevicePolicyManager
        logger.info("DROPBOX_SERVICE: \(context.getSystemService(android.content.Context.DROPBOX_SERVICE))") // android.os.DropBoxManager
        logger.info("UI_MODE_SERVICE: \(context.getSystemService(android.content.Context.UI_MODE_SERVICE))") // android.app.UiModeManager

        /* Added in API level 9 */
        logger.info("DOWNLOAD_SERVICE: \(context.getSystemService(android.content.Context.DOWNLOAD_SERVICE))") // android.app.DownloadManager
        logger.info("STORAGE_SERVICE: \(context.getSystemService(android.content.Context.STORAGE_SERVICE))") // android.os.storage.StorageManager

        /* Added in API level 10 */
        logger.info("NFC_SERVICE: \(context.getSystemService(android.content.Context.NFC_SERVICE))") // android.nfc.NfcManager

        /* Added in API level 12 */
        logger.info("USB_SERVICE: \(context.getSystemService(android.content.Context.USB_SERVICE))") // android.hardware.usb.UsbManager

        /* Added in API level 14 */
        logger.info("TEXT_SERVICES_MANAGER_SERVICE: \(context.getSystemService(android.content.Context.TEXT_SERVICES_MANAGER_SERVICE))") // android.view.textservice.TextServicesManager
        logger.info("WIFI_P2P_SERVICE: \(context.getSystemService(android.content.Context.WIFI_P2P_SERVICE))") // android.net.wifi.p2p.WifiP2pManager

        /* Added in API level 16 */
        logger.info("INPUT_SERVICE: \(context.getSystemService(android.content.Context.INPUT_SERVICE))") // android.hardware.input.InputManager
        logger.info("MEDIA_ROUTER_SERVICE: \(context.getSystemService(android.content.Context.MEDIA_ROUTER_SERVICE))") // android.media.MediaRouter
        logger.info("NSD_SERVICE: \(context.getSystemService(android.content.Context.NSD_SERVICE))") // android.net.nsd.NsdManager

        /* Added in API level 17 */
        logger.info("DISPLAY_SERVICE: \(context.getSystemService(android.content.Context.DISPLAY_SERVICE))") // Robolectric: null
        logger.info("USER_SERVICE: \(context.getSystemService(android.content.Context.USER_SERVICE))") // Robolectric: null

        /* Added in API level 18 */
        logger.info("BLUETOOTH_SERVICE: \(context.getSystemService(android.content.Context.BLUETOOTH_SERVICE))") // Robolectric: null

        /* Added in API level 19 */
        logger.info("APP_OPS_SERVICE: \(context.getSystemService(android.content.Context.APP_OPS_SERVICE))") // Robolectric: null
        logger.info("CAPTIONING_SERVICE: \(context.getSystemService(android.content.Context.CAPTIONING_SERVICE))") // Robolectric: null
        logger.info("CONSUMER_IR_SERVICE: \(context.getSystemService(android.content.Context.CONSUMER_IR_SERVICE))") // Robolectric: null
        logger.info("PRINT_SERVICE: \(context.getSystemService(android.content.Context.PRINT_SERVICE))") // Robolectric: null

        /* Added in API level 21 */
        logger.info("APPWIDGET_SERVICE: \(context.getSystemService(android.content.Context.APPWIDGET_SERVICE))") // Robolectric: null
        logger.info("BATTERY_SERVICE: \(context.getSystemService(android.content.Context.BATTERY_SERVICE))") // Robolectric: null
        logger.info("CAMERA_SERVICE: \(context.getSystemService(android.content.Context.CAMERA_SERVICE))") // Robolectric: null
        logger.info("JOB_SCHEDULER_SERVICE: \(context.getSystemService(android.content.Context.JOB_SCHEDULER_SERVICE))") // Robolectric: null
        logger.info("LAUNCHER_APPS_SERVICE: \(context.getSystemService(android.content.Context.LAUNCHER_APPS_SERVICE))") // Robolectric: null
        logger.info("MEDIA_PROJECTION_SERVICE: \(context.getSystemService(android.content.Context.MEDIA_PROJECTION_SERVICE))") // Robolectric: null
        logger.info("MEDIA_SESSION_SERVICE: \(context.getSystemService(android.content.Context.MEDIA_SESSION_SERVICE))") // Robolectric: null
        logger.info("RESTRICTIONS_SERVICE: \(context.getSystemService(android.content.Context.RESTRICTIONS_SERVICE))") // Robolectric: null
        logger.info("TELECOM_SERVICE: \(context.getSystemService(android.content.Context.TELECOM_SERVICE))") // Robolectric: null
        logger.info("TV_INPUT_SERVICE: \(context.getSystemService(android.content.Context.TV_INPUT_SERVICE))") // Robolectric: null

        /* Added in API level 22 */
        logger.info("TELEPHONY_SUBSCRIPTION_SERVICE: \(context.getSystemService(android.content.Context.TELEPHONY_SUBSCRIPTION_SERVICE))") // Robolectric: null
        logger.info("USAGE_STATS_SERVICE: \(context.getSystemService(android.content.Context.USAGE_STATS_SERVICE))") // Robolectric: null

        /* Added in API level 23 */
        logger.info("CARRIER_CONFIG_SERVICE: \(context.getSystemService(android.content.Context.CARRIER_CONFIG_SERVICE))") // Robolectric: null
        logger.info("FINGERPRINT_SERVICE: \(context.getSystemService(android.content.Context.FINGERPRINT_SERVICE))") // Robolectric: null
        logger.info("MIDI_SERVICE: \(context.getSystemService(android.content.Context.MIDI_SERVICE))") // Robolectric: null
        logger.info("NETWORK_STATS_SERVICE: \(context.getSystemService(android.content.Context.NETWORK_STATS_SERVICE))") // Robolectric: null

        /* Added in API level 24 */
        logger.info("HARDWARE_PROPERTIES_SERVICE: \(context.getSystemService(android.content.Context.HARDWARE_PROPERTIES_SERVICE))") // Robolectric: null
        logger.info("SYSTEM_HEALTH_SERVICE: \(context.getSystemService(android.content.Context.SYSTEM_HEALTH_SERVICE))") // Robolectric: null

        /* Added in API level 25 */
        logger.info("SHORTCUT_SERVICE: \(context.getSystemService(android.content.Context.SHORTCUT_SERVICE))") // Robolectric: null

        /* Added in API level 26 */
        logger.info("COMPANION_DEVICE_SERVICE: \(context.getSystemService(android.content.Context.COMPANION_DEVICE_SERVICE))") // Robolectric: null
        logger.info("STORAGE_STATS_SERVICE: \(context.getSystemService(android.content.Context.STORAGE_STATS_SERVICE))") // Robolectric: null
        logger.info("TEXT_CLASSIFICATION_SERVICE: \(context.getSystemService(android.content.Context.TEXT_CLASSIFICATION_SERVICE))") // Robolectric: null
        logger.info("WIFI_AWARE_SERVICE: \(context.getSystemService(android.content.Context.WIFI_AWARE_SERVICE))") // Robolectric: null

        /* Added in API level 28 */
        logger.info("CROSS_PROFILE_APPS_SERVICE: \(context.getSystemService(android.content.Context.CROSS_PROFILE_APPS_SERVICE))") // Robolectric: null
        logger.info("EUICC_SERVICE: \(context.getSystemService(android.content.Context.EUICC_SERVICE))") // Robolectric: null
        logger.info("IPSEC_SERVICE: \(context.getSystemService(android.content.Context.IPSEC_SERVICE))") // Robolectric: null
        logger.info("WIFI_RTT_RANGING_SERVICE: \(context.getSystemService(android.content.Context.WIFI_RTT_RANGING_SERVICE))") // Robolectric: null

        /* Added in API level 29 */
        logger.info("BIOMETRIC_SERVICE: \(context.getSystemService(android.content.Context.BIOMETRIC_SERVICE))") // Robolectric: null
        logger.info("ROLE_SERVICE: \(context.getSystemService(android.content.Context.ROLE_SERVICE))") // Robolectric: null

        /* Added in API level 30 */
        logger.info("BLOB_STORE_SERVICE: \(context.getSystemService(android.content.Context.BLOB_STORE_SERVICE))") // Robolectric: null
        logger.info("CONNECTIVITY_DIAGNOSTICS_SERVICE: \(context.getSystemService(android.content.Context.CONNECTIVITY_DIAGNOSTICS_SERVICE))") // Robolectric: null
        logger.info("FILE_INTEGRITY_SERVICE: \(context.getSystemService(android.content.Context.FILE_INTEGRITY_SERVICE))") // Robolectric: null
        logger.info("TELEPHONY_IMS_SERVICE: \(context.getSystemService(android.content.Context.TELEPHONY_IMS_SERVICE))") // Robolectric: null
        //logger.info("VPN_MANAGEMENT_SERVICE: \(context.getSystemService(android.content.Context.VPN_MANAGEMENT_SERVICE))") // Robolectric: null

        /* Added in API level 31 */
        logger.info("APP_SEARCH_SERVICE: \(context.getSystemService(android.content.Context.APP_SEARCH_SERVICE))") // Robolectric: null
        logger.info("BUGREPORT_SERVICE: \(context.getSystemService(android.content.Context.BUGREPORT_SERVICE))") // Robolectric: null
        logger.info("DISPLAY_HASH_SERVICE: \(context.getSystemService(android.content.Context.DISPLAY_HASH_SERVICE))") // Robolectric: null
        logger.info("DOMAIN_VERIFICATION_SERVICE: \(context.getSystemService(android.content.Context.DOMAIN_VERIFICATION_SERVICE))") // Robolectric: null
        logger.info("GAME_SERVICE: \(context.getSystemService(android.content.Context.GAME_SERVICE))") // Robolectric: null
        logger.info("MEDIA_COMMUNICATION_SERVICE: \(context.getSystemService(android.content.Context.MEDIA_COMMUNICATION_SERVICE))") // Robolectric: null
        logger.info("MEDIA_METRICS_SERVICE: \(context.getSystemService(android.content.Context.MEDIA_METRICS_SERVICE))") // Robolectric: null
        logger.info("PEOPLE_SERVICE: \(context.getSystemService(android.content.Context.PEOPLE_SERVICE))") // Robolectric: null
        logger.info("PERFORMANCE_HINT_SERVICE: \(context.getSystemService(android.content.Context.PERFORMANCE_HINT_SERVICE))") // Robolectric: null
        logger.info("VIBRATOR_MANAGER_SERVICE: \(context.getSystemService(android.content.Context.VIBRATOR_MANAGER_SERVICE))") // Robolectric: null

        /* Added in API level 33 */
        //logger.info("LOCALE_SERVICE: \(context.getSystemService(android.content.Context.LOCALE_SERVICE))")
        //logger.info("STATUS_BAR_SERVICE: \(context.getSystemService(android.content.Context.STATUS_BAR_SERVICE))")
        //logger.info("TV_INTERACTIVE_APP_SERVICE: \(context.getSystemService(android.content.Context.TV_INTERACTIVE_APP_SERVICE))")

        /*
         ACTIVITY_SERVICE: android.app.ActivityManager@7e4bb935
         ALARM_SERVICE: android.app.AlarmManager@5e7a796
         AUDIO_SERVICE: android.media.AudioManager@6725023b
         CLIPBOARD_SERVICE: android.content.ClipboardManager@3ea42c29
         CONNECTIVITY_SERVICE: android.net.ConnectivityManager@53814057
         KEYGUARD_SERVICE: android.app.KeyguardManager@3c4fca28
         LAYOUT_INFLATER_SERVICE: com.android.internal.policy.impl.PhoneLayoutInflater@7ae42749
         LOCATION_SERVICE: android.location.LocationManager@6b04a1b7
         NOTIFICATION_SERVICE: android.app.NotificationManager@66dcb48c
         POWER_SERVICE: android.os.PowerManager@21df49eb
         SEARCH_SERVICE: android.app.SearchManager@48a9678
         SENSOR_SERVICE: android.hardware.SystemSensorManager@10aee086
         TELEPHONY_SERVICE: android.telephony.TelephonyManager@651742c5
         WALLPAPER_SERVICE: android.app.WallpaperManager@50396aae
         WIFI_SERVICE: android.net.wifi.WifiManager@682243ab
         WINDOW_SERVICE: android.view.WindowManagerImpl$CompatModeWrapper@32f55e9c
         INPUT_METHOD_SERVICE: android.view.inputmethod.InputMethodManager@73b562e9
         ACCESSIBILITY_SERVICE: android.view.accessibility.AccessibilityManager@60a7d02b
         ACCOUNT_SERVICE: android.accounts.AccountManager@740d422a
         DEVICE_POLICY_SERVICE: android.app.admin.DevicePolicyManager@56d2c694
         DROPBOX_SERVICE: android.os.DropBoxManager@568b5371
         UI_MODE_SERVICE: android.app.UiModeManager@2fdb1a01
         DOWNLOAD_SERVICE: android.app.DownloadManager@2f4eb8cb
         STORAGE_SERVICE: android.os.storage.StorageManager@6e3a8d55
         NFC_SERVICE: android.nfc.NfcManager@14faf818
         USB_SERVICE: android.hardware.usb.UsbManager@305e9970
         TEXT_SERVICES_MANAGER_SERVICE: android.view.textservice.TextServicesManager@588d0c9d
         WIFI_P2P_SERVICE: android.net.wifi.p2p.WifiP2pManager@56baf47a
         INPUT_SERVICE: android.hardware.input.InputManager@3ed04942
         MEDIA_ROUTER_SERVICE: android.media.MediaRouter@22512c0d
         NSD_SERVICE: android.net.nsd.NsdManager@44514c65
         DISPLAY_SERVICE: null
         USER_SERVICE: null
         BLUETOOTH_SERVICE: null
         APP_OPS_SERVICE: null
         CAPTIONING_SERVICE: null
         CONSUMER_IR_SERVICE: null
         PRINT_SERVICE: null
         APPWIDGET_SERVICE: null
         BATTERY_SERVICE: null
         CAMERA_SERVICE: null
         JOB_SCHEDULER_SERVICE: null
         LAUNCHER_APPS_SERVICE: null
         MEDIA_PROJECTION_SERVICE: null
         MEDIA_SESSION_SERVICE: null
         RESTRICTIONS_SERVICE: null
         TELECOM_SERVICE: null
         TV_INPUT_SERVICE: null
         TELEPHONY_SUBSCRIPTION_SERVICE: null
         USAGE_STATS_SERVICE: null
         CARRIER_CONFIG_SERVICE: null
         FINGERPRINT_SERVICE: null
         MIDI_SERVICE: null
         NETWORK_STATS_SERVICE: null
         HARDWARE_PROPERTIES_SERVICE: null
         SYSTEM_HEALTH_SERVICE: null
         SHORTCUT_SERVICE: null
         COMPANION_DEVICE_SERVICE: null
         STORAGE_STATS_SERVICE: null
         TEXT_CLASSIFICATION_SERVICE: null
         WIFI_AWARE_SERVICE: null
         CROSS_PROFILE_APPS_SERVICE: null
         EUICC_SERVICE: null
         IPSEC_SERVICE: null
         WIFI_RTT_RANGING_SERVICE: null
         BIOMETRIC_SERVICE: null
         ROLE_SERVICE: null
         BLOB_STORE_SERVICE: null
         CONNECTIVITY_DIAGNOSTICS_SERVICE: null
         FILE_INTEGRITY_SERVICE: null
         TELEPHONY_IMS_SERVICE: null
         VPN_MANAGEMENT_SERVICE: null
         APP_SEARCH_SERVICE: null
         BUGREPORT_SERVICE: null
         DISPLAY_HASH_SERVICE: null
         DOMAIN_VERIFICATION_SERVICE: null
         GAME_SERVICE: null
         MEDIA_COMMUNICATION_SERVICE: null
         MEDIA_METRICS_SERVICE: null
         PEOPLE_SERVICE: null
         PERFORMANCE_HINT_SERVICE: null
         VIBRATOR_MANAGER_SERVICE: null
         */
    }

    func testAndroidClasses() throws {
        // load some interesting Android classes that are available via robolectric…
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
    }
    #endif
}
