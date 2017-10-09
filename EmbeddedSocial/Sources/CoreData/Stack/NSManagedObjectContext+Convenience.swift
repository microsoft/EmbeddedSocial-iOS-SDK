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
        guard let record = NSEntityDescription.insertNewObject(forEntityName: Record.entityName, into: self) as? Record else {
            fatalError()
        }
        return record
    }
    
    func entities<Record: CoreDataRecord>(_ type: Record.Type = Record.self,
                  page: QueryPage? = nil,
                  predicate: NSPredicate? = nil,
                  sortDescriptors: [NSSortDescriptor]? = nil,
                  onResult: @escaping ([Record]) -> Void) {
        
        let request = makeFetchRequest(type: type, page: page, predicate: predicate, sortDescriptors: sortDescriptors)
        
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
    
    func entities<Record: CoreDataRecord>(_ type: Record.Type = Record.self,
                  page: QueryPage? = nil,
                  predicate: NSPredicate? = nil,
                  sortDescriptors: [NSSortDescriptor]? = nil) -> [Record] {
        
        let request = makeFetchRequest(type: type, page: page, predicate: predicate, sortDescriptors: sortDescriptors)
        
        var records: [Record] = []
        
        performAndWait { [weak self] in
            do {
                records = try self?.fetch(request) ?? []
            } catch {
                print("Unable to execute asynchronous fetch result: \(error.localizedDescription).")
            }
        }
        
        return records
    }
    
    private func makeFetchRequest<T: CoreDataRecord>(type: T.Type = T.self,
                                  page: QueryPage?,
                                  predicate: NSPredicate?,
                                  sortDescriptors: [NSSortDescriptor]?) -> NSFetchRequest<T> {
        
        let request = T.fetchRequest()
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        
        if let page = page {
            request.fetchBatchSize = page.limit
            request.fetchOffset = page.offset
        }
        
        return request
    }
}
