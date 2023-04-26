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

final class ExampleLibTests: XCTestCase {
    func testExampleLib() throws {
        XCTAssertEqual("ExampleLib", ExampleLibInternalModuleName())
        XCTAssertEqual("ExampleLib", ExampleLibPublicModuleName())
    }

    func testHelloSkip() {
        // This code runs both in Swift and Kotlin!
        print("""
        Hello Skipper!

        Skip is a plugin that transpiles Swift to Kotlin
        for use on Android and other JVM platforms.
        """)
    }

    // Use the SKIP compilation directive to embed transpilation-conditional code
    #if SKIP
    let kotlin = true // we are running transpiled Kotlin on a JVM
    #else
    let kotlin = false // we are running compiled Swift
    #endif

    func testTour01_Skip_Directive() {
        print("This",
              kotlin ? "Kotlin" : "Swift",
              "code is currently running as a",
              kotlin ? "JUnit" : "XCTest",
              "test case by the",
              kotlin ? "Gradle" : "Swift Package Manager",
              "build tool.")
    }

    // This XCUnit test case is running transpiled as a Kotlin JUnit test.

    func testTour02_Testing_Framework() throws {
        XCTAssertEqual(1, 1, "assertions are converted into JUnit assertEqual")
        XCTAssertEqual("dog" + "cow", "dogcow")

        XCTAssertNotEqual("Kotlin", "Swift")

        XCTAssertGreaterThan(2, 1)
        XCTAssertLessThanOrEqual(1, 2)

        // Skipping tests is supported and will be
        // reported as such by both JUnit and XCTest test reports
        if false && true {
            throw XCTSkip("skip this test")
        }

        // Test asserion failures will be converted into Xcode errors
        // that will show in the Issue Navigator,
        // allowing you to jump to the failing line in both the Swift
        // as well as the transpiled Kotlin
        if false && true {
            XCTFail("Test failure example. Click me to see the Kotlin or Swift!")
        }
    }

    // Swift functions are converted into Kotlin functions.

    /// Returns the type name for this type
    func typeName(_ instance: Any) -> String {
        "\(type(of: instance))"
    }

    func testTour03_Transpiled_Types() {
        // Swift primitives like String and Int are converted into their Kotlin equivalents
        XCTAssertEqual(typeName("X"), kotlin ? "class kotlin.String" : "String")
        XCTAssertEqual(typeName(42), kotlin ? "class kotlin.Int" : "Int")

        // Arrays and other collections are converted into the types provided in the SkipLib module, which transpiles to the "skip.lib" Java package name
        XCTAssertEqual(typeName([42]), kotlin ? "class skip.lib.Array" : "Array<Int>")
        XCTAssertEqual(typeName(Set([true])), kotlin ? "class skip.lib.Set" : "Set<Bool>")
    }

    func testTour04_Filter_Map_Reduce() {
        let numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

        // Calculate the sum of even squares using filter, map, and reduce

        let sumOfEvenSquares = numbers
            .filter { $0 % 2 == 0 }
            .map { $0 * $0 }
            .reduce(0, +)

        XCTAssertEqual(220, sumOfEvenSquares, "filter/map/reduce works the same in Kotlin and Swift")
    }

    // Equatable structs are converted into Kotlin types with synthesized equality

    struct Person: Equatable {
        let name: String
    }

    func testTour05_Equatable_Structs() {
        let names = ["Adam", "Daria", "Rob", "Adrian", "Simone", "Albert", "Richard"]

        // Filter names that start with "R" and create Person instances for each
        let rPeople = names
            .filter { $0.lowercased().hasPrefix("r") }
            .map { Person(name: $0) }

        XCTAssertEqual(rPeople, [Person(name: "Rob"), Person(name: "Richard")], "people should have been equal")
    }
}
