//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import CoreData

class CoreDataRepository<T: CoreDataRecord>: QueriableRepository<T> {
    
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    override func create() -> T {
        return context.create(T.self)
    }
    
    override func query(with predicate: NSPredicate? = nil,
                        sortDescriptors: [NSSortDescriptor]? = nil,
                        completion: @escaping ([T]) -> Void) {
        context.entities(T.self, predicate: predicate, sortDescriptors: sortDescriptors, onResult: completion)
    }
    
    override func save(_ entities: [T], completion: ((Result<Void>) -> Void)? = nil) {
        saveContext(context, completion: completion)
    }
    
    override func delete(_ entities: [T], completion: ((Result<Void>) -> Void)? = nil) {
        for case let entity as NSManagedObject in entities {
            context.delete(entity)
        }
        saveContext(context, completion: completion)
    }
}
