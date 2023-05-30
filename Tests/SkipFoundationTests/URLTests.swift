// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
import Foundation
import XCTest

final class URLTests: XCTestCase {
    func testURLs() throws {
        let url: URL? = URL(string: "https://github.com/skiptools/skip.git")
        XCTAssertEqual("https://github.com/skiptools/skip.git", url?.absoluteString)
        XCTAssertEqual("/skiptools/skip.git", url?.path)
        XCTAssertEqual("github.com", url?.host)
        XCTAssertEqual("git", url?.pathExtension)
        XCTAssertEqual("skip.git", url?.lastPathComponent)
        XCTAssertEqual(false, url?.isFileURL)
    }

    func testDefaultURLSessionConfiguration() {
        let config = URLSessionConfiguration.default
        XCTAssertEqual(nil, config.identifier)
        XCTAssertEqual(60.0, config.timeoutIntervalForRequest)
        XCTAssertEqual(604800.0, config.timeoutIntervalForResource)
        XCTAssertEqual(true, config.allowsCellularAccess)
        XCTAssertEqual(true, config.allowsExpensiveNetworkAccess)
        XCTAssertEqual(true, config.allowsConstrainedNetworkAccess)
        XCTAssertEqual(false, config.waitsForConnectivity)
        XCTAssertEqual(false, config.isDiscretionary)
        XCTAssertEqual(nil, config.sharedContainerIdentifier)
        XCTAssertEqual(false, config.sessionSendsLaunchEvents)
        //XCTAssertEqual(nil, config.connectionProxyDictionary)
        XCTAssertEqual(false, config.httpShouldUsePipelining)
        XCTAssertEqual(true, config.httpShouldSetCookies)
        //XCTAssertEqual(nil, config.httpAdditionalHeaders)
        XCTAssertEqual(6, config.httpMaximumConnectionsPerHost)
        XCTAssertEqual(false, config.shouldUseExtendedBackgroundIdleMode)
    }

    func testEphemeralURLSessionConfiguration() {
        let config = URLSessionConfiguration.ephemeral
        XCTAssertEqual(nil, config.identifier)
        XCTAssertEqual(60.0, config.timeoutIntervalForRequest)
        XCTAssertEqual(604800.0, config.timeoutIntervalForResource)
        XCTAssertEqual(true, config.allowsCellularAccess)
        XCTAssertEqual(true, config.allowsExpensiveNetworkAccess)
        XCTAssertEqual(true, config.allowsConstrainedNetworkAccess)
        XCTAssertEqual(false, config.waitsForConnectivity)
        XCTAssertEqual(false, config.isDiscretionary)
        XCTAssertEqual(nil, config.sharedContainerIdentifier)
        XCTAssertEqual(false, config.sessionSendsLaunchEvents)
        //XCTAssertEqual(nil, config.connectionProxyDictionary)
        XCTAssertEqual(false, config.httpShouldUsePipelining)
        XCTAssertEqual(true, config.httpShouldSetCookies)
        //XCTAssertEqual(nil, config.httpAdditionalHeaders)
        XCTAssertEqual(6, config.httpMaximumConnectionsPerHost)
        XCTAssertEqual(false, config.shouldUseExtendedBackgroundIdleMode)
    }

    func testDownloadURL() async throws {
        let (data, response) = try await URLSession.shared.data(from: URL(string: "https://jsonplaceholder.typicode.com/todos/1")!)

        let HTTPResponse = try XCTUnwrap(response as? HTTPURLResponse)
        XCTAssertEqual("application/json", HTTPResponse.mimeType)
        XCTAssertEqual("utf-8", HTTPResponse.textEncodingName)
        XCTAssertEqual(83, HTTPResponse.expectedContentLength)

        XCTAssertEqual(83, data.count)
        XCTAssertEqual(String(data: data, encoding: .utf8), """
        {
          "userId": 1,
          "id": 1,
          "title": "delectus aut autem",
          "completed": false
        }
        """)
    }
}
