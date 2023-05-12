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
        XCTAssertEqual("3.32.2", version?.first?.textValue) // 3.31.1 on Android 11 (API level 30)
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

        try conn.execute(sql: "CREATE TABLE FOO (NAME VARCHAR, NUM INTEGER, DBL FLOAT)")
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

    struct LedgerEntry {
        /// The body of the entry, which is everything beyond the header
        var body: String

        let date: Date
        let version: (major: Int, minor: Int, patch: Int)
    }

    func testSemanticLedger() throws {
        // file header: -- semantic ledger specversion, hash algorithm, index size, ref
        // index entry: -- ref#start-end semver iso8601 checksum
        // sectionhead: -- semver iso8601 prevchecksum
        let index = """
        -- semantic ledger 1.0.0 813 v1.sql
        -- v2.sql#0020-0020 v2.0.2 2023-10-10T12:00:00Z
        -- v1.sql#1040-1050 v1.0.4 2023-09-09T12:00:00Z
        -- v2.sql#FF10-FF10 v2.0.1 2023-08-08T12:00:00Z
        -- v2.sql#0000-0010 v2.0.0 2023-07-07T12:00:00Z
        -- v1.sql#1030-1040 v1.0.3 2023-06-06T12:00:00Z
        -- v1.sql#1110-1120 v1.1.1 2023-05-05T12:00:00Z
        -- v1.sql#1A20-1A30 v1.0.2 2023-04-04T12:00:00Z
        -- v1.sql#1100-1110 v1.1.0 2023-03-03T12:00:00Z
        -- v1.sql#1010-1020 v1.0.1 2023-02-02T12:00:00Z
        -- v1.sql#0000-1010 v1.0.0 2023-01-01T12:00:00Z


        """

        let l100 = """

        CREATE TABLE IF NOT EXISTS FOO (ID INT, NAME TEXT);

        """

        let l101 = """

        INSERT INTO FOO (ID, NAME) VALUES(1, 'MARC'); -- seed

        """

        let l102 = """

        INSERT INTO FOO (ID, NAME) VALUES(2, 'EMILY');

        """

        let l103 = """

        INSERT INTO FOO (ID, NAME) VALUES(3, 'BEBE');

        """

        let l104 = """

        INSERT INTO FOO (ID, NAME) VALUES(5, 'BARB');
        INSERT INTO FOO (ID, NAME) VALUES(6, 'YODI');


        """

        let l110 = """

        ALTER TABLE FOO ADD COLUMN RANK INT; -- only table/column/index/view creation allowed
        CREATE TABLE BAR (STUFF BLOB);
        UPDATE FOO SET RANK = 0 WHERE RANK IS NULL; -- must be idempotent, as verified by clients

        """

        let l111 = """

        -- some comment
        INSERT INTO FOO (ID, NAME, RANK) VALUES(4, 'TIMO', 99);
        INSERT INTO BAR (STUFF) VALUES ('x');


        """

        let l200 = """

        CREATE TABLE IF NOT EXISTS FOO (ID INT, NAME TEXT, RANK INT);
        UPDATE FOO SET RANK = 0 WHERE RANK IS NULL;
        ALTER TABLE FOO RENAME COLUMN RANK TO SCORE;
        UPDATE FOO SET SCORE = SCORE + 1 WHERE ID <= 4; -- arbitrary migration commands
        DROP TABLE IF EXISTS BAR; -- arbitrary schema operations
        -- the first statement beginning with "DELETE" with cause a ledger client to stop processing; the implication is that subsequent commands will be deleting and re-creating all the data from all previous versions
        SAVEPOINT SEMANTIC_REBUILD; -- seed stage (will be skipped over by ledger clients)
        DELETE FROM FOO;
        INSERT INTO FOO (ID, NAME, SCORE) VALUES(1, 'MARC', 1);
        INSERT INTO FOO (ID, NAME, SCORE) VALUES(2, 'EMILY', 1);
        INSERT INTO FOO (ID, NAME, SCORE) VALUES(3, 'BEBE', 1);
        INSERT INTO FOO (ID, NAME, SCORE) VALUES(4, 'TIMO', 100);
        RELEASE SEMANTIC_REBUILD; -- smart clients may ROLLBACK on upgrade iff upgrading from immediate temporal predecessor release (v1.0.3 but not v1.0.4)

        """

        let l201 = """

        INSERT INTO FOO (ID, NAME, SCORE) VALUES(5, 'BARB', NULL); -- new data

        """

        let l202 = """
        
        INSERT INTO FOO (ID, NAME, SCORE) VALUES(6, 'YODI', 0); -- catchup with v1.0.4
        """

        let ledger = index + l100 + l101 + l102 + l103 + l104 + l110 + l111 + l200 + l201 + l202
        let ledgerLines = ledger.components(separatedBy: "\n")


        let v100 = 13...14 // 2023-01-01T12:00:00Z
        let v101 = 15...16 // 2023-02-02T12:00:00Z
        let v102 = 17...18 // 2023-04-04T12:00:00Z
        let v103 = 19...20 // 2023-06-06T12:00:00Z
        let v104 = 21...24 // 2023-09-09T12:00:00Z
        let v110 = 25...28 // 2023-03-03T12:00:00Z
        let v111 = 29...33 // 2023-05-05T12:00:00Z
        let v200 = 34...40 // 2023-07-07T12:00:00Z
        let v200a = 41...47 // savepoint block of v200
        let v201 = 48...49 // 2023-08-08T12:00:00Z
        let v202 = 50...51 // 2023-10-10T12:00:00Z

        let sequentialOrder = [
            v100, // 2023-01-01T12:00:00Z
            v101, // 2023-02-02T12:00:00Z
            v102, // 2023-04-04T12:00:00Z
            v103, // 2023-06-06T12:00:00Z
            v104, // 2023-09-09T12:00:00Z
            v110, // 2023-03-03T12:00:00Z
            v111, // 2023-05-05T12:00:00Z
            v200, // 2023-07-07T12:00:00Z
            v200a, // re-build stage
            v201, // 2023-08-08T12:00:00Z
            v202, // 2023-10-10T12:00:00Z
        ]

        let semanticOrder = [
            v100, // 2023-01-01T12:00:00Z
            v101, // 2023-02-02T12:00:00Z
            v102, // 2023-04-04T12:00:00Z
            v103, // 2023-06-06T12:00:00Z
            // v104, // 2023-09-09T12:00:00Z // skip temporally post-v200 release
            v110, // 2023-03-03T12:00:00Z
            v111, // 2023-05-05T12:00:00Z
            v200, // 2023-07-07T12:00:00Z
            // v200a, // skip re-build stage because we are upgrading
            v201, // 2023-08-08T12:00:00Z
            v202, // 2023-10-10T12:00:00Z
        ]

        let temporalOrder = [
            //1...ledgerLines.count,
            v100, // 2023-01-01T12:00:00Z
            v101, // 2023-02-02T12:00:00Z
            v110, // 2023-03-03T12:00:00Z
            v102, // 2023-04-04T12:00:00Z
            v111, // 2023-05-05T12:00:00Z
            v103, // 2023-06-06T12:00:00Z
            v200, v200a, // 2023-07-07T12:00:00Z
            v201, // 2023-08-08T12:00:00Z
            //v104, // 2023-09-09T12:00:00Z // skiped due to out-of-order
            v202, // 2023-10-10T12:00:00Z
        ]

        // the fewest number of operations required to get to the end state
        let optimalOrder = [
            v200, // 2023-07-07T12:00:00Z
            v200a, // skip the seed section of v2.0.0
            v201, // 2023-08-08T12:00:00Z
            v202, // 2023-10-10T12:00:00Z
        ]

        // try both semantic ordering and temporal ordering; both must yield identical results
        for indexSets in [
            sequentialOrder,
            semanticOrder,
            temporalOrder,
            optimalOrder,
        ] {
            let conn: SQLDB = try SQLDB()
            defer { conn.close() }
            try conn.execute(sql: "BEGIN TRANSACTION")

            for indices in indexSets {
                for index in indices {
                    let line = ledgerLines[index-1]
                    if !line.hasPrefix("--") && !line.isEmpty {
                        try conn.execute(sql: line)
                    }
                }
            }

            try conn.execute(sql: "COMMIT TRANSACTION")

            do {
                let q = "SELECT * FROM FOO ORDER BY ID, NAME, SCORE"

                do {
                    let cursor = try conn.query(sql: q)
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
                    XCTAssertEqual(#"[5.0,"BARB",null]"#, JSON.array(try cursor.getRow().map({ $0.toJSON() })).stringify())

                    XCTAssertTrue(try cursor.next())
                    XCTAssertEqual(#"[6.0,"YODI",0.0]"#, JSON.array(try cursor.getRow().map({ $0.toJSON() })).stringify())

                    XCTAssertFalse(try cursor.next())
                }

                do {
                    // check the insertion hash
                    XCTAssertEqual("919ac94d768dcf5cfca2d41d65ba34ff7a19a32ede533c6292238250ef65305c", try conn.query(sql: q).resultHash().hex())
                }
            }

            do {
                let cursor = try conn.query(sql: "SELECT sql FROM sqlite_master WHERE type = 'table' and name = 'FOO'")
                let rows = try cursor.rows().map({ JSON.array($0.map({ $0.toJSON() })) })
                XCTAssertEqual(rows.first?.stringify(), """
                ["CREATE TABLE FOO (ID INT, NAME TEXT, SCORE INT)"]
                """)
            }
        }
    }

}
