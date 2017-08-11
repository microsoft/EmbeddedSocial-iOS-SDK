//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

private func abstractMethod() -> Never {
    fatalError("abstract method")
}

class QueriableRepository<T>: Repository {
    typealias DomainType = T
    
    func create() -> T {
        abstractMethod()
    }
    
    func query(with predicate: NSPredicate? = nil,
               sortDescriptors: [NSSortDescriptor]? = nil,
               completion: @escaping ([T]) -> Void) {
        abstractMethod()
    }
    
    func query(with predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) -> [T] {
        abstractMethod()
    }
    
    func save(_ entities: [T], completion: ((Result<Void>) -> Void)? = nil) {
        abstractMethod()
    }
    
    func delete(_ entities: [T], completion: ((Result<Void>) -> Void)? = nil) {
        abstractMethod()
    }
}
