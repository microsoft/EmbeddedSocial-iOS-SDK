//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

final class MockCache: CacheType {
    private(set) var cacheIncomingCount = 0
    private(set) var cacheOutgoingCount = 0
    
    private(set) var firstIncomingCount = 0
    private(set) var fetchIncomingSyncCount = 0
    private(set) var fetchIncomingAsyncCount = 0
    
    private(set) var firstOutgoingCount = 0
    private(set) var fetchOutgoingSyncCount = 0
    private(set) var fetchOutgoingAsyncCount = 0
    
    var firstIncoming: Cacheable?
    var incomingItems: [Cacheable] = []
    
    var firstOutgoing: Cacheable?
    var outgoingItems: [Cacheable] = []
    
    func cacheIncoming<T: Cacheable>(_ item: T) {
        cacheIncomingCount += 1
    }
    
    func cacheOutgoing<T: Cacheable>(_ item: T) {
        cacheOutgoingCount += 1
    }
    
    func firstIncoming<T: Cacheable>(ofType type: T.Type, handle: String) -> T? {
        firstIncomingCount += 1
        return firstIncoming as? T
    }
    
    func fetchIncoming<T: Cacheable>(type: T.Type, sortDescriptors: [NSSortDescriptor]?) -> [T] {
        fetchIncomingSyncCount += 1
        return (incomingItems as? [T]) ?? []
    }
    
    func fetchIncoming<T: Cacheable>(type: T.Type, sortDescriptors: [NSSortDescriptor]?, result: @escaping FetchResult<T>) {
        fetchIncomingAsyncCount += 1
        result((incomingItems as? [T]) ?? [])
    }
    
    func firstOutgoing<T: Cacheable>(ofType type: T.Type, handle: String) -> T? {
        firstOutgoingCount += 1
        return firstOutgoing as? T
    }
    
    func fetchOutgoing<T: Cacheable>(type: T.Type, sortDescriptors: [NSSortDescriptor]?) -> [T] {
        fetchOutgoingSyncCount += 1
        return (outgoingItems as? [T]) ?? []
    }
    
    func fetchOutgoing<T: Cacheable>(type: T.Type, sortDescriptors: [NSSortDescriptor]?, result: @escaping FetchResult<T>) {
        fetchOutgoingAsyncCount += 1
        result((outgoingItems as? [T]) ?? [])
    }
}
