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
// SKIP INSERT: import androidx.compose.ui.geometry.Rect
// SKIP INSERT: import androidx.compose.ui.platform.testTag
// SKIP INSERT: import androidx.compose.ui.semantics.SemanticsNode
// SKIP INSERT: import androidx.compose.ui.semantics.SemanticsConfiguration
// SKIP INSERT: import androidx.compose.ui.semantics.SemanticsProperties
// SKIP INSERT: import androidx.compose.ui.test.assertIsDisplayed
// SKIP INSERT: import androidx.compose.ui.test.onNodeWithText
// SKIP INSERT: import androidx.compose.ui.test.onNodeWithTag
// SKIP INSERT: import androidx.compose.ui.test.performClick
// SKIP INSERT: import androidx.compose.ui.test.onRoot
// SKIP INSERT: import androidx.compose.ui.test.printToLog
// SKIP INSERT: import androidx.compose.ui.test.assertTextEquals
// SKIP INSERT: import androidx.compose.ui.test.junit4.createComposeRule
// SKIP INSERT: import androidx.compose.ui.text.AnnotatedString
// SKIP INSERT: import androidx.compose.ui.unit.toSize
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

        XCTAssertEqual(rule.onRoot().fetchSemanticsNode().treeString(), """
        Node:
          Node:Text=[ABC] GetTextLayoutResult=AccessibilityAction(label=null, action=(kotlin.collections.MutableList<androidx.compose.ui.text.TextLayoutResult>) -> kotlin.Boolean)
        """)
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

        XCTAssertEqual(rule.onRoot().fetchSemanticsNode().treeString(), """
        Node:
          Node:TestTag=Counter Text=[0] GetTextLayoutResult=AccessibilityAction(label=null, action=(kotlin.collections.MutableList<androidx.compose.ui.text.TextLayoutResult>) -> kotlin.Boolean)
          Node:Role=Button OnClick=AccessibilityAction(label=null, action=() -> kotlin.Boolean) Focused=false RequestFocus=AccessibilityAction(label=null, action=Function0<java.lang.Boolean>) Text=[Increment] GetTextLayoutResult=AccessibilityAction(label=null, action=(kotlin.collections.MutableList<androidx.compose.ui.text.TextLayoutResult>) -> kotlin.Boolean)
        """)

        rule
            .onNodeWithTag("Counter")
            .assertTextEquals("0")
        rule
            .onNodeWithText("Increment")
            .performClick()
        rule
            .onNodeWithTag("Counter")
            .assertTextEquals("1")

        XCTAssertEqual(rule.onRoot().fetchSemanticsNode().treeString(), """
        Node:
          Node:TestTag=Counter Text=[1] GetTextLayoutResult=AccessibilityAction(label=null, action=(kotlin.collections.MutableList<androidx.compose.ui.text.TextLayoutResult>) -> kotlin.Boolean)
          Node:Role=Button OnClick=AccessibilityAction(label=null, action=() -> kotlin.Boolean) Focused=false RequestFocus=AccessibilityAction(label=null, action=Function0<java.lang.Boolean>) Text=[Increment] GetTextLayoutResult=AccessibilityAction(label=null, action=(kotlin.collections.MutableList<androidx.compose.ui.text.TextLayoutResult>) -> kotlin.Boolean)
        """)

        #endif
    }
}

#if SKIP

extension SemanticsNode {
    /// Returns a description of this node's hierarchy and attributes
    func treeString(indent: String = "") -> String {
        let nodeDescription = "\(indent)Node:\(attrList())"
        let cdesc = self.children.joinToString(separator = "\n") { child in
            child.treeString(indent + "  ")
        }
        return cdesc.isBlank() ? nodeDescription : (nodeDescription + "\n" + cdesc)
    }

    private func attrList() -> String {
        var desc = ""

        config.forEach { configValue in
            let key = configValue.key.name
            let values = configValue.value
            if !desc.isEmpty {
                desc += " "
            }
            desc += "\(key)=\(values)"
        }

        return desc
    }
}

#endif
