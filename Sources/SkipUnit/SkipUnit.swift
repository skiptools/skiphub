// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
#if !SKIP
import XCTest
import SkipDriver

/// A base test case for a JUnit 5 (Jupiter) test suite, which is expected to use skip-transpiled tests.
open class JupiterTestCase: XCTestCase {
    public func testProjectGradle() async throws {
        // only run in subclasses, not in the base test
        #if os(macOS) || os(Linux)
        if self.className == "SkipUnit.JupiterTestCase" {
            // TODO: add a general system gradle checkup test here
        } else {
            try await runGradleTests()
        }
        #else
        print("skipping testProjectGradle() for non-macOS target")
        #endif
    }

    #if os(macOS) || os(Linux)
    func runGradleTests() async throws {
        let selfType = type(of: self)
        let moduleName = String(reflecting: selfType).components(separatedBy: ".").first ?? ""
        let moduleSuffix = "KotlinTests"
        if !moduleName.hasSuffix(moduleSuffix) {
            struct InvalidModuleNameError : LocalizedError {
                var errorDescription: String?
            }
            throw InvalidModuleNameError(errorDescription: "The module name '\(moduleName)' is invalid for running gradle tests; it must end with '\(moduleSuffix)'")
        }

        let driver = try await GradleDriver()
        let dir = try pluginOutputFolder(module: moduleName)

        // tests are run in the merged base module (e.g., "SkipLib") that corresponds to this test module name ("SkipLibKotlinTests")
        let baseModuleName = moduleName.dropLast(moduleSuffix.count).description

        var testProcessResult: ProcessResult? = nil
        let (output, parseResults) = try await driver.runTests(in: dir, module: baseModuleName, exitHandler: { result in
            // do not fail on non-zero exit code because we want to be able to parse the test results first
            testProcessResult = result
        })

        for try await line in output {
            print("GRADLE>", line)
        }

        let testSuites = try await parseResults()

        XCTAssertNotEqual(0, testSuites.count, "no tests were run")

        for testSuite in testSuites {
            for testCase in testSuite.testCases {
                var msg = ""
                msg += className + "."
                // Jupiter test case names are like "testSystemRandomNumberGenerator$SkipFoundation()"
                msg += testCase.name.split(separator: "$").first?.description ?? testCase.name
                msg += " (" + testCase.time.formatted(.number) + ") " // add in the time for profiling

                print("GRADLE TEST CASE", testCase.failures.isEmpty ? "PASSED" : "FAILED", msg)

                // add a failure for each reported failure
                for failure in testCase.failures {
                    // TODO: extract the file path and report the failing file abd line to xcode
                    var msg = msg
                    msg += failure.type
                    msg += ": "
                    msg += failure.message
                    msg += ": "
                    msg += failure.contents ?? "empty" // add the stack trace; TODO: option for trimming
                    XCTFail(msg)
                }
            }
        }

        //let firstResult = try XCTUnwrap(results.first)

        switch testProcessResult?.exitStatus {
        case .terminated(let code):
            XCTAssertEqual(0, code, "gradle process failed either build or test")
        default:
            XCTFail("gradle process unexpected exit: \(testProcessResult?.description ?? "")")
        }
    }

    func pluginOutputFolder(module moduleName: String) throws -> URL {
        let env = ProcessInfo.processInfo.environment

        // if we are running tests from Xcode, this environment variable should be set; otherwise, assume the .build folder for an SPM build
        // also seems to be __XPC_DYLD_LIBRARY_PATH or __XPC_DYLD_FRAMEWORK_PATH;
        // this will be something like ~/Library/Developer/Xcode/DerivedData/PROJ-ABC/Build/Products/Debug
        //
        // so we build something like:
        //
        // ~/Library/Developer/Xcode/DerivedData/PROJ-ABC/Build/Products/Debug/../../../SourcePackages/plugins/skip-core.output/
        //
        if let xcodeBuildFolder = env["__XCODE_BUILT_PRODUCTS_DIR_PATHS"] ?? env["BUILT_PRODUCTS_DIR"] {
            let buildBaseFolder = URL(fileURLWithPath: xcodeBuildFolder, isDirectory: true)
                .deletingLastPathComponent()
                .deletingLastPathComponent()
                .deletingLastPathComponent()
            let xcodeFolder = buildBaseFolder.appendingPathComponent("SourcePackages/plugins", isDirectory: true)
            return try findModuleFolder(in: xcodeFolder, extension: "output")
        } else {
            // note that unlike Xcode, the local SPM outputs folder is just the package name without the ".output" suffix
            return try findModuleFolder(in: URL(fileURLWithPath: ".build/plugins/outputs", isDirectory: true), extension: nil)
        }

        /// The only known way to figure out the package name asociated with the test's module is to brute-force search through the plugin output folders.
        func findModuleFolder(in pluginOutputFolder: URL, extension pathExtension: String?) throws -> URL {
            for outputFolder in try FileManager.default.contentsOfDirectory(at: pluginOutputFolder, includingPropertiesForKeys: [.isDirectoryKey]) {
                if outputFolder.pathExtension != pathExtension {
                    continue // only check known path extensions (e.g., ".output" or nil)
                }
                let pluginModuleOutputFolder = URL(fileURLWithPath: moduleName + "/SkipTranspilePlugIn/", isDirectory: true, relativeTo: outputFolder)
                if (try? pluginModuleOutputFolder.resourceValues(forKeys: [.isDirectoryKey]).isDirectory) == true {
                    return pluginModuleOutputFolder
                }
            }
            throw CocoaError(.fileNoSuchFile, userInfo: [NSFilePathErrorKey: pluginOutputFolder.path])
        }
    }
    #endif
}

#endif
