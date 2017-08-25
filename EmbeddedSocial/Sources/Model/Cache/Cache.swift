//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class Cache: CacheType {
    
    struct Queries<T: Transaction> {
        typealias Fetch<T: Transaction> = (NSPredicate?, QueryPage?, [NSSortDescriptor]?) -> [T]
        typealias Make<T: Transaction> = () -> T
        typealias AsyncFetch<T: Transaction> = (NSPredicate?, QueryPage?, [NSSortDescriptor]?, @escaping ([T]) -> Void) -> Void
        
        let fetch: Fetch<T>
        let make: Make<T>
        let fetchAsync: AsyncFetch<T>
    }

    static let createdAtSortDescriptor = NSSortDescriptor(key: "createdAt", ascending: false)

    private let database: TransactionsDatabaseFacadeType
    private let decoder: JSONDecoder.Type
    
    private let incomingQueries: Queries<IncomingTransaction>
    private let outgoingQueries: Queries<OutgoingTransaction>
    
    private let predicateBuilder: CachePredicateBuilder
    
    init(database: TransactionsDatabaseFacadeType,
         decoder: JSONDecoder.Type = Decoders.self,
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
    
    func cacheIncoming(_ item: Cacheable, typeID: String) {
        updateTransaction(for: item, typeID: typeID, queries: incomingQueries)
    }
    
    func cacheOutgoing(_ item: Cacheable, typeID: String) {
        updateTransaction(for: item, typeID: typeID, queries: outgoingQueries)
    }
    
    private func updateTransaction<T: Transaction>(for item: Cacheable, typeID: String, queries: Queries<T>) {
        var transaction = self.transaction(handle: item.getHandle(), typeID: typeID, queries: queries)
        transaction.typeid = item.typeIdentifier
        transaction.payload = item.encodeToJSON()
        transaction.handle = item.getHandle()
        transaction.relatedHandle = item.getRelatedHandle()
        database.save(transaction: transaction)
    }
    
    private func transaction<T: Transaction>(handle: String?, typeID: String, queries: Queries<T>) -> T {
        guard let handle = handle else {
            return queries.make()
        }
        let p = predicateBuilder.predicate(handle: handle)
        return queries.fetch(p, nil, nil).first ?? queries.make()
    }
    
    func firstIncoming<Item: Cacheable>(ofType type: Item.Type,
                       typeID: String,
                       handle: String,
                       sortDescriptors: [NSSortDescriptor]?) -> Item? {
        let p = predicateBuilder.predicate(typeID: typeID, handle: handle)
        return first(predicate: p, sortDescriptors: sortDescriptors, queries: incomingQueries)
    }
    
    func firstOutgoing<Item: Cacheable>(ofType type: Item.Type,
                       typeID: String,
                       handle: String,
                       sortDescriptors: [NSSortDescriptor]?) -> Item? {
        let p = predicateBuilder.predicate(typeID: typeID, handle: handle)
        return first(predicate: p, sortDescriptors: sortDescriptors, queries: outgoingQueries)
    }
    
    private func first<T: Transaction, Item: Cacheable>(predicate: NSPredicate?,
                       sortDescriptors: [NSSortDescriptor]?,
                       queries: Queries<T>) -> Item? {
        
        return queries.fetch(predicate, nil, sortDescriptors)
            .flatMap { self.decoder.decode(type: Item.self, payload: $0.payload) }
            .first
    }
    
    func fetchIncoming<Item: Cacheable>(with request: CacheFetchRequest<Item>) -> [Item] {
        return incomingQueries.fetch(request.predicate, request.page, request.sortDescriptors).flatMap { [weak self] tr in
            return self?.decoder.decode(type: Item.self, payload: tr.payload)
        }
    }
    
    func fetchIncoming<Item: Cacheable>(with request: CacheFetchRequest<Item>, result: @escaping FetchResult<Item>) {
        incomingQueries.fetchAsync(request.predicate, request.page, request.sortDescriptors) {
            let items = $0.flatMap { self.decoder.decode(type: Item.self, payload: $0.payload) }
            result(items)
        }
    }
    
    func fetchOutgoing<Item: Cacheable>(with request: CacheFetchRequest<Item>) -> [Item] {
        return outgoingQueries.fetch(request.predicate, request.page, request.sortDescriptors).flatMap { [weak self] tr in
            return self?.decoder.decode(type: Item.self, payload: tr.payload)
        }
    }
    
    func fetchOutgoing<Item: Cacheable>(with request: CacheFetchRequest<Item>, result: @escaping FetchResult<Item>) {
        outgoingQueries.fetchAsync(request.predicate, request.page, request.sortDescriptors) {
            let items = $0.flatMap { self.decoder.decode(type: Item.self, payload: $0.payload) }
            result(items)
        }
    }
    
//    func fetchIncoming<Item: Cacheable>(type: Item.Type,
//                       predicate: NSPredicate?,
//                       sortDescriptors: [NSSortDescriptor]?) -> [Item] {
//        return fetch(predicate: predicate, sortDescriptors: sortDescriptors, queries: incomingQueries)
//    }
//    
//    func fetchOutgoing<Item: Cacheable>(type: Item.Type, predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) -> [Item] {
//        return fetch(predicate: predicate, sortDescriptors: sortDescriptors, queries: outgoingQueries)
//    }
//    
//    private func fetch<T: Transaction, Item: Cacheable>(predicate: NSPredicate?,
//                       sortDescriptors: [NSSortDescriptor]?,
//                       queries: Queries<T>) -> [Item] {
//        return queries.fetch(predicate, nil, sortDescriptors).flatMap {
//            self.decoder.decode(type: Item.self, payload: $0.payload)
//        }
//    }
//    
//    func fetchIncoming<Item: Cacheable>(type: Item.Type, predicate: NSPredicate?,
//                       sortDescriptors: [NSSortDescriptor]?, result: @escaping FetchResult<Item>) {
//        fetchAsync(predicate: predicate, sortDescriptors: sortDescriptors, queries: incomingQueries, result: result)
//    }
//    
//    func fetchOutgoing<Item: Cacheable>(type: Item.Type, predicate: NSPredicate?,
//                       sortDescriptors: [NSSortDescriptor]?, result: @escaping FetchResult<Item>){
//        fetchAsync(predicate: predicate, sortDescriptors: sortDescriptors, queries: outgoingQueries, result: result)
//    }
//    
    private func fetchAsync<T: Transaction, Item: Cacheable>(predicate: NSPredicate?,
                            sortDescriptors: [NSSortDescriptor]?,
                            queries: Queries<T>,
                            result: @escaping FetchResult<Item>) {
        
        queries.fetchAsync(predicate, nil, sortDescriptors) {
            let items = $0.flatMap { self.decoder.decode(type: Item.self, payload: $0.payload) }
            result(items)
        }
    }
}
