//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class Cache: CacheType {
    
    private let database: TransactionsDatabaseFacadeType
    
    init(database: TransactionsDatabaseFacadeType) {
        self.database = database
    }
    
    @discardableResult func cacheIncoming(object: Cacheable) -> IncomingTransaction {
        let transactionModel = database.makeIncomingTransaction()
        transactionModel.typeid = String(describing: type(of: object))
        transactionModel.payload = object.encodeToJSON() as? [String : Any]
        database.save(transaction: transactionModel)
        return transactionModel
    }
    
    @discardableResult func cacheOutgoing(object: Cacheable) -> OutgoingTransaction {
        let transactionModel = database.makeOutgoingTransaction()
        transactionModel.typeid = String(describing: type(of: object))
        transactionModel.payload = object.encodeToJSON() as? [String : Any]
        database.save(transaction: transactionModel)
        return transactionModel
    }

    func fetchIncoming<T: Cacheable>(type: T.Type, sortDescriptors: [NSSortDescriptor]?, result: @escaping FetchResult<T>) {
        database.queryIncomingTransactions(
            with: NSPredicate(format: "typeid = %@", String(describing: type)),
            sortDescriptors: sortDescriptors) { transactions in
                let models = transactions.flatMap {
                    Decoders.decodeOptional(clazz: type, source: $0.payload as AnyObject).value as? T
                }
                result(models)
        }
    }
    
    func fetchIncoming<T: Cacheable>(type: T.Type, sortDescriptors: [NSSortDescriptor]?) -> [T] {
        let p = NSPredicate(format: "typeid = %@", String(describing: type))
        let records = database.queryIncomingTransactions(with: p, sortDescriptors: sortDescriptors)
        return records.flatMap {
            Decoders.decodeOptional(clazz: type, source: $0.payload as AnyObject).value as? T
        }
    }
    
    func fetchIncoming<T: Cacheable>(request: CacheRequest) -> [T] {
        let p = NSPredicate(format: "typeid = %@ AND handle = %@", String(describing: request.type), request.handle)
        let records = database.queryIncomingTransactions(with: p, sortDescriptors: request.sortDescriptors)
        return records.flatMap {
            Decoders.decodeOptional(clazz: type, source: $0.payload as AnyObject).value as? T
        }
    }
    
    func fetchOutgoing<T: Cacheable>(type: T.Type, sortDescriptors: [NSSortDescriptor]?, result: @escaping FetchResult<T>) {
        database.queryOutgoingTransactions(
            with: NSPredicate(format: "typeid = %@", String(describing: type)),
            sortDescriptors: sortDescriptors) { transactions in
                let models = transactions.flatMap {
                    Decoders.decodeOptional(clazz: type, source: $0.payload as AnyObject).value as? T
                }
                result(models)
        }
    }
    
    func fetchOutgoing<T: Cacheable>(type: T.Type, sortDescriptors: [NSSortDescriptor]?) -> [T] {
        let p = NSPredicate(format: "typeid = %@", String(describing: type))
        let records = database.queryOutgoingTransactions(with: p, sortDescriptors: sortDescriptors)
        return records.flatMap {
            Decoders.decodeOptional(clazz: type, source: $0.payload as AnyObject).value as? T
        }
    }
}
