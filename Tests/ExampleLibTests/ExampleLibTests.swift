// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
#if !SKIP
@testable import ExampleLib
#endif
import Foundation
import XCTest
import SkipLib

final class ExampleLibTests: XCTestCase {
    func testExampleLib() throws {
        XCTAssertEqual("ExampleLib", ExampleLibInternalModuleName())
        XCTAssertEqual("ExampleLib", ExampleLibPublicModuleName())
        XCTAssertEqual("SkipLib", SkipLibPublicModuleName())
    }

    func testJNA() throws {
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

#if SKIP
struct ScriptEvalError : Error { }
struct NoScriptResultError : Error { }
#else
struct ScriptEvalError : Swift.Error { }
struct NoScriptResultError : Swift.Error { }
#endif

#if !SKIP
// Non-Skip uses the JavaScriptCore symbols directly
import JavaScriptCore
#else

// workaround for Skip converting "JavaScriptCode.self.javaClass" to "(JavaScriptCoreLibrary::class.companionObjectInstance as JavaScriptCoreLibrary.Companion).java)"
// SKIP INSERT: fun <T : Any> javaClass(kotlinClass: kotlin.reflect.KClass<T>): Class<T> { return kotlinClass.java }

/// Global pointer to the JSC library, equivalent to the Swift `JavaScriptCore` framework
let JavaScriptCore: JavaScriptCoreLibrary = com.sun.jna.Native.load("JavaScriptCore", javaClass(JavaScriptCoreLibrary.self))

/// A JavaScript value. The base type for all JavaScript values, and polymorphic functions on them.
typealias OpaqueJSValue = com.sun.jna.Pointer
typealias JSValuePointer = com.sun.jna.ptr.PointerByReference

typealias JSValueRef = OpaqueJSValue
typealias JSStringRef = OpaqueJSValue
typealias JSObjectRef = OpaqueJSValue
typealias JSContextRef = OpaqueJSValue


/// A partial implementation of the JavaScriptCore C interface exposed as a JNA library.
protocol JavaScriptCoreLibrary : com.sun.jna.Library {
    func JSStringCreateWithUTF8CString(_ string: String) -> JSStringRef
    func JSStringRetain(_ string: JSStringRef) -> JSStringRef
    func JSStringRelease(_ string: JSStringRef)
    func JSStringGetLength(_ string: JSStringRef) -> Int

    func JSGlobalContextCreate(_ globalObjectClass: JSValueRef?) -> JSContextRef
    func JSGlobalContextRelease(_ ctx: JSContextRef)
    func JSEvaluateScript(_ ctx: JSContextRef, script: JSStringRef, thisObject: JSValueRef?, sourceURL: String?, startingLineNumber: Int, exception: JSValuePointer) -> JSValueRef

    func JSValueGetType(_ ctx: JSContextRef, _ value: JSValueRef) -> Int

    func JSValueIsUndefined(_ ctx: JSContextRef, _ value: JSValueRef) -> Bool
    func JSValueIsNull(_ ctx: JSContextRef, _ value: JSValueRef) -> Bool
    func JSValueIsBoolean(_ ctx: JSContextRef, _ value: JSValueRef) -> Bool
    func JSValueIsNumber(_ ctx: JSContextRef, _ value: JSValueRef) -> Bool
    func JSValueIsString(_ ctx: JSContextRef, _ value: JSValueRef) -> Bool
    func JSValueIsSymbol(_ ctx: JSContextRef, _ value: JSValueRef) -> Bool
    func JSValueIsObject(_ ctx: JSContextRef, _ value: JSValueRef) -> Bool
    func JSValueIsArray(_ ctx: JSContextRef, _ value: JSValueRef) -> Bool
    func JSValueIsDate(_ ctx: JSContextRef, _ value: JSValueRef) -> Bool

    func JSValueIsEqual(_ ctx: JSContextRef, _ a: JSValueRef, _ b: JSValueRef, _ exception: JSValuePointer) -> Boolean
    func JSValueIsStrictEqual(_ ctx: JSContextRef, _ a: JSValueRef, _ b: JSValueRef) -> Boolean

    func JSValueIsInstanceOfConstructor(_ ctx: JSContextRef, _ value: JSValueRef, _ constructor: JSObjectRef, _ exception: JSValuePointer) -> Boolean

    func JSValueMakeUndefined(_ ctx: JSContextRef) -> JSValueRef
    func JSValueMakeNull(_ ctx: JSContextRef) -> JSValueRef
    func JSValueMakeBoolean(_ ctx: JSContextRef, _ value: Boolean) -> JSValueRef
    func JSValueMakeNumber(_ ctx: JSContextRef, _ value: Double) -> JSValueRef
    func JSValueMakeString(_ ctx: JSContextRef, _ value: JSStringRef) -> JSValueRef
    func JSValueMakeSymbol(_ ctx: JSContextRef, _ value: JSStringRef) -> JSValueRef
    func JSValueMakeFromJSONString(_ ctx: JSContextRef, _ json: JSStringRef) -> JSValueRef
    func JSValueCreateJSONString(_ ctx: JSContextRef, _ value: JSValueRef, _ indent: UInt32, _ exception: JSValuePointer) -> JSStringRef
    func JSValueToBoolean(_ ctx: JSContextRef, _ value: JSValueRef) -> Boolean
    func JSValueToNumber(_ ctx: JSContextRef, _ value: JSValueRef, _ exception: JSValuePointer) -> Double
    func JSValueToStringCopy(_ ctx: JSContextRef, _ value: JSValueRef, _ exception: JSValuePointer) -> JSStringRef
    func JSValueToObject(_ ctx: JSContextRef, _ value: JSValueRef, _ exception: JSValuePointer) -> JSObjectRef
}

#endif

