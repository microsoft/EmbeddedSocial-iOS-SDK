//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import MSGP

final class CoreDataSetupHelper {
    static func makeInMemoryCoreDataStack() -> CoreDataStack {
        let model = CoreDataModel(name: "MSGP", bundle: Bundle(for: CoreDataModel.self), storeType: .inMemory)
        let builder = CoreDataStackFactory(model: model)
        var stack: CoreDataStack!
        
        let group = DispatchGroup()
        
        group.enter()
        builder.makeStack(onQueue: nil) { result in
            XCTAssertNotNil(result.value)
            stack = result.value
            group.leave()
        }
        
        group.wait()
        
        return stack
    }
}

