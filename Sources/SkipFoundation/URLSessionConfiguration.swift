// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
#if !SKIP
import class Foundation.URLSessionConfiguration
public typealias URLSessionConfiguration = Foundation.URLSessionConfiguration
internal typealias PlatformURLSessionConfiguration = Foundation.URLSessionConfiguration
#else
public typealias URLSessionConfiguration = SkipURLSessionConfiguration
#endif

// override the Kotlin type to be public while keeping the Swift version internal:
// SKIP DECLARE: class SkipURLSessionConfiguration
@available(macOS 13, iOS 16, tvOS 16, watchOS 9, *)
internal class SkipURLSessionConfiguration {
    #if SKIP
    private static let _default = SkipURLSessionConfiguration()
    #endif

    static var `default`: SkipURLSessionConfiguration {
        #if !SKIP
        return SkipURLSessionConfiguration(rawValue: PlatformURLSessionConfiguration.default)
        #else
        return _default
        #endif
    }

    #if SKIP
    // TODO: ephemeral config
    private static let _ephemeral = SkipURLSessionConfiguration()
    #endif

    open class var ephemeral: SkipURLSessionConfiguration {
        #if !SKIP
        return SkipURLSessionConfiguration(rawValue: PlatformURLSessionConfiguration.ephemeral)
        #else
        return _ephemeral
        #endif
    }

    #if !SKIP
    public var rawValue: PlatformURLSessionConfiguration

    init(rawValue: PlatformURLSessionConfiguration) {
        self.rawValue = rawValue
    }
    #else
    public var identifier: String?
    //public var requestCachePolicy: NSURLRequest.CachePolicy
    public var timeoutIntervalForRequest: TimeInterval = 60.0
    public var timeoutIntervalForResource: TimeInterval = 604800.0
    //public var networkServiceType: NSURLRequest.NetworkServiceType
    public var allowsCellularAccess: Bool = true
    //public var allowsExpensiveNetworkAccess: Bool = true
    public var allowsConstrainedNetworkAccess: Bool = true
    //public var requiresDNSSECValidation: Bool = true
    public var waitsForConnectivity: Bool = false
    public var isDiscretionary: Bool = false
    public var sharedContainerIdentifier: String? = nil
    public var sessionSendsLaunchEvents: Bool = false
    public var connectionProxyDictionary: [AnyHashable : Any]? = nil
    //public var tlsMinimumSupportedProtocol: SSLProtocol
    //public var tlsMaximumSupportedProtocol: SSLProtocol
    //public var tlsMinimumSupportedProtocolVersion: tls_protocol_version_t
    //public var tlsMaximumSupportedProtocolVersion: tls_protocol_version_t
    public var httpShouldUsePipelining: Bool = false
    public var httpShouldSetCookies: Bool = true
    //public var httpCookieAcceptPolicy: HTTPCookie.AcceptPolicy
    public var httpAdditionalHeaders: [AnyHashable : Any]? = nil
    public var httpMaximumConnectionsPerHost: Int = 6
    //public var httpCookieStorage: HTTPCookieStorage?
    //public var urlCredentialStorage: URLCredentialStorage?
    //public var urlCache: URLCache?
    public var shouldUseExtendedBackgroundIdleMode: Bool = false
    //public var protocolClasses: [AnyClass]?

    public init() {
    }
    #endif
}
