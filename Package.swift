// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "skiphub",
    defaultLocalization: "en",
    products: [
        .library(name: "SkipUnit", targets: ["SkipUnit"]),
        .library(name: "SkipUnitKt", targets: ["SkipUnitKt"]),

        .library(name: "SkipLib", targets: ["SkipLib"]),
        .library(name: "SkipLibKt", targets: ["SkipLib"]),

        .library(name: "SkipFoundation", targets: ["SkipFoundation"]),
        .library(name: "SkipFoundationKt", targets: ["SkipFoundationKt"]),

        .library(name: "SkipDevice", targets: ["SkipDevice"]),
        .library(name: "SkipDeviceKt", targets: ["SkipDeviceKt"]),

        .library(name: "SkipUI", targets: ["SkipUI"]),
        .library(name: "SkipUIKt", targets: ["SkipUIKt"]),

        .library(name: "SkipSQL", targets: ["SkipSQL"]),
        .library(name: "SkipSQLKt", targets: ["SkipSQLKt"]),

        .library(name: "ExampleLib", targets: ["ExampleLib"]),
        .library(name: "ExampleLibKt", targets: ["ExampleLibKt"]),

        .library(name: "ExampleApp", targets: ["ExampleApp"]),
        .library(name: "ExampleAppKt", targets: ["ExampleAppKt"]),
    ],
    dependencies: [
        .package(url: "https://github.com/skiptools/skip", from: "0.3.30"),
    ],
    targets: [
        .target(name: "SkipUnit", dependencies: [.product(name: "SkipDriver", package: "skip")]),
        .testTarget(name: "SkipUnitTests", dependencies: ["SkipUnit"]),
        .target(name: "SkipUnitKt", dependencies: ["SkipUnit", "SkipLibKt"], resources: [.copy("Skip")], plugins: [.plugin(name: "transpile", package: "skip")]),
        .testTarget(name: "SkipUnitTestsKt", dependencies: ["SkipUnitKt", "SkipUnit"], resources: [.copy("Skip")], plugins: [.plugin(name: "transpile", package: "skip")]),

        // Standard library types: Array, Dictionary, Set, etc.
        .target(name: "SkipLib", plugins: [.plugin(name: "preflight", package: "skip")]),
        .gradle(name: "SkipLib", plugins: [.plugin(name: "transpile", package: "skip")]),
        .testTarget(name: "SkipLibTests", dependencies: ["SkipLib"], plugins: [.plugin(name: "preflight", package: "skip")]),
        .testGradle(name: "SkipLibTests", dependencies: ["SkipLib"], plugins: [.plugin(name: "transpile", package: "skip")]),

        // Foundation types: URL, Data, Date, etc.
        .target(name: "SkipFoundation", dependencies: ["SkipLib"], plugins: [.plugin(name: "preflight", package: "skip")]),
        .gradle(name: "SkipFoundation", dependencies: ["SkipLib"], plugins: [.plugin(name: "transpile", package: "skip")]),
        .testTarget(name: "SkipFoundationTests", dependencies: ["SkipFoundation"], resources: [.process("Resources")], plugins: [.plugin(name: "preflight", package: "skip")]),
        .testGradle(name: "SkipFoundationTests", dependencies: ["SkipFoundation"], plugins: [.plugin(name: "transpile", package: "skip")]),

        // Device-specific services: UserDefaults, Logging, etc.
        .target(name: "SkipDevice", dependencies: ["SkipFoundation"], plugins: [.plugin(name: "preflight", package: "skip")]),
        .gradle(name: "SkipDevice", dependencies: ["SkipFoundation"], plugins: [.plugin(name: "transpile", package: "skip")]),
        .testTarget(name: "SkipDeviceTests", dependencies: ["SkipDevice"], plugins: [.plugin(name: "preflight", package: "skip")]),
        .testGradle(name: "SkipDeviceTests", dependencies: ["SkipDevice"], plugins: [.plugin(name: "transpile", package: "skip")]),

        // SQLite Database
        .target(name: "SkipSQL", dependencies: ["SkipDevice"], plugins: [.plugin(name: "preflight", package: "skip")]),
        .gradle(name: "SkipSQL", dependencies: ["SkipDevice"], plugins: [.plugin(name: "transpile", package: "skip")]),
        .testTarget(name: "SkipSQLTests", dependencies: ["SkipSQL"], plugins: [.plugin(name: "preflight", package: "skip")]),
        .testGradle(name: "SkipSQLTests", dependencies: ["SkipSQL"], plugins: [.plugin(name: "transpile", package: "skip")]),

        // UI
        .target(name: "SkipUI", dependencies: ["SkipFoundation"], plugins: [.plugin(name: "preflight", package: "skip")]),
        .gradle(name: "SkipUI", dependencies: ["SkipFoundation"], plugins: [.plugin(name: "transpile", package: "skip")]),
        .testTarget(name: "SkipUITests", dependencies: ["SkipUI"], plugins: [.plugin(name: "preflight", package: "skip")]),
        .testGradle(name: "SkipUITests", dependencies: ["SkipUI"], plugins: [.plugin(name: "transpile", package: "skip")]),

        // Example library
        .target(name: "ExampleLib", dependencies: ["SkipLib"], plugins: [.plugin(name: "preflight", package: "skip")]),
        .gradle(name: "ExampleLib", dependencies: ["SkipLib"], plugins: [.plugin(name: "transpile", package: "skip")]),
        .testTarget(name: "ExampleLibTests", dependencies: ["ExampleLib"], plugins: [.plugin(name: "preflight", package: "skip")]),
        .testGradle(name: "ExampleLibTests", dependencies: ["ExampleLib"], plugins: [.plugin(name: "transpile", package: "skip")]),

        // Example app
        .target(name: "ExampleApp", dependencies: ["SkipUI", "ExampleLib"], plugins: [.plugin(name: "preflight", package: "skip")]),
        .gradle(name: "ExampleApp", dependencies: ["SkipUI", "ExampleLib"], plugins: [.plugin(name: "transpile", package: "skip")]),
        .testTarget(name: "ExampleAppTests", dependencies: ["ExampleApp"], plugins: [.plugin(name: "preflight", package: "skip")]),
        .testGradle(name: "ExampleAppTests", dependencies: ["ExampleApp"], plugins: [.plugin(name: "transpile", package: "skip")]),
    ]
)

extension Target {
    /// Helper function to create a `target` for a `Kt` framework peer of a Swift target.
    static func gradle(name: String, dependencies: [String] = [], plugins: [PluginUsage]?) -> Target {
        .target(name: name + "Kt", dependencies: dependencies.map({ Dependency(stringLiteral: $0) }) + dependencies.map({ Dependency(stringLiteral: $0 + "Kt") }), resources: [.copy("Skip")], plugins: plugins)
    }

    /// Helper function to create a `testTarget` for a `Kt` framework peer of a Swift target.
    static func testGradle(name: String, dependencies: [String] = [], plugins: [PluginUsage]?) -> Target {
        .testTarget(name: name + "Kt", dependencies: dependencies.map({ Dependency(stringLiteral: $0) }) + dependencies.map({ Dependency(stringLiteral: $0 + "Kt") }) + ["SkipUnitKt"], resources: [.copy("Skip")], plugins: plugins)
    }
}

import class Foundation.ProcessInfo
// For Skip library development in peer directories, run: SKIPLOCAL=.. xed Package.swift
if let localPath = ProcessInfo.processInfo.environment["SKIPLOCAL"] {
    // locally linking SwiftSyntax requires explicit min platform targets
    package.platforms = package.platforms ?? [.iOS(.v15), .macOS(.v12), .tvOS(.v15), .watchOS(.v8), .macCatalyst(.v15)]
    package.dependencies[0] = .package(path: localPath + "/skip")
}
