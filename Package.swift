// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "skiphub",
    defaultLocalization: "en",
    products: [
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
        .package(url: "https://github.com/skiptools/skip", from: "0.3.42"),
    ],
    targets: [
        .target(name: "SkipUnit", dependencies: [.product(name: "SkipDriver", package: "skip")]),
        .target(name: "SkipUnitKt", dependencies: ["SkipUnit", "SkipLibKt"], resources: [.copy("Skip")], plugins: [.plugin(name: "transpile", package: "skip")]),
        .testTarget(name: "SkipUnitTests", dependencies: ["SkipUnit"]),
        .testTarget(name: "SkipUnitKtTests", dependencies: ["SkipUnitKt", "SkipUnit"], resources: [.copy("Skip")], plugins: [.plugin(name: "transpile", package: "skip")]),

        // Standard library types: Array, Dictionary, Set, etc.
        .target(name: "SkipLib", plugins: [.plugin(name: "preflight", package: "skip")]),
        .target(name: "SkipLibKt", dependencies: ["SkipLib"], resources: [.copy("Skip")], plugins: [.plugin(name: "transpile", package: "skip")]),
        .testTarget(name: "SkipLibTests", dependencies: ["SkipLib"], plugins: [.plugin(name: "preflight", package: "skip")]),
        .testTarget(name: "SkipLibKtTests", dependencies: ["SkipLibKt", "SkipUnitKt"], resources: [.copy("Skip")], plugins: [.plugin(name: "transpile", package: "skip")]),

        // Foundation types: URL, Data, Date, etc.
        .target(name: "SkipFoundation", dependencies: ["SkipLib"], plugins: [.plugin(name: "preflight", package: "skip")]),
        .target(name: "SkipFoundationKt", dependencies: ["SkipFoundation", "SkipLibKt"], resources: [.copy("Skip")], plugins: [.plugin(name: "transpile", package: "skip")]),
        .testTarget(name: "SkipFoundationTests", dependencies: ["SkipFoundation"], resources: [.process("Resources")], plugins: [.plugin(name: "preflight", package: "skip")]),
        .testTarget(name: "SkipFoundationKtTests", dependencies: ["SkipFoundationKt", "SkipUnitKt"], resources: [.copy("Skip")], plugins: [.plugin(name: "transpile", package: "skip")]),

        // Device-specific services: UserDefaults, Logging, etc.
        .target(name: "SkipKit", dependencies: ["SkipFoundation"], plugins: [.plugin(name: "preflight", package: "skip")]),
        .target(name: "SkipKitKt", dependencies: ["SkipKit", "SkipFoundationKt"], resources: [.copy("Skip")], plugins: [.plugin(name: "transpile", package: "skip")]),
        .testTarget(name: "SkipKitTests", dependencies: ["SkipKit"], plugins: [.plugin(name: "preflight", package: "skip")]),
        .testTarget(name: "SkipKitKtTests", dependencies: ["SkipKitKt", "SkipUnitKt"], resources: [.copy("Skip")], plugins: [.plugin(name: "transpile", package: "skip")]),

        // UI
        .target(name: "SkipUI", dependencies: ["SkipKit"], plugins: [.plugin(name: "preflight", package: "skip")]),
        .target(name: "SkipUIKt", dependencies: ["SkipUI", "SkipKitKt"], resources: [.copy("Skip")], plugins: [.plugin(name: "transpile", package: "skip")]),
        .testTarget(name: "SkipUITests", dependencies: ["SkipUI"], plugins: [.plugin(name: "preflight", package: "skip")]),
        .testTarget(name: "SkipUIKtTests", dependencies: ["SkipUIKt", "SkipUnitKt"], resources: [.copy("Skip")], plugins: [.plugin(name: "transpile", package: "skip")]),

        // Example library
        .target(name: "ExampleLib", dependencies: ["SkipFoundation"], plugins: [.plugin(name: "preflight", package: "skip")]),
        .target(name: "ExampleLibKt", dependencies: ["ExampleLib", "SkipFoundationKt"], resources: [.copy("Skip")], plugins: [.plugin(name: "transpile", package: "skip")]),
        .testTarget(name: "ExampleLibTests", dependencies: ["ExampleLib"], plugins: [.plugin(name: "preflight", package: "skip")]),
        .testTarget(name: "ExampleLibKtTests", dependencies: ["ExampleLibKt", "SkipUnitKt"], resources: [.copy("Skip")], plugins: [.plugin(name: "transpile", package: "skip")]),

        // Example app
        .target(name: "ExampleApp", dependencies: ["SkipUI", "ExampleLib"], plugins: [.plugin(name: "preflight", package: "skip")]),
        .target(name: "ExampleAppKt", dependencies: ["ExampleApp", "SkipUIKt", "ExampleLibKt"], resources: [.copy("Skip")], plugins: [.plugin(name: "transpile", package: "skip")]),
        .testTarget(name: "ExampleAppTests", dependencies: ["ExampleApp"], plugins: [.plugin(name: "preflight", package: "skip")]),
        .testTarget(name: "ExampleAppKtTests", dependencies: ["ExampleAppKt", "SkipUnitKt"], resources: [.copy("Skip")], plugins: [.plugin(name: "transpile", package: "skip")]),
    ]
)

import class Foundation.ProcessInfo
// For Skip library development in peer directories, run: SKIPLOCAL=.. xed Package.swift
if let localPath = ProcessInfo.processInfo.environment["SKIPLOCAL"] {
    // locally linking SwiftSyntax requires explicit min platform targets
    package.platforms = package.platforms ?? [.iOS(.v15), .macOS(.v12), .tvOS(.v15), .watchOS(.v8), .macCatalyst(.v15)]
    package.dependencies[0] = .package(path: localPath + "/skip")
}
