# SkipHub

The SkipHub repository contains the Swift Package Manager
modules for the core Skip library ecosystem, consisting of
the following core packages:

- SkipUnit: base testing support for Skip packages
- SkipLib: the Swift standard library Kotlin support
- SkipFoundation: Kotlin equivalents for a subset of Foundation
- SkipKit: Skip host support for Darwin and Android
- SkipUI: Declarative user-interface module for iOS and Android based on SwiftUI and Jetpack Compose.


SkipFoundation
===============

The types in `SkipFoundation` are limited to the subset of `swift-corelibs-foundation` types
for which an equivalent exists in a standard Kotlin environment without incurring any additional dependencies.

This means that types like `Date` (`java.util.Date`) and `Data` (`kotlin.ByteArray`) are provided,
but types like `UserDefaults` and `NotificationCenter` must be implemented at a higher level
like `SkipKit` that provies Android dependencies.

Any occurances of `import Foundation` will be transpiled to `import skip.foundation.*` in Kotlin,
and so it should not be necessary to import `SkipFoundation` directly from Swift.

## SkipFoundation Implementation Status

This document lays out the structure of the SkipFoundation project, and provides the current implementation status of each major feature area.


#### Table Key

##### Implementation Status
* _N/A_: There are no plans to port the given entity.
* _Unimplemented_: This entity does not yet exist.
* _Incomplete_: Implementation of this entity has begun, but critical sections have been left `NSUnimplemented()`
* _Mostly Complete_: All critical sections of this entity have been implemented, but some methods might remain `NSUnimplemented()`
* _Complete_: No methods are left `NSUnimplemented()` (though this is not a guarantee that work is complete -- there may be methods that need overriding or extra work)

##### Test Coverage
* _N/A_: This entity is internal and public tests are inappropriate, or it is an entity for which testing does not make sense
* _None_: There are no unit tests specific to this entity yet
* _Incomplete_: Unit tests exist for this entity, but there are critical paths that are not being tested
* _Substantial_: Most, if not all, of this entity's critical paths are being tested


### Entities

* **Model**: Representations for abstract model elements like null, data, and errors.

    | Entity Name              | Status          | Test Coverage | Notes                             |
    |--------------------------|-----------------|---------------|-----------------------------------|
    | `Data`                   | Incomplete      | Incomplete    |  `kotlin.ByteArray`               |
    | `NSData`                 | Incomplete      | "             |  "                                |
    | `NSMutableData`          | Incomplete      | "             |  "                                |
    | `UUID`                   | Incomplete      | Incomplete    |  `java.util.UUID`                 |
    | `NSUUID`                 | Incomplete      | "             |  "                                |
    | `NSNull`                 | Unimplemented   | None          |                                   |
    | `NSProgress`             | Unimplemented   | None          |                                   |
    | `NSError`                | Unimplemented   | None          |                                   |

* **DateTime**: Classes for representing dates, timezones, and calendars.

    | Entity Name        | Status          | Test Coverage | Notes                  |
    |--------------------|-----------------|---------------|------------------------|
    | `Date`             | Incomplete      | Incomplete    | `java.util.Date`       |
    | `NSDate`           | Incomplete      | "             | "                      |
    | `TimeZone`         | Unimplemented   | None          | `java.util.TimeZone`?  |
    | `NSTimeZone`       | Unimplemented   | None          | "                      |
    | `Calendar`         | Unimplemented   | None          | `java.util.Calendar`?  |
    | `NSCalendar`       | Unimplemented   | None          | "                      |
    | `DateComponents`   | Unimplemented   | None          |                        |
    | `NSDateComponents` | Unimplemented   | None          |                        |
    | `DateInterval`     | Unimplemented   | None          |                        |
    | `NSDateInterval`   | Unimplemented   | None          |                        |

* **App**: App runtime

    | Entity Name      | Status          | Test Coverage | Notes                                       |
    |------------------|-----------------|---------------|---------------------------------------------|
    | `NSPasteBoard`   | Unimplemented   | None          | `android.content.ClipboardManager`?         |
    | `NSCache`        | Unimplemented   | None          | `Map<SoftReference, V>`?                    |


* **UserDefaults**: A mechanism for storing values to persist as user settings and local.

    | Entity Name    | Status          | Test Coverage | Notes                                 |
    |----------------|-----------------|---------------|---------------------------------------|
    | `Locale`       | Incomplete      | Incomplete    | `java.util.Locale`                    |
    | `NSLocale`     | Incomplete      | "             | "                                     |
    | `UserDefaults` | Unimplemented   | None          | `android.content.SharedPreferences`?  |

* **URL**: Networking primitives

    | Entity Name                  | Status          | Test Coverage | Notes                         |
    |------------------------------|-----------------|---------------|-------------------------------|
    | `URL`                        | Incomplete      | Incomplete    | `java.net.URL`                |
    | `NSURL`                      | Incomplete      | "             | "                             |
    | `URLRequest`                 | Unimplemented   | None          | `java.net.URLConnection`?     |
    | `NSURLRequest`               | Unimplemented   | None          | "                             |
    | `NSMutableURLRequest`        | Unimplemented   | None          | "                             |
    | `URLResponse`                | Unimplemented   | None          |                               |
    | `NSHTTPURLResponse`          | Unimplemented   | None          |                               |
    | `URLResourceValues`          | Unimplemented   | None          |                               |
    | `URLSession`                 | Unimplemented   | None          |                               |
    | `URLSessionConfiguration`    | Unimplemented   | None          |                               |
    | `URLCache`                   | Unimplemented   | None          |                               |
    | `URLCredential`              | Unimplemented   | None          |                               |
    | `URLCredentialStorage`       | Unimplemented   | None          |                               |
    | `NSURLError*`                | Unimplemented   | None          |                               |
    | `URLProtectionSpace`         | Unimplemented   | None          |                               |
    | `URLProtocol`                | Unimplemented   | None          |                               |
    | `URLProtocolClient`          | Unimplemented   | None          |                               |
    | `NSURLQueryItem`             | Unimplemented   | None          |                               |
    | `URLResourceKey`             | Unimplemented   | None          |                               |
    | `URLFileResourceType`        | Unimplemented   | None          |                               |
    | `URLComponents`              | Unimplemented   | None          |                               |
    | `URLAuthenticationChallenge` | Unimplemented   | None          |                               |
    | `HTTPCookie`                 | Unimplemented   | None          |                               |
    | `HTTPCookiePropertyKey`      | Unimplemented   | None          |                               |
    | `HTTPCookieStorage`          | Unimplemented   | None          |                               |
    | `HTTPBodySource`             | Unimplemented   | None          |                               |
    | `HTTPMessage`                | Unimplemented   | None          |                               |
    | `MultiHandle`                | Unimplemented   | None          |                               |
    | `TaskRegistry`               | Unimplemented   | None          |                               |
    | `TransferState`              | Unimplemented   | None          |                               |

* **Formatters**: Locale and language-correct formatted values.

    | Entity Name                     | Status          | Test Coverage | Notes                         |
    |---------------------------------|-----------------|---------------|-------------------------------|
    | `ISO8601DateFormatter`          | Incomplete      | Incomplete    | `java.text.SimpleDateFormat`  |
    | `Formatter`                     | Unimplemented   | None          | uses pointers                 |
    | `NumberFormatter`               | Unimplemented   | None          | `java.text.NumberFormat`?     |
    | `DateFormatter`                 | Unimplemented   | None          | `java.text.DateFormat`?       |
    | `DateComponentsFormatter`       | Unimplemented   | None          |                               |
    | `DateIntervalFormatter`         | Unimplemented   | None          |                               |
    | `EnergyFormatter`               | Unimplemented   | None          |                               |
    | `LengthFormatter`               | Unimplemented   | None          |                               |
    | `MassFormatter`                 | Unimplemented   | None          |                               |
    | `ByteCountFormatter`            | Unimplemented   | None          |                               |
    | `MeasurementFormatter`          | Unimplemented   | None          |                               |
    | `PersonNameComponentsFormatter` | Unimplemented   | None          |                               |
    | `PersonNameComponents`          | Unimplemented   | None          |                               |
    | `NSPersonNameComponents`        | Unimplemented   | None          |                               |

* **OS**: Mechanisms for interacting with the operating system on a file system level as well as process and thread level

    | Entity Name      | Status          | Test Coverage | Notes                                       |
    |------------------|-----------------|---------------|---------------------------------------------|
    | `os.log.Logger`* | Incomplete      | Incomplete    | `android.util.Log`                          |
    | `FileManager`    | Incomplete      | Incomplete    | `java.io.File`                              |
    | `Bundle`         | Unimplemented   | None          | `android.content.res.Resources`?            |
    | `FileHandle`     | Unimplemented   | None          | `java.io.FileDescriptor`?                   |
    | `Pipe`           | Unimplemented   | None          | `java.nio.channels.Pipe`?                   |
    | `Process`        | Unimplemented   | None          | `java.lang.Process`?                        |
    | `ProcessInfo`    | Unimplemented   | None          |                                             |
    | `Lock`           | Unimplemented   | None          | `java.util.concurrent.locks.Lock`?          |
    | `ConditionLock`  | Unimplemented   | None          |                                             |
    | `RecursiveLock`  | Unimplemented   | None          | `java.util.concurrent.locks.ReentrantLock`? |
    | `Condition`      | Unimplemented   | None          |                                             |
    | `Thread`         | Unimplemented   | None          | `java.lang.Thread`?                         |
    | `Operation`      | Unimplemented   | None          |                                             |
    | `BlockOperation` | Unimplemented   | None          |                                             |
    | `OperationQueue` | Unimplemented   | None          |                                             |

* **Runtime**: The basis for interoperability.

    | Entity Name             | Status          | Test Coverage | Notes                        |
    |-------------------------|-----------------|---------------|------------------------------|
    | `NSObject`              | Unimplemented   | None          | `java.lang.Object`?          |
    | `NSStringFromClass`     | Unimplemented   | None          | `Class.getName`?             |
    | `NSClassFromString`     | Unimplemented   | None          | `Class.forName`?             |
    | `NSEnumerator`          | Unimplemented   | None          | `java.util.Enumeration`?     |
    | `NSGetSizeAndAlignment` | Unimplemented   | None          |                              |
    | `NSSwiftRuntime`        | Unimplemented   | None          |                              |
    | `Boxing`                | Unimplemented   | None          |                              |


* **Collections**: A group of classes to contain objects.

    | Entity Name           | Status          | Test Coverage | Notes                          |
    |-----------------------|-----------------|---------------|--------------------------------|
    | `IndexPath`           | Unimplemented   | None          |                                |
    | `IndexSet`            | Unimplemented   | None          |                                |
    | `NSIndexSet`          | Unimplemented   | None          |                                |
    | `NSMutableIndexSet`   | Unimplemented   | None          |                                |
    | `NSOrderedSet`        | Unimplemented   | None          |                                |
    | `NSMutableOrderedSet` | Unimplemented   | None          |                                |
    | `NSDictionary`        | Unimplemented   | None          | `java.util.HashMap`            |
    | `NSMutableDictionary` | Unimplemented   | None          |                                |
    | `NSIndexPath`         | Unimplemented   | None          |                                |
    | `NSArray`             | Unimplemented   | None          | `java.util.ArrayList`?         |
    | `NSMutableArray`      | Unimplemented   | None          | "                              |
    | `NSSet`               | Unimplemented   | None          | `java.util.HashSet`            |
    | `NSMutableSet`        | Unimplemented   | None          | "                              |
    | `NSCountedSet`        | Unimplemented   | None          |                                |
    | `NSSortDescriptor`    | Unimplemented   | None          |                                |

* **Predicates**: Base functionality for building queries.

    This is the base class and subclasses for `NSPredicate` and `NSExpression`.

    | Entity Name             | Status        | Test Coverage | Notes                          |
    |-------------------------|---------------|---------------|--------------------------------|
    | `NSExpression`          | Unimplemented | None          |                                |
    | `NSComparisonPredicate` | Unimplemented | None          |                                |
    | `NSCompoundPredicate`   | Unimplemented | None          |                                |
    | `NSPredicate`           | Unimplemented | None          |                                |

* **RunLoop**: Timers, streams and run loops.

    The classes in this group provide support for scheduling work and acting upon input from external sources.

    | Entity Name      | Status          | Test Coverage | Notes                    |
    |------------------|-----------------|---------------|--------------------------|
    | `RunLoop`        | Unimplemented   | None          | `android.os.Looper`      |
    | `Timer`          | Unimplemented   | None          | `java.util.Timer`        |
    | `InputStream`    | Unimplemented   | None          | `java.io.InputStream`?   |
    | `NSInputStream`  | Unimplemented   | None          | "                        |
    | `NSOutputStream` | Unimplemented   | None          | `java.io.OutputStream`?  |
    | `Stream`         | Unimplemented   | None          |                          |
    | `NSStream`       | Unimplemented   | None          |                          |
    | `Port`           | Unimplemented   | None          |                          |
    | `MessagePort`    | Unimplemented   | None          |                          |
    | `SocketPort`     | Unimplemented   | None          |                          |
    | `PortMessage`    | Unimplemented   | None          |                          |

* **String**: A set of classes for scanning, manipulating and storing string values.

    | Entity Name                 | Status          | Test Coverage | Notes                         |
    |-----------------------------|-----------------|---------------|-------------------------------|
    | `NSRegularExpression`       | Unimplemented   | None          | `java.util.regex.Matcher`?    |
    | `Scanner`                   | Unimplemented   | None          | `java.util.Scanner`           |
    | `CharacterSet`              | Unimplemented   | None          |                               |
    | `NSCharacterSet`            | Unimplemented   | None          |                               |
    | `NSMutableCharacterSet`     | Unimplemented   | None          |                               |
    | `NSAttributedString`        | Unimplemented   | None          | `java.text.AttributedString`? |
    | `NSMutableAttributedString` | Unimplemented   | None          | "                             |
    | `NSTextCheckingResult`      | Unimplemented   | None          |                               |
    | `NSString`                  | Unimplemented   | None          |                               |
    | `NSStringEncodings`         | Unimplemented   | None          |                               |
    | `NSStringAPI`               | Unimplemented   | None          |                               |

* **Number**: A set of classes and methods for representing numeric values and structures.

    | Entity Name                       | Status          | Test Coverage | Notes                        |
    |-----------------------------------|-----------------|---------------|------------------------------|
    | `CGFloat`                         | Unimplemented   | None          |                              |
    | `CGPoint`                         | Unimplemented   | None          |                              |
    | `CGSize`                          | Unimplemented   | None          |                              |
    | `CGRect`                          | Unimplemented   | None          |                              |
    | `NSRange`                         | Unimplemented   | None          |                              |
    | `NSNumber`                        | Unimplemented   | None          |                              |
    | `NSValue`                         | Unimplemented   | None          |                              |
    | `NSConcreteValue`                 | Unimplemented   | None          |                              |
    | `NSSpecialValue`                  | Unimplemented   | None          |                              |
    | `Decimal`                         | Unimplemented   | None          |                              |
    | `NSDecimalNumber`                 | Unimplemented   | None          |                              |
    | `NSDecimalNumberHandler`          | Unimplemented   | None          |                              |
    | `NSEdgeInsets`                    | Unimplemented   | None          |                              |
    | `NSGeometry`                      | Unimplemented   | None          |                              |
    | `AffineTransform`                 | Unimplemented   | None          |                              |
    | `NSAffineTransform`               | Unimplemented   | None          |                              |
    
* **Measurement**: A set of classes and methods for handling measurement and conversions.

    | Entity Name                       | Status          | Test Coverage | Notes                        |
    |-----------------------------------|-----------------|---------------|------------------------------|
    | `Measurement`                     | Unimplemented   | None          |                              |
    | `NSMeasurement`                   | Unimplemented   | None          |                              |
    | `Dimension`                       | Unimplemented   | None          |                              |
    | `UnitConverter`                   | Unimplemented   | None          |                              |
    | `UnitConverterLinear`             | Unimplemented   | None          |                              |
    | `Unit`                            | Unimplemented   | None          |                              |
    | `UnitAcceleration`                | Unimplemented   | None          |                              |
    | `UnitAngle`                       | Unimplemented   | None          |                              |
    | `UnitArea`                        | Unimplemented   | None          |                              |
    | `UnitDispersion`                  | Unimplemented   | None          |                              |
    | `UnitDuration`                    | Unimplemented   | None          |                              |
    | `UnitEnergy`                      | Unimplemented   | None          |                              |
    | `UnitFrequency`                   | Unimplemented   | None          |                              |
    | `UnitFuelEfficiency`              | Unimplemented   | None          |                              |
    | `UnitLength`                      | Unimplemented   | None          |                              |
    | `UnitIlluminance`                 | Unimplemented   | None          |                              |
    | `UnitMass`                        | Unimplemented   | None          |                              |
    | `UnitPower`                       | Unimplemented   | None          |                              |
    | `UnitPressure`                    | Unimplemented   | None          |                              |
    | `UnitSpeed`                       | Unimplemented   | None          |                              |
    | `UnitTemperature`                 | Unimplemented   | None          |                              |
    | `UnitVolume`                      | Unimplemented   | None          |                              |

* **Notifications**: Classes for loosely coupling events from a set of many observers.

    | Entity Name          | Status          | Test Coverage | Notes                                  |
    |----------------------|-----------------|---------------|----------------------------------------|
    | `NSNotification`     | Unimplemented   | None          |                                        |
    | `NotificationCenter` | Unimplemented   | None          | `android.content.BroadcastReceiver`?   |
    | `Notification`       | Unimplemented   | None          |                                        |
    | `NotificationQueue`  | Unimplemented   | None          |                                        |

* **Serialization**: Serialization and deserialization functionality.

    The classes in this group perform tasks like parsing and writing JSON, property lists and binary archives.

    | Entity Name                 | Status          | Test Coverage | Notes                    |
    |-----------------------------|-----------------|---------------|--------------------------|
    | `NSJSONSerialization`       | Unimplemented   | None          | `kotlinx.serialization`? |
    | `PropertyListSerialization` | Unimplemented   | None          |                          |
    | `NSKeyedArchiver`           | N/A             | None          |                          |
    | `NSKeyedCoderOldStyleArray` | N/A             | None          |                          |
    | `NSKeyedUnarchiver`         | N/A             | None          |                          |
    | `NSKeyedArchiverHelpers`    | N/A             | None          |                          |
    | `NSCoder`                   | N/A             | None          |                          |
    
* **XML**: A group of classes for parsing and representing XML documents and elements.

    | Entity Name   | Status          | Test Coverage | Notes                                        |
    |---------------|-----------------|---------------|----------------------------------------------|
    | `XMLDocument` | Unimplemented   | None          | `org.w3c.dom.Document`?                      |
    | `XMLDTD`      | Unimplemented   | None          | `org.w3c.dom.DocumentType`?                  |
    | `XMLElement`  | Unimplemented   | None          | `org.w3c.dom.Element`?                       |
    | `XMLNode`     | Unimplemented   | None          | `org.w3c.dom.Node`?                          |
    | `XMLParser`   | Unimplemented   | None          | `javax.xml.parsers.SAXParserFactory`?        |
    | `XMLParser`+  | Unimplemented   | None          | `javax.xml.parsers.DocumentBuilderFactory`?  |


SkipKit
===============

SkipKit is a project that aims to provide Android equivalent interfaces to device and system libraries such as DeviceServices, CoreLocation, and other iOS device-related interfaces.

SkipUI
===============

The mission of the SkipUI project is to provide a functional equivalent of SwiftUI atop Jetpack Compose for Android.

Modules
=======

- System
  - Crypto
  - SQLite
  - FileSystem
  - Localization
- Device
  - Network
  - NetInfo
  - Clipboard
  - Battery
  - Location
  - Brightness
  - AsyncStorage
  - BackgroundFetch
  - Notifications
  - SecureStore (Keychain + UserDefaults)
- Periphireals
  - Camera
  - Print
- Sensors
  - Accelerometer
  - Barometer
  - Gyroscope
  - DeviceMotion
  - LightSensor
  - Magnetometer
  - Pedometer
- Services
  - Maps
  - Speech
  - Geocoding
  - Sharing
  - PlatformAuthentication
  - SMS
  - Cellular
- LocalInfobase
  - Calendar
  - Contacts
  - MediaLibrary
- Application
- Linking
- TaskManager
- AV
- Audio
- Video
- VideoThumbnails
- Asset
- AuthSession
- BarCodeScanner
- BuildProperties
- Constants
- ErrorRecovery
- FaceDetector
- FlashList
- Haptics
- IntentLauncher
- KeepAwake
- LocalAuthentication
- MailComposer
- Reanimated
- SafeAreaContext
- ScreenCapture
- ScreenOrientation
- Screens
- SharedElement
- Skia
- Stripe
- Svg
- SystemUI
- TrackingTransparency
- InAppPurchases
- Updates
- StoreReview
- Font
- Image
- Picker
- Slider
- Checkbox
- SegmentedControl
- NavigationBar
- ViewPager
- DocumentPicker
- BlurView
- MaskedView
- LinearGradient
- GestureHandler
- GLView
- WebView
- WebBrowser
- DateTimePicker
- ImageManipulator
- ImagePicker
- MapView
- SplashScreen
- StatusBar
- Lottie

