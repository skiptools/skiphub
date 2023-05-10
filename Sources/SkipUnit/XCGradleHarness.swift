// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
#if !SKIP
import XCTest

/// A `XCTestCase` that invokes the `gradle` process.
///
/// When run as part of a test suite, JUnit XML test reports are parsed and converted to Xcode issues, along with any reverse-source mappings from transpiled Kotlin back into the original Swift.
@available(macOS 13, macCatalyst 16, *)
@available(iOS, unavailable, message: "Gradle tests can only be run on macOS")
@available(watchOS, unavailable, message: "Gradle tests can only be run on macOS")
@available(tvOS, unavailable, message: "Gradle tests can only be run on macOS")
public protocol XCGradleHarness {
}

@available(macOS 13, macCatalyst 16, *)
extension XCGradleHarness where Self : XCTestCase {

    /// Invokes the `gradle` process with the specified arguments.
    ///
    /// This is typically used to invoke test cases, but any actions and arguments can be specified, which can be used to drive the Gradle project in custom ways from a Skip test case.
    /// - Parameters:
    ///   - actions: the actions to invoke, such as `test` or `assembleDebug`
    ///   - arguments: and additional arguments
    ///   - outputPrefix: the prefix for funneling Gradle output messages to the console, or `nil` to mute the console
    ///   - moduleSuffix: the expected module name for automatic test determination
    ///   - linkFolderBase: the local Packages folder within which links should be created to the transpiled project
    ///   - sourcePath: the full path to the test case call site, which is used to determine the package root
    public func gradle(actions: [String], arguments: [String] = [], outputPrefix: String? = "GRADLE>", moduleSuffix: String = "KtTests", linkFolderBase: String? = "Packages/Skip", maxMemory: UInt64? = ProcessInfo.processInfo.physicalMemory, fromSourceFileRelativeToPackageRoot sourcePath: StaticString? = #file) async throws {
        // only run in subclasses, not in the base test
        if self.className == "SkipUnit.XCGradleHarness" {
            // TODO: add a general system gradle checkup test here
        } else {
            let selfType = type(of: self)
            let moduleName = String(reflecting: selfType).components(separatedBy: ".").first ?? ""
            if !moduleName.hasSuffix(moduleSuffix) {
                throw InvalidModuleNameError(errorDescription: "The module name '\(moduleName)' is invalid for running gradle tests; it must end with '\(moduleSuffix)'")
            }

            let driver = try await GradleDriver()

            // walk up from the test case swift file until we find the folder that contains "Package.swift", which we treat as the package root
            var linkFolder: URL? = nil
            if let sourcePath = sourcePath, let linkFolderBase = linkFolderBase {
                let sourcePathURL = URL(fileURLWithPath: sourcePath.description, isDirectory: false)
                var packageRootURL = sourcePathURL.deletingLastPathComponent()

                let isPackageRoot = { (try? packageRootURL.appendingPathComponent("Package.swift", isDirectory: false).checkResourceIsReachable()) != true }

                while !isPackageRoot() {
                    let parent = packageRootURL.deletingLastPathComponent()
                    if parent.path == packageRootURL.path {
                        break // top of the fs and not found
                    }
                    packageRootURL = parent
                }
                if isPackageRoot() {
                    linkFolder = packageRootURL.appendingPathComponent(linkFolderBase, isDirectory: true)
                }
            }

            let dir = try pluginOutputFolder(moduleTranspilerFolder: moduleName + "/skip-transpiler/", linkingInto: linkFolder)

            // tests are run in the merged base module (e.g., "SkipLib") that corresponds to this test module name ("SkipLibKtTests")
            let baseModuleName = moduleName.dropLast(moduleSuffix.count).description

            var testProcessResult: ProcessResult? = nil
            let (output, parseResults) = try await driver.launchGradleProcess(in: dir, module: baseModuleName, actions: actions, arguments: arguments, maxMemory: maxMemory, exitHandler: { result in
                // do not fail on non-zero exit code because we want to be able to parse the test results first
                testProcessResult = result
            })

            for try await line in output {
                if let outputPrefix = outputPrefix {
                    print(outputPrefix, line)
                }
                checkOutputForIssue(line: line)
            }

            // if any of the actions are a test case, when try to parse the XML results
            if actions.contains(where: { $0.hasPrefix("test") }) {
                let testSuites = try parseResults()
                // the absense of any test data probably indicates some sort of mis-configuration or else a build failure
                XCTAssertNotEqual(0, testSuites.count, "No tests were run")
                reportTestResults(testSuites, dir)
            }

            switch testProcessResult?.exitStatus {
            case .terminated(let code):
                // this is a general error that is reported whenever gradle fails, so that the overall test will fail even when we cannot parse any build errors or test failures
                // there should be additional messages in the log to provide better indication of where the test failed
                XCTAssertTrue(code == 0, "Gradle failed with exit code \(code)")
            default:
                XCTFail("Gradle process crashed: \(testProcessResult?.description ?? "")")
            }
        }
    }


    /// Returns the URL to the folder that holds the top-level `settings.gradle.kts` file for the destination module.
    /// - Parameters:
    ///   - moduleTranspilerFolder: the output folder for the transpiler plug-in
    ///   - linkFolder: when specified, the module's root folder will first be linked into the linkFolder, which enables the output of the project to be browsable from the containing project (e.g., Xcode)
    /// - Returns: the folder that contains the buildable gradle project, either in the DerivedData/ folder, or re-linked through the specified linkFolder
    func pluginOutputFolder(moduleTranspilerFolder: String, linkingInto linkFolder: URL?) throws -> URL {
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


    /// The contents typically contain a stack trace, which we need to parse in order to try to figure out the source code and line of the failure:
    /// ```
    ///  org.junit.ComparisonFailure: expected:<ABC[]> but was:<ABC[DEF]>
    ///      at org.junit.Assert.assertEquals(Assert.java:117)
    ///      at org.junit.Assert.assertEquals(Assert.java:146)
    ///      at skip.unit.XCTestCase.XCTAssertEqual(XCTest.kt:31)
    ///      at skip.lib.SkipLibTests.testSkipLib$SkipLib(SkipLibTests.kt:16)
    ///      at java.base/jdk.internal.reflect.DirectMethodHandleAccessor.invoke(DirectMethodHandleAccessor.java:104)
    ///      at java.base/java.lang.reflect.Method.invoke(Method.java:578)
    ///      at org.junit.runners.model.FrameworkMethod$1.runReflectiveCall(FrameworkMethod.java:59)
    /// ```
    private func extractSourceLocation(dir: URL, failure: GradleDriver.TestFailure) -> (kotlin: XCTSourceCodeLocation?, swift: XCTSourceCodeLocation?) {
        // turn: "at skip.lib.SkipLibTests.testSkipLib$SkipLib(SkipLibTests.kt:16)"
        // into: src/main/skip/lib/SkipLibTests.kt line: 16

        for line in failure.contents?.split(separator: "\n") ?? [] {
            let trimmedLine = line.trimmingCharacters(in: .whitespaces)
            // make sure it matches the pattern: "at skip.lib.SkipLibTests.testSkipLib$SkipLib(SkipLibTests.kt:16)"
            if !trimmedLine.hasPrefix("at ") || !line.hasSuffix(")") {
                continue
            }

            let lineParts = trimmedLine.dropFirst(3).dropLast().split(separator: "(").map(\.description) // drop the "at" and final paren

            // get the contents of the final parens, like: (SkipLibTests.kt:16)
            guard lineParts.count == 2,
                  let stackElement = lineParts.first,
                  let fileLine = lineParts.last else {
                continue
            }

            if stackElement.hasPrefix("org.junit.") {
                // skip over JUnit stack elements
                continue
            }

            if stackElement.hasPrefix("skip.unit.XCTestCase") {
                // skip over assertion wrappers
                continue
            }

            // check the format of the "SkipLibTests.kt:16" line, and only continut for Kotlin files
            let parts = fileLine.split(separator: ":").map(\.description)
            guard parts.count == 2,
                  let fileName = parts.first,
                  let fileLine = parts.last,
                  let fileLineNumber = Int(fileLine),
                  fileName.hasSuffix(".kt") else {
                continue
            }

            // now look at the stackElement like "skip.lib.SkipLibTests.testSkipLib$SkipLib" and turn it into "skip/lib/SkipLibTests.kt"
            let packageElements = stackElement.split(separator: ".").map(\.description)

            // extract the kotlin module name, which comes after the dollar in the stack trace:
            // e.g., "SkipLib" is extracted from "skip.lib.SkipLibTests.testSkipLib$SkipLib"
            // also handle Kotlin/Gradle/Android appending of _debug or _release to the module name:
            // "skip.device.SkipKitTests.testCanvas$SkipKit_debug" should turn into "SkipKit"
            // this will break of the package/module name has an underscore in it.

            // FIXME: only test cases seems to be appended with the "$Module_debug" suffix; non-test stack do not have it, so we'll need to try to figure out the module name for the code if we want to handle jumping to non-test locations
            guard let moduleElements = packageElements.last?.split(separator: "$"),
                  moduleElements.count == 2,
                  let moduleName = moduleElements.last?.split(separator: "_").first else {
                continue
            }

            // the module name comes before the root of the source paths
            let modulePath = dir.appendingPathComponent(String(moduleName), isDirectory: true)

            // we have the base file name; now construct the file path based on the package name of the failing stack
            // we need to check in both the base source folders of the project: "src/test/kotlin/" and "src/main/kotlin/"
            // also include (legacy) Java paths, which by convention can also contain Kotlin files
            for folder in [
                modulePath.appendingPathComponent("src/test/kotlin/", isDirectory: true),
                modulePath.appendingPathComponent("src/main/kotlin/", isDirectory: true),
                modulePath.appendingPathComponent("src/test/java/", isDirectory: true),
                modulePath.appendingPathComponent("src/main/java/", isDirectory: true),
            ] {
                var filePath = folder

                for packagePart in packageElements {
                    if packagePart.lowercased() != packagePart {
                        // assume the convention of package names being lower-case and class names being camel-case
                        break
                    }
                    filePath = filePath.appendingPathComponent(packagePart, isDirectory: true)
                }

                // finally, tack on the name of the kotlin file to the end of the path
                filePath = filePath.appendingPathComponent(fileName, isDirectory: false)

                // check whether the file exists; if not, it may be in another of the root folders
                if FileManager.default.fileExists(atPath: filePath.path) {
                    let kotlinLocation = XCTSourceCodeLocation(fileURL: filePath, lineNumber: fileLineNumber)
                    let swiftLocation = try? kotlinLocation.findSourceMapLine()
                    return (kotlinLocation, swiftLocation)
                }
            }
        }

        return (nil, nil)
    }

    /// Parse the line looking for compile errors like:
    ///
    /// ```
    /// e: file:///SOME/PAH/Library/Developer/Xcode/DerivedData/Skip-ID/SourcePackages/plugins/skiphub.output/SkipSQLKtTests/skip-transpiler/SkipSQL/src/main/kotlin/skip/sql/SkipSQL.kt:94:26 Function invocation 'blob(...)' expected
    /// ```
    private func checkOutputForIssue(line: String) {
        if line.hasPrefix("e: file://") || line.hasPrefix("w: file://") {
            let isWarning = line.hasPrefix("w: file://")

            let trimmedLine = line.dropFirst("w: file://".count)
            let lineComponents = trimmedLine.split(separator: ":", maxSplits: 3, omittingEmptySubsequences: false)
            guard let fileURLString = lineComponents.first,
                  let fileURL = URL(string: String("file://" + fileURLString)) else {
                return
            }

            guard let lineNumberString = lineComponents.dropFirst().first,
                  let lineNumber = Int(lineNumberString) else {
                return
            }

            if !isWarning {
                print("reporting error in file:", fileURLString, "line:", lineNumber)
                let kotlinLocation = XCTSourceCodeLocation(fileURL: fileURL, lineNumber: lineNumber)

                let desc = lineComponents.dropFirst(1).joined(separator: ":")

                // report the Kotlin error
                do {
                    // attempt the map the error back any originally linking source projects, since it is better the be editing the canonical Xcode version of the file as Xcode is able to provide details about it
                    let kotlinLocationOrig = XCTSourceCodeLocation(fileURL: URL(fileURLWithPath: (try? FileManager.default.destinationOfSymbolicLink(atPath: kotlinLocation.fileURL.path)) ?? kotlinLocation.fileURL.path), lineNumber: kotlinLocation.lineNumber)

                    let issue = XCTIssue(type: .system, compactDescription: desc, detailedDescription: desc, sourceCodeContext: XCTSourceCodeContext(location: kotlinLocationOrig), associatedError: nil, attachments: [])
                    record(issue)
                }

                // also look up in the Swift location
                if let swiftLocation = try? kotlinLocation.findSourceMapLine() {
                    let issue = XCTIssue(type: .system, compactDescription: desc, detailedDescription: desc, sourceCodeContext: XCTSourceCodeContext(location: swiftLocation), associatedError: nil, attachments: [])
                    record(issue)
                }
            }
        }
    }

    private func reportTestResults(_ testSuites: [GradleDriver.TestSuite], _ dir: URL, showStreams: Bool = true) {

        // do one intial pass to show the stdout and stderror
        if showStreams {
            for testSuite in testSuites {
                let testSuiteName = testSuite.name.split(separator: ".").last?.description ?? testSuite.name

                // all the stdout/stderr is batched together for all test tests, so output it all at the end
                // and line up the spaced with the "GRADLE TEST CASE" line describing the test
                if let systemOut = testSuite.systemOut {
                    print("JUNIT TEST STDOUT: \(testSuiteName):")
                    let prefix = "STDOUT> "
                    print(prefix + systemOut.split(separator: "\n").joined(separator: "\n" + prefix))
                }
                if let systemErr = testSuite.systemErr {
                    print("JUNIT TEST STDERR: \(testSuiteName):")
                    let prefix = "STDERR> "
                    print(prefix + systemErr.split(separator: "\n").joined(separator: "\n" + prefix))
                }
            }
        }

        var passTotal = 0, failTotal = 0, skipTotal = 0, suiteTotal = 0, testsTotal = 0
        var timeTotal = 0.0

        // parse the test result XML files and convert test failures into XCTIssues with links to the failing source and line
        for testSuite in testSuites {
            // Turn "skip.foundation.TestDateIntervalFormatter" into "TestDateIntervalFormatter"
            let testSuiteName = testSuite.name.split(separator: ".").last?.description ?? testSuite.name

            suiteTotal += 1
            var pass = 0, fail = 0, skip = 0
            var timeSuite = 0.0
            defer {
                passTotal += pass
                failTotal += fail
                skipTotal += skip
                timeTotal += timeSuite
            }

            for testCase in testSuite.testCases {
                testsTotal += 1
                if testCase.skipped {
                    skip += 1
                } else if testCase.failures.isEmpty {
                    pass += 1
                } else {
                    fail += 1
                }
                timeSuite += testCase.time

                var msg = ""

                // msg += className + "." // putting the class name in makes the string long

                // Jupiter test case names are like "testSystemRandomNumberGenerator$SkipFoundation()"
                let testName = testCase.name.split(separator: "$").first?.description ?? testCase.name

                // turn "" into ""
                msg += testSuiteName + "." + testName

                if !testCase.skipped {
                    msg += " (" + testCase.time.description + ") " // add in the time for profiling
                }

                print("JUNIT TEST", testCase.skipped ? "SKIPPED" : testCase.failures.isEmpty ? "PASSED" : "FAILED", msg)
                // add a failure for each reported failure
                for failure in testCase.failures {
                    var failureMessage = failure.message
                    let trimPrefixes = [
                        "testProjectGradle(): ",
                        //"java.lang.AssertionError: ",
                    ]
                    for trimPrefix in trimPrefixes {
                        if failureMessage.hasPrefix(trimPrefix) {
                            failureMessage.removeFirst(trimPrefix.count)
                        }
                    }

                    let failureContents = failure.contents ?? ""

                    // TODO: extract the file path and report the failing file abd line to xcode
                    var msg = msg
                    msg += failure.type
                    msg += ": "
                    msg += failureMessage
                    msg += ": "
                    msg += failureContents // add the stack trace

                    // convert the failure into an XCTIssue so we can see where in the source it failed
                    let issueType: XCTIssueReference.IssueType

                    // check for common known assertion failure exception types
                    if failure.type.hasPrefix("org.junit.")
                        || failure.type.hasPrefix("org.opentest4j.") {
                        issueType = .assertionFailure
                    } else {
                        // we might rather mark it as a `thrownError`, but Xcode seems to only report a single thrownError, whereas it will report multiple `assertionFailure`
                        // issueType = .thrownError
                        issueType = .assertionFailure
                    }

                    let (kotlinLocation, swiftLocation) = extractSourceLocation(dir: dir, failure: failure)


                    // and report the Kotlin error so the user can jump to the right place
                    do {
                        let issue = XCTIssue(type: issueType, compactDescription: failure.message, detailedDescription: failure.contents, sourceCodeContext: XCTSourceCodeContext(location: kotlinLocation), associatedError: nil, attachments: [])
                        record(issue)
                    }

                    // we managed to link up the Kotlin line with the Swift source file, so add an initial issue with the swift location
                    if let swiftLocation = swiftLocation {
                        let issue = XCTIssue(type: issueType, compactDescription: failure.message, detailedDescription: failure.contents, sourceCodeContext: XCTSourceCodeContext(location: swiftLocation), associatedError: nil, attachments: [])
                        record(issue)
                    }
                }
            }

            print("JUNIT TEST SUITE: \(testSuiteName): PASSED \(pass) FAILED \(fail) SKIPPED \(skip) TIME \(round(timeSuite * 100.0) / 100.0)")
        }

        let passPercentage = Double(passTotal) / (testsTotal == 0 ? Double.nan : Double(testsTotal))
        print("JUNIT SUITES \(suiteTotal) TESTS \(testsTotal) PASSED \(passTotal) (\(round(passPercentage * 100))%) FAILED \(failTotal) SKIPPED \(skipTotal) TIME \(round(timeTotal * 100.0) / 100.0)")

        // TODO: compare the output with the SPM test output "xunit" xml reports
    }

}

struct NoModuleFolder : LocalizedError {
    var errorDescription: String?
}

struct InvalidModuleNameError : LocalizedError {
    var errorDescription: String?
}

extension XCTSourceCodeLocation : SourceCodeLocation {

}
#endif // !SKIP