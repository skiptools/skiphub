// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
import Foundation
import XCTest
#if !SKIP
@testable import SkipFoundation
#endif

final class SkipFoundationTests: XCTestCase {
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
}
