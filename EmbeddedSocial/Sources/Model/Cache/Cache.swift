//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class Cache: CacheType {
    
    private let database: TransactionsDatabaseFacadeType
    private let decoder: JSONDecoderProtocol.Type
    
    private let incomingQueries: Queries<IncomingTransaction>
    private let outgoingQueries: Queries<OutgoingTransaction>
    
    private let predicateBuilder: CachePredicateBuilder
    
    init(database: TransactionsDatabaseFacadeType,
         decoder: JSONDecoderProtocol.Type = Decoders.self,
         predicateBuilder: CachePredicateBuilder = PredicateBuilder()) {
        
        self.database = database
        self.decoder = decoder
        self.predicateBuilder = predicateBuilder
        
        incomingQueries = Queries(fetch: database.queryIncomingTransactions(with:page:sortDescriptors:),
                                  make: database.makeIncomingTransaction,
                                  fetchAsync: database.queryIncomingTransactions(with:page:sortDescriptors:completion:))
        
        outgoingQueries = Queries(fetch: database.queryOutgoingTransactions(with:page:sortDescriptors:),
                                  make: database.makeOutgoingTransaction,
                                  fetchAsync: database.queryOutgoingTransactions(with:page:sortDescriptors:completion:))
    }
    
    func cacheIncoming(_ item: Cacheable, for typeID: String) {
        updateTransaction(for: item, typeID: typeID, queries: incomingQueries)
    }
    
    func cacheOutgoing(_ item: Cacheable, for typeID: String) {
        updateTransaction(for: item, typeID: typeID, queries: outgoingQueries)
    }
    
    private func updateTransaction<T: Transaction>(for item: Cacheable, typeID: String, queries: Queries<T>) {
        var transaction = self.transaction(handle: item.getHandle(), typeID: typeID, queries: queries)
        transaction.typeid = typeID
        transaction.payload = item.encodeToJSON()
        transaction.handle = item.getHandle()
        transaction.relatedHandle = item.getRelatedHandle()
        database.save(transaction: transaction)
    }
    
    private func transaction<T: Transaction>(handle: String?, typeID: String, queries: Queries<T>) -> T {
        let p = handle == nil ? predicateBuilder.predicate(typeID: typeID) : predicateBuilder.predicate(typeID: typeID, handle: handle!)
        return queries.fetch(p, nil, nil).first ?? queries.make()
    }
    
    func firstIncoming<Item: Cacheable>(ofType type: Item.Type, predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) -> Item? {
        return first(predicate: predicate, sortDescriptors: sortDescriptors, queries: incomingQueries)
    }
    
    func firstIncoming<Item: Cacheable>(ofType type: Item.Type, handle: String) -> Item? {
        let p = predicateBuilder.predicate(typeID: type.typeIdentifier, handle: handle)
        return firstIncoming(ofType: type, predicate: p, sortDescriptors: nil)
    }
    
    func firstIncoming<Item: Cacheable>(ofType type: Item.Type, typeID: String) -> Item? {
        let p = predicateBuilder.predicate(typeID: typeID)
        return firstIncoming(ofType: type, predicate: p, sortDescriptors: nil)
    }
    
    func firstOutgoing<Item: Cacheable>(ofType type: Item.Type, predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) -> Item? {
        return first(predicate: predicate, sortDescriptors: sortDescriptors, queries: outgoingQueries)
    }
    
    private func first<T: Transaction, Item: Cacheable>(predicate: NSPredicate?,
                       sortDescriptors: [NSSortDescriptor]?,
                       queries: Queries<T>) -> Item? {
        
        return queries.fetch(predicate, nil, sortDescriptors)
            .flatMap { self.decoder.decode(type: Item.self, payload: $0.payload) }
            .first
    }
    
    func fetchIncoming<Item: Cacheable>(with request: CacheFetchRequest<Item>) -> [Item] {
        return fetch(request: request, queries: incomingQueries)
    }
    
    func fetchIncoming<Item: Cacheable>(with request: CacheFetchRequest<Item>, result: @escaping FetchResult<Item>) {
        fetchAsync(request: request, queries: incomingQueries, result: result)
    }

    func fetchOutgoing<Item: Cacheable>(with request: CacheFetchRequest<Item>) -> [Item] {
        return fetch(request: request, queries: outgoingQueries)
    }
    
    func fetchOutgoing<Item: Cacheable>(with request: CacheFetchRequest<Item>, result: @escaping FetchResult<Item>) {
        fetchAsync(request: request, queries: outgoingQueries, result: result)
    }

    private func fetch<T: Transaction, Item: Cacheable>(request: CacheFetchRequest<Item>, queries: Queries<T>) -> [Item] {
        return queries.fetch(request.predicate, request.page, request.sortDescriptors).flatMap { [weak self] tr in
            self?.decodeTransaction(tr, itemType: request.resultType)
        }
    }

    private func fetchAsync<T: Transaction, Item: Cacheable>(request: CacheFetchRequest<Item>,
                            queries: Queries<T>,
                            result: @escaping FetchResult<Item>) {
        
        queries.fetchAsync(request.predicate, request.page, request.sortDescriptors) { [weak self] trs in
            let items = trs.flatMap { self?.decodeTransaction($0, itemType: request.resultType) }
            result(items)
        }
    }
    
    private func decodeTransaction<Item: Cacheable>(_ tr: Transaction, itemType: Item.Type) -> Item? {
        let item = decoder.decode(type: itemType, payload: tr.payload)
        item?.setHandle(tr.handle)
        item?.setRelatedHandle(tr.relatedHandle)
        return item
    }
    
    func deleteIncoming(with predicate: NSPredicate) {
        let transactions = database.queryIncomingTransactions(with: predicate, page: nil, sortDescriptors: nil)
        database.deleteIncomingTransactions(transactions)
    }
    
    func deleteOutgoing(with predicate: NSPredicate) {
        let transactions = database.queryOutgoingTransactions(with: predicate, page: nil, sortDescriptors: nil)
        database.deleteOutgoingTransactions(transactions)
    }
}
