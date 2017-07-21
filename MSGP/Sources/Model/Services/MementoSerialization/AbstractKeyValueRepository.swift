//
//  AbstractKeyValueRepository.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/20/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import Foundation

class AbstractKeyValueRepository<T>: Repository {
    typealias DomainType = T
    
    func save(_ serializable: DomainType?, forKey key: String) {
        fatalError()
    }
    
    func load(forKey key: String) -> Memento? {
        fatalError()
    }
}

extension AbstractKeyValueRepository where T: MementoSerializable {
    func deserialize(forKey key: String) -> T? {
        if let memento = load(forKey: key) {
            return T(memento: memento)
        } else {
            return nil
        }
    }
}
