//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import MSGP

final class CoreDataSetupHelper {
    static func setupInMemoryCoreDataStack(completion: @escaping (CoreDataStack) -> Void) {
        let model = CoreDataModel(name: "MSGP", bundle: Bundle(for: CoreDataModel.self), storeType: .inMemory)
        let builder = CoreDataStackFactory(model: model)
        
        builder.makeStack(onQueue: nil) { result in
            XCTAssertNotNil(result.value)
            completion(result.value!)
        }
    }
}

