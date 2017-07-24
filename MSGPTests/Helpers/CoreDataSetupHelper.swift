//
//  CommonMethods.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/21/17.
//  Copyright © 2017 Akvelon. All rights reserved.
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

