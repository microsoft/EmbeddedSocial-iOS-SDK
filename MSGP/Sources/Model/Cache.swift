//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol Cachable {
    @discardableResult func cacheIncoming(object: JSONEncodable) -> IncomingTransaction
    
    @discardableResult func cacheOutgoing(object: JSONEncodable) -> OutgoingTransaction
}

class Cache: Cachable {
    
    private let database: TransactionsDatabaseFacadeType
    
    init(database: TransactionsDatabaseFacadeType) {
        self.database = database
    }
    
    @discardableResult func cacheIncoming(object: JSONEncodable) -> IncomingTransaction {
        let transactionModel = database.makeIncomingTransaction()
        transactionModel.payload = object.encodeToJSON() as? [String : Any]
        database.save(transaction: transactionModel)
        return transactionModel
    }
    
    @discardableResult func cacheOutgoing(object: JSONEncodable) -> OutgoingTransaction {
        let transactionModel = database.makeOutgoingTransaction()
        transactionModel.payload = object.encodeToJSON() as? [String : Any]
        database.save(transaction: transactionModel)
        return transactionModel
    }

}
