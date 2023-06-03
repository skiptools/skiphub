// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
#if !SKIP
import class Foundation.URLSession
public typealias URLSession = Foundation.URLSession
internal typealias PlatformURLSession = Foundation.URLSession
//public typealias PlatformAsyncSequence<T> = _Concurrency.AsyncSequence<T>
#else
public typealias URLSession = SkipURLSession
//public typealias PlatformURLSession = java.util.URLSession
public typealias PlatformAsyncSequence<T> = kotlinx.coroutines.flow.Flow<T>
#endif

@available(macOS 11, iOS 14, tvOS 14, watchOS 7, *)
fileprivate let logger: Logger = Logger(subsystem: "skip", category: "SkipURLSession")

// override the Kotlin type to be public while keeping the Swift version internal:
// SKIP DECLARE: class SkipURLSession
@available(macOS 13, iOS 16, tvOS 16, watchOS 9, *)
internal class SkipURLSession {
    #if !SKIP
    public let rawValue: PlatformURLSession

    public init(rawValue: PlatformURLSession) {
        self.rawValue = rawValue
    }
    #else
    private static let _shared = SkipURLSession(configuration: SkipURLSessionConfiguration.default)

    public var configuration: SkipURLSessionConfiguration
    #endif

    public init(configuration: SkipURLSessionConfiguration) {
        #if !SKIP
        self.rawValue = PlatformURLSession(configuration: configuration.rawValue)
        #else
        self.configuration = configuration
        #endif
    }

    public static var shared: SkipURLSession {
        #if !SKIP
        return SkipURLSession(rawValue: PlatformURLSession.shared)
        #else
        return _shared
        #endif
    }

    #if SKIP
    private func openConnection(request: SkipURLRequest) -> java.net.URLConnection {
        let config = self.configuration
        guard let url = request.url else {
            throw NoURLInRequestError()
        }

        // not that `openConnection` does not actually connect(); we do that below in a Dispatchers.IO coroutine
        let connection = url.rawValue.openConnection()

        switch request.cachePolicy {
        case .useProtocolCachePolicy:
            connection.setUseCaches(true)
        case .returnCacheDataElseLoad:
            connection.setUseCaches(true)
        case .returnCacheDataDontLoad:
            connection.setUseCaches(true)
        case .reloadRevalidatingCacheData:
            connection.setUseCaches(true)
        case .reloadIgnoringLocalCacheData:
            connection.setUseCaches(false)
        case .reloadIgnoringLocalAndRemoteCacheData:
            connection.setUseCaches(false)
        }

        //connection.setDoInput(true)
        //connection.setDoOutput(true)

        if let httpConnection = connection as? java.net.HttpURLConnection {
            if let httpMethod = request.httpMethod {
                httpConnection.setRequestMethod(httpMethod)
            }

            httpConnection.connectTimeout = request.timeoutInterval > 0 ? request.timeoutInterval.toInt() : config.timeoutIntervalForRequest.toInt()
            httpConnection.readTimeout = config.timeoutIntervalForResource.toInt()
        }

        for (headerKey, headerValue) in request.allHTTPHeaderFields ?? [:] {
            connection.setRequestProperty(headerKey, headerValue)
        }

        return connection
    }

    private func connect(request: SkipURLRequest) -> (java.net.URLConnection, HTTPURLResponse) {
        let connection = try openConnection(request: request)

        var statusCode = -1
        if let httpConnection = connection as? java.net.HttpURLConnection {
            statusCode = httpConnection.getResponseCode()
        }

        let headerFields = connection.getHeaderFields()

        let httpVersion: String? = nil // TODO: extract version from response
        var headers: [String: String] = [:]
        for (key, values) in headerFields {
            if let key = key, let values = values {
                for value in values {
                    if let value = value {
                        headers[key] = value
                    }
                }
            }
        }

        let response = HTTPURLResponse(url: request.url!, statusCode: statusCode, httpVersion: httpVersion, headerFields: headers)
        return (connection, response!)
    }
    #endif

    public func data(for request: SkipURLRequest) async throws -> (SkipData, SkipURLResponse) {
        #if !SKIP
        let (data, response) = try await rawValue.data(for: request.rawValue)
        let result = (SkipData(rawValue: data), SkipURLResponse(rawValue: response))
        return result
        #else
        let (data, response) = kotlinx.coroutines.withContext(kotlinx.coroutines.Dispatchers.IO) {
            let (connection, response) = try connect(request: request)
            let inputStream = connection.getInputStream()
            let outputStream = java.io.ByteArrayOutputStream()
            let buffer = ByteArray(1024)
            var bytesRead: Int
            while (inputStream.read(buffer).also { bytesRead = $0 } != -1) {
                outputStream.write(buffer, 0, bytesRead)
            }
            inputStream.close()

            let bytes = outputStream.toByteArray()
            return (data: SkipData(rawValue: bytes), response: response as HTTPURLResponse)
        }

        return (data, response)
        #endif
    }

    public func data(from url: SkipURL) async throws -> (SkipData, SkipURLResponse) {
        #if !SKIP
        let (data, response) = try await rawValue.data(from: url.rawValue)
        let result = (SkipData(rawValue: data), SkipURLResponse(rawValue: response))
        return result
        #else
        return self.data(for: SkipURLRequest(url: url))
        #endif
    }

    public func download(for request: SkipURLRequest) async throws -> (SkipURL, SkipURLResponse) {
        #if !SKIP
        let (localURL, response) = try await rawValue.download(for: request.rawValue)
        let result = (SkipURL(rawValue: localURL), SkipURLResponse(rawValue: response))
        return result
        #else
        // WARNING: this is untested, since Robolectric's ShadowDownloadManager is a stub
        guard let url = request.url else {
            throw NoURLInRequestError()
        }

        // seems to be the typical way of converting from java.net.URL into android.net.Uri (which is needed by the DownloadManager)
        let uri = android.net.Uri.parse(url.description)

        let downloadManager = ProcessInfo.processInfo.androidContext.getSystemService(android.content.Context.DOWNLOAD_SERVICE) as android.app.DownloadManager

        let downloadRequest = android.app.DownloadManager.Request(uri)
            .setAllowedOverMetered(self.configuration.allowsExpensiveNetworkAccess)
            .setAllowedOverRoaming(self.configuration.allowsConstrainedNetworkAccess)
            .setShowRunningNotification(true)

        for (headerKey, headerValue) in request.allHTTPHeaderFields ?? [:] {
            downloadRequest.addRequestHeader(headerKey, headerValue)
        }

        let downloadId = downloadManager.enqueue(downloadRequest)
        let query = android.app.DownloadManager.Query()
            .setFilterById(downloadId)

        /// Query the DownloadManager for the response, which returns a SQLite cursor with the current download status of all the outstanding downloads.
        func queryDownload() -> Result<(SkipURL, SkipURLResponse), Error>? {
            let cursor = downloadManager.query(query)

            defer { cursor.close() }

            if !cursor.moveToFirst() {
                // download not found
                let error = UnableToStartDownload()
                return Result.failure(error)
            }

            let status = cursor.getInt(cursor.getColumnIndexOrThrow(android.app.DownloadManager.COLUMN_STATUS))
            let uri = cursor.getString(cursor.getColumnIndexOrThrow(android.app.DownloadManager.COLUMN_URI)) // URI to be downloaded.

            // STATUS_FAILED, STATUS_PAUSED, STATUS_PENDING, STATUS_RUNNING, STATUS_SUCCESSFUL
            if status == android.app.DownloadManager.STATUS_PAUSED {
                return nil
            }
            if status == android.app.DownloadManager.STATUS_PENDING {
                return nil
            }

            //let desc = cursor.getString(cursor.getColumnIndexOrThrow(android.app.DownloadManager.COLUMN_DESCRIPTION)) // The client-supplied description of this download // NPE
            //let id = cursor.getString(cursor.getColumnIndexOrThrow(android.app.DownloadManager.COLUMN_ID)) // An identifier for a particular download, unique across the system. // NPE
            // let lastModified = cursor.getLong(cursor.getColumnIndexOrThrow(android.app.DownloadManager.COLUMN_LAST_MODIFIED_TIMESTAMP)) // Timestamp when the download was last modified, in System.currentTimeMillis() (wall clock time in UTC).
            let localFilename = cursor.getString(cursor.getColumnIndexOrThrow(android.app.DownloadManager.COLUMN_LOCAL_FILENAME)) // Path to the downloaded file on disk.
            //let localURI = cursor.getString(cursor.getColumnIndexOrThrow(android.app.DownloadManager.COLUMN_LOCAL_URI)) // Uri where downloaded file will be stored. // NPE
            // let mediaproviderURI = cursor.getString(cursor.getColumnIndexOrThrow(android.app.DownloadManager.COLUMN_MEDIAPROVIDER_URI)) // The URI to the corresponding entry in MediaProvider for this downloaded entry. // NPE
            //let mediaType = cursor.getString(cursor.getColumnIndexOrThrow(android.app.DownloadManager.COLUMN_MEDIA_TYPE)) // Internet Media Type of the downloaded file.
            let reason = cursor.getString(cursor.getColumnIndexOrThrow(android.app.DownloadManager.COLUMN_REASON)) // Provides more detail on the status of the download.
            //let title = cursor.getString(cursor.getColumnIndexOrThrow(android.app.DownloadManager.COLUMN_TITLE)) // The client-supplied title for this download.
            let totalSizeBytes = cursor.getLong(cursor.getColumnIndexOrThrow(android.app.DownloadManager.COLUMN_TOTAL_SIZE_BYTES)) // Total size of the download in bytes.
            let bytesDownloaded = cursor.getLong(cursor.getColumnIndexOrThrow(android.app.DownloadManager.COLUMN_BYTES_DOWNLOADED_SO_FAR)) // Number of bytes download so far.

            if status == android.app.DownloadManager.STATUS_RUNNING {
                // TODO: update progress
//                if let progress = Progress.current() {
//                }
                return nil
            } else if status == android.app.DownloadManager.STATUS_SUCCESSFUL {
                let httpVersion: String? = nil // TODO: extract version from response
                var headers: [String: String] = [:]
                let statusCode = 200 // TODO: extract status code
                headers["Content-Length"] = totalSizeBytes?.description
                //headers["Last-Modified"] = lastModified // TODO: convert to Date
                let response = HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: httpVersion, headerFields: headers)
                let localURL = SkipURL(fileURLWithPath: localFilename)
                return Result.success((localURL as SkipURL, response as SkipURLResponse))
            } else if status == android.app.DownloadManager.STATUS_FAILED {
                // File download failed
                // TODO: create error from error
                let error = FailedToDownloadURLError()
                return Result.failure(error)
            } else {
                // no known android.app.DownloadManager.STATUS_*
                // this can happen with Robolectric tests, since ShadowDownloadManager is just a stub and it sets 0 for the status
                let error = DownloadUnsupportedWithRobolectric(status: status)
                return Result.failure(error)
            }

            return nil
        }

        let isRobolectric = (try? Class.forName("org.robolectric.Robolectric")) != nil

        let response: Result<(SkipURL, SkipURLResponse), Error> = kotlinx.coroutines.withContext(kotlinx.coroutines.Dispatchers.IO) {
            if isRobolectric {
                // Robolectric's ShadowDownloadManager doesn't actually download anything, so we fake it for testing by just getting the data in-memory (hoping it isn't too large!) and saving it to a temporary file
                do {
                    let (data, response) = try await data(for: request)
                    let outputFileURL: SkipURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
                    try data.write(to: outputFileURL)
                    return Result.success((outputFileURL, response))
                } catch {
                    return Result.failure(error)
                }
            } else {
                // initiate using android.app.DownloadManager
                // TODO: rather than polling in a loop, we could do android.registerBroadcastReceiver(android.app.DownloadManager.ACTION_DOWNLOAD_COMPLETE, handleDownloadEvent)
                while true {
                    if let downloadResult = queryDownload() {
                        return downloadResult
                    }
                    kotlinx.coroutines.delay(250) // wait and poll again
                }
            }
            return Result.failure(FailedToDownloadURLError()) // needed for Kotlin type checking
        }

        switch response {
        case .failure(let error): throw error
        case .success(let urlResponseTuple): return urlResponseTuple
        }

        #endif
    }

    public func download(from url: SkipURL) async throws -> (SkipURL, SkipURLResponse) {
        #if !SKIP
        let (localURL, response) = try await rawValue.download(from: url.rawValue)
        let result = (SkipURL(rawValue: localURL), SkipURLResponse(rawValue: response))
        return result
        #else
        return self.download(for: SkipURLRequest(url: url))
        #endif
    }

    public func upload(for request: SkipURLRequest, fromFile fileURL: SkipURL) async throws -> (SkipData, SkipURLResponse) {
        #if !SKIP
        let (data, response) = try await rawValue.upload(for: request.rawValue, fromFile: fileURL.rawValue)
        let result = (SkipData(rawValue: data), SkipURLResponse(rawValue: response))
        return result
        #else
        fatalError("TODO: SkipURLSession.data")
        #endif
    }

    public func upload(for request: SkipURLRequest, from bodyData: SkipData) async throws -> (SkipData, SkipURLResponse) {
        #if !SKIP
        let (data, response) = try await rawValue.upload(for: request.rawValue, from: bodyData.rawValue)
        let result = (SkipData(rawValue: data), SkipURLResponse(rawValue: response))
        return result
        #else
        fatalError("TODO: SkipURLSession.data")
        #endif
    }

    public func bytes(from url: SkipURL) async throws -> (SkipURLSessionAsyncBytes, SkipURLResponse) {
        #if !SKIP
        let (bytes, response) = try await rawValue.bytes(from: url.rawValue)
        fatalError("TODO: non-Skip bytes(from:")
        //let result = (SkipURLSessionAsyncBytes(stream: bytes), SkipURLResponse(rawValue: response))
        //return result
        #else
        return bytes(for: SkipURLRequest(url: url))
        #endif
    }

    public func bytes(for request: SkipURLRequest) async throws -> (SkipURLSessionAsyncBytes, SkipURLResponse) {
        #if !SKIP
        let (stream, response) = try await rawValue.bytes(for: request.rawValue)
        fatalError("TODO: non-Skip bytes(from:")
        //let result = (SkipURLSessionAsyncBytes(byteStream: stream), SkipURLResponse(rawValue: response))
        //return result
        #else
        return kotlinx.coroutines.withContext(kotlinx.coroutines.Dispatchers.IO) {
            let (connection, response) = try connect(request: request)
            let stream: kotlinx.coroutines.flow.Flow<UByte> = kotlinx.coroutines.flow.flow {
                connection.getInputStream().use { inputStream in
                    while true {
                        let byte = inputStream.read()
                        if byte == -1 {
                            break
                        } else {
                            emit(byte.toUByte())
                        }
                    }
                }
            }

            return (SkipURLSessionAsyncBytes(stream: stream), response)
        }
        #endif
    }

    public enum DelayedRequestDisposition : Int, @unchecked Sendable {
        case continueLoading = 0
        case useNewRequest = 1
        case cancel = 2
    }

    public enum AuthChallengeDisposition : Int, @unchecked Sendable {
        case useCredential = 0
        case performDefaultHandling = 1
        case cancelAuthenticationChallenge = 2
        case rejectProtectionSpace = 3
    }

    public enum ResponseDisposition : Int, @unchecked Sendable {
        case cancel = 0
        case allow = 1
        case becomeDownload = 2
        case becomeStream = 3
    }
}

#if SKIP
public protocol URLSessionTask {
}

public protocol URLSessionDataTask : URLSessionTask {
}

public protocol URLSessionDelegate {
}

public protocol URLSessionTaskDelegate : URLSessionDelegate {
}

public protocol URLSessionDataDelegate : URLSessionTaskDelegate {
}

public struct NoURLInRequestError : Error {
}

public struct FailedToDownloadURLError : Error {
}

public struct UnableToStartDownload : Error {
}

public struct DownloadUnsupportedWithRobolectric : Error {
    let status: Int
}

#endif

#if !SKIP
public typealias PlatformAsyncStream<Element> = AsyncStream<Element>
#else
public typealias PlatformAsyncStream<Element> = kotlinx.coroutines.flow.Flow<Element>
#endif

/// A type that provides asynchronous, sequential, iterated access to its elements.
public protocol SkipAsyncSequence {
    associatedtype Element

    /// The underlying `AsyncStream` or `kotlinx.coroutines.flow.Flow` for this element
    var stream: PlatformAsyncStream<Element> { get }
}

public extension SkipAsyncSequence {

    // Skip FIXME: Cannot declare both forms of `reduce` due to JVM signature clash:
    // The following declarations have the same JVM signature (reduce(Ljava/lang/Object;Lkotlin/jvm/functions/Function2;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;):
    //func reduce<Result>(_ initialResult: Result, _ nextPartialResult: (_ partialResult: Result, Element) async throws -> Result) async rethrows -> Result {
    //    fatalError("TODO: SkipAsyncSequence extension functions")
    //}

    func reduce<Result>(into initialResult: Result, _ updateAccumulatingResult: (_ partialResult: inout Result, Element) async throws -> Void) async rethrows -> Result {
        #if !SKIP
        return try await stream.reduce(into: initialResult, updateAccumulatingResult)
        #else
        var result = initialResult
        stream.collect { element in
            updateAccumulatingResult(result, element)
        }
        return result
        #endif
    }

    func contains(where predicate: (Element) async throws -> Bool) async rethrows -> Bool {
        fatalError("TODO: SkipAsyncSequence extension functions")
    }

    func allSatisfy(_ predicate: (Element) async throws -> Bool) async rethrows -> Bool {
        fatalError("TODO: SkipAsyncSequence extension functions")
    }

    func contains(_ search: Element) async -> Bool {
        fatalError("TODO: SkipAsyncSequence extension functions")
    }

    func first(where predicate: (Element) async throws -> Bool) async rethrows -> Element? {
        fatalError("TODO: SkipAsyncSequence extension functions")
    }

    func min(by areInIncreasingOrder: (Element, Element) async throws -> Bool) async rethrows -> Element? {
        fatalError("TODO: SkipAsyncSequence extension functions")
    }

    func max(by areInIncreasingOrder: (Element, Element) async throws -> Bool) async rethrows -> Element? {
        fatalError("TODO: SkipAsyncSequence extension functions")
    }

    func min() async -> Element? {
        fatalError("TODO: SkipAsyncSequence extension functions")
    }

    func max() async -> Element? {
        fatalError("TODO: SkipAsyncSequence extension functions")
    }

    #if !SKIP // references to Self not allowed
    func compactMap<ElementOfResult>(_ transform: @escaping @Sendable (Element) async -> ElementOfResult?) -> AsyncCompactMapSequence<Self, ElementOfResult> {
        fatalError("TODO: SkipAsyncSequence extension functions")
    }

    func dropFirst(_ count: Int = 1) -> SkipAsyncDropFirstSequence<Self> {
        fatalError("TODO: SkipAsyncSequence extension functions")
    }

    func drop(while predicate: @escaping @Sendable (Element) async -> Bool) -> SkipAsyncDropWhileSequence<Self> {
        fatalError("TODO: SkipAsyncSequence extension functions")
    }

    func filter(_ isIncluded: @escaping @Sendable (Element) async -> Bool) -> SkipAsyncFilterSequence<Self> {
        fatalError("TODO: SkipAsyncSequence extension functions")
    }

    func flatMap<SegmentOfResult>(_ transform: @escaping @Sendable (Element) async -> SegmentOfResult) -> SkipAsyncFlatMapSequence<Self, SegmentOfResult> where SegmentOfResult : AsyncSequence {
        fatalError("TODO: SkipAsyncSequence extension functions")
    }

    func map<Transformed>(_ transform: @escaping @Sendable (Element) async -> Transformed) -> SkipAsyncMapSequence<Self, Transformed> {
        fatalError("TODO: SkipAsyncSequence extension functions")
    }

    func prefix(_ count: Int) -> SkipAsyncPrefixSequence<Self> {
        fatalError("TODO: SkipAsyncSequence extension functions")
    }

    func prefix(while predicate: @escaping @Sendable (Element) async throws -> Bool) rethrows -> SkipAsyncPrefixWhileSequence<Self> {
        fatalError("TODO: SkipAsyncSequence extension functions")
    }

    func compactMap<ElementOfResult>(_ transform: @escaping @Sendable (Element) async throws -> ElementOfResult?) -> SkipAsyncThrowingCompactMapSequence<Self, ElementOfResult> {
        fatalError("TODO: SkipAsyncSequence extension functions")
    }

    func drop(while predicate: @escaping @Sendable (Element) async throws -> Bool) -> SkipAsyncThrowingDropWhileSequence<Self> {
        fatalError("TODO: SkipAsyncSequence extension functions")
    }

    func filter(_ isIncluded: @escaping @Sendable (Element) async throws -> Bool) -> SkipAsyncThrowingFilterSequence<Self> {
        fatalError("TODO: SkipAsyncSequence extension functions")
    }

    func flatMap<SegmentOfResult>(_ transform: @escaping @Sendable (Element) async throws -> SegmentOfResult) -> SkipAsyncThrowingFlatMapSequence<Self, SegmentOfResult> where SegmentOfResult : AsyncSequence {
        fatalError("TODO: SkipAsyncSequence extension functions")
    }

    func map<Transformed>(_ transform: @escaping @Sendable (Element) async throws -> Transformed) -> SkipAsyncThrowingMapSequence<Self, Transformed> {
        fatalError("TODO: SkipAsyncSequence extension functions")
    }

    func prefix(while predicate: @escaping @Sendable (Element) async throws -> Bool) rethrows -> SkipAsyncThrowingPrefixWhileSequence<Self> {
        fatalError("TODO: SkipAsyncSequence extension functions")
    }
    #endif
}

/// An asynchronous sequence generated from a closure that calls a continuation
/// to produce new elements.
///
/// `AsyncStream` conforms to `AsyncSequence`, providing a convenient way to
/// create an asynchronous sequence without manually implementing an
/// asynchronous iterator. In particular, an asynchronous stream is well-suited
/// to adapt callback- or delegation-based APIs to participate with
/// `async`-`await`.
/// You initialize an `AsyncStream` with a closure that receives an
/// `AsyncStream.Continuation`. Produce elements in this closure, then provide
/// them to the stream by calling the continuation's `yield(_:)` method. When
/// there are no further elements to produce, call the continuation's
/// `finish()` method. This causes the sequence iterator to produce a `nil`,
/// which terminates the sequence. The continuation conforms to `Sendable`, which permits
/// calling it from concurrent contexts external to the iteration of the
/// `AsyncStream`.
@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
public struct SkipAsyncStream<Element> : SkipAsyncSequence {
    // Swift and Kotlin treat types nested within generic types in incompatible ways, and Skip cannot translate between the two. Consider moving this type out of its generic outer type
    //public struct Continuation : Sendable {
    //}

    public let stream: PlatformAsyncStream<Element>
    public init(stream: PlatformAsyncStream<Element>) {
        self.stream = stream
    }
}

// Wrap a kotlinx.coroutines.flow.Flow and provide an async interface
// Mirrors the interface of Foundation.AsyncBytes, which extends AsyncSequence
// Note that there could also be `SkipURLAsyncBytes` and `SkipFileHandleAsyncBytes` for `URL.bytes` and `FileHandle.bytes`.
public struct SkipURLSessionAsyncBytes : SkipAsyncSequence {
    //public typealias Element = UInt8
    public let stream: PlatformAsyncStream<UInt8>

    //#if !SKIP
    //public var lines: SkipAsyncLineSequence<SkipURLSessionAsyncBytes> {
    //    return SkipAsyncLineSequence(stream: self)
    //}
    //#endif

    public func allSatisfy(_ condition: (UInt8) throws -> (Bool)) async rethrows -> Bool {
        #if !SKIP
        return try await stream.allSatisfy(condition)
        #else
        var satisfied = false
        stream.collect { b in
            satisfied = condition(b) && satisfied
        }
        return satisfied
        #endif
    }
}

#if !SKIP // need nested typealias support

public struct SkipAsyncLineSequence<Base: SkipAsyncSequence> : SkipAsyncSequence {
    // where BytesStream.Element == UInt8 { // Skip does not support the referenced type as a generic constraint
    public let stream: PlatformAsyncStream<String>

    public func allSatisfy(_ condition: (String) throws -> (Bool)) async rethrows -> Bool {
        fatalError("TODO: SkipAsyncLineSequence.allSatisfy")
    }
}

/// Default declaration: `class SkipAsyncCompactMapSequence<Base, ElementOfResult>: SkipAsyncSequence<Element> where Base: SkipAsyncSequence`
// SKIP DECLARE: class SkipAsyncCompactMapSequence<Base, ElementOfResult, Element>: SkipAsyncSequence<Element> where Base: SkipAsyncSequence<Element>
public struct SkipAsyncCompactMapSequence<Base: SkipAsyncSequence, ElementOfResult> : SkipAsyncSequence {
    public typealias Element = Base.Element
    public let stream: PlatformAsyncStream<Element>
}

public struct SkipAsyncDropFirstSequence<Base: SkipAsyncSequence> : SkipAsyncSequence {
    public typealias Element = Base.Element
    public let stream: PlatformAsyncStream<Element>
}

public struct SkipAsyncDropWhileSequence<Base: SkipAsyncSequence> : SkipAsyncSequence {
    public typealias Element = Base.Element
    public let stream: PlatformAsyncStream<Element>
}

public struct SkipAsyncFilterSequence<Base: SkipAsyncSequence> : SkipAsyncSequence {
    public typealias Element = Base.Element
    public let stream: PlatformAsyncStream<Element>
}

public struct SkipAsyncFlatMapSequence<Base: SkipAsyncSequence, SegmentOfResult> : SkipAsyncSequence where SegmentOfResult : SkipAsyncSequence {
    public typealias Element = Base.Element
    public let stream: PlatformAsyncStream<Element>
}

public struct SkipAsyncMapSequence<Base: SkipAsyncSequence, Transformed> : SkipAsyncSequence {
    public typealias Element = Base.Element
    public let stream: PlatformAsyncStream<Element>
}

public struct SkipAsyncPrefixSequence<Base: SkipAsyncSequence> : SkipAsyncSequence {
    public typealias Element = Base.Element
    public let stream: PlatformAsyncStream<Element>
}

public struct SkipAsyncPrefixWhileSequence<Base: SkipAsyncSequence> : SkipAsyncSequence {
    public typealias Element = Base.Element
    public let stream: PlatformAsyncStream<Element>
}

public struct SkipAsyncThrowingCompactMapSequence<Base: SkipAsyncSequence, ElementOfResult> : SkipAsyncSequence {
    public typealias Element = Base.Element
    public let stream: PlatformAsyncStream<Element>
}

public struct SkipAsyncThrowingDropWhileSequence<Base: SkipAsyncSequence> : SkipAsyncSequence {
    public typealias Element = Base.Element
    public let stream: PlatformAsyncStream<Element>
}

public struct SkipAsyncThrowingFilterSequence<Base: SkipAsyncSequence> : SkipAsyncSequence {
    public typealias Element = Base.Element
    public let stream: PlatformAsyncStream<Element>
}

public struct SkipAsyncThrowingFlatMapSequence<Base: SkipAsyncSequence, SegmentOfResult: SkipAsyncSequence> : SkipAsyncSequence {
    public typealias Element = Base.Element
    public let stream: PlatformAsyncStream<Element>
}

public struct SkipAsyncThrowingMapSequence<Base: SkipAsyncSequence, Transformed> : SkipAsyncSequence {
    public typealias Element = Base.Element
    public let stream: PlatformAsyncStream<Element>
}

public struct SkipAsyncThrowingPrefixWhileSequence<Base: SkipAsyncSequence> : SkipAsyncSequence {
    public typealias Element = Base.Element
    public let stream: PlatformAsyncStream<Element>
}
#endif
