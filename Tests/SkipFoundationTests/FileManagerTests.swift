// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
#if !SKIP
@testable import SkipFoundation
#endif
import XCTest

final class FileManagerTests: XCTestCase {
    //var logger = Logger(subsystem: "test", category: "FileManagerTests")

    // SKIP INSERT: @Test
    func testFileManager() throws {
        let tmp = NSTemporaryDirectory()
        //logger.log("temporary folder: \(tmp)")
        XCTAssertNotNil(tmp)
        XCTAssertNotEqual("", tmp)

        let fm = FileManager.default
        XCTAssertNotNil(fm)
    }
}
