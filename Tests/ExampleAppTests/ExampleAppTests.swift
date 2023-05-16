// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
#if !SKIP
@testable import ExampleApp
#endif
import XCTest
import ExampleLib
import SkipFoundation
import SkipUI

// SKIP INSERT: @org.junit.runner.RunWith(androidx.test.ext.junit.runners.AndroidJUnit4::class)
// SKIP INSERT: @org.robolectric.annotation.Config(manifest=org.robolectric.annotation.Config.NONE, sdk = [33])
final class ExampleAppTests: XCTestCase {
    func testExampleApp() throws {
        #if SKIP
        //Activity activity = org.robolectric.Robolectric.setupActivity(MyActivity.class);
        //Button button = (Button) activity.findViewById(R.id.press_me_button);
        //TextView results = (TextView) activity.findViewById(R.id.results_text_view);
        //button.performClick();
        //assertThat(results.getText().toString(), equalTo("Testing Android Rocks!"));
        #endif

        XCTAssertEqual("SkipUI", SkipUIPublicModuleName())
        XCTAssertEqual("ExampleLib", ExampleLibPublicModuleName())
        XCTAssertEqual("SkipFoundation", SkipFoundationPublicModuleName())
    }
}
