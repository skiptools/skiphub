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

//    #if !SKIP
//    func testSkipLibSymbols() async throws {
//        let testModule = "SkipLibTests"
//        let symbols = try await SkipSystem.extractSymbols(moduleNames: [testModule], accessLevel: "private")
//        let symbolGraph = try XCTUnwrap(symbols)
//        XCTAssertEqual(1, symbolGraph.count)
//        let graph = try XCTUnwrap(symbolGraph.values.first)
//
//        let demoStruct = try XCTUnwrap(graph.symbols["s:12SkipLibTests10DemoStructV"])
//        XCTAssertEqual(["DemoStruct"], demoStruct.pathComponents)
//
//    }
//    #endif
}

#if !SKIP
public struct DemoStruct {
    public let publicInt: Int = 1
    private var privateOptionalString: String?
    private var impliedDouble = (1.234 * 1)
}
#endif
