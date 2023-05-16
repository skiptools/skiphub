// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
import XCTest
#if !SKIP
@testable import SkipLib
#endif

final class SkipLibTests: XCTestCase {
    func testSkipLib() throws {
        XCTAssertEqual(3, 1 + 2)
        XCTAssertEqual("SkipLib", SkipLibInternalModuleName())
        XCTAssertEqual("SkipLib", SkipLibPublicModuleName())
    }

    func testUnitTests() throws {
        // test the various test assertions and ensure the JUnit implementations match the XCUnit ones
        XCTAssertEqual(1, 1)
        XCTAssertEqual(1, 1, "one == one")

        XCTAssertNotEqual(1, 2)
        XCTAssertNotEqual(1, 2, "one != two")

        XCTAssertGreaterThanOrEqual(1, 1)
        XCTAssertGreaterThanOrEqual(1, 1, "one >= one")

        XCTAssertGreaterThan(2, 1)
        XCTAssertGreaterThan(2, 1, "two > one")

        XCTAssertLessThanOrEqual(1, 1)
        XCTAssertLessThanOrEqual(1, 1, "one <= one")

        XCTAssertLessThan(1, 2)
        XCTAssertLessThan(1, 2, "one < two")
    }

    func testFatalError() throws {
        if ({ false }()) {
            fatalError("this is a fatal error")
        }

        if ({ false }()) {
            fatalError() // no-arg
        }
    }

    // https://kotlinlang.org/api/kotlinx.coroutines/kotlinx-coroutines-test/kotlinx.coroutines.test/run-test.html
    // could also use: kotlinx.coroutines.runBlocking
    // SKIP DECLARE: @Test fun testAsync() = kotlinx.coroutines.test.runTest
    func testAsync() async throws {
        // SKIP REPLACE: val start = System.currentTimeMillis() / 1000.0
        let start = CFAbsoluteTimeGetCurrent()
        // SKIP INSERT: Thread.sleep(1000) // brute-force
        // SKIP REPLACE: // kotlinx.coroutines.delay(1000) // coroutine scheduler makes this return immediately!
        try await Task.sleep(nanoseconds: 1 * 1_000_000_000)
        // SKIP REPLACE: val end = System.currentTimeMillis() / 1000.0
        let end = CFAbsoluteTimeGetCurrent()
        XCTAssertGreaterThanOrEqual(end - start, 1.0, "async sleep should have taken 1 second")
    }

}

#if !SKIP
public struct DemoStruct {
    public let publicInt: Int = 1
    private var privateOptionalString: String?
    private var impliedDouble = (1.234 * 1)
}
#endif
