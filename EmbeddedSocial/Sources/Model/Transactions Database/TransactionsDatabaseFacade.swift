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
    
    func queryIncomingTransactions(with predicate: NSPredicate? = nil,
                                   sortDescriptors: [NSSortDescriptor]? = nil,
                                   completion: @escaping ([IncomingTransaction]) -> Void) {
        return incomingRepo.query(with: predicate, sortDescriptors: sortDescriptors, completion: completion)
    }
    
    func queryOutgoingTransactions(with predicate: NSPredicate? = nil,
                                   sortDescriptors: [NSSortDescriptor]? = nil,
                                   completion: @escaping ([OutgoingTransaction]) -> Void) {
        return outgoingRepo.query(with: predicate, sortDescriptors: sortDescriptors, completion: completion)
    }
    
    func deleteIncomingTransactions(_ entities: [IncomingTransaction], completion: ((Result<Void>) -> Void)?) {
        incomingRepo.delete(entities)
    }
    
    func deleteOutgoingTransactions(_ entities: [OutgoingTransaction], completion: ((Result<Void>) -> Void)?) {
        outgoingRepo.delete(entities)
    }
}
