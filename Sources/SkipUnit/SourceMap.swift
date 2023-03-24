// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
#if !SKIP
import Foundation

/// An abstraction of a source code location
protocol SourceCodeLocation {
    init(fileURL: URL, lineNumber: Int)
    var fileURL: URL { get }
    var lineNumber: Int { get }
}

extension SourceCodeLocation {
    /// Parses the `File.sourcemap` for this `File.kt` and tries to find the matching line in the decoded source map JSON file (emitted by the skip transpiler).
    func findSourceMapLine() throws -> Self? {
        // turn SourceFile.kt into SourceFile.sourcemap
        let path = fileURL.deletingPathExtension().appendingPathExtension("sourcemap")
        guard FileManager.default.isReadableFile(atPath: path.path) else {
            return nil
        }

        let sourceMap = try JSONDecoder().decode(SourceMap.self, from: Data(contentsOf: path))
        var lineRanges: [ClosedRange<Int>: Self] = [:]

        for entry in sourceMap.entries {
            if let sourceRange = entry.sourceRange {
                let sourceLines = entry.range.start.line...entry.range.end.line
                if sourceLines.contains(self.lineNumber) {
                    let sourceFile = URL(fileURLWithPath: entry.sourceFile.path)
                    // remember all the matched ranges because we'll want to use the smallest possible match the get the best estimate of the corresponding source line number
                    lineRanges[sourceLines] = Self(fileURL: sourceFile, lineNumber: sourceRange.start.line)
                }
            }
        }

        // find the narrowest range that includes the source line
        let minKeyValue = lineRanges.min(by: {
            $0.key.count < $1.key.count
        })

        return minKeyValue?.value
    }
}

/// A decoded source map. This is the decodable counterpart to `SkipSyntax.OutputMap`
struct SourceMap : Decodable {
    let entries: [Entry]

    struct Entry : Decodable {
        let sourceFile: Source.FilePath
        let sourceRange: Source.Range?
        let range: Source.Range
    }

    struct Source {
        struct SourceLine : Decodable {
            let offset: Int
            let line: String
        }

        /// A Swift source file.
        struct FilePath: Hashable, Decodable {
            let path: String
        }

        /// A line and column-based range in the source, appropriate for Xcode reporting.
        struct Range: Equatable, Decodable {
            let start: Position
            let end: Position
        }

        /// A line and column-based position in the source, appropriate for Xcode reporting.
        /// Line and column numbers start with 1 rather than 0.
        struct Position: Equatable, Comparable, Decodable {
            let line: Int
            let column: Int

            init(line: Int, column: Int) {
                self.line = line
                self.column = column
            }

            static func < (lhs: Position, rhs: Position) -> Bool {
                return lhs.line < rhs.line || (lhs.line == rhs.line && lhs.column < rhs.column)
            }
        }
    }
}
#endif
