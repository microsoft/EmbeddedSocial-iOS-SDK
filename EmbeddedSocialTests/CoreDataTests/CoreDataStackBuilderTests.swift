//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class CoreDataStackBuilderTests: XCTestCase {
    private let timeout: TimeInterval = 5
    
    override func setUp() {
        super.setUp()
        CoreDataHelper.cleanUpTestModel()
    }
    
    override func tearDown() {
        super.tearDown()
        CoreDataHelper.cleanUpTestModel()
    }
    
    func testThatStackIsCreated() {
        let inMemoryModel = CoreDataModel(name: CoreDataHelper.testModelName,
                                          bundle: CoreDataHelper.currentBundle,
                                          storeType: .inMemory)
        
        let builder = CoreDataStackBuilder(model: inMemoryModel)
        XCTAssertEqual(builder.model.storeType, inMemoryModel.storeType)
        XCTAssertTrue((builder.options! as NSDictionary).isEqual(to: defaultStoreOptions))
    }
    
    func testThatStackBuilderCreatesStackInBackground() {
        // given
        let sqliteModel = CoreDataModel(name: CoreDataHelper.testModelName, bundle: CoreDataHelper.currentBundle)
        let builder = CoreDataStackBuilder(model: sqliteModel)
        
        var stack: CoreDataStack?
        let expectation = self.expectation(description: #function)
        
        // when
        builder.makeStack { result in
            XCTAssertTrue(Thread.isMainThread, "Must be on main thread")
            
            switch result {
            case let .success(s):
                stack = s
                XCTAssertNotNil(s)
                
            case let .failure(e):
                XCTFail("Error: \(e)")
            }
            
            expectation.fulfill()
        }
        
        // then
        wait(for: [expectation], timeout: timeout)
        
        XCTAssertNotNil(stack)
        
        validateStack(stack!)
    }
    
    func test_ThatStackFactory_CreatesStackSynchronously_Successfully() {
        // given
        let sqliteModel = CoreDataModel(name: CoreDataHelper.testModelName, bundle: CoreDataHelper.currentBundle)
        let builder = CoreDataStackBuilder(model: sqliteModel)
        
        // when
        let stack = builder.makeStack().value
        
        // then
        XCTAssertNotNil(stack)
        
        validateStack(stack!)
    }
    
    private func validateStack(_ stack: CoreDataStack) {
        XCTAssertNotNil(stack.storeCoordinator)
        XCTAssertEqual(stack.mainContext.persistentStoreCoordinator, stack.backgroundContext.persistentStoreCoordinator)
        
        XCTAssertEqual(stack.mainContext.concurrencyType, .mainQueueConcurrencyType)
        XCTAssertNil(stack.mainContext.parent)
        XCTAssertNotNil(stack.mainContext.persistentStoreCoordinator)
        
        XCTAssertEqual(stack.backgroundContext.concurrencyType, .privateQueueConcurrencyType)
        XCTAssertNil(stack.backgroundContext.parent)
        XCTAssertNotNil(stack.backgroundContext.persistentStoreCoordinator)
    }
}
