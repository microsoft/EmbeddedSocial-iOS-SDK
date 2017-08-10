//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol CacheType {
    @discardableResult func cacheIncoming(object: JSONEncodable) -> IncomingTransaction
    
    @discardableResult func cacheOutgoing(object: JSONEncodable) -> OutgoingTransaction
    
    func fetchIncoming<T: JSONEncodable>(type: T.Type, sortDescriptors: [NSSortDescriptor]?, result: @escaping FetchResult)
    
    func fetchOutgoing<T: JSONEncodable>(type: T.Type, sortDescriptors: [NSSortDescriptor]?, result: @escaping FetchResult)
    
}

typealias FetchResult = ([JSONEncodable]) -> Void

class Cache: CacheType {
    
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
            for cachedModel in incoming {
                guard let model = Decoders.decodeOptional(clazz: type, source: cachedModel.payload as AnyObject) as? T else {
                    continue
                }
                
                models.append(model)
            }
                                            
            result(models)
        }
    }
    
    func fetchOutgoing<T: JSONEncodable>(type: T.Type, sortDescriptors: [NSSortDescriptor]?, result: @escaping FetchResult) {
        database.queryOutgoingTransactions(with: NSPredicate(format: "typeid = %@", String(describing: type)),
                                           sortDescriptors: sortDescriptors) { (outgoing) in
            var models = [T]()
            for cachedModel in outgoing {
                guard let model = Decoders.decodeOptional(clazz: type, source: cachedModel.payload as AnyObject) as? T else {
                    continue
                }
                
                models.append(model)
            }
                                            
            result(models)
        }
    }
}
