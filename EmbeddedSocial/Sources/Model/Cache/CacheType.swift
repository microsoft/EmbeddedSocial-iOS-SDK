//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

protocol CacheType: class {
    typealias FetchResult<T> = ([T]) -> Void

    func cacheIncoming(_ item: Cacheable, for typeID: String)
    func firstIncoming<Item: Cacheable>(ofType type: Item.Type, handle: String) -> Item?
    func firstIncoming<Item: Cacheable>(ofType type: Item.Type, predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) -> Item?
    func fetchIncoming<Item: Cacheable>(with request: CacheFetchRequest<Item>) -> [Item]
    func fetchIncoming<Item: Cacheable>(with request: CacheFetchRequest<Item>, result: @escaping FetchResult<Item>)
    
    func cacheOutgoing(_ item: Cacheable, for typeID: String)
    func firstOutgoing<Item: Cacheable>(ofType type: Item.Type, predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) -> Item?
    func fetchOutgoing<Item: Cacheable>(with request: CacheFetchRequest<Item>) -> [Item]
    func fetchOutgoing<Item: Cacheable>(with request: CacheFetchRequest<Item>, result: @escaping FetchResult<Item>)
}

extension CacheType {
    
    func cacheOutgoing(_ item: Cacheable) {
        cacheOutgoing(item, for: item.typeIdentifier)
    }
    
    func cacheIncoming(_ item: Cacheable) {
        cacheIncoming(item, for: item.typeIdentifier)
    }
}
