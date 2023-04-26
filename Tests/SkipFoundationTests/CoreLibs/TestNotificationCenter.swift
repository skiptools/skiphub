
// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
import Foundation
import XCTest

// These tests are adapted from https://github.com/apple/swift-corelibs-foundation/blob/main/Tests/Foundation/Tests which have the following license:


// This source file is part of the Swift.org open source project
//
// Copyright (c) 2014 - 2016 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See http://swift.org/LICENSE.txt for license information
// See http://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//

class TestNotificationCenter : XCTestCase {
    #if !SKIP
    static var allTests: [(String, (TestNotificationCenter) -> () throws -> Void)] {
        return [
            ("test_defaultCenter", test_defaultCenter),
            ("test_postNotification", test_postNotification),
            ("test_postNotificationForObject", test_postNotificationForObject),
            ("test_postMultipleNotifications", test_postMultipleNotifications),
            ("test_addObserverForNilName", test_addObserverForNilName),
            ("test_removeObserver", test_removeObserver),
            ("test_observeOnPostingQueue", test_observeOnPostingQueue),
            ("test_observeOnSpecificQueuePostFromMainQueue", test_observeOnSpecificQueuePostFromMainQueue),
            ("test_observeOnSpecificQueuePostFromObservedQueue", test_observeOnSpecificQueuePostFromObservedQueue),
            ("test_observeOnSpecificQueuePostFromUnrelatedQueue", test_observeOnSpecificQueuePostFromUnrelatedQueue),
        ]
    }
    #endif // SKIP
    
    func test_defaultCenter() {
        #if SKIP
        throw XCTSkip("TODO")
        #else
        let defaultCenter1 = NotificationCenter.default
        let defaultCenter2 = NotificationCenter.default
        XCTAssertEqual(defaultCenter1, defaultCenter2)
        #endif // !SKIP
    }
    
    func removeObserver(_ observer: NSObjectProtocol, notificationCenter: NotificationCenter) {
        #if SKIP
        throw XCTSkip("TODO")
        #else
        guard let observer = observer as? NSObject else {
            return
        }
        
        notificationCenter.removeObserver(observer)
        #endif // !SKIP
    }
    
    func test_postNotification() {
        #if SKIP
        throw XCTSkip("TODO")
        #else
        let notificationCenter = NotificationCenter()
        let notificationName = Notification.Name(rawValue: "test_postNotification_name")
        var flag = false
        let dummyObject = NSObject()
        let observer = notificationCenter.addObserver(forName: notificationName, object: dummyObject, queue: nil) { notification in
            XCTAssertEqual(notificationName, notification.name)
            XCTAssertTrue(dummyObject === notification.object as? NSObject)
            
            flag = true
        }
        
        notificationCenter.post(name: notificationName, object: dummyObject)
        XCTAssertTrue(flag)
        
        removeObserver(observer, notificationCenter: notificationCenter)
        #endif // !SKIP
    }

    func test_postNotificationForObject() {
        #if SKIP
        throw XCTSkip("TODO")
        #else
        let notificationCenter = NotificationCenter()
        let notificationName = Notification.Name(rawValue: "test_postNotificationForObject_name")
        var flag = true
        let dummyObject = NSObject()
        let dummyObject2 = NSObject()
        let observer = notificationCenter.addObserver(forName: notificationName, object: dummyObject, queue: nil) { notification in
            flag = false
        }
        
        notificationCenter.post(name: notificationName, object: dummyObject2)
        XCTAssertTrue(flag)
        
        removeObserver(observer, notificationCenter: notificationCenter)
        #endif // !SKIP
    }
    
    func test_postMultipleNotifications() {
        #if SKIP
        throw XCTSkip("TODO")
        #else
        let notificationCenter = NotificationCenter()
        let notificationName = Notification.Name(rawValue: "test_postMultipleNotifications_name")
        var flag1 = false
        let observer1 = notificationCenter.addObserver(forName: notificationName, object: nil, queue: nil) { _ in
            flag1 = true
        }
        
        var flag2 = true
        let observer2 = notificationCenter.addObserver(forName: notificationName, object: nil, queue: nil) { _ in
            flag2 = false
        }
        
        var flag3 = false
        let observer3 = notificationCenter.addObserver(forName: notificationName, object: nil, queue: nil) { _ in
            flag3 = true
        }
        
        removeObserver(observer2, notificationCenter: notificationCenter)
        
        notificationCenter.post(name: notificationName, object: nil)
        XCTAssertTrue(flag1)
        XCTAssertTrue(flag2)
        XCTAssertTrue(flag3)
        
        removeObserver(observer1, notificationCenter: notificationCenter)
        removeObserver(observer3, notificationCenter: notificationCenter)
        #endif // !SKIP
    }

    func test_addObserverForNilName() {
        #if SKIP
        throw XCTSkip("TODO")
        #else
        let notificationCenter = NotificationCenter()
        let notificationName = Notification.Name(rawValue: "test_addObserverForNilName_name")
        let invalidNotificationName = Notification.Name(rawValue: "test_addObserverForNilName_name_invalid")
        var flag1 = false
        let observer1 = notificationCenter.addObserver(forName: notificationName, object: nil, queue: nil) { _ in
            flag1 = true
        }
        
        var flag2 = true
        let observer2 = notificationCenter.addObserver(forName: invalidNotificationName, object: nil, queue: nil) { _ in
            flag2 = false
        }
        
        var flag3 = false
        let observer3 = notificationCenter.addObserver(forName: nil, object: nil, queue: nil) { _ in
            flag3 = true
        }
        
        notificationCenter.post(name: notificationName, object: nil)
        XCTAssertTrue(flag1)
        XCTAssertTrue(flag2)
        XCTAssertTrue(flag3)
        
        removeObserver(observer1, notificationCenter: notificationCenter)
        removeObserver(observer2, notificationCenter: notificationCenter)
        removeObserver(observer3, notificationCenter: notificationCenter)
        #endif // !SKIP
    }

    func test_removeObserver() {
        #if SKIP
        throw XCTSkip("TODO")
        #else
        let notificationCenter = NotificationCenter()
        let notificationName = Notification.Name(rawValue: "test_removeObserver_name")
        var flag = true
        let observer = notificationCenter.addObserver(forName: notificationName, object: nil, queue: nil) { _ in
            flag = false
        }

        removeObserver(observer, notificationCenter: notificationCenter)

        notificationCenter.post(name: notificationName, object: nil)
        XCTAssertTrue(flag)
        #endif // !SKIP
    }
    
    func test_observeOnPostingQueue() {
        #if SKIP
        throw XCTSkip("TODO")
        #else
        let notificationCenter = NotificationCenter()
        let name = Notification.Name(rawValue: "\(#function)_name")
        let postingQueue = OperationQueue()
        let expectation = self.expectation(description: "Observer was not notified.")
        
        _ = notificationCenter.addObserver(forName: name, object: nil, queue: nil) { _ in
            XCTAssertEqual(OperationQueue.current, postingQueue)
            expectation.fulfill()
        }
        
        postingQueue.addOperation {
            notificationCenter.post(name: name, object: nil)
        }
        
        self.waitForExpectations(timeout: 1)
        #endif // !SKIP
    }
    
    func test_observeOnSpecificQueuePostFromMainQueue() {
        #if SKIP
        throw XCTSkip("TODO")
        #else
        let name = Notification.Name(rawValue: "\(#function)_name")
        let notificationCenter = NotificationCenter()
        let operationQueue = OperationQueue()
        var flag1 = false
        var flag2 = false
        
        _ = notificationCenter.addObserver(forName: name, object: nil, queue: operationQueue) { _ in
            XCTAssertEqual(OperationQueue.current, operationQueue)
            flag1 = true
        }
        
        _ = notificationCenter.addObserver(forName: name, object: nil, queue: .main) { _ in
            XCTAssertEqual(OperationQueue.current, .main)
            flag2 = true
        }
        
        notificationCenter.post(name: name, object: nil)
        // All observers should be notified synchronously regardless of the observer queue.
        XCTAssertTrue(flag1)
        XCTAssertTrue(flag2)
        #endif // !SKIP
    }
    
    func test_observeOnSpecificQueuePostFromObservedQueue() {
        #if SKIP
        throw XCTSkip("TODO")
        #else
        let name = Notification.Name(rawValue: "\(#function)_name")
        let notificationCenter = NotificationCenter()
        let observingQueue = OperationQueue()
        let expectation = self.expectation(description: "Notification posting operation was not executed.")
        var flag1 = false
        var flag2 = false
        
        _ = notificationCenter.addObserver(forName: name, object: nil, queue: observingQueue) { _ in
            XCTAssertEqual(OperationQueue.current, observingQueue)
            flag1 = true
        }
        
        _ = notificationCenter.addObserver(forName: name, object: nil, queue: .main) { _ in
            XCTAssertEqual(OperationQueue.current, .main)
            flag2 = true
        }
        
        observingQueue.addOperation {
            notificationCenter.post(name: name, object: nil)
            // All observers should be notified synchronously regardless of the observer queue.
            XCTAssertTrue(flag1)
            XCTAssertTrue(flag2)
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 1)
        #endif // !SKIP
    }
    
    func test_observeOnSpecificQueuePostFromUnrelatedQueue() {
        #if SKIP
        throw XCTSkip("TODO")
        #else
        let name = Notification.Name(rawValue: "\(#function)_name")
        let notificationCenter = NotificationCenter()
        let operationQueue = OperationQueue()
        let postingQueue = OperationQueue()
        let expectation = self.expectation(description: "Notification posting operation was not executed.")
        var flag1 = false
        var flag2 = false
        
        _ = notificationCenter.addObserver(forName: name, object: nil, queue: operationQueue) { _ in
            XCTAssertEqual(OperationQueue.current, operationQueue)
            flag1 = true
        }
        
        _ = notificationCenter.addObserver(forName: name, object: nil, queue: .main) { _ in
            XCTAssertEqual(OperationQueue.current, .main)
            flag2 = true
        }
        
        postingQueue.addOperation {
            notificationCenter.post(name: name, object: nil)
            // All observers should be notified synchronously regardless of the observer queue.
            XCTAssertTrue(flag1)
            XCTAssertTrue(flag2)
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 1)
        #endif // !SKIP
    }
}


