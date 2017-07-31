//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import CoreData

// swiftlint:disable vertical_parameter_alignment

extension NSManagedObjectContext {
    
    func first<Record: NSFetchRequestResult>(ofType: Record.Type = Record.self, with predicate: NSPredicate) throws -> Record? {
        let entityName = String(describing: Record.self)
        let fetchRequest = NSFetchRequest<Record>(entityName: entityName)
        fetchRequest.predicate = predicate
        let result = try fetch(fetchRequest)
        return result.first
    }
    
    func create<Record: CoreDataRecord>(_ type: Record.Type = Record.self) -> Record {
        print(Record.entityName)
        guard let record = NSEntityDescription.insertNewObject(forEntityName: Record.entityName, into: self) as? Record else {
            fatalError()
        }
        return record
    }
    
    func entities<Record: CoreDataRecord>(
        _ type: Record.Type = Record.self,
        predicate: NSPredicate? = nil,
        sortDescriptors: [NSSortDescriptor]? = nil,
        onResult: @escaping ([Record]) -> Void) {
        
        let request = Record.fetchRequest()
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        
        let asyncRequest = NSAsynchronousFetchRequest(fetchRequest: request) { result in
            onResult(result.finalResult ?? [])
        }
        
        perform { [weak self] in
            do {
                _ = try self?.execute(asyncRequest)
            } catch {
                print("Unable to execute asynchronous fetch result: \(error.localizedDescription).")
            }
        }
    }
}
