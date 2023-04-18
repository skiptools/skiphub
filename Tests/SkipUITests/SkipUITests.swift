// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
@testable import SkipUI
import XCTest
import SkipFoundation

// SKIP INSERT: import org.junit.Rule
// SKIP INSERT: import androidx.compose.material.Text
// SKIP INSERT: import androidx.compose.material.Button
// SKIP INSERT: import androidx.compose.ui.Modifier
// SKIP INSERT: import androidx.compose.ui.test.assertIsDisplayed
// SKIP INSERT: import androidx.compose.ui.test.onNodeWithText
// SKIP INSERT: import androidx.compose.ui.test.junit4.createComposeRule
// SKIP INSERT: import androidx.test.ext.junit.runners.AndroidJUnit4
// SKIP INSERT: import org.junit.runner.RunWith

// SKIP INSERT: @RunWith(AndroidJUnit4::class)
// SKIP INSERT: @org.robolectric.annotation.Config(manifest=org.robolectric.annotation.Config.NONE, sdk = [android.os.Build.VERSION_CODES.S])
final class SkipUITests: XCTestCase {
    // SKIP INSERT: @get:Rule val rule = createComposeRule()

    func testSkipUI() throws {
        XCTAssertEqual(3, 1 + 2)
        XCTAssertEqual("SkipUI", SkipUIInternalModuleName())
        XCTAssertEqual("SkipUI", SkipUIPublicModuleName())
        XCTAssertEqual("SkipFoundation", SkipFoundationPublicModuleName())
    }


    func testCompose() {
        // SKIP INSERT: // DEMO
        XCTAssertEqual("X", "X")
        // SKIP INSERT: rule.setContent {
        // SKIP INSERT:     Text(text = "Hello")
        // SKIP INSERT: }
        XCTAssertEqual("X", "X")
    }

    // SKIP INSERT: @Test func testComposeFunctions() {
    // SKIP INSERT: rule.setContent {
    // SKIP INSERT:     Text("Hello")
    // SKIP INSERT: }
    // SKIP INSERT: }
}
