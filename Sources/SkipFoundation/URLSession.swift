// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
#if !SKIP
import class Foundation.URLSession
public typealias URLSession = Foundation.URLSession
internal typealias PlatformURLSession = Foundation.URLSession
#else
public typealias URLSession = SkipURLSession
//public typealias PlatformURLSession = java.util.URLSession
#endif

fileprivate let logger: Logger = Logger(subsystem: "network", category: "URLSession")

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

    public func data(for request: SkipURLRequest) async throws -> (SkipData, SkipURLResponse) {
        #if !SKIP
        let (data, response) = try await rawValue.data(for: request.rawValue)
        let result = (SkipData(rawValue: data), SkipURLResponse(rawValue: response))
        return result
        #else
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

        let (data, response) = kotlinx.coroutines.withContext(kotlinx.coroutines.Dispatchers.IO) {
            try connection.connect() // make the actual network connection

            var statusCode = -1
            if let httpConnection = connection as? java.net.HttpURLConnection {
                statusCode = httpConnection.getResponseCode()
            }

            let headerFields = connection.getHeaderFields() // public Map<String,List<String>> getHeaderFields()

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

            let response = HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: httpVersion, headerFields: headers)

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

        /// Query the DownloadManager for the response
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
                // this can happen with Robolectric tests, since ShadowDownloadManager is just a stub
                let error = { UnknownStatusCodeError(status: status) }()
                return Result.failure(error)
            }

            return nil
        }

        let response: Result<(SkipURL, SkipURLResponse), Error> = kotlinx.coroutines.withContext(kotlinx.coroutines.Dispatchers.IO) {
            // TODO: rather than polling in a loop, we could do android.registerBroadcastReceiver(android.app.DownloadManager.ACTION_DOWNLOAD_COMPLETE, handleDownloadEvent)
            while true {
                if let downloadResult = queryDownload() {
                    return downloadResult
                }
                kotlinx.coroutines.delay(250) // wait and poll again
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

public struct UnknownStatusCodeError : Error {
    let status: Int
}

#endif
