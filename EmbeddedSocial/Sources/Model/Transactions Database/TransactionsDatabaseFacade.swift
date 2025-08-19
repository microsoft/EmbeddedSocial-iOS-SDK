//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class TransactionsDatabaseFacade: TransactionsDatabaseFacadeType {
    private let incomingRepo: QueriableRepository<IncomingTransaction>
    private let outgoingRepo: QueriableRepository<OutgoingTransaction>
    
    init(incomingRepo: QueriableRepository<IncomingTransaction>, outgoingRepo: QueriableRepository<OutgoingTransaction>) {
        self.incomingRepo = incomingRepo
        self.outgoingRepo = outgoingRepo
    }
    
    func save(transaction: IncomingTransaction) {
        incomingRepo.save([transaction])
    }
    
    func save(transaction: OutgoingTransaction) {
        outgoingRepo.save([transaction])
    }
    
    func makeIncomingTransaction() -> IncomingTransaction {
        return incomingRepo.create()
    }
    
    func makeOutgoingTransaction() -> OutgoingTransaction {
        return outgoingRepo.create()
    }
    
    func queryIncomingTransactions(with predicate: NSPredicate?,
                                   page: QueryPage?,
                                   sortDescriptors: [NSSortDescriptor]?) -> [IncomingTransaction] {
        return incomingRepo.query(with: predicate, page: page, sortDescriptors: sortDescriptors)
    }
    
    func queryIncomingTransactions(with predicate: NSPredicate? = nil,
                                   page: QueryPage?,
                                   sortDescriptors: [NSSortDescriptor]? = nil,
                                   completion: @escaping ([IncomingTransaction]) -> Void) {
        return incomingRepo.query(with: predicate, page: page, sortDescriptors: sortDescriptors, completion: completion)
    }
    
    func queryOutgoingTransactions(with predicate: NSPredicate?,
                                   page: QueryPage?,
                                   sortDescriptors: [NSSortDescriptor]?) -> [OutgoingTransaction] {
        return outgoingRepo.query(with: predicate, page: page, sortDescriptors: sortDescriptors)
    }
    
    func queryOutgoingTransactions(with predicate: NSPredicate? = nil,
                                   page: QueryPage?,
                                   sortDescriptors: [NSSortDescriptor]? = nil,
                                   completion: @escaping ([OutgoingTransaction]) -> Void) {
        return outgoingRepo.query(with: predicate, page: page, sortDescriptors: sortDescriptors, completion: completion)
    }
    
    func deleteIncomingTransactions(_ entities: [IncomingTransaction]) {
        incomingRepo.delete(entities)
    }
    
    func deleteOutgoingTransactions(_ entities: [OutgoingTransaction]) {
        outgoingRepo.delete(entities)
    }
}
