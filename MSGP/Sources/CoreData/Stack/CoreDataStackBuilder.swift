//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
import CoreData

typealias PersistentStoreOptions = [NSObject: AnyObject]

let defaultStoreOptions: PersistentStoreOptions = [
    NSMigratePersistentStoresAutomaticallyOption as NSObject: true as AnyObject,
    NSInferMappingModelAutomaticallyOption as NSObject: true as AnyObject
]

struct CoreDataStackBuilder {
    let model: CoreDataModel
    let options: PersistentStoreOptions?
    
    init(model: CoreDataModel, options: PersistentStoreOptions? = defaultStoreOptions) {
        self.model = model
        self.options = options
    }
    
    /**
     Initializes a new `CoreDataStack` instance using the factory's `model` and `options`.
     
     - warning: If a queue is provided, this operation is performed asynchronously on the specified queue,
     and the completion closure is executed asynchronously on the main queue.
     If `queue` is `nil`, then this method and the completion closure execute synchronously on the current queue.
     
     - parameter queue: The queue on which to initialize the stack.
     The default is a background queue with a "user initiated" quality of service class.
     If passing `nil`, this method is executed synchronously on the queue from which the method was called.
     
     - parameter completion: The closure to be called once initialization is complete.
     If a queue is provided, this is called asynchronously on the main queue.
     Otherwise, this is executed on the thread from which the method was originally called.
     */
    
    func makeStack() -> Result<CoreDataStack> {
        var result: Result<CoreDataStack>!
        makeStack(onQueue: nil) { r in
            result = r
        }
        return result
    }
    
    func makeStack(onQueue queue: DispatchQueue? = .global(qos: .userInitiated),
                   completion: @escaping (Result<CoreDataStack>) -> Void) {
        let isAsync = (queue != nil)
        
        let creationClosure = {
            let storeCoordinator: NSPersistentStoreCoordinator
            do {
                storeCoordinator = try self.createStoreCoordinator()
            } catch {
                if isAsync {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                } else {
                    completion(.failure(error))
                }
                return
            }
            
            let backgroundContext = self.createContext(.privateQueueConcurrencyType, name: "background")
            backgroundContext.persistentStoreCoordinator = storeCoordinator
            
            let mainContext = self.createContext(.mainQueueConcurrencyType, name: "main")
            mainContext.persistentStoreCoordinator = storeCoordinator
            
            let stack = CoreDataStack(model: self.model,
                                      mainContext: mainContext,
                                      backgroundContext: backgroundContext,
                                      storeCoordinator: storeCoordinator)
            
            if let storeURL = self.model.storeURL {
                print("*** Storage URL 🗂 \(storeURL)")
            }

            if isAsync {
                DispatchQueue.main.async {
                    completion(.success(stack))
                }
            } else {
                completion(.success(stack))
            }
        }
        
        if let queue = queue {
            queue.async(execute: creationClosure)
        } else {
            creationClosure()
        }
    }
    // swiftlint:enable function_body_length

    private func createStoreCoordinator() throws -> NSPersistentStoreCoordinator {
        let storeCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model.managedObjectModel)
        try storeCoordinator.addPersistentStore(ofType: model.storeType.type,
                                                configurationName: nil,
                                                at: model.storeURL,
                                                options: options)
        return storeCoordinator
    }
    
    private func createContext(_ concurrencyType: NSManagedObjectContextConcurrencyType,
                               name: String) -> NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: concurrencyType)
        context.mergePolicy = NSMergePolicy(merge: .mergeByPropertyStoreTrumpMergePolicyType)
        context.name = "msgp." + name
        return context
    }
}
