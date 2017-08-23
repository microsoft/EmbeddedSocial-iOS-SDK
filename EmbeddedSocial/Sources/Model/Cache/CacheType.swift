//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

protocol CacheType: class {
    typealias FetchResult<T> = ([T]) -> Void

    func cacheIncoming(_ item: Cacheable, typeID: String)
    func cacheOutgoing(_ item: Cacheable, typeID: String)
    
    func firstIncoming<T: Cacheable>(ofType type: T.Type, typeID: String, handle: String, sortDescriptors: [NSSortDescriptor]?) -> T?
    
    func firstOutgoing<T: Cacheable>(ofType type: T.Type, typeID: String, handle: String, sortDescriptors: [NSSortDescriptor]?) -> T?

    func fetchIncoming<T: Cacheable>(type: T.Type,
                       predicate: NSPredicate?,
                       page: (limit: Int, offset: Int)?,
                       sortDescriptors: [NSSortDescriptor]?) -> [T]
    
    func fetchIncoming<T: Cacheable>(type: T.Type, predicate: NSPredicate?,
                       sortDescriptors: [NSSortDescriptor]?, result: @escaping FetchResult<T>)

    func fetchOutgoing<T: Cacheable>(type: T.Type, predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) -> [T]
    func fetchOutgoing<T: Cacheable>(type: T.Type, predicate: NSPredicate?,
                       sortDescriptors: [NSSortDescriptor]?, result: @escaping FetchResult<T>)
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
    
    func fetchIncoming<T: Cacheable>(type: T.Type,
                       predicate: NSPredicate?,
                       sortDescriptors: [NSSortDescriptor]?) -> [T] {
        return fetchIncoming(type: type, predicate: predicate, page: nil, sortDescriptors: sortDescriptors)
    }
}
