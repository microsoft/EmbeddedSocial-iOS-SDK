//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

typealias FetchResult<T> = ([T]) -> Void

struct CacheRequest {
    let type: Cacheable.Type
    let sortDescriptors: [NSSortDescriptor]?
    let handle: String?
}

protocol CacheType: class {
    @discardableResult func cacheIncoming(object: Cacheable) -> IncomingTransaction
    
    func fetchIncoming<T: Cacheable>(request: CacheRequest) -> [T]
    func fetchIncoming<T: Cacheable>(type: T.Type, sortDescriptors: [NSSortDescriptor]?) -> [T]
    func fetchIncoming<T: Cacheable>(type: T.Type, sortDescriptors: [NSSortDescriptor]?, result: @escaping FetchResult<T>)
    
    @discardableResult func cacheOutgoing(object: Cacheable) -> OutgoingTransaction
    
    func fetchOutgoing<T: Cacheable>(type: T.Type, sortDescriptors: [NSSortDescriptor]?) -> [T]
    func fetchOutgoing<T: Cacheable>(type: T.Type, sortDescriptors: [NSSortDescriptor]?, result: @escaping FetchResult<T>)
}
