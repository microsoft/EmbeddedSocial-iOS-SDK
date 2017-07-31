//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol Cachable {
    @discardableResult func cacheIncoming(object: JSONEncodable) -> IncomingTransaction
    
    @discardableResult func cacheOutgoing(object: JSONEncodable) -> OutgoingTransaction
    
    func fetchIncoming<T: JSONEncodable>(type: T.Type, sortDescriptors: [NSSortDescriptor]?, result: @escaping FetchResult)
    
    func fetchOutgoing<T: JSONEncodable>(type: T.Type, sortDescriptors: [NSSortDescriptor]?, result: @escaping FetchResult)
    
}

typealias FetchResult = ([JSONEncodable]) -> Void

class Cache: Cachable {
    
    private let database: TransactionsDatabaseFacadeType
    
    init(database: TransactionsDatabaseFacadeType) {
        self.database = database
    }
    
    @discardableResult func cacheIncoming(object: JSONEncodable) -> IncomingTransaction {
        let transactionModel = database.makeIncomingTransaction()
        transactionModel.typeid = String(describing: type(of: object))
        transactionModel.payload = object.encodeToJSON() as? [String : Any]
        database.save(transaction: transactionModel)
        return transactionModel
    }
    
    @discardableResult func cacheOutgoing(object: JSONEncodable) -> OutgoingTransaction {
        let transactionModel = database.makeOutgoingTransaction()
        transactionModel.typeid = String(describing: type(of: object))
        transactionModel.payload = object.encodeToJSON() as? [String : Any]
        database.save(transaction: transactionModel)
        return transactionModel
    }

    func fetchIncoming<T: JSONEncodable>(type: T.Type, sortDescriptors: [NSSortDescriptor]?, result: @escaping FetchResult) {
        database.queryIncomingTransactions(with: NSPredicate(format: "typeid = %@", String(describing: type)),
                                           sortDescriptors: sortDescriptors) { (incoming) in
            var models = [T]()
            _ = incoming.map { models.append(Decoders.decode(clazz: type, source: $0.payload as AnyObject)) }
            result(models)
        }
    }
    
    func fetchOutgoing<T: JSONEncodable>(type: T.Type, sortDescriptors: [NSSortDescriptor]?, result: @escaping FetchResult) {
        database.queryOutgoingTransactions(with: NSPredicate(format: "typeid = %@", String(describing: type)),
                                           sortDescriptors: sortDescriptors) { (incoming) in
            var models = [T]()
            _ = incoming.map { models.append(Decoders.decode(clazz: type, source: $0.payload as AnyObject)) }
            result(models)
        }
    }
}
