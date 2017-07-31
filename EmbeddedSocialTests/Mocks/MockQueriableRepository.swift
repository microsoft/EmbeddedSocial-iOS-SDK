//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

final class MockQueriableRepository<DomainType>: QueriableRepository<DomainType> {
    private(set) var createCount = 0
    private(set) var queryCount = 0
    private(set) var saveCount = 0
    private(set) var deleteCount = 0
    
    var itemToCreate: DomainType!
    var itemsToQuery: [DomainType] = []
    
    override func create() -> DomainType {
        createCount += 1
        return itemToCreate
    }
    
    override func query(with predicate: NSPredicate? = nil,
               sortDescriptors: [NSSortDescriptor]? = nil,
               completion: @escaping ([DomainType]) -> Void) {
        queryCount += 1
        completion(itemsToQuery)
    }
    
    override func save(_ entities: [DomainType], completion: ((Result<Void>) -> Void)? = nil) {
        saveCount += 1
        completion?(.success())
    }
    
    override func delete(_ entities: [DomainType], completion: ((Result<Void>) -> Void)? = nil) {
        deleteCount += 1
        completion?(.success())
    }
}
