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
                                   sortDescriptors: [NSSortDescriptor]?,
                                   completion: @escaping ([IncomingTransaction]) -> Void)
    
    func queryIncomingTransactions(with predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) -> [IncomingTransaction]
    
    func queryOutgoingTransactions(with predicate: NSPredicate?,
                                   sortDescriptors: [NSSortDescriptor]?,
                                   completion: @escaping ([OutgoingTransaction]) -> Void)
    
    func queryOutgoingTransactions(with predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) -> [OutgoingTransaction]

    func deleteIncomingTransactions(_ entities: [IncomingTransaction], completion: ((Result<Void>) -> Void)?)
    
    func deleteOutgoingTransactions(_ entities: [OutgoingTransaction], completion: ((Result<Void>) -> Void)?)
}
