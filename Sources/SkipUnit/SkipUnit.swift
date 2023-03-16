// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
#if !SKIP
@_exported import XCTest
import SkipDriver

/// A base test case for a JUnit 5 (Jupiter) test suite, which is expected to use skip-transpiled tests.
open class JupiterTestCase: XCTestCase {
    public func testProjectGradle() async throws {
        // only run in subclasses, not in the base test
        if self.className == "SkipUnit.JupiterTestCase" {
            // TODO: add a general system gradle checkup test here
        } else {
            try await runGradleTests()
        }
    }

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
        print(#function, "gradleDriver", driver)

        let dir = try URL.pluginOutputFolder(module: moduleName)

        print(#function, "pluginOutputFolder", dir.path)

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
                // Jupiter test case names are like "testSystemRandomNumberGenerator$SkipFoundation()"
                msg += testCase.name.split(separator: "$").first?.description ?? testCase.name
                msg += " (" + testCase.time.formatted(.number) + ") " // add in the time for profiling

                print("TEST CASE", testCase.failures.isEmpty ? "PASSED" : "FAILED", msg)

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
}

extension URL {
    // FIXME: reduntant with SkipAssemble
    /// The folder where built modules will be placed.
    ///
    /// When running within Xcode, which will query the `__XCODE_BUILT_PRODUCTS_DIR_PATHS` environment.
    /// Otherwise, it assumes SPM's standard ".build" folder relative to the working directory.
    static func pluginOutputFolder(module moduleName: String) throws -> URL {
        URL(fileURLWithPath: "\(moduleName)/SkipTranspilePlugIn/", isDirectory: true, relativeTo: pluginOutputBaseFolder())
    }

    private static func pluginOutputBaseFolder() -> URL {
        let env = ProcessInfo.processInfo.environment

        #warning("FIXME: will not always be skip-core")
        let moduleRootName = "skip-core"

        //for (key, value) in env {
        //    print("ENV: \(key) = \(value)")
        //}

        // if we are running tests from Xcode, this environment variable should be set; otherwise, assume the .build folder for an SPM build
        // also seems to be __XPC_DYLD_LIBRARY_PATH or __XPC_DYLD_FRAMEWORK_PATH;
        // this will be something like ~/Library/Developer/Xcode/DerivedData/MODULENAME-bsjbchzxfwcrveckielnbyhybwdr/Build/Products/Debug
        if let xcodeBuildFolder = env["__XCODE_BUILT_PRODUCTS_DIR_PATHS"] ?? env["BUILT_PRODUCTS_DIR"] {
            let buildBaseFolder = URL(fileURLWithPath: xcodeBuildFolder, isDirectory: true)
                .deletingLastPathComponent()
                .deletingLastPathComponent()
                .deletingLastPathComponent()
            // turn "skip-core-acfwraikkessprdjxjsnylgamsnj" into "skip-core"
            //let moduleRootName = buildBaseFolder.lastPathComponent.split(separator: "-").dropLast(1).joined(separator: "-").description
            let xcodeFolder = buildBaseFolder
                .appendingPathComponent("SourcePackages/plugins/\(moduleRootName).output", isDirectory: true)
            return xcodeFolder
        } else {
            let swiftBuildFolder = ".build/plugins/outputs/\(moduleRootName)"
            return URL(fileURLWithPath: swiftBuildFolder, isDirectory: true)
        }
    }
}

#endif

