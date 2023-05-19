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
        -- semantic ledger 1.0.0 1024 sha256 36ab5512815d8c8cc799f62cc8cce43fca1d7d8fc3dfc24e4ce5635c728080c4 https://www.example.com/ledger.sql
        -- 3.0.0 2023-11-11T12:00:00Z https://www.example.com/ledgerv3.sql
        -- 2.0.2 2023-10-10T12:00:00Z #08D3-091B 70026e8c24cc9731110cc3a18edffe2cfbf3fa2542a54dcbf598578478b12159
        -- 1.0.4 2023-09-09T12:00:00Z #1040-1050 36ab5512815d8c8cc799f62cc8cce43fca1d7d8fc3dfc24e4ce5635c728080c4
        -- 2.0.1 2023-08-08T12:00:00Z #FF10-FF10 b6dee10b0424ecedb0d7d144ddb650e86256a9fead94f1719f4f6445dbdd6c78
        -- 2.0.0 2023-07-07T12:00:00Z #0000-0010 e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855
        -- 1.0.3 2023-06-06T12:00:00Z #1030-1040 8dc662d02128554cddd7b301739be87826cee62840e7658ec7228518afc8e8da
        -- 1.1.1 2023-05-05T12:00:00Z #1110-1120 ded8a202b0bab7326386959d93b1827bca001d9b008d100fbf34572d17bfe14c
        -- 1.0.2 2023-04-04T12:00:00Z #1A20-1A30 1465c9217724f4544792fc609f31aa3cd4a50cf91fefc02831dd0f86397f10f7
        -- 1.1.0 2023-03-03T12:00:00Z #1100-1110 88adaac88d0472ba94b4b7a11390f1b38526110c82ba6232ced7cec343bb0159
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


        let v100 = 14...15 // 2023-01-01T12:00:00Z
        let v101 = 16...17 // 2023-02-02T12:00:00Z
        let v102 = 18...19 // 2023-04-04T12:00:00Z
        let v103 = 20...21 // 2023-06-06T12:00:00Z
        let v104 = 22...25 // 2023-09-09T12:00:00Z
        let v110 = 26...29 // 2023-03-03T12:00:00Z
        let v111 = 30...34 // 2023-05-05T12:00:00Z
        let v200 = 35...41 // 2023-07-07T12:00:00Z
        let v200a = 42...48 // savepoint block of v200
        let v201 = 49...50 // 2023-08-08T12:00:00Z
        let v202 = 51...52 // 2023-10-10T12:00:00Z

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
                    XCTAssertEqual("5cf50e249c2d4ca3f53f34937b00a98a83bad808a4fa76b27a9f85a3cd044496", try conn.query(sql: q).digest(rows: 5).1.hex())
                    XCTAssertEqual("666cbb931dc99d8bfc4885b22727d2676921873a72a66d9f7935c44b65e36e78", try conn.query(sql: q).digest(rows: 6).1.hex())
                    XCTAssertEqual("666cbb931dc99d8bfc4885b22727d2676921873a72a66d9f7935c44b65e36e78", try conn.query(sql: q).digest().1.hex())
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
            func schemaSQL() throws -> [(tableName: String, createSQL: String, selectSQL: String)] {
                // note: "sqlite_schema" does not exist on Android
                let q = try conn.query(sql: "SELECT tbl_name, sql FROM sqlite_master")
                defer { try? q.close() }
                let results: [(tableName: String, createSQL: String, selectSQL: String)?] = try q.rows().map({ row in
                    guard let tableName = row.first?.textValue else {
                        return nil
                    }
                    // known system tables to avoid
                    if tableName == "android_metadata" {
                        return nil
                    }
                    guard let tableSQL = row.last?.textValue else {
                        return nil
                    }

                    let c = try conn.query(sql: "PRAGMA table_info('\(tableName)');")
                    defer { try? c.close() }

                    var select = "SELECT "
                    for (index, row) in try c.rows().enumerated() {
                        if index > 0 { select += ", " }
                        // cid|name|type|notnull|dflt_value|pk
                        if row.count < 3 { continue }
                        guard let name = row[1].textValue else { continue }
                        select += "\"\(name)\""
                    }
                    select += " FROM \"\(tableName)\""
                    return (tableName: tableName, createSQL: tableSQL, selectSQL: select)
                })

                return results.compactMap({ $0 })
            }

            func verify(minor permitSchemaChanges: Bool = false, rollback: Bool? = nil, sql updateSQL: String) throws -> Bool {
                let rollback = rollback ?? !permitSchemaChanges
                let schema1 = try schemaSQL()
                let tables = schema1.compactMap({ $0.createSQL })
                var tableHashes: [(select: String, (rows: Int, digest: Data))] = []
                // build up the hashes of all the pre-existing tables
                for schema in schema1 {
                    #if !SKIP
                    try Task.checkCancellation()
                    #endif
                    let digest = try conn.query(sql: schema.selectSQL).digest()
                    tableHashes.append((schema.selectSQL, digest))
                }

                #if !SKIP
                try Task.checkCancellation()
                #endif
                try conn.execute(sql: "BEGIN")
                do {
                    try conn.execute(sql: updateSQL)
                } catch {
                    // rollback on error; otherwise, defer commit
                    try conn.execute(sql: "ROLLBACK")
                    throw error
                }

                let completeTransaction = rollback ? "ROLLBACK" : "COMMIT"

                // if we forbid schema changes, verify that the SQL did not result in any alterations to the database
                if permitSchemaChanges == false {
                    // check to see if the schema has changed as a result of the upate SQL
                    let schema2 = try schemaSQL()

                    #if !SKIP
                    try Task.checkCancellation()
                    #endif
                    if schema1.map({ $0.createSQL }) != schema2.map({ $0.createSQL }) {
                        try conn.execute(sql: completeTransaction)
                        return false
                    }
                }

                // check the tables for hash differences
                for (tableSelect, expected) in tableHashes {
                    let (expectedRows, expectedDigest) = expected
                    #if !SKIP
                    try Task.checkCancellation()
                    #endif

                    // re-execute the table selection, which limits the columns to the original rows (and thereby tolrates column additions)
                    let (rows, digest) = try conn.query(sql: tableSelect).digest(rows: expectedRows)
                    if rows != expectedRows {
                        try conn.execute(sql: completeTransaction)
                        return false // throw DisallowedRowDeletionError()
                    }
                    if digest != expectedDigest {
                        print("#### HASH: \(digest.hex()) != \(expectedDigest.hex())")
                        try conn.execute(sql: completeTransaction)
                        return false // throw DisallowedRowUpdateError()
                    }
                }

                // no changes: we can commit the operation
                try conn.execute(sql: "COMMIT")
                return true
            }

            do {
                try conn.execute(sql: "BEGIN")
                try conn.execute(sql: "CREATE TABLE BAR(NUM INT, STR TEXT)")

                XCTAssertEqual("e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855", try conn.query(sql: "SELECT NUM,STR FROM BAR").digest().1.hex())
                try conn.execute(sql: "INSERT INTO BAR (NUM, STR) VALUES (1, 'ABC')")
                XCTAssertEqual("de28386bb84d67cc9416eb5410e5942a6a6045af5520c3e54f77ea9be64613e1", try conn.query(sql: "SELECT NUM,STR FROM BAR").digest().1.hex())
                try conn.execute(sql: "INSERT INTO BAR (NUM, STR) VALUES (2, 'DEF')")
                XCTAssertEqual("c2a0f7f8ea74a68b1dda49a4934572a4582872c2c8d343ca34541d761c0418b1", try conn.query(sql: "SELECT NUM,STR FROM BAR").digest().1.hex())
                try conn.execute(sql: "UPDATE BAR SET NUM = 0")
                XCTAssertEqual("951495cc2d873ea389e6c9e429d5a20045e04e5b251907947aab82f28d21bec3", try conn.query(sql: "SELECT NUM,STR FROM BAR").digest().1.hex())

                try conn.execute(sql: "ROLLBACK")
            }

            for rollback in [true, false] {
                try? conn.execute(sql: "DROP TABLE BAR")
                try? conn.execute(sql: "DROP TABLE BAZ")

                try conn.execute(sql: "CREATE TABLE BAR(NUM INT, STR TEXT)")

                try XCTAssertEqual(true, verify(rollback: rollback, sql: "INSERT INTO BAR (NUM, STR) VALUES (1, 'ABC')"), "insert should not change hash")
                try XCTAssertEqual(true, verify(rollback: rollback, sql: "INSERT INTO BAR (NUM, STR) VALUES (2, 'DEF')"), "insert should not change hash")
                try XCTAssertEqual(false, verify(rollback: rollback, sql: "UPDATE BAR SET NUM = NUM + NUM / NUM"), "alterations should change hash")
                try XCTAssertEqual(false, verify(rollback: rollback, sql: "UPDATE BAR SET NUM = 0 WHERE NUM != 0 OR NUM IS NULL"), "updates should change hash")
                try XCTAssertEqual(!rollback, verify(rollback: rollback, sql: "UPDATE BAR SET NUM = 0"), "update with no changes should not change hash")
                if rollback {
                    try XCTAssertEqual(false, verify(rollback: rollback, sql: "UPDATE BAR SET NUM = NULL"), "div/0 should be NULL and thus unchanged")
                }
                try XCTAssertEqual(true, verify(minor: true, sql: "CREATE TABLE BAZ (ID INT)"), "schema additions should change hash")
                try XCTAssertEqual(true, verify(minor: true, sql: "ALTER TABLE BAZ ADD COLUMN DATA BLOB"), "column additions should change hash")
                try XCTAssertEqual(true, verify(rollback: rollback, sql: "INSERT INTO BAZ (ID, DATA) VALUES (10, x'010101')"), "insert should not change hash")
                try XCTAssertEqual(true, verify(minor: true, sql: "ALTER TABLE BAZ ADD COLUMN DBL REAL"), "alterations should not change hash for minor updates")
                try XCTAssertEqual(true, verify(rollback: rollback, sql: "INSERT INTO BAZ (ID, DATA, DBL) VALUES (10, x'0000', 1.2345)"), "insert should not change hash")
                try XCTAssertEqual(true, verify(rollback: rollback, sql: "UPDATE BAZ SET DATA = DATA"), "update with no alterations should not change hash")
                try XCTAssertEqual(false, verify(rollback: rollback, sql: "UPDATE BAZ SET DATA = DATA + DATA"), "alterations to data columns should change hash")
                try XCTAssertEqual(false, verify(rollback: rollback, sql: "UPDATE BAZ SET DBL = DBL + DBL"), "alterations to real columns should change hash")
                try XCTAssertEqual(false, verify(rollback: rollback, sql: "UPDATE BAZ SET ID = ID + ID"), "alterations to int columns should change hash")

                if rollback {
                    XCTAssertEqual("666cbb931dc99d8bfc4885b22727d2676921873a72a66d9f7935c44b65e36e78", try conn.query(sql: "SELECT * FROM FOO").digest().1.hex())
                    XCTAssertEqual("c2a0f7f8ea74a68b1dda49a4934572a4582872c2c8d343ca34541d761c0418b1", try conn.query(sql: "SELECT * FROM BAR").digest().1.hex())
                    XCTAssertEqual("8c88c27ecbd7b401a32026e13cc01052a6945512b76f62e86a25e983095bc99d", try conn.query(sql: "SELECT * FROM BAZ").digest().1.hex())
                } else {
                    XCTAssertEqual("666cbb931dc99d8bfc4885b22727d2676921873a72a66d9f7935c44b65e36e78", try conn.query(sql: "SELECT * FROM FOO").digest().1.hex())
                    XCTAssertEqual("951495cc2d873ea389e6c9e429d5a20045e04e5b251907947aab82f28d21bec3", try conn.query(sql: "SELECT * FROM BAR").digest().1.hex())
                    XCTAssertEqual("65dc5323321069b21129e8ee7a272ef671e8c126b84b9ab5eb408ca240d3f5b0", try conn.query(sql: "SELECT * FROM BAZ").digest().1.hex())
                }
            }
        }
    }
}
