// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
import XCTest

import SkipUnit

final class SkipUnitTests: XCTestCase {
    // SKIP INSERT: @Test
    func testSkipUnit() {
        XCTAssertEqual(1, 1)
    }

    // SKIP INSERT: @Test
    func testEnum() {
        XCTAssertEqual(1, 1)
        var thingCase = Thing.case1
        XCTAssertEqual(1, thingCase.num)
        thingCase = Thing.case2
        XCTAssertEqual(2, thingCase.num)
        thingCase = Thing.case3
        XCTAssertEqual(3, thingCase.num)
        thingCase = Thing.casex
        XCTAssertEqual(0, thingCase.num)
    }

    enum Thing {
        case case1
        case case2
        case case3
        case casex

        var num: Int {
            switch self {
            case .case1: return 1
            case .case2: return 2
            case .case3: return 3
            default: return 0
            }
        }

        // bogus sref() because we don't have SkipLib
        func sref() -> Thing { self }
    }

    // SKIP INSERT: @Test
    func testEnum2() {
        XCTAssertEqual(1, 1)

        enum Stuff {
            case str(String)
            case num(Int)

            func funcInEnum() -> String {
                funcInFunc()
            }
        }

        func funcInFunc() -> String {
            "XXX"
        }
    }
}

extension Int {
    func sref() -> Int { self }
}
