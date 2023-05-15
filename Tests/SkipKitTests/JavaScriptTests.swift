// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
#if !SKIP
@testable import SkipKit
import WebKit
#endif
import Foundation
import XCTest

// SKIP INSERT: @org.junit.runner.RunWith(org.robolectric.RobolectricTestRunner::class)
// SKIP INSERT: @org.robolectric.annotation.Config(sdk = [33])
@available(macOS 11, iOS 14, watchOS 7, tvOS 14, *)
class JavaScriptTests : XCTestCase {
    func testJavaScript() throws {
        let webView = WebView()
        #if SKIP

        XCTAssertEqual(0, webView.webView.getContentHeight())
        XCTAssertEqual(nil, webView.webView.getTitle())
        XCTAssertEqual(nil, webView.webView.getUrl())
        #endif

        // doesn't work because Robolectric's WebView is fake
        #if !SKIP
        let result = try webView.eval(javaScript: "'Hell' + 0")
        XCTAssertEqual("Hell0", result as? String)
        #endif
    }
}

/// A Swift JSON parsing API to match the `org.json.JSONObject` Java API.
public final class WebView {
    #if SKIP
    let webView: android.webkit.WebView
    /// Flag for whether the webview is loaded and ready to execute JavaScript
    private var webViewReady: Bool = false
    #else
    let webView: WKWebView
    #endif

    public init() {
        #if SKIP
        self.webView = android.webkit.WebView(androidContext())
        self.webView.settings.javaScriptEnabled = true
        #else
        self.webView = WKWebView()
        #endif
    }

    func eval(javaScript: String, timeout: Int = 2) throws -> Any? {
        #if SKIP
        // in order to evaluate JavaScript, some HTML must first be loaded
        if webViewReady == false {
            let loadPageLatch = java.util.concurrent.CountDownLatch(1)

            // SKIP INSERT: webView.webViewClient = object : android.webkit.WebViewClient() {
            // SKIP INSERT:     override fun onPageFinished(view: android.webkit.WebView?, url: String?) {
            // SKIP INSERT:         super.onPageFinished(view, url)
            // SKIP INSERT:         webViewReady = true
            // SKIP INSERT:         loadPageLatch.countDown()
            // SKIP INSERT:     }
            // SKIP INSERT: }

            webView.loadData("<html><body></body></html>", "text/html", "UTF-8")
            //webView.loadUrl("http://example.com")

            //org.robolectric.shadows.ShadowApplication.runBackgroundTasks()

            loadPageLatch.await(Long(timeout), java.util.concurrent.TimeUnit.SECONDS)
        }

        assert(webViewReady == true)

        let latch = java.util.concurrent.CountDownLatch(1)

        var scriptResult: String? = nil
        webView.evaluateJavascript(javaScript) { result in
            scriptResult = result
            latch.countDown()
        }

        latch.await(Long(timeout), java.util.concurrent.TimeUnit.SECONDS)
        return scriptResult
        #else

        var resultError: Error? = nil
        var resultObject: Any? = nil
        let semaphore = DispatchSemaphore(value: 0)
        webView.evaluateJavaScript(javaScript) { (result, error) in
            resultError = error
            resultObject = result
            semaphore.signal()
        }

        let runLoop = RunLoop.current
        let end = Date().addingTimeInterval(TimeInterval(timeout))

        while (Date().compare(end) == .orderedAscending) && (semaphore.wait(timeout: .now()) == .timedOut) {
            runLoop.run(mode: .default, before: .distantFuture)
        }

        _ = semaphore.wait(timeout: .now() + .seconds(timeout))
        if let resultError = resultError {
            throw resultError
        }
        return resultObject
        #endif
    }
}
