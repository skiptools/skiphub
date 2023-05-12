// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
import SkipFoundation

#if SKIP
#else
#if os(Linux)
import CSQLite
#else
import SQLite3
#endif
#endif

#if !SKIP
import CryptoKit
#endif

// SKIP INSERT: import android.database.sqlite.SQLiteDatabase
// SKIP INSERT: import android.database.*
// SKIP INSERT: import android.database.sqlite.*

/// A connection to SQLite.
public final class SQLDB {
    #if SKIP
    public let db: SQLiteDatabase
    #else
    public typealias Handle = OpaquePointer
    fileprivate var _handle: Handle?
    public var handle: Handle { _handle! }
    #endif

    /// Whether the connection to the database is closed or not
    public private(set) var closed = false

    /// Creates a connection from the given URL
    public static func open(url: URL, readonly: Bool = false) throws -> SQLDB {
        try SQLDB(url.path, readonly: readonly)
    }

    public init(_ filename: String = ":memory:", readonly: Bool = false) throws {
        #if SKIP
        // self.db = SQLiteDatabase.openDatabase(filename, nil, readonly ? SQLiteDatabase.OPEN_READONLY : (SQLiteDatabase.CREATE_IF_NECESSARY | SQLiteDatabase.OPEN_READWRITE))
        self.db = SQLiteDatabase.openDatabase(filename, nil, SQLiteDatabase.CREATE_IF_NECESSARY)
        #else
        let flags = readonly ? SQLITE_OPEN_READONLY : (SQLITE_OPEN_CREATE | SQLITE_OPEN_READWRITE)
        try check(resultOf: sqlite3_open_v2(filename, &_handle, flags | SQLITE_OPEN_FULLMUTEX | SQLITE_OPEN_URI, nil))
        #endif
    }

    // FIXME: no deinit support in Kotlin (“Unknown declaration (failed to translate SwiftSyntax node).”)
    #if SKIP

    #else
    deinit {
        close()
    }
    #endif

    /// Closes the connection to the database
    func close() {
        if !closed {
            #if SKIP
            self.db.close()
            #else
            sqlite3_close(handle)
            #endif
            closed = true
        }
    }

    /// Executes a single SQL statement.
    public func execute(sql: any StringProtocol, params: [SQLValue] = []) throws {
        #if SKIP
        let bindArgs = params.map { $0.toBindArg() }
        db.execSQL(sql.toString(), bindArgs.toList().toTypedArray())
        #else
        if params.isEmpty {
            // no-param single-shot exec convenience
            try check(resultOf: sqlite3_exec(handle, sql.description, nil, nil, nil))
        } else {
            _ = try Cursor(self, sql, params: params).nextRow(close: true)
        }
        #endif
    }

    #if SKIP

    #else
    @discardableResult fileprivate func check(resultOf resultCode: Int32) throws -> Int32 {
        let successCodes: Set = [SQLITE_OK, SQLITE_ROW, SQLITE_DONE]
        if !successCodes.contains(resultCode) {
            let message = String(cString: sqlite3_errmsg(self.handle))
            struct SQLError : Error {
                let message: String
            }
            throw SQLError(message: message)
        }

        return resultCode
    }
    #endif

    /// Executes the given query with the specified parameters.
    public func query(sql: String, params: [SQLValue] = []) throws -> Cursor {
        try Cursor(self, sql, params: params)
    }

    #if SKIP

    #else
    /// Binds the given parameter at the given index.
    /// - Parameters:
    ///   - handle: the statement handle to bind to
    ///   - parameter: the parameter value to bind
    ///   - index: the index of the matching '?' parameter, which starts at 1
    fileprivate func bind(handle: Cursor.Handle?, parameter: SQLValue, index: Int32) throws {
        switch parameter {
        case .nul:
            try self.check(resultOf: sqlite3_bind_null(handle, index))
        case let .text(string: string):
            try self.check(resultOf: sqlite3_bind_text(handle, index, string, -1, SQLITE_TRANSIENT))
        case let .integer(int: num):
            try self.check(resultOf: sqlite3_bind_int64(handle, index, num))
        case let .float(double: dbl):
            try self.check(resultOf: sqlite3_bind_double(handle, index, dbl))
        case let .blob(data: bytes) where bytes.isEmpty:
            try self.check(resultOf: sqlite3_bind_zeroblob(handle, index, 0))
        case let .blob(data: bytes):
            _ = try bytes.withUnsafeBytes { ptr in
                try self.check(resultOf: sqlite3_bind_blob(handle, index, ptr.baseAddress.unsafelyUnwrapped, Int32(bytes.count), SQLITE_TRANSIENT))
            }
       }
    }
    #endif

    /// A cursor to the open result set returned by `SQLDB.query`.
    public final class Cursor {
        fileprivate let connection: SQLDB

        #if SKIP
        fileprivate var cursor: android.database.Cursor
        #else
        typealias Handle = OpaquePointer
        fileprivate var handle: Handle?
        #endif

        /// Whether the cursor is closed or not
        public private(set) var closed = false

        fileprivate init(_ connection: SQLDB, _ SQL: any StringProtocol, params: [SQLValue]) throws {
            self.connection = connection

            #if SKIP
            let bindArgs: [String?] = params.map { $0.toBindString() }
            self.cursor = connection.db.rawQuery(SQL.toString(), bindArgs.toList().toTypedArray())
            #else
            try connection.check(resultOf: sqlite3_prepare_v2(connection.handle, SQL.description, -1, &handle, nil))
            for (index, param) in params.enumerated() {
                try connection.bind(handle: self.handle, parameter: param, index: .init(index + 1))
            }
            #endif
        }

        public var columnCount: Int32 {
            if closed { return 0 }
            #if SKIP
            return self.cursor.getColumnCount()
            #else
            return sqlite3_column_count(handle)
            #endif
        }


        /// Moves to the next row in the result set, returning `false` if there are no more rows to traverse.
        public func next() throws -> Bool {
            if closed {
                throw CursorClosedError()
            }
            #if SKIP
            return self.cursor.moveToNext()
            #else
            return try connection.check(resultOf: sqlite3_step(handle)) == SQLITE_ROW
            #endif
        }

        /// Generates a SHA-256 hash by iterating over the remaining rows and updating a hash of each string value of the columns in order.
        ///
        /// The exact algorithm is to iterate through the remaining rows in the Cursor, then output a series of tab-delimited pair of count\tvalue for each column.
        @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
        public func resultHash(algorithm: any HashFunction = SHA256()) throws -> Data {
            var hash = algorithm
            let columns = columnCount

            let tab = "\t".data(using: String.Encoding.utf8)!
            let nl = "\n".data(using: String.Encoding.utf8)!

            while try next() {
                for i in 0..<columns {
                    let columnData = try getString(column: i)?.data(using: String.Encoding.utf8) ?? Data()

                    // we always prefix the column's hash in order to ensure that overlapping values (e.g., COL1="ABC"+COL2="DEF" == COL1="A"+COL2="BCDEF")
                    let valueLength = "\(columnData.count)".data(using: String.Encoding.utf8) ?? Data()
                    hash.update(data: valueLength)
                    hash.update(data: tab) // length-value separated by tabs
                    hash.update(data: columnData) // then add the data itself

                    if i == columns - 1 {
                        hash.update(data: nl) // lines end in a newline
                    } else {
                        hash.update(data: tab) // length-value separated by tabs
                    }
                }
            }
            try close()
            return Data(hash.finalize())
        }

        /// Returns the name of the column at the given zero-based index.
        public func getColumnName(column: Int32) throws -> String {
            if closed {
                throw CursorClosedError()
            }
            #if SKIP
            return self.cursor.getColumnName(column)
            #else
            return String(cString: sqlite3_column_name(handle, column))
            #endif
        }

        public func getColumnType(column: Int32) throws -> ColumnType {
            if closed {
                throw CursorClosedError()
            }

            //return ColumnType(rawValue: getTypeConstant(column: column))

            switch try getTypeConstant(column: column) {
            case ColumnType.nul.rawValue:
                return .nul
            case ColumnType.integer.rawValue:
                return .integer
            case ColumnType.float.rawValue:
                return .float
            case ColumnType.text.rawValue:
                return .text
            case ColumnType.blob.rawValue:
                return .blob
            //case let type: // “error: Unsupported switch case item (failed to translate SwiftSyntax node)”
            default:
                return .nul
                //fatalError("unsupported column type")
            }
        }

        /// Returns the value contained in the given column, coerced to the expected type based on the column definition.
        public func getValue(column: Int32) throws -> SQLValue {
            if closed {
                throw CursorClosedError()
            }
            switch try getColumnType(column: column) {
            case .nul:
                return .nul
            case .text:
                guard let str = try getString(column: column) else {
                    return .nul
                }
                return .text(str)
            case .integer:
                return .integer(try getInt64(column: column))
            case .float:
                return .float(try getDouble(column: column))
            case .blob:
                return .nul // .blob(data: getBlob(column: column)) // TODO: SKIP
            }
        }

        /// Returns the values of the current row as an array
        public func getRow() throws -> [SQLValue] {
            return try Array((0..<columnCount).map { column in
                try getValue(column: column)
            })
        }

        /// Returns a JSON array by converting the current row into JSON values
        public func getJSON() throws -> JSON {
            try JSON.array(getRow().map({ $0.toJSON() }))
        }

        /// Returns a textual description of the row's values in a format suitable for printing to a console
        public func rowText(header: Bool = false, values: Bool = false, width: Int = 80) throws -> String {
            var str = ""
            let sep = header == false && values == false ? "+" : "|"
            str += sep
            let count: Int = Int(columnCount)
            var cellSpan: Int = (width / count) - 2
            if cellSpan < 0 {
                cellSpan = 0
                cellSpan = 0
            }

            for col in 0..<count {
                let i = Int32(col)
                let cell: String
                if header {
                    cell = try getColumnName(column: i)
                } else if values {
                    cell = try getValue(column: i).toBindString() ?? ""
                } else {
                    cell = ""
                }

                let numeric = header || values ? try getColumnType(column: i).isNumeric : false
                let padding = header || values ? " " : "-"
                str += padding
                str += cell.pad(to: cellSpan - 2, with: padding, rightAlign: numeric)
                str += padding
                if col < count - 1 {
                    str += sep
                }
            }
            str += sep
            return str
        }

        /// Returns a single value from the query, closing the result set afterwards
        public func singleValue() throws -> SQLValue? {
            try nextRow(close: true)?.first
        }

        /// Steps to the next row and returns all the values in the row.
        /// - Parameter close: if true, closes the cursor after returning the values; this can be useful for single-shot execution of queries where only one row is expected.
        /// - Returns: an array of ``SQLValue`` containing the row contents.
       public func nextRow(close: Bool = false) throws -> [SQLValue]? {
           do {
               if try next() == false {
                   try self.close()
                   return nil
               } else {
                   let values = try getRow()
                   if close {
                       try self.close()
                   }
                   return values
               }
           } catch let error {
               try? self.close()
               throw error
           }
        }

        public func rows(count: Int = Int.max) throws -> [[SQLValue]] {
            if closed {
                throw CursorClosedError()
            }
            var values: [[SQLValue]] = []
            for _ in 1...count {
                if let row = try nextRow() {
                    values.append(row)
                } else {
                    break
                }
            }
            return values
        }

        public func getDouble(column: Int32) throws -> Double {
            if closed {
                throw CursorClosedError()
            }
            #if SKIP
            return self.cursor.getDouble(column)
            #else
            return sqlite3_column_double(handle, column)
            #endif
        }

        public func getInt64(column: Int32) throws -> Int64 {
            if closed {
                throw CursorClosedError()
            }
            #if SKIP
            return self.cursor.getLong(column)
            #else
            return sqlite3_column_int64(handle, column)
            #endif
        }

        public func getString(column: Int32) throws -> String? {
            if closed {
                throw CursorClosedError()
            }
            #if SKIP
            return self.cursor.getString(column)
            #else
            guard let text = sqlite3_column_text(handle, Int32(column)) else {
                return nil
            }
            return String(cString: UnsafePointer(text))
            #endif
        }

        public func getBlob(column: Int32) throws -> Data {
            if closed {
                throw CursorClosedError()
            }
            #if SKIP
            return Data(self.cursor.getBlob(column))
            #else
            if let pointer = sqlite3_column_blob(handle, Int32(column)) {
                let length = Int(sqlite3_column_bytes(handle, Int32(column)))
                //let ptr = UnsafeBufferPointer(start: pointer.assumingMemoryBound(to: Int8.self), count: length)
                return Data(bytes: pointer, count: length)
            } else {
                // The return value from sqlite3_column_blob() for a zero-length BLOB is a NULL pointer.
                return Data()
            }
            #endif
        }

        private func getTypeConstant(column: Int32) throws -> Int32 {
            if closed {
                throw CursorClosedError()
            }
            #if SKIP
            return self.cursor.getType(column)
            #else
            return sqlite3_column_type(handle, column)
            #endif
        }

        func close() throws {
            if !closed {
                #if SKIP
                self.cursor.close()
                #else
                try connection.check(resultOf: sqlite3_finalize(handle))
                #endif
            }
            closed = true
        }

        #if SKIP
        // TODO: finalize { close() }
        #else
        deinit {
            try? close()
        }
        #endif
    }

}

struct CursorClosedError : Error {
    let errorDescription: String?

    init(errorDescription: String = "Cursor closed") {
        self.errorDescription = errorDescription
    }
}

#if !SKIP
// let SQLITE_STATIC = unsafeBitCast(0, sqlite3_destructor_type.self)
let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
#endif

public enum SQLValue {
    case nul
    case text(_ string: String)
    case integer(_ int: Int64)
    case float(_ double: Double)
    case blob(_ data: Data)

    var columnType: ColumnType {
        switch self {
        case SQLValue.nul:
            return ColumnType.nul
        case SQLValue.text:
            return ColumnType.text
        case SQLValue.integer:
            return ColumnType.integer
        case SQLValue.float:
            return ColumnType.float
        case SQLValue.blob:
            return ColumnType.blob
        }
    }

    func toBindArg() -> Any? {
        switch self {
        case SQLValue.nul:
            return nil
        case let SQLValue.text(str):
            return str
        case let SQLValue.integer(num):
            return num
        case let SQLValue.float(dbl):
            return dbl
        case let SQLValue.blob(bytes):
            return bytes
        }
    }

    /// Convert this SQLValue into a JSON for serialization
    func toJSON() -> JSON {
        switch self {
        case SQLValue.nul:
            return JSON.null
        case let SQLValue.text(str):
            return JSON.string(str)
        case let SQLValue.integer(num):
            return JSON.number(Double(num))
        case let SQLValue.float(dbl):
            return JSON.number(dbl)
        case let SQLValue.blob(bytes):
            return JSON.string(bytes.base64EncodedString())
        }
    }

    func toBindString() -> String? {
        switch self {
        case SQLValue.nul:
            return nil
        case let SQLValue.text(str):
            return str
        case let SQLValue.integer(num):
            return num.description
        case let SQLValue.float(dbl):
            return dbl.description
        case SQLValue.blob:
            return nil // bytes.description // mis-transpiles
        }
    }

    /// If this is a `text` value, then return the underlying string
    var textValue: String? {
        switch self {
        case let SQLValue.text(str): return str
        default: return nil
        }
    }

    /// If this is a `integer` value, then return the underlying integer
    var integerValue: Int64? {
        switch self {
        case let SQLValue.integer(num): return num
        default: return nil
        }
    }

    /// If this is a `float` value, then return the underlying double
    var floatValue: Double? {
        switch self {
        case let SQLValue.float(dbl): return dbl
        default: return nil
        }
    }

    /// If this is a `blob` value, then return the underlying data
    var blobValue: Data? {
        switch self {
        case SQLValue.blob(let dat): return dat
        default: return nil
        }
    }

}

/// The type of a SQLite colums.
///
/// Every value in SQLite has one of five fundamental datatypes:
///  - 64-bit signed integer
///  - 64-bit IEEE floating point number
///  - string
///  - BLOB
///  - NULL
///  
// FIXME: workaround “Enum class cannot inherit from classes” when it inserts Hashable extension
// SKIP REPLACE: enum class ColumnType(val rawValue: Int) { nul(0), integer(1), float(2), text(3), blob(4); }
public enum ColumnType : Int32 {
    /// `SQLITE_NULL`
    case nul = 0
    /// `SQLITE_INTEGER`, a 64-bit signed integer
    case integer = 1
    /// `SQLITE_FLOAT`, a 64-bit IEEE floating point number
    case float = 2
    /// `SQLITE_TEXT`, a string
    case text = 3
    /// `SQLITE_BLOB`, a byte array
    case blob = 4
}

extension ColumnType {
    /// Returns true if this column is expected to hold a numeric type.
    var isNumeric: Bool {
        switch self {
        case .integer: return true
        case .float: return true
        default: return false
        }
    }
}


extension String {
    func pad(to width: Int, with padding: String, rightAlign: Bool) -> String {
        var str = self
        while str.count < width {
            str = (rightAlign ? padding : "") + str + (!rightAlign ? padding : "")
        }
        if str.count > width {
            #if SKIP
            str = str.dropLast(width - str.count)
            #else
            str.removeLast(width - str.count)
            #endif
        }
        return str
    }
}
