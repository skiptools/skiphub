// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
#if !SKIP
@testable import SkipUI
#endif
import XCTest
import SkipFoundation

final class SkipUITests: XCTestCase {
    // SKIP INSERT: @Test
    func testSkipUI() throws {
        XCTAssertEqual(3, 1 + 2)
        //XCTAssertEqual("SkipUI", SkipUIInternalModuleName())
        //XCTAssertEqual("SkipUI", SkipUIPublicModuleName())
        XCTAssertEqual("SkipFoundation", SkipFoundationPublicModuleName())
    }
}
