// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
import XCTest
// SKIP INSERT: import kotlinx.coroutines.*
// SKIP INSERT: import kotlinx.coroutines.test.*

final class ConcurrencyTests: XCTestCase {
    /* SKIP INSERT:
     @Test fun testSimpleValue() {
        val dispatcher = StandardTestDispatcher()
        Dispatchers.setMain(dispatcher)
        try {
            runTest {
                withContext(Dispatchers.Main) {
                    _testSimpleValue()
                }
            }
        } finally {
            Dispatchers.resetMain()
        }
     }
     */
    // SKIP DECLARE: suspend fun _testSimpleValue()
    func testSimpleValue() async throws {
        let task1 = Task {
            return await asyncInt()
        }
        // SKIP REPLACE: val task2 = Task.detached l@{ return@l asyncInt2() }
        let task2 = Task.detached {
            // code transpiled as: val task2 = Task.detached l@{ return@l this.asyncInt2() }
            // error: “Not enough information to infer type variable T”
            // "self"/"this" mismatch
            return await self.asyncInt2()
        }
        let value1 = await task1.value
        // SKIP REPLACE: val value2 = task2.value()
        let value2 = await task2.value
        XCTAssertEqual(value1, 100)
        XCTAssertEqual(value2, 200)

        let value3 = await asyncInt()
        XCTAssertEqual(value3, 100)
    }

    func asyncInt() async -> Int {
        return 100
    }

    func asyncInt2() async -> Int {
        return 200
    }
}
