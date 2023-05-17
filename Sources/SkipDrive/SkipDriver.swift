// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
#if !SKIP
import Foundation


/// A harness for invoking `gradle` and processing the output of builds and tests.
@available(macOS 10.15, macCatalyst 11, *)
@available(iOS, unavailable, message: "Gradle tests can only be run on macOS")
@available(watchOS, unavailable, message: "Gradle tests can only be run on macOS")
@available(tvOS, unavailable, message: "Gradle tests can only be run on macOS")
public protocol GradleHarness {
    /// Scans the output line of the Gradle command and processes it for errors or issues.
    func scanGradleOutput(line: String)
}

@available(macOS 10.15, macCatalyst 11, *)
@available(iOS, unavailable, message: "Gradle tests can only be run on macOS")
@available(watchOS, unavailable, message: "Gradle tests can only be run on macOS")
@available(tvOS, unavailable, message: "Gradle tests can only be run on macOS")
extension GradleHarness {
    /// Returns the URL to the folder that holds the top-level `settings.gradle.kts` file for the destination module.
    /// - Parameters:
    ///   - moduleTranspilerFolder: the output folder for the transpiler plug-in
    ///   - linkFolder: when specified, the module's root folder will first be linked into the linkFolder, which enables the output of the project to be browsable from the containing project (e.g., Xcode)
    /// - Returns: the folder that contains the buildable gradle project, either in the DerivedData/ folder, or re-linked through the specified linkFolder
    public func pluginOutputFolder(moduleTranspilerFolder: String, linkingInto linkFolder: URL?) throws -> URL {
        let env = ProcessInfo.processInfo.environment

        // if we are running tests from Xcode, this environment variable should be set; otherwise, assume the .build folder for an SPM build
        // also seems to be __XPC_DYLD_LIBRARY_PATH or __XPC_DYLD_FRAMEWORK_PATH;
        // this will be something like ~/Library/Developer/Xcode/DerivedData/PROJ-ABC/Build/Products/Debug
        //
        // so we build something like:
        //
        // ~/Library/Developer/Xcode/DerivedData/PROJ-ABC/Build/Products/Debug/../../../SourcePackages/plugins/skiphub.output/
        //
        if let xcodeBuildFolder = env["__XCODE_BUILT_PRODUCTS_DIR_PATHS"] ?? env["BUILT_PRODUCTS_DIR"] {
            let buildBaseFolder = URL(fileURLWithPath: xcodeBuildFolder, isDirectory: true)
                .deletingLastPathComponent()
                .deletingLastPathComponent()
                .deletingLastPathComponent()
            let xcodeFolder = buildBaseFolder.appendingPathComponent("SourcePackages/plugins", isDirectory: true)
            return try findModuleFolder(in: xcodeFolder, extension: "output")
        } else {
            // when run from the CLI with a custom --build-path, there seems to be no way to know where the gradle folder was output, so we need to also specify it as an environment variable:
            // SWIFTBUILD=/tmp/swiftbuild swift test --build-path /tmp/swiftbuild
            let buildBaseFolder = env["SWIFTBUILD"] ?? ".build"
            // note that unlike Xcode, the local SPM output folder is just the package name without the ".output" suffix
            return try findModuleFolder(in: URL(fileURLWithPath: buildBaseFolder + "/plugins/outputs", isDirectory: true), extension: "")
        }

        /// The only known way to figure out the package name asociated with the test's module is to brute-force search through the plugin output folders.
        func findModuleFolder(in pluginOutputFolder: URL, extension pathExtension: String) throws -> URL {
            for outputFolder in try FileManager.default.contentsOfDirectory(at: pluginOutputFolder, includingPropertiesForKeys: [.isDirectoryKey]) {
                if !pathExtension.isEmpty && !outputFolder.lastPathComponent.hasSuffix("." + pathExtension) {
                    continue // only check known path extensions (e.g., ".output")
                }

                let pluginModuleOutputFolder = URL(fileURLWithPath: moduleTranspilerFolder, isDirectory: true, relativeTo: outputFolder)
                //print("findModuleFolder: pluginModuleOutputFolder:", pluginModuleOutputFolder)
                if (try? pluginModuleOutputFolder.resourceValues(forKeys: [.isDirectoryKey]).isDirectory) == true {
                    // found the folder; now make a link from its parent folder to the project source…
                    if let linkFolder = linkFolder {
                        let localModuleLink = URL(fileURLWithPath: outputFolder.lastPathComponent, isDirectory: false, relativeTo: linkFolder)
                        //print("findModuleFolder: localModuleLink:", localModuleLink.path)

                        // make sure the output root folder exists
                        try FileManager.default.createDirectory(at: linkFolder, withIntermediateDirectories: true)

                        let linkFrom = localModuleLink.path, linkTo = outputFolder.path
                        //print("findModuleFolder: createSymbolicLink:", linkFrom, linkTo)

                        if (try? FileManager.default.destinationOfSymbolicLink(atPath: linkFrom)) != linkTo {
                            try? FileManager.default.removeItem(atPath: linkFrom) // if it exists
                            try FileManager.default.createSymbolicLink(atPath: linkFrom, withDestinationPath: linkTo)
                        }

                        let localTranspilerOut = URL(fileURLWithPath: outputFolder.lastPathComponent, isDirectory: true, relativeTo: localModuleLink)
                        let linkedPluginModuleOutputFolder = URL(fileURLWithPath: moduleTranspilerFolder, isDirectory: true, relativeTo: localTranspilerOut)
                        //print("findModuleFolder: linkedPluginModuleOutputFolder:", linkedPluginModuleOutputFolder.path)
                        return linkedPluginModuleOutputFolder
                    } else {
                        return pluginModuleOutputFolder
                    }
                }
            }
            throw NoModuleFolder(errorDescription: "Unable to find module folders in \(pluginOutputFolder.path)")
        }
    }

    /// For any given source file, find the nearest parent folder that contains a `Package.swift` file.
    /// - Parameter forSourceFile: the source file for the request, typically from the `#file` directive at the call site
    /// - Returns: the URL containing the `Package.swift` file, or `.none` if it could not be found.
    public func packageBaseFolder(forSourceFile sourcePath: StaticString) -> URL? {
        var packageRootURL = URL(fileURLWithPath: sourcePath.description, isDirectory: false)

        let isPackageRoot = {
            (try? packageRootURL.appendingPathComponent("Package.swift", isDirectory: false).checkResourceIsReachable()) == true
        }

        while true {
            let parent = packageRootURL.deletingLastPathComponent()
            if parent.path == packageRootURL.path {
                return nil // top of the fs and not found
            }
            packageRootURL = parent
            if isPackageRoot() {
                return packageRootURL
            }
        }
    }

    /// Uses the system `adb` process to install and launch the given APK, following the
    public func launchAPK(device: String?, appid: String, log: [String] = [], apk: String, relativeTo sourcePath: StaticString = #file) async throws {
        let env: [String: String] = [:]

        let apkPath = URL(fileURLWithPath: apk, isDirectory: false, relativeTo: packageBaseFolder(forSourceFile: sourcePath))

        guard FileManager.default.isReadableFile(atPath: apkPath.path) else {
            throw ADBError(errorDescription: "APK did not exist at \(apkPath.path)")
        }

        // List of devices attached:
        // adb-R9TT50AJWEX-F9Ujyu._adb-tls-connect._tcp.    device
        // emulator-5554    device
        let adbDevices = [
            "adb",
            "devices",
        ]

        for try await outputLine in Process.streamLines(command: adbDevices, environment: env, onExit: { result in
            guard case .terminated(0) = result.exitStatus else {
                // we failed, but did not expect an error
                throw ADBError(errorDescription: "error listing devices: \(result)")
            }
        }) {
            print("ADB DEVICE>", outputLine)
        }

        let adb = ["adb"] + (device.flatMap { ["-s", $0] } ?? [])

        // adb install -r Packages/Skip/skipapp.swiftpm.output/AppDemoKtTests/skip-transpiler/AppDemo/.build/AppDemo/outputs/apk/debug/AppDemo-debug.apk
        let adbInstall = adb + [
            "install",
            "-r", // replace existing application
            "-t", // allow test packages
            apkPath.path,
        ]

        print("running:", adbInstall.joined(separator: " "))

        for try await outputLine in Process.streamLines(command: adbInstall, environment: env, onExit: { result in
            guard case .terminated(0) = result.exitStatus else {
                // we failed, but did not expect an error
                throw ADBError(errorDescription: "error installing APK: \(result)")
            }
        }) {
            print("ADB>", outputLine)
        }

        // adb shell am start -n app.demo/.MainActivity
        let adbStart = adb + [
            "shell",
            "am",
            "start-activity",
            "-S", // force stop the target app before starting the activity
            "-W", // wait for launch to complete
            "-n", appid,
        ]

        for try await outputLine in Process.streamLines(command: adbStart, environment: env, onExit: { result in
            guard case .terminated(0) = result.exitStatus else {
                throw ADBError(errorDescription: "error launching APK: \(result)")
            }
        }) {
            print("ADB>", outputLine)
        }

        // GOOD:
        // ADB> Starting: Intent { cmp=app.demo/.MainActivity }

        // BAD:
        // ADB> Error: Activity not started, unable to resolve Intent { act=android.intent.action.VIEW dat= flg=0x10000000 }


        if !log.isEmpty {
            // adb shell am start -n app.demo/.MainActivity
            let logcat = adb + [
                "logcat",
                "-T", "100", // start with only the 100 most recent entries
                // "-v", "time",
                // "-d", // dump then exit
            ]
            + log // e.g., ["*:W"] or ["app.demo*:E"],


            for try await outputLine in Process.streamLines(command: logcat, environment: env, onExit: { result in
                guard case .terminated(0) = result.exitStatus else {
                    throw ADBError(errorDescription: "error watching log: \(result)")
                }
            }) {
                print("LOGCAT>", outputLine)
            }
        }
    }

}

public struct NoModuleFolder : LocalizedError {
    public var errorDescription: String?
}

public struct ADBError : LocalizedError {
    public var errorDescription: String?
}

#endif

