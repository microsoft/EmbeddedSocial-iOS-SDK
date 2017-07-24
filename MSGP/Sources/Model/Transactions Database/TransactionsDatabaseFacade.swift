//
//  TransactionsDatabaseFacade.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/24/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import Foundation

final class TransactionsDatabaseFacade: TransactionsDatabaseFacadeType {
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
                                   sortDescriptors: [NSSortDescriptor]?,
                                   completion: @escaping ([IncomingTransaction]) -> Void) {
        return incomingRepo.query(with: predicate, sortDescriptors: sortDescriptors, completion: completion)
    }
    
    func queryOutgoingTransactions(with predicate: NSPredicate?,
                                   sortDescriptors: [NSSortDescriptor]?,
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
