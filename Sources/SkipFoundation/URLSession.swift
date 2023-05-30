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

    public func data(from url: SkipURL) async throws -> (SkipData, SkipURLResponse) {
        #if !SKIP
        let (data, response) = try await rawValue.data(from: url.rawValue)
        let result = (SkipData(rawValue: data), SkipURLResponse(rawValue: response))
        return result
        #else
        let config = self.configuration
        let (data, response) = kotlinx.coroutines.withContext(kotlinx.coroutines.Dispatchers.IO) {
            let connection = url.rawValue.openConnection()

            var statusCode = -1
            if let httpConnection = connection as? java.net.HttpURLConnection {
                httpConnection.connectTimeout = config.timeoutIntervalForRequest.toInt()
                httpConnection.readTimeout = config.timeoutIntervalForResource.toInt()
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

    public func data(for request: SkipURLRequest) async throws -> (SkipData, SkipURLResponse) {
        #if !SKIP
        let (data, response) = try await rawValue.data(for: request.rawValue)
        let result = (SkipData(rawValue: data), SkipURLResponse(rawValue: response))
        return result
        #else
        fatalError("TODO: SkipURLSession.data")
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
public protocol URLSessionDelegate {
}

public protocol URLSessionTask {
}

public protocol URLSessionDataTask : URLSessionTask {
}

public protocol URLSessionTaskDelegate : URLSessionDelegate {
}

public protocol URLSessionDataDelegate : URLSessionTaskDelegate {
}
#endif
