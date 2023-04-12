// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
#if !SKIP
@testable import ExampleLib
#endif
import XCTest
import SkipLib

final class ExampleLibTests: XCTestCase {
    func testExampleLib() throws {
        XCTAssertEqual(3.0 + 1.5, 9.0/2)
        XCTAssertEqual("ExampleLib", ExampleLibInternalModuleName())
        XCTAssertEqual("ExampleLib", ExampleLibPublicModuleName())
        XCTAssertEqual("SkipLib", SkipLibPublicModuleName())

        let name = SkipLibPublicModuleName()
        XCTAssertEqual(1, f(f(f(f(f(name))))))

        if false {
            fatalError("XXX")
        }
    }


    private func f(_ string: String) -> Int {
        #if SKIP
        return string.length
        #else
        return string.count
        #endif
    }

    private func f(_ number: Int) -> String {
        return "\(number)"
    }

//    func testThisOrThat() throws {
//        let x: ThisOrThat<Int, String> = .a(1)
//        let x2: ThisOrThat<Int, String> = .a(1)
//        let y: ThisOrThat<Int, String> = .b("2")
//
//        XCTAssertEqual(x, x)
//        XCTAssertEqual(x, x2)
//        XCTAssertNotEqual(x, y)
//    }
}

//#if SKIP
//typealias ThisOrThatEquatable = Equatable
//#else
///// Empty protocol for type stub
//protocol ThisOrThatEquatable {
//}
//#endif
//
//enum ThisOrThat<A, B> : ThisOrThatEquatable {
//    case a(A)
//    case b(B)
//}
//
//#if !SKIP
//extension ThisOrThat : Swift.Equatable where A : Swift.Equatable, B : Swift.Equatable {
//}
//#endif

