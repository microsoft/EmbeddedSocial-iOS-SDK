//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
import CoreData
@testable import MSGP

class CoreDataSavingTests: XCTestCase {
    var stack: CoreDataStack!
    
    private let timeout: TimeInterval = 5
    
    override func setUp() {
        super.setUp()
        stack = CoreDataHelper.makeTestInMemoryStack()
    }
    
    override func tearDown() {
        super.tearDown()
        stack = nil
    }
    
    func testThatContextIsNotSavedWithoutChanges() {
        saveContext(stack.mainContext) { _ in
            XCTFail("Context should not be saved when no changes happen.")
        }
    }
    
    func testThatSaveChangesSyncSucceeds() {
        testThatSaveWithChangesSucceeds(async: true)
    }
    
    func testThatSaveChangesAsyncSucceeds() {
        testThatSaveWithChangesSucceeds(async: false)
    }
    
    private func testThatSaveWithChangesSucceeds(async: Bool) {
        // given
        let context = stack.mainContext
        context.performAndWait {
            CoreDataHelper.generateItems(inContext: context, count: 10)
        }
        
        var didSaveMain = false
        expectation(forNotification: Notification.Name.NSManagedObjectContextDidSave.rawValue,
                    object: stack.mainContext) { _ in
                        didSaveMain = true
                        return true
        }
        
        var didUpdateBackground = false
        expectation(forNotification: Notification.Name.NSManagedObjectContextObjectsDidChange.rawValue,
                    object: stack.backgroundContext) { _ in
                        didUpdateBackground = true
                        return true
        }
        
        let saveExpectation = expectation(description: #function)
        
        // when
        saveContext(stack.mainContext, wait: true) { result in
            XCTAssertTrue(result.isSuccess)
            saveExpectation.fulfill()
        }
        
        // then
        waitForExpectations(timeout: timeout) { error in
            XCTAssertNil(error)
            XCTAssertTrue(didSaveMain)
            XCTAssertTrue(didUpdateBackground)
        }
    }
    
    func testThatSavingChildContextSucceedsAndSavesParentMainContext() {
        // given
        let childContext = stack.childContext(concurrencyType: .mainQueueConcurrencyType)
        childContext.performAndWait {
            CoreDataHelper.generateItems(inContext: childContext, count: 10)
        }
        
        var didSaveChild = false
        expectation(forNotification: Notification.Name.NSManagedObjectContextDidSave.rawValue,
                    object: childContext) { _ in
                        didSaveChild = true
                        return true
        }
        
        var didSaveMain = false
        expectation(forNotification: Notification.Name.NSManagedObjectContextDidSave.rawValue,
                    object: stack.mainContext) { _ in
                        didSaveMain = true
                        return true
        }
        
        var didUpdateBackground = false
        expectation(forNotification: Notification.Name.NSManagedObjectContextObjectsDidChange.rawValue,
                    object: stack.backgroundContext) { _ in
                        didUpdateBackground = true
                        return true
        }
        
        let saveExpectation = expectation(description: #function)
        
        // when
        saveContext(childContext) { result in
            XCTAssertTrue(result.isSuccess)
            saveExpectation.fulfill()
        }
        
        // then
        waitForExpectations(timeout: timeout) { error in
            XCTAssertNil(error)
            XCTAssertTrue(didSaveChild)
            XCTAssertTrue(didSaveMain)
            XCTAssertTrue(didUpdateBackground)
        }
    }
}
