//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
import CoreData
@testable import EmbeddedSocial

class CoreDataStackTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        CoreDataHelper.cleanUpTestModel()
    }
    
    override func tearDown() {
        super.tearDown()
        CoreDataHelper.cleanUpTestModel()
    }
    
    func testThatSQLiteStackInitializesSuccessfully() {
        // given
        let sqliteModel = CoreDataModel(name: CoreDataHelper.testModelName, bundle: CoreDataHelper.currentBundle)
        
        // when
        let builder = CoreDataStackBuilder(model: sqliteModel)
        let stack = builder.makeStack().value
        
        // test
        XCTAssertNotNil(stack)
        XCTAssertTrue(FileManager.default.fileExists(atPath: sqliteModel.storeURL!.path), "Model store should exist on disk")
        XCTAssertEqual(stack!.mainContext.concurrencyType, .mainQueueConcurrencyType)
        XCTAssertEqual(stack!.backgroundContext.concurrencyType, .privateQueueConcurrencyType)
    }

    func testThatInMemoryStackInitializesSuccessfully() {
        // given
        let inMemoryModel = CoreDataModel(name: CoreDataHelper.testModelName, bundle: CoreDataHelper.currentBundle, storeType: .inMemory)
        
        // when
        let builder = CoreDataStackBuilder(model: inMemoryModel)
        let stack = builder.makeStack().value
        
        // then
        XCTAssertNotNil(stack)
        XCTAssertNil(inMemoryModel.storeURL, "Model store should not exist on disk")
        XCTAssertEqual(stack!.mainContext.concurrencyType, .mainQueueConcurrencyType)
        XCTAssertEqual(stack!.backgroundContext.concurrencyType, .privateQueueConcurrencyType)
    }
    
    func testThatChildContextIsCreatedSuccessfully() {
        // given
        let model = CoreDataModel(name: CoreDataHelper.testModelName, bundle: CoreDataHelper.currentBundle)
        let builder = CoreDataStackBuilder(model: model)
        let stack = builder.makeStack().value!
        
        // when
        let backgroundChildContext = stack.childContext(concurrencyType: .privateQueueConcurrencyType,
                                                        mergePolicyType: .errorMergePolicyType)
        
        let mainChildContext = stack.childContext(concurrencyType: .mainQueueConcurrencyType,
                                                  mergePolicyType: .overwriteMergePolicyType)
        
        // then
        XCTAssertEqual(backgroundChildContext.parent!, stack.backgroundContext)
        XCTAssertEqual(backgroundChildContext.concurrencyType, .privateQueueConcurrencyType)
        XCTAssertEqual((backgroundChildContext.mergePolicy as! NSMergePolicy).mergeType, .errorMergePolicyType)
        
        XCTAssertEqual(mainChildContext.parent!, stack.mainContext)
        XCTAssertEqual(mainChildContext.concurrencyType, .mainQueueConcurrencyType)
        XCTAssertEqual((mainChildContext.mergePolicy as! NSMergePolicy).mergeType, .overwriteMergePolicyType)
    }
}
