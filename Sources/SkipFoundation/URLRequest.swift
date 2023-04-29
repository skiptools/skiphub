// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP
import struct Foundation.URLRequest
public typealias URLRequest = Foundation.URLRequest
internal typealias PlatformURLRequest = Foundation.URLRequest
#else
public typealias URLRequest = SkipURLRequest
public typealias PlatformURLRequest = java.net.HttpURLConnection
#endif


// override the Kotlin type to be public while keeping the Swift version internal:
// SKIP DECLARE: class SkipURLRequest: RawRepresentable<PlatformURLRequest>, MutableStruct
internal struct SkipURLRequest : RawRepresentable, Hashable, CustomStringConvertible {
    public var rawValue: PlatformURLRequest

    public init(rawValue: PlatformURLRequest) {
        self.rawValue = rawValue
    }

    public init(_ rawValue: PlatformURLRequest) {
        self.rawValue = rawValue
    }

    #if !SKIP
    public init(url: PlatformURL, cachePolicy: URLRequest.CachePolicy = URLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: TimeInterval = 0) {
        self.rawValue = PlatformURLRequest(url: url, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval)
    }
    #endif

    var description: String {
        return rawValue.description
    }

    public enum CachePolicy : Int {
        case useProtocolCachePolicy = 0
        case reloadIgnoringLocalCacheData = 1
        case reloadIgnoringLocalAndRemoteCacheData = 4
        //public static var reloadIgnoringCacheData: NSURLRequest.CachePolicy { get }
        case returnCacheDataElseLoad = 2
        case returnCacheDataDontLoad = 3
        case reloadRevalidatingCacheData = 5
    }
}
