// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
import XCTest
// SKIP INSERT: import kotlinx.coroutines.*
// SKIP INSERT: import kotlinx.coroutines.test.*

//~~~
final class ConcurrencyTests: XCTestCase {
    /* SKIP INSERT:
     @Test fun testSimpleValue() {
        val dispatcher = StandardTestDispatcher()
        Dispatchers.setMain(dispatcher)
        try {
            runTest {
                GlobalScope.launch(Dispatchers.Main) {
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
        let task2 = Task.detached {
            // SKIP REPLACE: this@ConcurrencyTests.asyncInt2()
            return await self.asyncInt2()
        }
        let value1 = await task1.value
        let value2 = await task2.value
        XCTAssertEqual(value1, 100)
        XCTAssertEqual(value2, 200)
    }

    func asyncInt() async -> Int {
        return 100
    }

    func asyncInt2() async -> Int {
        return 200
    }
}
