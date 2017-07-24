//
//  TransactionsDatabaseFacadeType.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/24/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import Foundation

protocol TransactionsDatabaseFacadeType {
    func save(transaction: IncomingTransaction)
    
    func save(transaction: OutgoingTransaction)
    
    func makeIncomingTransaction() -> IncomingTransaction
    
    func makeOutgoingTransaction() -> OutgoingTransaction
    
    func queryIncomingTransactions(with predicate: NSPredicate?,
                                   sortDescriptors: [NSSortDescriptor]?,
                                   completion: @escaping ([IncomingTransaction]) -> Void)
    
    func queryOutgoingTransactions(with predicate: NSPredicate?,
                                   sortDescriptors: [NSSortDescriptor]?,
                                   completion: @escaping ([OutgoingTransaction]) -> Void)
    
    func deleteIncomingTransactions(_ entities: [IncomingTransaction], completion: ((Result<Void>) -> Void)?)
    
    func deleteOutgoingTransactions(_ entities: [OutgoingTransaction], completion: ((Result<Void>) -> Void)?)
}
