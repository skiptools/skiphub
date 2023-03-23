// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "skip-core",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .tvOS(.v15),
        .watchOS(.v8),
        .macCatalyst(.v15),
    ],
    products: [
        .library(name: "SkipUnit", targets: ["SkipUnit"]),
        .library(name: "SkipUnitKotlin", targets: ["SkipUnitKotlin"]),

        .library(name: "SkipLib", targets: ["SkipLib"]),
        .library(name: "SkipLibKotlin", targets: ["SkipLib"]),

        .library(name: "SkipFoundation", targets: ["SkipFoundation"]),
        .library(name: "SkipFoundationKotlin", targets: ["SkipFoundationKotlin"]),

        .library(name: "SkipDevice", targets: ["SkipDevice"]),
        .library(name: "SkipDeviceKotlin", targets: ["SkipDeviceKotlin"]),

        .library(name: "SkipUI", targets: ["SkipUI"]),
        .library(name: "SkipUIKotlin", targets: ["SkipUIKotlin"]),

        .library(name: "SkipSQL", targets: ["SkipSQL"]),
        .library(name: "SkipSQLKotlin", targets: ["SkipSQLKotlin"]),

        .library(name: "ExampleLib", targets: ["ExampleLib"]),
        .library(name: "ExampleLibKotlin", targets: ["ExampleLibKotlin"]),

        .library(name: "ExampleApp", targets: ["ExampleApp"]),
        .library(name: "ExampleAppKotlin", targets: ["ExampleAppKotlin"]),
    ],
    dependencies: [
        .package(url: "https://github.com/skiptools/skip.git", from: "0.0.0"),
    ],
    targets: [
        .target(name: "SkipUnit", dependencies: [.product(name: "SkipDriver", package: "skip")]),
        .testTarget(name: "SkipUnitTests", dependencies: ["SkipUnit"]),
        .target(name: "SkipUnitKotlin", dependencies: ["SkipUnit", "SkipLibKotlin"],
                resources: [.copy("skip")],
                plugins: [.plugin(name: "transpile", package: "skip")]),

        // Standard library types: Array, Dictionary, Set, etc.
        .target(name: "SkipLib"),
        .gradle(name: "SkipLib"),
        .testTarget(name: "SkipLibTests", dependencies: ["SkipLib"]),
        .testGradle(name: "SkipLibTests", dependencies: ["SkipLib"]),

        // Foundation types: URL, Data, Date, etc.
        .target(name: "SkipFoundation", dependencies: ["SkipLib"]),
        .gradle(name: "SkipFoundation", dependencies: ["SkipLib"]),
        .testTarget(name: "SkipFoundationTests", dependencies: ["SkipFoundation"]),
        .testGradle(name: "SkipFoundationTests", dependencies: ["SkipFoundation"]),

        // Device-specific services: UserDefaults, Logging, etc.
        .target(name: "SkipDevice", dependencies: ["SkipFoundation"]),
        .gradle(name: "SkipDevice", dependencies: ["SkipFoundation"]),
        .testTarget(name: "SkipDeviceTests", dependencies: ["SkipDevice"]),
        .testGradle(name: "SkipDeviceTests", dependencies: ["SkipDevice"]),

        // SQLite Database
        .target(name: "SkipSQL", dependencies: ["SkipDevice"]),
        .gradle(name: "SkipSQL", dependencies: ["SkipDevice"]),
        .testTarget(name: "SkipSQLTests", dependencies: ["SkipSQL"]),
        .testGradle(name: "SkipSQLTests", dependencies: ["SkipSQL"]),

        // UI
        .target(name: "SkipUI", dependencies: ["SkipFoundation"]),
        .gradle(name: "SkipUI", dependencies: ["SkipFoundation"]),
        .testTarget(name: "SkipUITests", dependencies: ["SkipUI"]),
        .testGradle(name: "SkipUITests", dependencies: ["SkipUI"]),

        // Example library
        .target(name: "ExampleLib", dependencies: ["SkipFoundation"]),
        .gradle(name: "ExampleLib", dependencies: ["SkipFoundation"]),
        .testTarget(name: "ExampleLibTests", dependencies: ["ExampleLib"]),
        .testGradle(name: "ExampleLibTests", dependencies: ["ExampleLib"]),

        // Example app
        .target(name: "ExampleApp", dependencies: ["SkipUI", "ExampleLib"]),
        .gradle(name: "ExampleApp", dependencies: ["SkipUI", "ExampleLib"]),
        .testTarget(name: "ExampleAppTests", dependencies: ["ExampleApp"]),
        .testGradle(name: "ExampleAppTests", dependencies: ["ExampleApp"]),
    ]
)

extension Target {
    static func gradle(name: String, dependencies: [String] = [], standardResources: Bool = true) -> Target {
        // this: .target(name: "SkipLib", dependencies: ["SkipUnit"]),
        // becomes: .target(name: "SkipLibKotlin", dependencies: ["SkipLib"], resources: [.copy("skip")], plugins: [.plugin(name: "transpile", package: "skip")]),
        .target(name: name + "Kotlin", dependencies: [Dependency(stringLiteral: name)] + dependencies.map({ Dependency(stringLiteral: $0 + "Kotlin") }) + ["SkipUnit"], resources: [.copy("skip")], plugins: [.plugin(name: "transpile", package: "skip")])
    }

    static func testGradle(name: String, dependencies: [String] = [], standardResources: Bool = true) -> Target {
        // this: .testTarget(name: "SkipLibTests", dependencies: ["SkipLib"]),
        // becomes: .testTarget(name: "SkipLibKotlinTests", dependencies: ["SkipLibKotlin", "SkipUnitKotlin"], resources: [.copy("skip")], plugins: [.plugin(name: "transpile", package: "skip")]),
        .testTarget(name: name.dropLast("Tests".count) + "KotlinTests", dependencies: dependencies.map({ Dependency(stringLiteral: $0 + "Kotlin") }) + ["SkipUnitKotlin"], resources: [.copy("skip")], plugins: [.plugin(name: "transpile", package: "skip")])
    }
}

// Instead of these .kotlin shortcuts, the targets can be written out manually like so:

//.target(name: "SkipLib", dependencies: ["SkipUnit"]),
//.testTarget(name: "SkipLibTests", dependencies: ["SkipLib"]),
//
//.target(name: "SkipLibKotlin", dependencies: ["SkipLib"], resources: [.copy("skip")], plugins: [.plugin(name: "transpile", package: "skip")]),
//.testTarget(name: "SkipLibKotlinTests", dependencies: ["SkipLibKotlin", "SkipUnit"], resources: [.copy("skip")], plugins: [.plugin(name: "transpile", package: "skip")]),
//
//.target(name: "SkipFoundation", dependencies: ["SkipLib"], resources: [.process("Resources")]),
//.testTarget(name: "SkipFoundationTests", dependencies: ["SkipFoundation"], resources: [.process("Resources")]),
//
//.target(name: "SkipFoundationKotlin", dependencies: ["SkipFoundation", "SkipLibKotlin"], resources: [.copy("skip")], plugins: [.plugin(name: "transpile", package: "skip")]),
//.testTarget(name: "SkipFoundationKotlinTests", dependencies: ["SkipFoundationKotlin", "SkipUnit"], plugins: [.plugin(name: "transpile", package: "skip")]),


import class Foundation.ProcessInfo
if let localPath = ProcessInfo.processInfo.environment["SKIPLOCAL"] {
    // build agains the local relative packages in the peer folders by running: SKIPLOCAL=.. xed Package.swift
    package.dependencies[0] = .package(path: localPath + "/skip")
}
