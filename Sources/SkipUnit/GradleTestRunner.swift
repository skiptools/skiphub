// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
//@_exported import SkipBuild
//import TSCBasic
//import SkipSyntax
//import OSLog
//
//fileprivate let logger = Logger(subsystem: "skip", category: "unit")
//fileprivate let gradleLogger = Logger(subsystem: "skip", category: "gradle")
//
///// The base class for executing a transpiled test case.
//open class GradleTestRunner : XCTestCase {
//    /// Whether the fork the tests from the XCTestCase
//    public static var testInProcess = true
//
//    open override func setUp() async throws {
//        try await super.setUp()
//    }
//}
//
//extension GradleTestRunner {
//    public func transpileAndTest(targets: SkipTargetSet) async throws {
//        // locate the root package for this test case (assuming shallow test directory structure of Tests/ModuleName/TestCase.swift)
//        let srcURL = URL(fileURLWithPath: targets.sourceBase.description, isDirectory: false)
//            .deletingLastPathComponent()
//            .deletingLastPathComponent()
//            .deletingLastPathComponent()
//
//        // turn SomeLibTests.SomeLibTests/ into SomeLibTests/
//        let testOutputBase = String(self.className.split(separator: ".").first ?? .init(self.className))
//
//        let sourceFS = localFileSystem
//        let sourceRoot = try AbsolutePath(validating: srcURL.path)
//
//        let destFS = sourceFS
//        let destRoot = sourceRoot.appending(components: [SkipSystem.kipFolderName, testOutputBase])
//
//        // transpile and assemble the gradle project in the given destination
//        let (destRooResult, createdPaths) = try await SkipSystem.assemble(root: sourceRoot, sourceFS: sourceFS, targets: targets, destRoot: destRoot, destFS: destFS)
//
//        let destRootURL = URL(fileURLWithPath: destRooResult.pathString)
//        let paths = createdPaths.map({ URL(fileURLWithPath: $0.pathString) })
//
//        // create the Gradle project and execute it
//        try await SkipSystem.assembleAndExecuteGradle(testCase: Self.testInProcess ? self : nil, root: srcURL, targets: targets, destRootURL: destRootURL, paths: paths)
//    }
//}
//
//#if os(macOS) || os(Linux)
//extension SkipSystem {
//    @discardableResult static func assembleAndExecuteGradle(testCase: GradleTestRunner?, root packageRoot: URL, targets: SkipTargetSet, destRootURL destRoot: URL, paths: [URL], verbose: Bool = true, overwrite: Bool = true, studioID: String = androidStudioBundleID) async throws -> URL {
//
//        logger.info("transpiling and testing: \(targets.target.moduleName) from: \(packageRoot.path)")
//
//        let packageSwift = try await SkipSystem.parsePackageSwift(path: packageRoot)
//
//        let _ = packageSwift // TODO: use Package.swift to determine local module dependencies
//
//        let workingFolder = try AbsolutePath(validating: destRoot.path)
//
//        #if DEBUG
//        let target = "testDebugUnitTest"
//        #else
//        let target = "testReleaseUnitTest"
//        #endif
//
//        guard let testCase = testCase else {
//            logger.info("skipping test cases; run or watch manually with: \(destRoot.path)/gradlew -p \(destRoot.path) test -t")
//            return destRoot // only fork the tests if we have specified a test case
//        }
//
//        logger.debug("exec: \(destRoot.appendingPathComponent("gradlew").path)")
//        let args = [
//            destRoot.appendingPathComponent("gradlew").path,
//            "--no-daemon",
//            "--console", "plain",
//            verbose ? "--info" : nil,
//            //"--stacktrace",
//            "--rerun-tasks", // force Gradle to execute all tasks ignoring up-to-date checks
//            "--project-dir", destRoot.path,
//            target,
//        ].compactMap({ $0 })
//
//        let gradleOpts = [
//            // output to a folder that isn't contained in the project itself
//            // "-Dorg.gradle.project.buildDir=/tmp/gradle-build",
//
//            // disable the daemon. In order for this to work, the options must match *exactly* what the daemon would fork,
//            // which seems to be a combination of the settings in the build.gradle.kts (e.g., the max memory that we configure),
//            // as well as some of these openns arguments that don't seem to be documented
//            // "GRADLE_OPTS": "-Xmx512m -Dorg.gradle.daemon=false", // otherwise: “To honour the JVM settings for this build a single-use Daemon process will be forked.”
//            // 2023-03-01T22:35:37.611-0500 [INFO] [org.gradle.launcher.daemon.configuration.BuildProcess] Checking if the launcher JVM can be re-used for build. To be re-used, the launcher JVM needs to match the parameters required for the build process: --add-opens=java.base/java.util=ALL-UNNAMED --add-opens=java.base/java.lang=ALL-UNNAMED --add-opens=java.base/java.lang.invoke=ALL-UNNAMED --add-opens=java.prefs/java.util.prefs=ALL-UNNAMED --add-opens=java.base/java.nio.charset=ALL-UNNAMED --add-opens=java.base/java.net=ALL-UNNAMED --add-opens=java.base/java.util.concurrent.atomic=ALL-UNNAMED -Xmx2g -Dfile.encoding=UTF-8 -Duser.country=US -Duser.language=en -Duser.variant
//
//            "-Dorg.gradle.daemon=false",
//            "-Xmx2g",
//            "--add-opens=java.base/java.util=ALL-UNNAMED",
//            "--add-opens=java.base/java.lang=ALL-UNNAMED",
//            "--add-opens=java.base/java.lang.invoke=ALL-UNNAMED",
//            "--add-opens=java.prefs/java.util.prefs=ALL-UNNAMED",
//            "--add-opens=java.base/java.nio.charset=ALL-UNNAMED",
//            "--add-opens=java.base/java.net=ALL-UNNAMED",
//            "--add-opens=java.base/java.util.concurrent.atomic=ALL-UNNAMED",
//        ]
//        let env = [
//            "GRADLE_OPTS": gradleOpts.joined(separator: " "), // save build artifacts in TMP
//            "ANDROID_HOME": ("~/Library/Android/sdk" as NSString).expandingTildeInPath, // the standard install for the SDK
//            // "JAVA_HOME": "/opt/homebrew/opt/openjdk/libexec/openjdk.jdk/Contents/Home", // override JAVA_HOME
//        ]
//
//        var issues: [XCTIssue] = []
//        do {
//            func handleOutputLine(_ outputLine: String) {
//                if outputLine.hasPrefix("w: ") {
//                    gradleLogger.warning("\(outputLine)")
//                    // breakpoint here to stop on build warning
//                } else if outputLine.hasPrefix("e: ") {
//                    gradleLogger.error("\(outputLine)")
//                    // breakpoint here to stop on build error
//                } else if outputLine.trimmingCharacters(in: .whitespaces).hasSuffix(" FAILED") {
//                    gradleLogger.error("\(outputLine)")
//                    // breakpoint here to stop on test case failure
//                } else {
//                    gradleLogger.debug("\(outputLine)")
//                }
//
//                //try Task.checkCancellation() // TODO: throwing?
//
//                // errors look like: java.lang.AssertionError at SkipFoundationTests.kt:13
//                let line = outputLine.trimmingCharacters(in: .whitespaces)
//                if line.hasPrefix("java.lang.AssertionError") {
//                    if let fileLine = outputLine.components(separatedBy: " at ").last,
//                       let fileName = fileLine.split(separator: ":").first,
//                       let fileLine = Int(fileLine.split(separator: ":").last ?? "") {
//                        // the file is unfortunately only the last path component, so we need to manually find it to match it back to the issue so Xcode can jump to the right line in the generated content; so we look up the full path from the list of transpiled URLs (hoping the test file names are unique)
//                        let filePath = paths.first(where: { $0.lastPathComponent == fileName })?.path ?? String(fileName)
//                        let issue = XCTIssue(type: .assertionFailure, compactDescription: line, detailedDescription: line, sourceCodeContext: XCTSourceCodeContext(location: XCTSourceCodeLocation(filePath: filePath, lineNumber: fileLine)), associatedError: nil, attachments: [])
//                        issues.append(issue)
//                        testCase.record(issue)
//                    }
//                }
//            }
//
//            var outputBuffer = Data()
//            func handleOutput(_ buffer: [UInt8]) {
//                let nl = Character("\n").asciiValue
//                for c in buffer {
//                    if c == nl {
//                        let str = String(data: outputBuffer, encoding: .utf8) ?? ""
//                        handleOutputLine(str)
//                        outputBuffer = Data()
//                    } else {
//                        outputBuffer.append(c)
//                    }
//                }
//            }
//
//            let process = Process(arguments: ["/usr/bin/env"] + args, environment: env, workingDirectory: workingFolder, outputRedirection: .stream(stdout: handleOutput, stderr: { _ in }, redirectStderr: true))
//            let stdin = try process.launch()
//            let _ = stdin
//            let result = try await process.waitUntilExit()
//            // Throw if there was a non zero termination.
//            guard result.exitStatus == .terminated(code: 0) else {
//                throw ProcessResult.Error.nonZeroExit(result)
//            }
//        } catch let error as TSCBasic.Process.Error {
//            // Gradle fails either due to build failures or test failures; since we're already creating issues for the test failures, we shouldn't add an additional failure
//            //if issues.isEmpty {
//                throw error
//            //}
//        }
//
//        return destRoot
//    }
//}
//#endif
//
//extension XCTestCase {
//    /// Checks that the given Swift compiles to the specified Kotlin.
//    public func check(swift: String, kotlin: String? = nil, file: StaticString = #file, line: UInt = #line) async throws {
//        /// Creates a temporary file with the given name and optional contents.
//        func tmpFile(named fileName: String, contents: String? = nil) throws -> URL {
//            let tmpDir = URL(fileURLWithPath: UUID().uuidString, isDirectory: true, relativeTo: URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true))
//            try FileManager.default.createDirectory(at: tmpDir, withIntermediateDirectories: true)
//            let tmpFile = URL(fileURLWithPath: fileName, isDirectory: false, relativeTo: tmpDir)
//            if let contents = contents {
//                try contents.write(to: tmpFile, atomically: true, encoding: .utf8)
//            }
//            return tmpFile
//        }
//
//        let srcFile = try tmpFile(named: "Source.swift", contents: swift)
//        if let kotlin = kotlin {
//            let tp = Transpiler(sourceFiles: [Source.File(path: srcFile.path)])
//            try await tp.transpile { transpilation in
//                //logger.debug("transpilation: \(transpilation.output.content)")
//                XCTAssertEqual(kotlin.trimmingCharacters(in: .whitespacesAndNewlines), transpilation.output.content.trimmingCharacters(in: .whitespacesAndNewlines), file: file, line: line)
//            }
//        }
//    }
//
//}
