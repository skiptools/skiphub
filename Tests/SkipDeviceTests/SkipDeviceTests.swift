// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
#if !SKIP
@testable import SkipDevice
#endif
import XCTest
import SkipFoundation

final class SkipDeviceTests: XCTestCase {
    // SKIP INSERT: @Test
    func testSkipDevice() throws {
        print("Running: testSkipDevice…")
        XCTAssertEqual(3.0 + 1.5, 9.0/2)
        XCTAssertEqual("SkipDevice", SkipDeviceInternalModuleName())
        XCTAssertEqual("SkipDevice", SkipDevicePublicModuleName())
        XCTAssertEqual("SkipFoundation", SkipFoundationPublicModuleName())
    }
}
