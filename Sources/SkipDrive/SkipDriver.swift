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
                if outputFolder.pathExtension != pathExtension {
                    continue // only check known path extensions (e.g., ".output" or "")
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
}

public struct NoModuleFolder : LocalizedError {
    public var errorDescription: String?
}

#endif

