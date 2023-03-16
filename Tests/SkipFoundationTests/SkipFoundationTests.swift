// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
#if !SKIP
@testable import SkipFoundation
#endif
import XCTest

final class SkipFoundationTests: XCTestCase {
    // SKIP INSERT: @Test
    func testSkipFoundation() throws {
        XCTAssertEqual(3, 1 + 2)
        XCTAssertEqual("SkipFoundation", SkipFoundationInternalModuleName())
        XCTAssertEqual("SkipFoundation", SkipFoundationPublicModuleName())

        #if SKIP
        XCTAssertEqual("Kotlin", foundationHelperDemo())
        #else
        XCTAssertEqual("Swift", foundationHelperDemo())
        #endif
    }

    // MARK: - ArrayTests
    // SKIP INSERT: @Test
    func testArrayLiteralInit() {
        let emptyArray: [Int] = []
        XCTAssertEqual(emptyArray.count, 0)

        let singleElementArray = [1]
        XCTAssertEqual(singleElementArray.count, 1)

        let multipleElementArray = [1, 2]
        XCTAssertEqual(multipleElementArray.count, 2)
    }
}
