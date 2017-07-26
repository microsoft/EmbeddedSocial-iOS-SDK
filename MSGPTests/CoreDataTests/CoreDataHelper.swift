//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
import CoreData
@testable import MSGP

final class CoreDataHelper {
    static let testModelName = "TestModel"
    
    static var currentBundle: Bundle {
        return Bundle(for: self)
    }
    
    static func makeMSGPInMemoryStack() -> CoreDataStack {
        let model = CoreDataModel(name: "MSGP", bundle: Bundle(for: CoreDataModel.self), storeType: .inMemory)
        let builder = CoreDataStackBuilder(model: model)
        return builder.makeStack().value!
    }
    
    static func makeTestInMemoryStack() -> CoreDataStack {
        let model = CoreDataModel(name: testModelName, bundle: currentBundle, storeType: .inMemory)
        let builder = CoreDataStackBuilder(model: model)
        return builder.makeStack().value!
    }
    
    static func cleanUpTestModel() {
        let model = CoreDataModel(name: testModelName, bundle: currentBundle)
        _ = try? model.removeExistingStore()
    }
    
    @discardableResult static func generateItems(inContext context: NSManagedObjectContext, count: Int) -> [Item] {
        return Array(0..<count).map { _ in Item.makeItem(inContext: context) }
    }
}

