//
//  MementoRepository.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/20/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import Foundation

class KeyValueRepository<DomainType: MementoSerializable>: AbstractKeyValueRepository<DomainType> {
    private let storage: KeyValueStorage
    
    init(storage: KeyValueStorage) {
        self.storage = storage
    }
    
    override func save(_ serializable: DomainType?, forKey key: String) {
        guard let memento = serializable?.memento else {
            return
        }
        storage.set(memento, forKey: key)
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
