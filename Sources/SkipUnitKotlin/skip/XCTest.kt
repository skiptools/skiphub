package skip.unit

//import org.junit.Test
//import org.junit.Assert

//import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.Assertions
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.assertThrows
//import org.junit.jupiter.params.ParameterizedTest
//import org.junit.jupiter.params.provider.CsvSource


typealias Test = org.junit.jupiter.api.Test

// Mimics the API of XCTest for a JUnit test
// Behavior difference: JUnit assert* thows an exception, but XCTAssert* just reports the failure and continues
interface XCTestCase {
    fun XCTFail(): Unit = Assertions.fail()

    fun XCTFail(msg: String): Unit = Assertions.fail(msg)

    fun <T> XCTUnwrap (ob: T?): T { Assertions.assertNotNull(ob); if (ob != null) { return ob }; throw AssertionError() }
    fun <T> XCTUnwrap(ob: T?, msg: String): T { Assertions.assertNotNull(ob, msg); if (ob != null) { return ob }; throw AssertionError() }

    fun XCTAssert(a: Boolean): Unit = Assertions.assertTrue(a as Boolean)
    fun XCTAssertTrue(a: Boolean): Unit = Assertions.assertTrue(a as Boolean)
    fun XCTAssertTrue(a: Boolean, msg: String): Unit = Assertions.assertTrue(a, msg)
    fun XCTAssertFalse(a: Boolean): Unit = Assertions.assertFalse(a)
    fun XCTAssertFalse(a: Boolean, msg: String): Unit = Assertions.assertFalse(a, msg)

    fun XCTAssertNil(a: Any?): Unit = Assertions.assertNull(a)
    fun XCTAssertNil(a: Any?, msg: String): Unit = Assertions.assertNull(a, msg)
    fun XCTAssertNotNil(a: Any?): Unit = Assertions.assertNotNull(a)
    fun XCTAssertNotNil(a: Any?, msg: String): Unit = Assertions.assertNotNull(a, msg)

    fun XCTAssertIdentical(a: Any?, b: Any?): Unit = Assertions.assertSame(a, b)
    fun XCTAssertIdentical(a: Any?, b: Any?, msg: String): Unit = Assertions.assertSame(a, b, msg)
    fun XCTAssertNotIdentical(a: Any?, b: Any?): Unit = Assertions.assertNotSame(a, b)
    fun XCTAssertNotIdentical(a: Any?, b: Any?, msg: String): Unit = Assertions.assertNotSame(a, b, msg)

    fun XCTAssertEqual(a: Any?, b: Any?): Unit = Assertions.assertEquals(a, b)
    fun XCTAssertEqual(a: Any?, b: Any?, msg: String): Unit = Assertions.assertEquals(a, b, msg)
    fun XCTAssertNotEqual(a: Any?, b: Any?): Unit = Assertions.assertNotEquals(a, b)
    fun XCTAssertNotEqual(a: Any?, b: Any?, msg: String): Unit = Assertions.assertNotEquals(a, b, msg)

    // additional overloads needed for XCTAssert*() which have different signatures on Linux (@autoclosures) than on Darwin platforms (direct values)

    fun XCTUnwrap(ob: () -> Any?) = { val x = ob(); Assertions.assertNotNull(x); x }
    fun XCTUnwrap(ob: () -> Any?, msg: () -> String) = { val x = ob(); Assertions.assertNotNull(x, msg()); x }

    fun XCTAssertTrue(a: () -> Boolean) = Assertions.assertTrue(a())
    fun XCTAssertTrue(a: () -> Boolean, msg: () -> String) = Assertions.assertTrue(a(), msg())
    fun XCTAssertFalse(a: () -> Boolean) = Assertions.assertFalse(a())
    fun XCTAssertFalse(a: () -> Boolean, msg: () -> String) = Assertions.assertFalse(a(), msg())

    fun XCTAssertNil(a: () -> Any?) = Assertions.assertNull(a())
    fun XCTAssertNil(a: () -> Any?, msg: () -> String) = Assertions.assertNull(a(), msg())
    fun XCTAssertNotNil(a: () -> Any?) = Assertions.assertNotNull(a())
    fun XCTAssertNotNil(a: () -> Any?, msg: () -> String) = Assertions.assertNotNull(a(), msg())

    fun XCTAssertIdentical(a: () -> Any?, b: () -> Any?) = Assertions.assertSame(a(), b())
    fun XCTAssertIdentical(a: () -> Any?, b: () -> Any?, msg: () -> String) = Assertions.assertSame(a(), b(), msg())
    fun XCTAssertNotIdentical(a: () -> Any?, b: () -> Any?) = Assertions.assertNotSame(a(), b())
    fun XCTAssertNotIdentical(a: () -> Any?, b: () -> Any?, msg: () -> String) = Assertions.assertNotSame(a(), b(), msg())

    fun XCTAssertEqual(a: () -> Any?, b: () -> Any?) = Assertions.assertEquals(a(), b())
    fun XCTAssertEqual(a: () -> Any?, b: () -> Any?, msg: () -> String) = Assertions.assertEquals(a(), b(), msg())
    fun XCTAssertNotEqual(a: () -> Any?, b: () -> Any?) = Assertions.assertNotEquals(a(), b())
    fun XCTAssertNotEqual(a: () -> Any?, b: () -> Any?, msg: () -> String) = Assertions.assertNotEquals(a(), b(), msg())
}
