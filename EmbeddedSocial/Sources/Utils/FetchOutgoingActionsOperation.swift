//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class FetchOutgoingActionsOperation: Operation {
    private let cache: CacheType
    
    var actions: [OutgoingAction] = []
    
    init(cache: CacheType) {
        self.cache = cache
    }
    
    override func main() {
        guard !isCancelled else { return }
        
        let p = PredicateBuilder.predicate(typeID: OutgoingAction.typeIdentifier)
        
        let request = CacheFetchRequest(resultType: OutgoingAction.self,
                                        predicate: p,
                                        sortDescriptors: [Cache.createdAtSortDescriptor])
        
        actions = cache.fetchOutgoing(with: request)
    }
}
