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
    // SKIP DECLARE: @Test fun testSimpleValue() = runTest
    func testSimpleValue() async throws {
#if SKIP
        print("CALLING TASK: \(Thread.currentThread().hashCode())")
        let dispatcher = UnconfinedTestDispatcher()
        Dispatchers.setMain(dispatcher)
#endif
        let task1 = Task {
            return await asyncInt()
        }
        let task2 = Task.detached {
            // SKIP REPLACE: this@ConcurrencyTests.asyncInt2()
            return await self.asyncInt2()
        }
        let value1 = await task1.value
        let value2 = await task2.value
#if SKIP
        print("GOT VALUE: \(Thread.currentThread().hashCode())")
        Dispatchers.resetMain()
#endif
        XCTAssertEqual(value1, 100)
        XCTAssertEqual(value2, 200)
    }

    func asyncInt() async -> Int {
        // SKIP INSERT: print("ASYNCINT: ${Thread.currentThread().hashCode()}")
        return 100
    }

    func asyncInt2() async -> Int {
        // SKIP INSERT: print("ASYNCINT 2: ${Thread.currentThread().hashCode()}")
        return 200
    }
}
