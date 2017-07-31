//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class CoreDataModelTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testThatInMemoryModelInitializedSuccessfully() {
        // given
        
        // when
        let model = CoreDataModel(name: CoreDataHelper.testModelName, bundle: CoreDataHelper.currentBundle, storeType: .inMemory)
        
        // then
        XCTAssertEqual(model.name, CoreDataHelper.testModelName)
        XCTAssertEqual(model.bundle, Bundle(for: type(of: self)))
        XCTAssertEqual(model.storeType, StoreType.inMemory)
        
        XCTAssertNil(model.storeURL)
        
        XCTAssertNotNil(model.managedObjectModel)
    }
    
    func testThatSQLiteModelInitializedSuccessfully() {
        // given
        
        // when
        let model = CoreDataModel(name: CoreDataHelper.testModelName, bundle: CoreDataHelper.currentBundle)

        // then
        XCTAssertEqual(model.name, CoreDataHelper.testModelName)
        XCTAssertEqual(model.bundle, Bundle(for: type(of: self)))
        XCTAssertEqual(model.storeType, StoreType.sqlite(CoreDataModel.defaultDirectoryURL))
        
        XCTAssertEqual(model.databaseFileName, model.name + "." + ModelFileExtension.sqlite.rawValue)

        let storeURLComponents = model.storeURL!.pathComponents
        XCTAssertEqual(String(storeURLComponents.last!), model.databaseFileName)
        XCTAssertEqual(String(storeURLComponents[storeURLComponents.count - 2]), "Documents")
        XCTAssertTrue(model.storeURL!.isFileURL)
        
        XCTAssertNotNil(model.managedObjectModel)
    }
    
    func testThatSQLiteModelRemoveExistingStoreSucceeds() {
        // given
        let model = CoreDataModel(name: CoreDataHelper.testModelName, bundle: CoreDataHelper.currentBundle)
        let factory = CoreDataStackBuilder(model: model)
        let stack = factory.makeStack().value!
        saveContext(stack.mainContext) { error in }
        
        let fileManager = FileManager.default
        
        XCTAssertTrue(fileManager.fileExists(atPath: model.storeURL!.path), "Model store should exist on disk")
        XCTAssertTrue(fileManager.fileExists(atPath: model.storeURL!.path + "-wal"), "Model write ahead log should exist on disk")
        XCTAssertTrue(fileManager.fileExists(atPath: model.storeURL!.path + "-shm"), "Model shared memory file should exist on disk")
        
        // when
        do {
            try model.removeExistingStore()
        } catch {
            XCTFail("Removing existing model store should not error.")
        }
        
        // then
        XCTAssertFalse(fileManager.fileExists(atPath: model.storeURL!.path), "Model store should NOT exist on disk")
        XCTAssertFalse(fileManager.fileExists(atPath: model.storeURL!.path + "-wal"), "Model write ahead log should NOT exist on disk")
        XCTAssertFalse(fileManager.fileExists(atPath: model.storeURL!.path + "-shm"), "Model shared memory file should NOT exist on disk")
    }
    
    func testThatSQLiteModelRemoveExistingStoreNothingHappens() {
        // given
        let model = CoreDataModel(name: CoreDataHelper.testModelName, bundle: CoreDataHelper.currentBundle)
        
        // when: nothing is created
        
        // then
        XCTAssertFalse(FileManager.default.fileExists(atPath: model.storeURL!.path), "Model store should not exist on disk")
        XCTAssertNoThrow(try model.removeExistingStore())
    }
    
    func testThatInMemoryModelRemoveExistingStoreNothingHappens() {
        // given
        let model = CoreDataModel(name: CoreDataHelper.testModelName, bundle: CoreDataHelper.currentBundle, storeType: .inMemory)
        XCTAssertNil(model.storeURL)
        
        // when
        
        // then
        XCTAssertNoThrow(try model.removeExistingStore())
    }
}
