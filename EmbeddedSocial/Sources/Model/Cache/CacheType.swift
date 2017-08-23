//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

protocol CacheType: class {
    typealias FetchResult<T> = ([T]) -> Void

    func cacheIncoming<T: Cacheable>(_ item: T)
    func cacheOutgoing<T: Cacheable>(_ item: T)
    
    func firstIncoming<T: Cacheable>(ofType type: T.Type, handle: String) -> T?
    func firstIncoming<T: Cacheable>(ofType type: T.Type, predicate: NSPredicate, sortDescriptors: [NSSortDescriptor]) -> T?
    
    func firstOutgoing<T: Cacheable>(ofType type: T.Type, handle: String) -> T?
    func firstOutgoing<T: Cacheable>(ofType type: T.Type, predicate: NSPredicate, sortDescriptors: [NSSortDescriptor]) -> T?

    func fetchIncoming<T: Cacheable>(type: T.Type, sortDescriptors: [NSSortDescriptor]?) -> [T]
    func fetchIncoming<T: Cacheable>(type: T.Type, predicate: NSPredicate, sortDescriptors: [NSSortDescriptor]?) -> [T]
    func fetchIncoming<T: Cacheable>(type: T.Type, sortDescriptors: [NSSortDescriptor]?, result: @escaping FetchResult<T>)
    func fetchIncoming<T: Cacheable>(type: T.Type, predicate: NSPredicate,
                       sortDescriptors: [NSSortDescriptor]?, result: @escaping FetchResult<T>)

    func fetchOutgoing<T: Cacheable>(type: T.Type, sortDescriptors: [NSSortDescriptor]?) -> [T]
    func fetchOutgoing<T: Cacheable>(type: T.Type, predicate: NSPredicate, sortDescriptors: [NSSortDescriptor]?) -> [T]
    func fetchOutgoing<T: Cacheable>(type: T.Type, sortDescriptors: [NSSortDescriptor]?, result: @escaping FetchResult<T>)
    func fetchOutgoing<T: Cacheable>(type: T.Type, predicate: NSPredicate,
                       sortDescriptors: [NSSortDescriptor]?, result: @escaping FetchResult<T>)
}
