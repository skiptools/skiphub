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
// SKIP INSERT: import androidx.compose.runtime.mutableStateOf
// SKIP INSERT: import androidx.compose.runtime.remember
// SKIP INSERT: import androidx.compose.runtime.getValue
// SKIP INSERT: import androidx.compose.runtime.setValue
// SKIP INSERT: import androidx.compose.ui.platform.testTag
// SKIP INSERT: import androidx.compose.ui.test.assertIsDisplayed
// SKIP INSERT: import androidx.compose.ui.test.onNodeWithText
// SKIP INSERT: import androidx.compose.ui.test.onNodeWithTag
// SKIP INSERT: import androidx.compose.ui.test.performClick
// SKIP INSERT: import androidx.compose.ui.test.assertTextEquals
// SKIP INSERT: import androidx.compose.ui.test.junit4.createComposeRule
// SKIP INSERT: import androidx.test.ext.junit.runners.AndroidJUnit4
// SKIP INSERT: import org.junit.runner.RunWith

// SKIP INSERT: @RunWith(AndroidJUnit4::class)
// SKIP INSERT: @org.robolectric.annotation.Config(manifest=org.robolectric.annotation.Config.NONE, sdk = [33])
final class SkipUITests: XCTestCase {
    // SKIP INSERT: @get:Rule val rule = createComposeRule()

    func testSkipUI() throws {
        XCTAssertEqual(3, 1 + 2)
        XCTAssertEqual("SkipUI", SkipUIInternalModuleName())
        XCTAssertEqual("SkipUI", SkipUIPublicModuleName())
        XCTAssertEqual("SkipFoundation", SkipFoundationPublicModuleName())
    }


    func testCompose() {
        #if SKIP
        rule.setContent {
            Text(text: "ABC")
        }

        //rule.onRoot().printToLog("TAG")
        rule.onNodeWithText("ABC").assertIsDisplayed()
        #endif
    }

    func testPressButton() {
        #if SKIP
        rule.setContent {
            // SKIP INSERT: var counter by remember { mutableStateOf(0) }

            Text(
                text: counter.toString(),
                modifier: Modifier.testTag("Counter")
            )
            Button(onClick = { counter++ }) {
                Text("Increment")
            }
        }

        rule
            .onNodeWithTag("Counter")
            .assertTextEquals("0")
        rule
            .onNodeWithText("Increment")
            .performClick()
        rule
            .onNodeWithTag("Counter")
            .assertTextEquals("1")

        #endif
    }
}
