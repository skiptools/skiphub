// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
#if !SKIP
@testable import SkipSQL
#endif
import XCTest
import SkipFoundation

final class SkipSQLTests: XCTestCase {
    // SKIP INSERT: @Test
    func testSkipSQL() throws {
        try Connection.testDatabase()
    }

//    // SKIP INSERT: @Test
//    func testConnection() throws {
//        let url: URL = URL.init(fileURLWithPath: "/tmp/testConnection.db", isDirectory: false)
//        let conn: Connection = try Connection.open(url: url)
//        XCTAssertEqual(1.0, try conn.query(sql: "SELECT 1.0").singleValue()?.floatValue)
//        XCTAssertEqual(3.5, try conn.query(sql: "SELECT 1.0 + 2.5").singleValue()?.floatValue)
//        conn.close()
//    }

}

extension Connection {
    /// Test case lives here until we can get module symbols linking from `CrossSQLTests.swift`
    static func testDatabase() throws {
        // FIXME: cannot determine type
        //let random: Random = Random.shared
        //let rnd: Double = (random as Random).randomDouble()
        let rnd = 1

        let dbname = "/tmp/demosql_\(rnd).db"

        print("connecting to: " + dbname)
        let conn = try Connection(dbname)

        let version = try conn.query(sql: "select sqlite_version()").nextRow(close: true)?.first?.textValue
        print("SQLite version: " + (version ?? "")) // Kotlin: 3.28.0 Swift: 3.39.5

        assert(try! conn.query(sql: "SELECT 1.0").nextRow(close: true)?.first?.floatValue == 1.0)
        assert(try! conn.query(sql: "SELECT 'ABC'").nextRow(close: true)?.first?.textValue == "ABC")
        assert(try! conn.query(sql: "SELECT lower('ABC')").nextRow(close: true)?.first?.textValue == "abc")
        assert(try! conn.query(sql: "SELECT 3.0/2.0, 4.0*2.5").nextRow(close: true)?.last?.floatValue == 10.0)

        assert(try! conn.query(sql: "SELECT ?", params: [.text("ABC")]).nextRow(close: true)?.first?.textValue == "ABC")
        assert(try! conn.query(sql: "SELECT upper(?), lower(?)", params: [.text("ABC"), .text("XYZ")]).nextRow(close: true)?.last?.textValue == "xyz")

        // SKIP IGNORE
        assert(try! conn.query(sql: "SELECT ?", params: [.float(1.5)]).nextRow(close: true)?.last?.floatValue == 1.5) // compiles but AssertionError in Kotlin

        // SKIP IGNORE
        assert(try! conn.query(sql: "SELECT 1").nextRow(close: true)?.first?.integerValue == 1) // Kotlin error: “Operator '==' cannot be applied to 'Long?' and 'Int'”

        do {
            try conn.execute(sql: "DROP TABLE FOO")
        } catch {
            // exception expected when re-running on existing database
        }

        try conn.execute(sql: "CREATE TABLE FOO(NAME VARCHAR, NUM INTEGER, DBL FLOAT)")
        for i in 1...10 {
            try conn.execute(sql: "INSERT INTO FOO VALUES(?, ?, ?)", params: [.text("NAME_" + i.description), .integer(/* SKIP VALUE: i.toLong() */ Int64(i)), .float(Double(i))])
        }

        let cursor = try conn.query(sql: "SELECT * FROM FOO")
        let colcount = cursor.columnCount
        print("columns: \(colcount)")
        assert(colcount == 3)

        var row = 0
        let consoleWidth = 45

        while try cursor.next() {
            if row == 0 {
                // header and border rows
                print(cursor.rowText(header: false, values: false, width: consoleWidth))
                print(cursor.rowText(header: true, values: false, width: consoleWidth))
                print(cursor.rowText(header: false, values: false, width: consoleWidth))
            }

            print(cursor.rowText(header: false, values: true, width: consoleWidth))

            row += 1

            assert(cursor.getColumnName(column: 0) == "NAME")
            assert(cursor.getColumnType(column: 0) == .text)
            assert(cursor.getString(column: 0) == "NAME_\(row)")

            assert(cursor.getColumnName(column: 1) == "NUM")
            assert(cursor.getColumnType(column: 1) == .integer)
            assert(cursor.getInt64(column: 1) == /* SKIP VALUE: row.toLong() */ Int64(row))

            assert(cursor.getColumnName(column: 2) == "DBL")
            assert(cursor.getColumnType(column: 2) == .float)
            assert(cursor.getDouble(column: 2) == Double(row))
        }

        print(cursor.rowText(header: false, values: false, width: consoleWidth))

        try cursor.close()
        assert(cursor.closed == true)

        try conn.execute(sql: "DROP TABLE FOO")

        conn.close()
        assert(conn.closed == true)

        // .init not being resolved for some reason…

        // let dataFile: Data = try Data.init(contentsOfFile: dbname)
        // assert(dataFile.count > 1024) // 8192 on Darwin, 12288 for Android

        // 'removeItem(at:)' is deprecated: URL paths not yet implemented in Kotlin
        //try FileManager.default.removeItem(at: URL(fileURLWithPath: dbname, isDirectory: false))

        try FileManager.default.removeItem(atPath: dbname)
    }
}
