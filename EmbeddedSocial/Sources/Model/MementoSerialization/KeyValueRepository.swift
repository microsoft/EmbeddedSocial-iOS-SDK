//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class KeyValueRepository<DomainType: MementoSerializable>: AbstractKeyValueRepository<DomainType> {
    private let storage: KeyValueStorage
    
    init(storage: KeyValueStorage) {
        self.storage = storage
    }
    
    override func save(_ serializable: DomainType?, forKey key: String) {
        storage.set(serializable?.memento, forKey: key)
    }
    
    override func remove(forKey key: String) {
        storage.removeObject(forKey: key)
    }
    
    override func load(forKey key: String) -> Memento? {
        return storage.object(forKey: key) as? Memento
    }
    
    override func purge(key: String) {
        storage.purge(key: key)
    }
}
