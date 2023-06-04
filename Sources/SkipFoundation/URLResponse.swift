// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP
/* @_implementationOnly */import class Foundation.URLResponse
public typealias PlatformURLResponse = Foundation.URLResponse
#else
#endif

/// The metadata associated with the response to a URL load request, independent of protocol and URL scheme.
public class URLResponse : CustomStringConvertible {
    #if !SKIP
    public var rawValue: PlatformURLResponse
    public var url: URL? { rawValue.url.flatMap(URL.init(rawValue:)) }
    public var mimeType: String? { rawValue.mimeType }
    public var expectedContentLength: Int64 { rawValue.expectedContentLength }
    public var textEncodingName: String? { rawValue.textEncodingName }
    #else
    public internal(set) var url: URL?
    public internal(set) var mimeType: String?
    public internal(set) var expectedContentLength: Int64 = -1
    public internal(set) var textEncodingName: String?
    #endif

    public init() {
        #if !SKIP
        self.rawValue = PlatformURLResponse()
        #else
        #endif
    }

    public init(url: URL, mimeType: String?, expectedContentLength: Int, textEncodingName: String?) {
        #if !SKIP
        self.rawValue = PlatformURLResponse(url: url.rawValue, mimeType: mimeType, expectedContentLength: expectedContentLength, textEncodingName: textEncodingName)
        #else
        self.url = url
        self.mimeType = mimeType
        self.expectedContentLength = Int64(expectedContentLength)
        self.textEncodingName = textEncodingName
        #endif
    }

    #if !SKIP
    public init(rawValue: PlatformURLResponse) {
        self.rawValue = rawValue
    }

    public init(_ rawValue: PlatformURLResponse) {
        self.rawValue = rawValue
    }

    public var description: String {
        return rawValue.description
    }
    #endif

    public var suggestedFilename: String? {
        #if !SKIP
        return rawValue.suggestedFilename
        #else
        // A filename specified using the content disposition header.
        // The last path component of the URL.
        // The host of the URL.
        // If the host of URL can't be converted to a valid filename, the filename “unknown” is used.
        if let component = self.url?.lastPathComponent, !component.isEmpty {
            return component
        }
        // not expected by the test cases
        //if let host = self.url?.host {
        //    return host
        //}
        return "Unknown"
        #endif
    }

    public func copy() -> Any {
        #if !SKIP
        return rawValue.copy()
        #else
        if let url = self.url {
            return URLResponse(url: url, mimeType: self.mimeType, expectedContentLength: Int(self.expectedContentLength), textEncodingName: self.textEncodingName)
        } else {
            return URLResponse()
        }
        #endif
    }

    public func isEqual(_ other: Any?) -> Bool {
        #if !SKIP
        return rawValue.isEqual(other)
        #else
        guard let other = other as? URLResponse else {
            return false
        }
        return self.url == other.url &&
            self.mimeType == other.mimeType &&
            self.expectedContentLength == other.expectedContentLength &&
            self.textEncodingName == other.textEncodingName
        #endif
    }

    public var hash: Int {
        #if !SKIP
        return rawValue.hash
        #else
        return hashValue
        #endif
    }
}
