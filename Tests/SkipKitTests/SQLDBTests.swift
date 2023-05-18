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

// SKIP INSERT: @org.junit.runner.RunWith(androidx.test.ext.junit.runners.AndroidJUnit4::class)
// SKIP INSERT: @org.robolectric.annotation.Config(manifest=org.robolectric.annotation.Config.NONE, sdk = [33])
final class SQLDBTests: XCTestCase {
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
        let ledger = """
        -- semantic ledger 1.0.0 sha256 https://www.example.com/ledger.sql
        -- 2.0.2 2023-10-10T12:00:00Z #08D3-091B 70026e8c24cc9731110cc3a18edffe2cfbf3fa2542a54dcbf598578478b12159
        -- 1.0.4 2023-09-09T12:00:00Z #1040-1050
        -- 2.0.1 2023-08-08T12:00:00Z #FF10-FF10
        -- 2.0.0 2023-07-07T12:00:00Z #0000-0010
        -- 1.0.3 2023-06-06T12:00:00Z #1030-1040
        -- 1.1.1 2023-05-05T12:00:00Z #1110-1120
        -- 1.0.2 2023-04-04T12:00:00Z #1A20-1A30
        -- 1.1.0 2023-03-03T12:00:00Z #1100-1110
        -- 1.0.1 2023-02-02T12:00:00Z #1010-1020 XXXX+0235dcaf204f405dd91eaeb9b081795d0f468a283f430bbe568948d2c2e
        -- 1.0.0 2023-01-01T12:00:00Z #01F6-022B 5a77e0235dcaf204f405dd91eaeb9b081795d0f468a283f430bbe568948d2c2e

        -- v1.0.0
        CREATE TABLE IF NOT EXISTS FOO (ID INT, NAME TEXT);
        -- v1.0.1
        INSERT INTO FOO (ID, NAME) VALUES(1, 'MARC'); -- seed
        -- v1.0.2
        INSERT INTO FOO (ID, NAME) VALUES(2, 'EMILY');
        -- v1.0.3
        INSERT INTO FOO (ID, NAME) VALUES(3, 'BEBE');
        -- v1.0.4
        INSERT INTO FOO (ID, NAME) VALUES(5, 'BARB');
        INSERT INTO FOO (ID, NAME) VALUES(6, 'YODI');

        -- v1.1.0
        ALTER TABLE FOO ADD COLUMN RANK INT; -- only table/column/index/view creation allowed
        CREATE TABLE BAR (STUFF BLOB);
        UPDATE FOO SET RANK = 0 WHERE RANK IS NULL; -- must be idempotent, as verified by clients
        -- v1.1.1
        -- some comment
        INSERT INTO FOO (ID, NAME, RANK) VALUES(4, 'TIMO', 99);
        INSERT INTO BAR (STUFF) VALUES ('x');

        -- v2.0.0
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
        -- v2.0.1
        INSERT INTO FOO (ID, NAME, SCORE) VALUES(5, 'BARB', NULL); -- new data
        -- v2.0.2
        INSERT INTO FOO (ID, NAME, SCORE) VALUES(6, 'YODI', 0); -- catchup with v1.0.4
        """

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
                    XCTAssertEqual("e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855", try conn.query(sql: q).digest(rows: 0).1.hex())
                    XCTAssertEqual("83afa8aae5693b8eee78a4b36aa9a78840aecce6f11fa7f52ccf79729b9780ec", try conn.query(sql: q).digest(rows: 1).1.hex())
                    XCTAssertEqual("6fd76e609ce51e276d0a95d66a6066943dba82c66d98bdc9421db89ed8d4b258", try conn.query(sql: q).digest(rows: 2).1.hex())
                    XCTAssertEqual("ec87e1176496724ff728b4ff13802bc887e22dff41ab495942a323077a7a4a0f", try conn.query(sql: q).digest(rows: 3).1.hex())
                    XCTAssertEqual("a59b116211491b48f0d4f8f639ac22b793e2daefb54c81112bb745c9bcb0ffcd", try conn.query(sql: q).digest(rows: 4).1.hex())
                    XCTAssertEqual("079f78cadc9d49a0ad1a6c12cb1783c894aabd100299f44393e926fe38dea215", try conn.query(sql: q).digest(rows: 5).1.hex())
                    XCTAssertEqual("919ac94d768dcf5cfca2d41d65ba34ff7a19a32ede533c6292238250ef65305c", try conn.query(sql: q).digest(rows: 6).1.hex())
                    XCTAssertEqual("919ac94d768dcf5cfca2d41d65ba34ff7a19a32ede533c6292238250ef65305c", try conn.query(sql: q).digest().1.hex())
                }
            }

            do {
                let cursor = try conn.query(sql: "SELECT sql FROM sqlite_master WHERE type = 'table' and name = 'FOO'")
                let rows = try cursor.rows().map({ JSON.array($0.map({ $0.toJSON() })) })
                XCTAssertEqual(rows.first?.stringify(), """
                ["CREATE TABLE FOO (ID INT, NAME TEXT, SCORE INT)"]
                """)
            }

            /// Returns the SQL for all the schema creation statements
            func schemaSQL() throws -> [(table: String?, sql: String?)] {
                let q = try conn.query(sql: "SELECT tbl_name, sql FROM sqlite_master")
                defer { try? q.close() }
                let columns = try q.getColumnNames()

                return try q.rows().map({ ($0.first?.textValue, $0.last?.textValue) })
            }

            func checkHashChanges(_ updateSQL: String) throws -> Bool {
                let schema1 = try schemaSQL()
                let tables = schema1.compactMap({ $0.table })
                var hashes: [String: (rows: Int, digest: Data)] = [:]
                // build up the hashes of all the known tables
                for tableName in tables {
                    hashes[tableName] = try conn.query(sql: "SELECT * FROM '\(tableName)'").digest()
                }

                try conn.execute(sql: updateSQL)
                // check to see if the schema has changed as a result of the upate SQL
                let schema2 = try schemaSQL()

                if schema1.map({ $0.sql }) != schema2.map({ $0.sql }) {
                    return true
                }

                // check the tables for hash differences
                // TODO: permit schema additions by selecting only from the previous tables
                for tableName in tables {
                    guard let (expectedRows, expectedDigest) = hashes[tableName] else {
                        continue // should be impossible
                    }

                    // limit the digest to just the expected rows
                    let (rows, digest) = try conn.query(sql: "SELECT * FROM '\(tableName)'").digest(rows: expectedRows)
                    if rows != expectedRows {
                        return true
                    }
                    if digest != expectedDigest {
//                        return true
                    }
                }

                return false
            }

            try conn.execute(sql: "CREATE TABLE BAR(NUM INT, STR TEXT)")

            try XCTAssertFalse(checkHashChanges("INSERT INTO BAR (NUM, STR) VALUES (1, 'ABC')"))
            try XCTAssertFalse(checkHashChanges("INSERT INTO BAR (NUM, STR) VALUES (2, 'DEF')"))
            try XCTAssertTrue(checkHashChanges("UPDATE BAR SET NUM = 0"))
            try XCTAssertTrue(checkHashChanges("CREATE TABLE BAZ (ID INT)"))


        }
    }

}
