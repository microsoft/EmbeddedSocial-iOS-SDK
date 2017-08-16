//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class Cache: CacheType {
    
    struct Queries<T: Transaction> {
        typealias Fetch<T: Transaction> = (NSPredicate?, [NSSortDescriptor]?) -> [T]
        typealias Make<T: Transaction> = () -> T
        typealias AsyncFetch<T: Transaction> = (NSPredicate?, [NSSortDescriptor]?, @escaping ([T]) -> Void) -> Void
        
        let fetch: Fetch<T>
        let make: Make<T>
        let fetchAsync: AsyncFetch<T>
    }

    private let database: TransactionsDatabaseFacadeType
    private let decoder: JSONDecoder.Type
    
    private let incomingQueries: Queries<IncomingTransaction>
    private let outgoingQueries: Queries<OutgoingTransaction>
    
    init(database: TransactionsDatabaseFacadeType, decoder: JSONDecoder.Type = Decoders.self) {
        self.database = database
        self.decoder = decoder
        
        incomingQueries = Queries(fetch: database.queryIncomingTransactions(with:sortDescriptors:),
                                  make: database.makeIncomingTransaction,
                                  fetchAsync: database.queryIncomingTransactions(with:sortDescriptors:completion:))
        
        outgoingQueries = Queries(fetch: database.queryOutgoingTransactions(with:sortDescriptors:),
                                  make: database.makeOutgoingTransaction,
                                  fetchAsync: database.queryOutgoingTransactions(with:sortDescriptors:completion:))
    }
    
    func cacheIncoming<Item: Cacheable>(_ item: Item) {
        updateTransaction(for: item, queries: incomingQueries)
    }
    
    func cacheOutgoing<Item: Cacheable>(_ item: Item) {
        updateTransaction(for: item, queries: outgoingQueries)
    }
    
    private func updateTransaction<T: Transaction, Item: Cacheable>(for item: Item, queries: Queries<T>) {
        var transaction = self.transaction(for: item, queries: queries)
        transaction.typeid = item.typeIdentifier
        transaction.payload = item.encodeToJSON()
        transaction.handle = item.getHandle()
        database.save(transaction: transaction)
    }
    
    private func transaction<T: Transaction, Item: Cacheable>(for item: Item, queries: Queries<T>) -> T {
        guard let handle = item.getHandle() else {
            return queries.make()
        }
        let p = predicate(with: Item.self, handle: handle)
        return queries.fetch(p, nil).first ?? queries.make()
    }
    
    func firstIncoming<Item: Cacheable>(ofType type: Item.Type, handle: String) -> Item? {
        return first(ofType: Item.self, handle: handle, queries: incomingQueries)
    }
    
    func firstOutgoing<Item: Cacheable>(ofType type: Item.Type, handle: String) -> Item? {
        return first(ofType: Item.self, handle: handle, queries: outgoingQueries)
    }
    
    private func first<T: Transaction, Item: Cacheable>(ofType type: Item.Type, handle: String, queries: Queries<T>) -> Item? {
        let p = predicate(with: type, handle: handle)
        let items = queries.fetch(p, nil).flatMap { self.decoder.decode(type: type, payload: $0.payload) }
        return items.first
    }
    
    func fetchIncoming<Item: Cacheable>(type: Item.Type, sortDescriptors: [NSSortDescriptor]?) -> [Item] {
        return fetch(type: Item.self, sortDescriptors: sortDescriptors, queries: incomingQueries)
    }
    
    func fetchOutgoing<Item: Cacheable>(type: Item.Type, sortDescriptors: [NSSortDescriptor]?) -> [Item] {
        return fetch(type: Item.self, sortDescriptors: sortDescriptors, queries: outgoingQueries)
    }
    
    private func fetch<T: Transaction, Item: Cacheable>(type: Item.Type,
                       sortDescriptors: [NSSortDescriptor]?,
                       queries: Queries<T>) -> [Item] {
        
        return queries.fetch(predicate(with: Item.self), sortDescriptors).flatMap {
            self.decoder.decode(type: type, payload: $0.payload)
        }
    }
    
    func fetchIncoming<Item: Cacheable>(type: Item.Type, sortDescriptors: [NSSortDescriptor]?, result: @escaping FetchResult<Item>) {
        fetchAsync(type: Item.self, sortDescriptors: sortDescriptors, queries: incomingQueries, result: result)
    }
    
    func fetchOutgoing<Item: Cacheable>(type: Item.Type, sortDescriptors: [NSSortDescriptor]?, result: @escaping FetchResult<Item>) {
        fetchAsync(type: Item.self, sortDescriptors: sortDescriptors, queries: outgoingQueries, result: result)
    }
    
    private func fetchAsync<T: Transaction, Item: Cacheable>(type: Item.Type,
                            sortDescriptors: [NSSortDescriptor]?,
                            queries: Queries<T>,
                            result: @escaping FetchResult<Item>) {
        
        queries.fetchAsync(predicate(with: Item.self), sortDescriptors) {
            let items = $0.flatMap { self.decoder.decode(type: Item.self, payload: $0.payload) }
            result(items)
        }
    }
    
    private func predicate(with type: Cacheable.Type, handle: String? = nil) -> NSPredicate {
        if let handle = handle {
            return NSPredicate(format: "typeid = %@ AND handle = %@", type.typeIdentifier, handle)
        } else {
            return NSPredicate(format: "typeid = %@", type.typeIdentifier)
        }
    }
}
