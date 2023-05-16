// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
#if !SKIP
@testable import SkipKit
#endif
import Foundation
import OSLog
import JavaScriptCore
import XCTest

//#if !SKIP
//// MARK: Shims for API parity
//fileprivate typealias JSContext = SkipJSContext
//fileprivate typealias JSValue = SkipJSValue
//#endif

@available(macOS 11, iOS 14, watchOS 7, tvOS 14, *)
class ScriptTests : XCTestCase {
    fileprivate let logger: Logger = Logger(subsystem: "test", category: "ScriptTests")

    fileprivate final class JSEvalException : Error {
        var exception: JSValue?

        init(exception: JSValue? = nil) {
            self.exception = exception
        }
    }

    func testJSCAPIHigh() throws {
        let ctx = try XCTUnwrap(JSContext())
        let num = try XCTUnwrap(ctx.evaluateScript("1 + 2.3"))
        
        XCTAssertEqual(3.3, num.toDouble())
        #if SKIP
        let className = "\(type(of: num))" // could be: "class skip.foundation.SkipJSValue (Kotlin reflection is not available)"
        XCTAssertTrue(className.contains("skip.kit.SkipJSValue"), "unexpected calss name: \(className)")
        #endif
        XCTAssertEqual("3.3", num.toString())

        func eval(_ script: String) throws -> JSValue {
            let result = ctx.evaluateScript(script)
            if let exception = ctx.exception {
                throw JSEvalException(exception: exception)
            }
            if let result = result {
                return result
            } else {
                throw JSEvalException()
            }
        }

        XCTAssertEqual("q", ctx.evaluateScript("'q'")?.toString())
        XCTAssertEqual("Ƕe110", try eval(#"'Ƕ'+"e"+1+1+0"#).toString())

        XCTAssertEqual(true, try eval("[] + {}").isString)
        XCTAssertEqual("[object Object]", try eval("[] + {}").toString())

        XCTAssertEqual(true, try eval("[] + []").isString)
        XCTAssertEqual(true, try eval("{} + {}").isNumber)
        XCTAssertEqual(true, try eval("{} + {}").toDouble().isNaN)

        XCTAssertEqual(true, try eval("{} + []").isNumber)
        XCTAssertEqual(0.0, try eval("{} + []").toDouble())

        XCTAssertEqual(true, try eval("1.0 === 1.0000000000000001").toBool())

        XCTAssertEqual(",,,,,,,,,,,,,,,", try eval("Array(16)").toString())
        XCTAssertEqual("watwatwatwatwatwatwatwatwatwatwatwatwatwatwat", try eval("Array(16).join('wat')").toString())
        XCTAssertEqual("wat1wat1wat1wat1wat1wat1wat1wat1wat1wat1wat1wat1wat1wat1wat1", try eval("Array(16).join('wat' + 1)").toString())
        XCTAssertEqual("NaNNaNNaNNaNNaNNaNNaNNaNNaNNaNNaNNaNNaNNaNNaN Batman!", try eval("Array(16).join('wat' - 1) + ' Batman!'").toString())

        #if !SKIP // debug crashing on CI
        XCTAssertEqual(1, try eval("let y = {}; y[[]] = 1; Object.keys(y)").toArray().count)

        XCTAssertEqual(10.0, try eval("['10', '10', '10'].map(parseInt)").toArray().first as? Double)
        XCTAssertEqual(2.0, try eval("['10', '10', '10'].map(parseInt)").toArray().last as? Double)
        #endif // !SKIP // debug crash
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
