//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import MSGP

final class MockKeyValueRepository<DomainType>: AbstractKeyValueRepository<DomainType> {
    private (set) var saveCount = 0
    private (set) var removeCount = 0
    private (set) var loadCount = 0
    private (set) var purgeCount = 0
    
    var mementoToLoad: Memento?
    
    override func save(_ serializable: DomainType?, forKey key: String) {
        saveCount += 1
    }
    
    override func remove(forKey key: String) {
        removeCount += 1
    }
    
    override func load(forKey key: String) -> Memento? {
        loadCount += 1
        return mementoToLoad
    }
    
    override func purge(key: String) {
        purgeCount += 1
    }
}
