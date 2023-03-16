// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
#if !SKIP
@testable import ExampleApp
#endif
import ExampleLib
import SkipFoundation
import SkipUI
import SkipUnit

final class ExampleAppTests: XCTestCase {
    // SKIP INSERT: @Test
    func testExampleApp() throws {
        XCTAssertEqual(3, 1 + 2 + 0)
//        XCTAssertEqual("ExampleApp", ExampleAppInternalModuleName())
//        XCTAssertEqual("ExampleApp", ExampleAppPublicModuleName())
        XCTAssertEqual("ExampleLib", ExampleLibPublicModuleName())
        XCTAssertEqual("SkipFoundation", SkipFoundationPublicModuleName())
        XCTAssertEqual("SkipUI", SkipUIPublicModuleName())
    }
}
