// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
import XCTest
#if !SKIP
@testable import SkipLib
//import SkipBuild
//import SymbolKit
#endif

final class SkipLibTests: XCTestCase {
    // SKIP INSERT: @Test
    func testSkipLib() throws {
        XCTAssertEqual(3, 1 + 2)
        XCTAssertEqual("SkipLib", SkipLibInternalModuleName())
        XCTAssertEqual("SkipLib", SkipLibPublicModuleName())
    }
}

#if !SKIP
public struct DemoStruct {
    public let publicInt: Int = 1
    private var privateOptionalString: String?
    private var impliedDouble = (1.234 * 1)
}
#endif
