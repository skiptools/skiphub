// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
import Foundation
import XCTest

// These tests are adapted from https://github.com/apple/swift-corelibs-foundation/blob/main/Tests/Foundation/Tests which have the following license:

#if !SKIP

// This source file is part of the Swift.org open source project
//
// Copyright (c) 2014 - 2019 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//

class TestDimension: XCTestCase {

    func test_encodeDecode() {
        let original = Dimension(symbol: "symbol", converter: UnitConverterLinear(coefficient: 1.0))

        let encodedData = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: encodedData)
        original.encode(with: archiver)
        archiver.finishEncoding()

        let unarchiver = NSKeyedUnarchiver(forReadingWith: encodedData as Data)
        let decoded = Dimension(coder: unarchiver)

        XCTAssertNotNil(decoded)
        XCTAssertEqual(original, decoded)
    }

    static var allTests: [(String, (TestDimension) -> () throws -> Void)] {
        return [
            ("test_encodeDecode", test_encodeDecode),
        ]
    }
}

#endif

