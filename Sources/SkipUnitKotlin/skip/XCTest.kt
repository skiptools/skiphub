package skip.unit

typealias Test = org.junit.Test

// Mimics the API of XCTest for a JUnit 5 test
// Behavior difference: JUnit assert* thows an exception, but XCTAssert* just reports the failure and continues
interface XCTestCase {
    fun XCTFail(): Unit = org.junit.Assert.fail()

    fun XCTFail(msg: String): Unit = org.junit.Assert.fail(msg)

    fun <T> XCTUnwrap (ob: T?): T { org.junit.Assert.assertNotNull(ob); if (ob != null) { return ob }; throw AssertionError() }
    fun <T> XCTUnwrap(ob: T?, msg: String): T { org.junit.Assert.assertNotNull(msg, ob); if (ob != null) { return ob }; throw AssertionError() }

    fun XCTAssert(a: Boolean): Unit = org.junit.Assert.assertTrue(a as Boolean)
    fun XCTAssertTrue(a: Boolean): Unit = org.junit.Assert.assertTrue(a as Boolean)
    fun XCTAssertTrue(a: Boolean, msg: String): Unit = org.junit.Assert.assertTrue(msg, a)
    fun XCTAssertFalse(a: Boolean): Unit = org.junit.Assert.assertFalse(a)
    fun XCTAssertFalse(a: Boolean, msg: String): Unit = org.junit.Assert.assertFalse(msg, a)

    fun XCTAssertNil(a: Any?): Unit = org.junit.Assert.assertNull(a)
    fun XCTAssertNil(a: Any?, msg: String): Unit = org.junit.Assert.assertNull(msg, a)
    fun XCTAssertNotNil(a: Any?): Unit = org.junit.Assert.assertNotNull(a)
    fun XCTAssertNotNil(a: Any?, msg: String): Unit = org.junit.Assert.assertNotNull(msg, a)

    fun XCTAssertIdentical(a: Any?, b: Any?): Unit = org.junit.Assert.assertSame(b, a)
    fun XCTAssertIdentical(a: Any?, b: Any?, msg: String): Unit = org.junit.Assert.assertSame(msg, b, a)
    fun XCTAssertNotIdentical(a: Any?, b: Any?): Unit = org.junit.Assert.assertNotSame(b, a)
    fun XCTAssertNotIdentical(a: Any?, b: Any?, msg: String): Unit = org.junit.Assert.assertNotSame(msg, b, a)

    fun XCTAssertEqual(a: Any?, b: Any?): Unit = org.junit.Assert.assertEquals(b, a)
    fun XCTAssertEqual(a: Any?, b: Any?, msg: String): Unit = org.junit.Assert.assertEquals(msg, b, a)
    fun XCTAssertNotEqual(a: Any?, b: Any?): Unit = org.junit.Assert.assertNotEquals(b, a)
    fun XCTAssertNotEqual(a: Any?, b: Any?, msg: String): Unit = org.junit.Assert.assertNotEquals(msg, b, a)

    // additional overloads needed for XCTAssert*() which have different signatures on Linux (@autoclosures) than on Darwin platforms (direct values)

    fun XCTUnwrap(ob: () -> Any?) = { val x = ob(); org.junit.Assert.assertNotNull(x); x }
    fun XCTUnwrap(ob: () -> Any?, msg: () -> String) = { val x = ob(); org.junit.Assert.assertNotNull(msg(), x); x }

    fun XCTAssertTrue(a: () -> Boolean) = org.junit.Assert.assertTrue(a())
    fun XCTAssertTrue(a: () -> Boolean, msg: () -> String) = org.junit.Assert.assertTrue(msg(), a())
    fun XCTAssertFalse(a: () -> Boolean) = org.junit.Assert.assertFalse(a())
    fun XCTAssertFalse(a: () -> Boolean, msg: () -> String) = org.junit.Assert.assertFalse(msg(), a())

    fun XCTAssertNil(a: () -> Any?) = org.junit.Assert.assertNull(a())
    fun XCTAssertNil(a: () -> Any?, msg: () -> String) = org.junit.Assert.assertNull(msg(), a())
    fun XCTAssertNotNil(a: () -> Any?) = org.junit.Assert.assertNotNull(a())
    fun XCTAssertNotNil(a: () -> Any?, msg: () -> String) = org.junit.Assert.assertNotNull(msg(), a())

    fun XCTAssertIdentical(a: () -> Any?, b: () -> Any?) = org.junit.Assert.assertSame(b(), a())
    fun XCTAssertIdentical(a: () -> Any?, b: () -> Any?, msg: () -> String) = org.junit.Assert.assertSame(msg(), b(), a())
    fun XCTAssertNotIdentical(a: () -> Any?, b: () -> Any?) = org.junit.Assert.assertNotSame(b(), a())
    fun XCTAssertNotIdentical(a: () -> Any?, b: () -> Any?, msg: () -> String) = org.junit.Assert.assertNotSame(msg(), b(), a())

    fun XCTAssertEqual(a: () -> Any?, b: () -> Any?) = org.junit.Assert.assertEquals(b(), a())
    fun XCTAssertEqual(a: () -> Any?, b: () -> Any?, msg: () -> String) = org.junit.Assert.assertEquals(msg(), b(), a())
    fun XCTAssertNotEqual(a: () -> Any?, b: () -> Any?) = org.junit.Assert.assertNotEquals(b(), a())
    fun XCTAssertNotEqual(a: () -> Any?, b: () -> Any?, msg: () -> String) = org.junit.Assert.assertNotEquals(msg(), b(), a())
}


// NOTE: the parameter order of JUnit 5's org.junit.jupiter.api.Assertions is the reverse of JUnit 4's org.junit.Assert


/* JUnit 5 (awaiting Robolectric support

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
*/
