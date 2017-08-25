//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

protocol CacheType: class {
    typealias FetchResult<T> = ([T]) -> Void

    func cacheIncoming(_ item: Cacheable, typeID: String)
    func firstIncoming<Item: Cacheable>(ofType type: Item.Type, typeID: String, handle: String, sortDescriptors: [NSSortDescriptor]?) -> Item?
    func fetchIncoming<Item: Cacheable>(with request: CacheFetchRequest<Item>) -> [Item]
    func fetchIncoming<Item: Cacheable>(with request: CacheFetchRequest<Item>, result: @escaping FetchResult<Item>)
    
    func cacheOutgoing(_ item: Cacheable, typeID: String)
    func firstOutgoing<Item: Cacheable>(ofType type: Item.Type, typeID: String, handle: String, sortDescriptors: [NSSortDescriptor]?) -> Item?
    func fetchOutgoing<Item: Cacheable>(with request: CacheFetchRequest<Item>) -> [Item]
    func fetchOutgoing<Item: Cacheable>(with request: CacheFetchRequest<Item>, result: @escaping FetchResult<Item>)
}

extension CacheType {
    
    func firstIncoming<Item: Cacheable>(ofType type: Item.Type, handle: String) -> Item? {
        return firstIncoming(ofType: type, typeID: Item.typeIdentifier, handle: handle, sortDescriptors: nil)
    }
    
    func cacheOutgoing(_ item: Cacheable) {
        cacheOutgoing(item, typeID: item.typeIdentifier)
    }
    
    func cacheIncoming(_ item: Cacheable) {
        cacheIncoming(item, typeID: item.typeIdentifier)
    }
    
//    func fetchIncoming<T: Cacheable>(type: T.Type,
//                       predicate: NSPredicate?,
//                       sortDescriptors: [NSSortDescriptor]?) -> [T] {
//        return fetchIncoming(type: type, predicate: predicate, page: nil, sortDescriptors: sortDescriptors)
//    }
}
