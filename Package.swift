// swift-tools-version: 5.8
import PackageDescription

let package = Package(
    name: "Skip Package Hub",
    defaultLocalization: "en",
    products: [
        //.executable(name: "skipdroid", targets: ["SkipDroid"]),
        .library(name: "SkipDrive", targets: ["SkipDrive"]),

        .library(name: "SkipUnit", targets: ["SkipUnit"]),
        .library(name: "SkipUnitKt", targets: ["SkipUnitKt"]),

        .library(name: "SkipLib", targets: ["SkipLib"]),
        .library(name: "SkipLibKt", targets: ["SkipLibKt"]),

        .library(name: "SkipFoundation", targets: ["SkipFoundation"]),
        .library(name: "SkipFoundationKt", targets: ["SkipFoundationKt"]),

        .library(name: "SkipKit", targets: ["SkipKit"]),
        .library(name: "SkipKitKt", targets: ["SkipKitKt"]),

        .library(name: "SkipUI", targets: ["SkipUI"]),
        .library(name: "SkipUIKt", targets: ["SkipUIKt"]),

        .library(name: "ExampleLib", targets: ["ExampleLib"]),
        .library(name: "ExampleLibKt", targets: ["ExampleLibKt"]),

        .library(name: "ExampleApp", targets: ["ExampleApp"]),
        .library(name: "ExampleAppKt", targets: ["ExampleAppKt"]),
    ],
    dependencies: [
        .package(url: "https://skip.tools/skiptools/skip.git", from: "0.5.4"),
    ],
    targets: [
        // The launcher executable for the transpiled Android APK
        //.executableTarget(name: "SkipDroid", dependencies: [.target(name: "SkipDrive", condition: .when(platforms: [.android, .linux, .windows, .macOS, .macCatalyst]))]),

        // The Gradle driver for building and testing skip-transpiled projects
        .target(name: "SkipDrive", dependencies: []),

        // Unit testing support: XCTest to JUnit conversion, Gradle test launch and results handling
        .target(name: "SkipUnit", dependencies: [.target(name: "SkipDrive", condition: .when(platforms: [.android, .macOS]))]),
        .target(name: "SkipUnitKt", dependencies: ["SkipUnit", "SkipLibKt"], resources: [.process("Skip")], plugins: [.plugin(name: "transpile", package: "skip")]),
        .testTarget(name: "SkipUnitTests", dependencies: ["SkipUnit"]),
        .testTarget(name: "SkipUnitKtTests", dependencies: ["SkipUnitKt", "SkipUnit"], resources: [.process("Skip")], plugins: [.plugin(name: "transpile", package: "skip")]),

        // Standard library types: Array, Dictionary, Set, etc.
        .target(name: "SkipLib", plugins: [.plugin(name: "preflight", package: "skip")]),
        .target(name: "SkipLibKt", dependencies: ["SkipLib"], resources: [.process("Skip")], plugins: [.plugin(name: "transpile", package: "skip")]),
        .testTarget(name: "SkipLibTests", dependencies: ["SkipLib"], plugins: [.plugin(name: "preflight", package: "skip")]),
        .testTarget(name: "SkipLibKtTests", dependencies: ["SkipLibKt", "SkipUnitKt"], resources: [.process("Skip")], plugins: [.plugin(name: "transpile", package: "skip")]),

        // Foundation types: URL, Data, Date, DateFormatter, Bundle, FileManager, etc.
        .target(name: "SkipFoundation", dependencies: ["SkipLib"], resources: [], plugins: [.plugin(name: "preflight", package: "skip")]),
        .target(name: "SkipFoundationKt", dependencies: ["SkipFoundation", "SkipLibKt"], resources: [.process("Skip")], plugins: [.plugin(name: "transpile", package: "skip")]),
        .testTarget(name: "SkipFoundationTests", dependencies: ["SkipFoundation"], resources: [.process("Resources")], plugins: [.plugin(name: "preflight", package: "skip")]),
        .testTarget(name: "SkipFoundationKtTests", dependencies: ["SkipFoundationKt", "SkipUnitKt"], resources: [.process("Skip")], plugins: [.plugin(name: "transpile", package: "skip")]),

        // Host-specific services: Logging, UserDefaults, Notifications, SQL, Digests, etc.
        .target(name: "SkipKit", dependencies: ["SkipFoundation"], plugins: [.plugin(name: "preflight", package: "skip")]),
        .target(name: "SkipKitKt", dependencies: ["SkipKit", "SkipFoundationKt"], resources: [.process("Skip")], plugins: [.plugin(name: "transpile", package: "skip")]),
        .testTarget(name: "SkipKitTests", dependencies: ["SkipKit"], plugins: [.plugin(name: "preflight", package: "skip")]),
        .testTarget(name: "SkipKitKtTests", dependencies: ["SkipKitKt", "SkipUnitKt"], resources: [.process("Skip")], plugins: [.plugin(name: "transpile", package: "skip")]),

        // UI: SwiftUI to Compose, semantic unit testing
        .target(name: "SkipUI", dependencies: ["SkipKit"], plugins: [.plugin(name: "preflight", package: "skip")]),
        .target(name: "SkipUIKt", dependencies: ["SkipUI", "SkipKitKt"], resources: [.process("Skip")], plugins: [.plugin(name: "transpile", package: "skip")]),
        .testTarget(name: "SkipUITests", dependencies: ["SkipUI"], plugins: [.plugin(name: "preflight", package: "skip")]),
        .testTarget(name: "SkipUIKtTests", dependencies: ["SkipUIKt", "SkipUnitKt"], resources: [.process("Skip")], plugins: [.plugin(name: "transpile", package: "skip")]),

        // Example library
        .target(name: "ExampleLib", dependencies: ["SkipFoundation"], plugins: [.plugin(name: "preflight", package: "skip")]),
        .target(name: "ExampleLibKt", dependencies: ["ExampleLib", "SkipFoundationKt"], resources: [.process("Skip")], plugins: [.plugin(name: "transpile", package: "skip")]),
        .testTarget(name: "ExampleLibTests", dependencies: ["ExampleLib"], plugins: [.plugin(name: "preflight", package: "skip")]),
        .testTarget(name: "ExampleLibKtTests", dependencies: ["ExampleLibKt", "SkipUnitKt"], resources: [.process("Skip")], plugins: [.plugin(name: "transpile", package: "skip")]),

        // Example app
        .target(name: "ExampleApp", dependencies: ["SkipUI", "ExampleLib"], plugins: [.plugin(name: "preflight", package: "skip")]),
        .target(name: "ExampleAppKt", dependencies: ["ExampleApp", "SkipUIKt", "ExampleLibKt"], resources: [.process("Skip")], plugins: [.plugin(name: "transpile", package: "skip")]),
        .testTarget(name: "ExampleAppTests", dependencies: ["ExampleApp"], plugins: [.plugin(name: "preflight", package: "skip")]),
        .testTarget(name: "ExampleAppKtTests", dependencies: ["ExampleAppKt", "SkipUnitKt"], resources: [.process("Skip")], plugins: [.plugin(name: "transpile", package: "skip")]),
    ]
)

import class Foundation.ProcessInfo
// For Skip library development in peer directories, run: SKIPLOCAL=.. xed Package.swift
if let localPath = ProcessInfo.processInfo.environment["SKIPLOCAL"] {
    // locally linking SwiftSyntax requires explicit min platform targets
    package.platforms = package.platforms ?? [.iOS(.v16), .macOS(.v13), .tvOS(.v16), .watchOS(.v9), .macCatalyst(.v16)]
    package.dependencies[0] = .package(path: localPath + "/skip")
}
