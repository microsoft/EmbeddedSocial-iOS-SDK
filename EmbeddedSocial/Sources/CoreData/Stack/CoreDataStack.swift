//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
import CoreData

final class CoreDataStack {
    let model: CoreDataModel
    let mainContext: NSManagedObjectContext
    let backgroundContext: NSManagedObjectContext
    let storeCoordinator: NSPersistentStoreCoordinator
    
    init(model: CoreDataModel,
         mainContext: NSManagedObjectContext,
         backgroundContext: NSManagedObjectContext,
         storeCoordinator: NSPersistentStoreCoordinator) {
        self.model = model
        self.mainContext = mainContext
        self.backgroundContext = backgroundContext
        self.storeCoordinator = storeCoordinator
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(didReceiveMainContextDidSave(notification:)),
                                       name: NSNotification.Name.NSManagedObjectContextDidSave,
                                       object: mainContext)
        notificationCenter.addObserver(self,
                                       selector: #selector(didReceiveBackgroundContextDidSave(notification:)),
                                       name: NSNotification.Name.NSManagedObjectContextDidSave,
                                       object: backgroundContext)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    /**
     The parent context is either `mainContext` or `backgroundContext` dependending on the specified `concurrencyType`:
     `.privateQueueConcurrencyType` will set `backgroundContext` as the parent.
     `.mainQueueConcurrencyType` will set `mainContext` as the parent.
     */
    func childContext(concurrencyType: NSManagedObjectContextConcurrencyType = .mainQueueConcurrencyType,
                      mergePolicyType: NSMergePolicyType = .mergeByPropertyObjectTrumpMergePolicyType) -> NSManagedObjectContext {
        
        let childContext = NSManagedObjectContext(concurrencyType: concurrencyType)
        childContext.mergePolicy = NSMergePolicy(merge: mergePolicyType)
        
        switch concurrencyType {
        case .mainQueueConcurrencyType:
            childContext.parent = mainContext
        case .privateQueueConcurrencyType:
            childContext.parent = backgroundContext
        case .confinementConcurrencyType:
            fatalError("*** Error: confinementConcurrencyType is not supported because it is being deprecated in iOS 9.0")
        }
        
        if let name = childContext.parent?.name {
            childContext.name = name + ".child"
        }
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didReceiveChildContextDidSave(notification:)),
                                               name: NSNotification.Name.NSManagedObjectContextDidSave,
                                               object: childContext)
        return childContext
    }
    
    func reset(onQueue queue: DispatchQueue = .global(qos: .userInitiated),
               completion: @escaping (Result<CoreDataStack>) -> Void) {
        
        mainContext.performAndWait { self.mainContext.reset() }
        backgroundContext.performAndWait { self.backgroundContext.reset() }
        
        guard let store = storeCoordinator.persistentStores.first else {
            DispatchQueue.main.async {
                completion(.success(self))
            }
            return
        }
        
        queue.async {
            precondition(!Thread.isMainThread, "*** Error: cannot reset a stack on the main queue")
            
            let storeCoordinator = self.storeCoordinator
            let options = store.options
            let model = self.model
            
            storeCoordinator.performAndWait {
                do {
                    if #available(iOS 9.0, *), let modelURL = model.storeURL {
                        try storeCoordinator.destroyPersistentStore(at: modelURL,
                                                                    ofType: model.storeType.type,
                                                                    options: options)
                    } else {
                        try model.removeExistingStore()
                        try storeCoordinator.remove(store)
                    }
                    
                    try storeCoordinator.addPersistentStore(ofType: model.storeType.type,
                                                            configurationName: nil,
                                                            at: model.storeURL,
                                                            options: options)
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                    return
                }
                
                DispatchQueue.main.async {
                    completion(.success(self))
                }
            }
        }
    }
    
    var description: String {
        return "\(CoreDataStack.self)(model=\(model.name); mainContext=\(mainContext); backgroundContext=\(backgroundContext))"
    }
    
    @objc private func didReceiveChildContextDidSave(notification: Notification) {
        guard let context = notification.object as? NSManagedObjectContext,
            let parentContext = context.parent else {
                return
        }
        
        CoreDataStack.saveContext(parentContext)
    }
    
    @objc private func didReceiveBackgroundContextDidSave(notification: Notification) {
        mainContext.perform {
            self.mainContext.mergeChanges(fromContextDidSave: notification)
        }
    }
    
    @objc private func didReceiveMainContextDidSave(notification: Notification) {
        backgroundContext.perform {
            self.backgroundContext.mergeChanges(fromContextDidSave: notification)
        }
    }
    
    static func saveContext(_ context: NSManagedObjectContext, wait: Bool = true, completion: ((Result<Void>) -> Void)? = nil) {
        let block = {
            guard context.hasChanges else {
                return
            }
            do {
                try context.save()
                completion?(.success())
            } catch {
                completion?(.failure(error as NSError))
            }
        }
        wait ? context.performAndWait(block) : context.perform(block)
    }
}
