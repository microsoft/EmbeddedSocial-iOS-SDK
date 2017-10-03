//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol RelatedHandleUpdater {
    func updateRelatedHandle(from oldHandle: String?, to newHandle: String?, predicate: NSPredicate)
}

struct OutgoingCommandsRelatedHandleUpdater: RelatedHandleUpdater {
    private let cache: CacheType
    
    init(cache: CacheType = SocialPlus.shared.cache) {
        self.cache = cache
    }
    
    func updateRelatedHandle(from oldHandle: String?, to newHandle: String?, predicate: NSPredicate) {
        let request = CacheFetchRequest(resultType: OutgoingCommand.self,
                                        predicate: predicate,
                                        sortDescriptors: [Cache.createdAtSortDescriptor])
        
        let commands = cache.fetchOutgoing(with: request)
        
        commands.forEach { $0.setRelatedHandle(newHandle) }
        
        cache.deleteOutgoing(with: predicate)
        
        commands.forEach(cache.cacheOutgoing)
    }
}
