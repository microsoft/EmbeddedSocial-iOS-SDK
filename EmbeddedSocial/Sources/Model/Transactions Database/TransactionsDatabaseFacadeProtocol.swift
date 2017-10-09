//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol TransactionsDatabaseFacadeType {
    func save(transaction: IncomingTransaction)
    
    func save(transaction: OutgoingTransaction)
    
    func makeIncomingTransaction() -> IncomingTransaction
    
    func makeOutgoingTransaction() -> OutgoingTransaction
    
    func queryIncomingTransactions(with predicate: NSPredicate?,
                                   page: QueryPage?,
                                   sortDescriptors: [NSSortDescriptor]?,
                                   completion: @escaping ([IncomingTransaction]) -> Void)
    
    func queryIncomingTransactions(with predicate: NSPredicate?,
                                   page: QueryPage?,
                                   sortDescriptors: [NSSortDescriptor]?) -> [IncomingTransaction]
    
    func queryOutgoingTransactions(with predicate: NSPredicate?,
                                   page: QueryPage?,
                                   sortDescriptors: [NSSortDescriptor]?,
                                   completion: @escaping ([OutgoingTransaction]) -> Void)
    
    func queryOutgoingTransactions(with predicate: NSPredicate?,
                                   page: QueryPage?,
                                   sortDescriptors: [NSSortDescriptor]?) -> [OutgoingTransaction]

    func deleteIncomingTransactions(_ entities: [IncomingTransaction])
    
    func deleteOutgoingTransactions(_ entities: [OutgoingTransaction])
}

extension TransactionsDatabaseFacadeType {
    func save(transaction: Transaction) {
        if let tr = transaction as? IncomingTransaction {
            save(transaction: tr)
        } else if let tr = transaction as? OutgoingTransaction {
            save(transaction: tr)
        } else {
            fatalError("Cannot save transaction \(transaction)")
        }
    }
}
