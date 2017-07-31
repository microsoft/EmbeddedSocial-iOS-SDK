//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class AbstractKeyValueRepository<T>: Repository {
    typealias DomainType = T
    
    func save(_ serializable: DomainType?, forKey key: String) {
        fatalError()
    }
    
    func remove(forKey key: String) {
        fatalError()
    }
    
    func load(forKey key: String) -> Memento? {
        fatalError()
    }
    
    func purge(key: String) {
        fatalError()
    }
    
    func deserialize<T>(forKey key: String) -> T? where T: MementoSerializable {
        if let memento = load(forKey: key) {
            return T(memento: memento)
        } else {
            return nil
        }
    }
}
