//
//  QueriableRepository.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/21/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import Foundation

private func abstractMethod() -> Never {
    fatalError("abstract method")
}

class QueriableRepository<T>: Repository {
    typealias DomainType = T
    
    init() { }
    
    func create() -> T {
        abstractMethod()
    }
    
    func query(with predicate: NSPredicate? = nil,
               sortDescriptors: [NSSortDescriptor]? = nil,
               completion: @escaping ([T]) -> Void) {
        abstractMethod()
    }
    
    func save(_ entities: [T], completion: ((Result<Void>) -> Void)? = nil) {
        abstractMethod()
    }
    
    func delete(_ entities: [T], completion: ((Result<Void>) -> Void)? = nil) {
        abstractMethod()
    }
}
