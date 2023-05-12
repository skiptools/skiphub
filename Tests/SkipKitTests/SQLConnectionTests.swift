// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
#if !SKIP
@testable import SkipKit
#endif
import XCTest
import SkipFoundation

// SKIP INSERT: @org.junit.runner.RunWith(org.robolectric.RobolectricTestRunner::class)
// SKIP INSERT: @org.robolectric.annotation.Config(manifest=org.robolectric.annotation.Config.NONE, sdk = [33])
final class SkipSQLTests: XCTestCase {
    func testCheckSQLVersion() throws {
        let version = try SQLDB().query(sql: "SELECT sqlite_version()").nextRow(close: true)
        #if SKIP
        XCTAssertEqual("3.32.2", version?.first?.textValue)
        #else
        XCTAssertEqual("3.39.5", version?.first?.textValue)
        #endif
    }

    func testSkipSQL() throws {
        //var random = PseudoRandomNumberGenerator(seed: 1234)
        //let rnd = (0...999999).randomElement(using: &random)!
        let rnd = 1
        let dbname = "/tmp/demosql_\(rnd).db"

        print("connecting to: " + dbname)
        let conn = try SQLDB(dbname)

        let version = try conn.query(sql: "select sqlite_version()").nextRow(close: true)?.first?.textValue
        print("SQLite version: " + (version ?? "")) // Kotlin: 3.28.0 Swift: 3.39.5

        XCTAssertEqual(try conn.query(sql: "SELECT 1.0").nextRow(close: true)?.first?.floatValue, 1.0)
        XCTAssertEqual(try conn.query(sql: "SELECT 'ABC'").nextRow(close: true)?.first?.textValue, "ABC")
        XCTAssertEqual(try conn.query(sql: "SELECT lower('ABC')").nextRow(close: true)?.first?.textValue, "abc")
        XCTAssertEqual(try conn.query(sql: "SELECT 3.0/2.0, 4.0*2.5").nextRow(close: true)?.last?.floatValue, 10.0)

        XCTAssertEqual(try conn.query(sql: "SELECT ?", params: [SQLValue.text("ABC")]).nextRow(close: true)?.first?.textValue, "ABC")
        XCTAssertEqual(try conn.query(sql: "SELECT upper(?), lower(?)", params: [SQLValue.text("ABC"), SQLValue.text("XYZ")]).nextRow(close: true)?.last?.textValue, "xyz")

        #if !SKIP
        XCTAssertEqual(try conn.query(sql: "SELECT ?", params: [SQLValue.float(1.5)]).nextRow(close: true)?.first?.floatValue, 1.5) // compiles but AssertionError in Kotlin
        #endif
        
        XCTAssertEqual(try conn.query(sql: "SELECT 1").nextRow(close: true)?.first?.integerValue, Int64(1))

        do {
            try conn.execute(sql: "DROP TABLE FOO")
        } catch {
            // exception expected when re-running on existing database
        }

        try conn.execute(sql: "CREATE TABLE FOO(NAME VARCHAR, NUM INTEGER, DBL FLOAT)")
        for i in 1...10 {
            try conn.execute(sql: "INSERT INTO FOO VALUES(?, ?, ?)", params: [SQLValue.text("NAME_" + i.description), SQLValue.integer(Int64(i)), SQLValue.float(Double(i))])
        }

        let cursor = try conn.query(sql: "SELECT * FROM FOO")
        let colcount = cursor.columnCount
        print("columns: \(colcount)")
        XCTAssertEqual(colcount, 3)

        var row = 0
        let consoleWidth = 45

        while try cursor.next() {
            if row == 0 {
                // header and border rows
                try print(cursor.rowText(header: false, values: false, width: consoleWidth))
                try print(cursor.rowText(header: true, values: false, width: consoleWidth))
                try print(cursor.rowText(header: false, values: false, width: consoleWidth))
            }

            try print(cursor.rowText(header: false, values: true, width: consoleWidth))

            row += 1

            try XCTAssertEqual(cursor.getColumnName(column: 0), "NAME")
            try XCTAssertEqual(cursor.getColumnType(column: 0), ColumnType.text)
            try XCTAssertEqual(cursor.getString(column: 0), "NAME_\(row)")

            try XCTAssertEqual(cursor.getColumnName(column: 1), "NUM")
            try XCTAssertEqual(cursor.getColumnType(column: 1), ColumnType.integer)
            try XCTAssertEqual(cursor.getInt64(column: 1), Int64(row))

            try XCTAssertEqual(cursor.getColumnName(column: 2), "DBL")
            try XCTAssertEqual(cursor.getColumnType(column: 2), ColumnType.float)
            try XCTAssertEqual(cursor.getDouble(column: 2), Double(row))
        }

        try print(cursor.rowText(header: false, values: false, width: consoleWidth))

        try cursor.close()
        XCTAssertEqual(cursor.closed, true)

        try conn.execute(sql: "DROP TABLE FOO")

        conn.close()
        XCTAssertEqual(conn.closed, true)

        // .init not being resolved for some reason…

        // let dataFile: Data = try Data.init(contentsOfFile: dbname)
        // XCTAssertEqual(dataFile.count > 1024) // 8192 on Darwin, 12288 for Android

        // 'removeItem(at:)' is deprecated: URL paths not yet implemented in Kotlin
        //try FileManager.default.removeItem(at: URL(fileURLWithPath: dbname, isDirectory: false))

        try FileManager.default.removeItem(atPath: dbname)
    }

    func testConnection() throws {
        let url: URL = URL.init(fileURLWithPath: "/tmp/testConnection.db", isDirectory: false)
        let conn: SQLDB = try SQLDB.open(url: url)
        //XCTAssertEqual(1.0, try conn.query(sql: "SELECT 1.0").singleValue()?.floatValue)
        //XCTAssertEqual(3.5, try conn.query(sql: "SELECT 1.0 + 2.5").singleValue()?.floatValue)
        conn.close()
    }

    func testSemanticLedger() throws {
        let url: URL = URL.init(fileURLWithPath: "/tmp/sqlLedger-\(UUID().uuidString).db", isDirectory: false)
        let conn: SQLDB = try SQLDB.open(url: url)
        defer { conn.close() }

        let ledger = """
        -- semantic ledger v1.sql sha256 813
        -- v1.sql#2020-0020 v2.0.2 2023-10-10T12:00:00Z sha256v202
        -- v1.sql#1040-1050 v1.0.4 2023-09-09T12:00:00Z sha256v104
        -- v1.sql#2010-0010 v2.0.1 2023-08-08T12:00:00Z sha256v201
        -- v1.sql#2000-0010 v2.0.0 2023-07-07T12:00:00Z sha256v200
        -- v1.sql#1030-1040 v1.0.3 2023-06-06T12:00:00Z sha256v103
        -- v1.sql#1110-1120 v1.1.1 2023-05-05T12:00:00Z sha256v111
        -- v1.sql#1020-1030 v1.0.2 2023-04-04T12:00:00Z sha256v102
        -- v1.sql#1100-1110 v1.1.0 2023-03-03T12:00:00Z sha256v110
        -- v1.sql#1010-1020 v1.0.1 2023-02-02T12:00:00Z sha256v101
        -- v1.sql#0000-1010 v1.0.0 2023-01-01T12:00:00Z sha256v100

        -- v1.0.0 2023-01-01T12:00:00Z
        CREATE TABLE FOO(ID INT, NAME TEXT);
        -- v1.0.1 2023-02-02T12:00:00Z sha256v100
        DELETE FROM FOO;
        INSERT INTO FOO (ID, NAME) VALUES(1, 'MARC'); -- seed
        -- v1.0.2 2023-04-04T12:00:00Z sha256v110
        INSERT INTO FOO (ID, NAME) VALUES(2, 'EMILY');
        -- v1.0.3 2023-06-06T12:00:00Z sha256v111
        INSERT INTO FOO (ID, NAME) VALUES(4, 'BEBE');
        -- v1.0.4 2023-09-09T12:00:00Z sha256v201
        INSERT INTO FOO (ID, NAME) VALUES(5, 'YODI');

        -- v1.1.0 2023-03-03T12:00:00Z sha256v101
        ALTER TABLE FOO ADD COLUMN RANK INT; -- only table/column/index/view creation allowed
        CREATE TABLE BAR (STUFF BLOB);
        UPDATE FOO SET RANK = 0 WHERE RANK IS NULL; -- must be idempotent, as verified by clients
        -- v1.1.1 2023-05-05T12:00:00Z sha256v102
        DELETE FROM BAR;
        INSERT INTO FOO (ID, NAME, RANK) VALUES(3, 'TIMO', 99);
        INSERT INTO BAR (STUFF) VALUES ('x');

        -- v2.0.0 2023-07-07T12:00:00Z sha256v103
        DROP TABLE IF EXISTS BAR;
        CREATE TABLE IF NOT EXISTS FOO (ID INT, NAME TEXT, RANK INT);
        ALTER TABLE FOO RENAME COLUMN RANK TO SCORE;
        UPDATE FOO SET SCORE = SCORE + 1; -- arbitrary migration commands
        -- the first statement beginning with "DELETE" with cause a ledger client to stop processing; the implication is that subsequent commands will be deleting and re-creating all the data from all previous versions
        DELETE FROM FOO; -- seed stage (will be skipped over by ledger clients)
        INSERT INTO FOO (ID, NAME, SCORE) VALUES(1, 'MARC', 1);
        INSERT INTO FOO (ID, NAME, SCORE) VALUES(2, 'EMILY', 1);
        INSERT INTO FOO (ID, NAME, SCORE) VALUES(3, 'BEBE', 1);
        INSERT INTO FOO (ID, NAME, SCORE) VALUES(4, 'TIMO', 100);
        -- v2.0.1 2023-08-08T12:00:00Z sha256v200
        INSERT INTO FOO (ID, NAME, SCORE) VALUES(5, 'BARB', 0); -- new data
        -- v2.0.2 2023-10-10T12:00:00Z sha256v104
        INSERT INTO FOO (ID, NAME, SCORE) VALUES(6, 'YODI', 0); -- catchup with v1.0.4
        """

        try conn.execute(sql: "BEGIN TRANSACTION")

        for (index, line) in ledger.components(separatedBy: "\n").enumerated() {
            if !line.hasPrefix("--") && !line.isEmpty {
                try conn.execute(sql: line)
            }
        }

        try conn.execute(sql: "COMMIT TRANSACTION")

        do {
            let cursor = try conn.query(sql: "SELECT * FROM FOO")
            let colcount = cursor.columnCount
            print("columns: \(colcount)")
            XCTAssertEqual(colcount, 3)

            XCTAssertTrue(try cursor.next())
            XCTAssertEqual(#"[1.0,"MARC",1.0]"#, JSON.array(try cursor.getRow().map({ $0.toJSON() })).stringify())

            XCTAssertTrue(try cursor.next())
            XCTAssertEqual(#"[2.0,"EMILY",1.0]"#, JSON.array(try cursor.getRow().map({ $0.toJSON() })).stringify())

            XCTAssertTrue(try cursor.next())
            XCTAssertEqual(#"[3.0,"BEBE",1.0]"#, JSON.array(try cursor.getRow().map({ $0.toJSON() })).stringify())

            XCTAssertTrue(try cursor.next())
            XCTAssertEqual(#"[4.0,"TIMO",100.0]"#, JSON.array(try cursor.getRow().map({ $0.toJSON() })).stringify())

            XCTAssertTrue(try cursor.next())
            XCTAssertEqual(#"[5.0,"BARB",0.0]"#, JSON.array(try cursor.getRow().map({ $0.toJSON() })).stringify())

            XCTAssertTrue(try cursor.next())
            XCTAssertEqual(#"[6.0,"YODI",0.0]"#, JSON.array(try cursor.getRow().map({ $0.toJSON() })).stringify())

            XCTAssertFalse(try cursor.next())
        }

        if false { // no such table on Android
            let cursor = try conn.query(sql: "SELECT sql FROM sqlite_schema")
            let rows = try cursor.rows().map({ JSON.array($0.map({ $0.toJSON() })) })
            XCTAssertEqual(rows.first?.stringify(), """
            ["CREATE TABLE FOO(ID INT, NAME TEXT, SCORE INT)"]
            """)
        }
    }

}
