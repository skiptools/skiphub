// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
#if !SKIP
@testable import SkipFoundation
#endif
import Foundation
import OSLog
import JavaScriptCore
import XCTest

#if !SKIP
// MARK: Shims for API parity
fileprivate typealias JSContext = SkipJSContext
#endif

@available(macOS 11, iOS 14, watchOS 7, tvOS 14, *)
class ScriptTests : XCTestCase {
    fileprivate let logger: Logger = Logger(subsystem: "test", category: "ScriptTests")

    func testJSCAPIHigh() throws {
        let ctx = try XCTUnwrap(JSContext())
        let value = ctx.evaluateScript("1 + 2.3")
        XCTAssertEqual(3.3, value?.toDouble())
    }

    func testJSCAPILow() throws {
        let ctx = JavaScriptCore.JSGlobalContextCreate(nil)
        defer { JavaScriptCore.JSGlobalContextRelease(ctx) }

        /// Executes the given script using either iOS's bilt-in JavaScriptCore or via Java JNA/JNI linkage to the jar dependencies
        func js(_ script: String) throws -> JSValueRef {
            let scriptValue = JavaScriptCore.JSStringCreateWithUTF8CString(script)
            defer { JavaScriptCore.JSStringRelease(scriptValue) }

            #if SKIP
            var exception = JSValuePointer()
            #else
            var exception = UnsafeMutablePointer<JSValueRef?>(nil)
            #endif

            let result = JavaScriptCore.JSEvaluateScript(ctx, scriptValue, nil, nil, 1, exception)

            #if SKIP
            if let error: com.sun.jna.Pointer = exception.value {
                XCTFail("JavaScript exception occurred: \(error)")
                throw ScriptEvalError()
            }
            #else
            if let error: JavaScriptCore.JSValueRef = exception?.pointee {
                XCTFail("JavaScript exception occurred: \(error)")
                throw ScriptEvalError()
            }
            #endif

            guard let result = result else {
                throw NoScriptResultError()
            }
            return result
        }

        XCTAssertTrue(JavaScriptCore.JSValueIsUndefined(ctx, try js("undefined")))
        XCTAssertTrue(JavaScriptCore.JSValueIsNull(ctx, try js("null")))
        XCTAssertTrue(JavaScriptCore.JSValueIsBoolean(ctx, try js("true||false")))
        XCTAssertTrue(JavaScriptCore.JSValueIsString(ctx, try js("'1'+1")))
        XCTAssertTrue(JavaScriptCore.JSValueIsArray(ctx, try js("[true, null, 1.234, {}, []]")))
        XCTAssertTrue(JavaScriptCore.JSValueIsDate(ctx, try js("new Date()")))
        XCTAssertTrue(JavaScriptCore.JSValueIsObject(ctx, try js(#"new Object()"#)))

        XCTAssertTrue(JavaScriptCore.JSValueIsNumber(ctx, try js("""
        function sumArray(arr) {
          let sum = 0;
          for (let i = 0; i < arr.length; i++) {
            sum += arr[i];
          }
          return sum;
        }

        const largeArray = new Array(100000000).fill(1);
        sumArray(largeArray);
        """)))

        do {
            _ = try js("XXX")
            XCTFail("Expected error")
        } catch {
            // e.g.: skip.lib.ErrorThrowable: java.lang.AssertionError: JavaScript exception occurred: native@0x168020ea8
            // TODO: extract error message and verify
        }
    }
}
