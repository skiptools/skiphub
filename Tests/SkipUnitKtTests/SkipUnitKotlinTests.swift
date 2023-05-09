// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
import SkipUnit

#if os(macOS) // Skip transpiled tests can only be run against macOS
/// This test case will run the transpiled tests for the Skip module.
final class SkipUnitKtTests: JUnitTestCase {
    /// This test case will run the transpiled tests defined in the Swift peer module.
    /// New tests should be added there, not here.
    public func testSkipModule() async throws {
        try await runTranspiledGradleTests()
    }
}
#endif
