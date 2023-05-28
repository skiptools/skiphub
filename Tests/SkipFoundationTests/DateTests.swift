// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
import Foundation
import XCTest

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
final class DateTests: XCTestCase {
    func testDateTime() throws {
        let date: Date = Date()
        XCTAssertNotEqual(0, date.timeIntervalSince1970)
    }

    func testMultipleConstructorsSameParams() throws {
        let d1 = Date(timeIntervalSince1970: 99999.0)
        let d2 = Date(timeIntervalSinceReferenceDate: 99999.0)

        XCTAssertEqual(99999.0, d1.timeIntervalSince1970)
        XCTAssertEqual(978407199.0, d2.timeIntervalSince1970)

        XCTAssertEqual(-978207201.0, d1.timeIntervalSinceReferenceDate)
        XCTAssertEqual(99999.0, d2.timeIntervalSinceReferenceDate)
    }

    func testISOFormatting() throws {
        let d = Date(timeIntervalSince1970: 172348932.0)
        XCTAssertEqual(172348932.0, d.timeIntervalSince1970)
        //logger.info("date: \(d.ISO8601Format())")
        XCTAssertEqual("1975-06-18T18:42:12Z", d.ISO8601Format())

        let d2 = Date(timeIntervalSince1970: 999999999.0)
        XCTAssertEqual(999999999.0, d2.timeIntervalSince1970)
        //logger.info("date: \(d2.ISO8601Format())")
        XCTAssertEqual("2001-09-09T01:46:39Z", d2.ISO8601Format())

        let d3030 = Date(timeIntervalSince1970: 33450382800.0 - (5 * 60 * 60))
        XCTAssertEqual(33450382800.0 - (5 * 60 * 60), d3030.timeIntervalSince1970)
        //logger.info("date: \(d3030.ISO8601Format())")
        XCTAssertEqual("3030-01-01T00:00:00Z", d3030.ISO8601Format())

        XCTAssertEqual(-62135769600.0, Date.distantPast.timeIntervalSince1970)
        XCTAssertEqual("0001-01-01T00:00:00Z", Date.distantPast.ISO8601Format())

        XCTAssertEqual(64092211200.0, Date.distantFuture.timeIntervalSince1970)
        XCTAssertEqual("4001-01-01T00:00:00Z", Date.distantFuture.ISO8601Format())
    }

    func testAbsoluteTimeGetCurrent() {
        XCTAssertNotEqual(0, CFAbsoluteTimeGetCurrent())
    }

    func testDateComponentsLeapYears() {
        XCTAssertTrue(DateComponents(calendar: Calendar.current, year: 1928, month: 2, day: 29).isValidDate)
        #if !SKIP // validation not yet correct
        XCTAssertFalse(DateComponents(calendar: Calendar.current, year: 1928 + 1, month: 2, day: 29).isValidDate)

        XCTAssertTrue(DateComponents(calendar: Calendar.current, year: 1956, month: 2, day: 29).isValidDate)
        XCTAssertFalse(DateComponents(calendar: Calendar.current, year: 1956 + 1, month: 2, day: 29).isValidDate)

        XCTAssertTrue(DateComponents(calendar: Calendar.current, year: 2000, month: 2, day: 29).isValidDate)
        XCTAssertFalse(DateComponents(calendar: Calendar.current, year: 2000 + 1, month: 2, day: 29).isValidDate)

        XCTAssertTrue(DateComponents(calendar: Calendar.current, year: 2020, month: 2, day: 29).isValidDate)
        XCTAssertFalse(DateComponents(calendar: Calendar.current, year: 2020 + 1, month: 2, day: 29).isValidDate)

        XCTAssertTrue(DateComponents(calendar: Calendar.current, year: 800, month: 2, day: 29).isValidDate)
        XCTAssertFalse(DateComponents(calendar: Calendar.current, year: 800 + 1, month: 2, day: 29).isValidDate)

        XCTAssertTrue(DateComponents(calendar: Calendar.current, year: 8, month: 2, day: 29).isValidDate)
        XCTAssertFalse(DateComponents(calendar: Calendar.current, year: 8 + 1, month: 2, day: 29).isValidDate)
        #endif
    }
}
