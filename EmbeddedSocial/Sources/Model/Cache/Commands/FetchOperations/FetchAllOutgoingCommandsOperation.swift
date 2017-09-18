//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class FetchAllOutgoingCommandsOperation: Operation {
    private let cache: CacheType
    
    var commands: [OutgoingCommand] = []
    
    init(cache: CacheType) {
        self.cache = cache
    }
    
    override func main() {
        guard !isCancelled else {
            return
        }
        
        let request = CacheFetchRequest(resultType: OutgoingCommand.self,
                                        predicate: PredicateBuilder.allOutgoingCommandsPredicate(),
                                        sortDescriptors: [Cache.createdAtSortDescriptor])
        
        commands = cache.fetchOutgoing(with: request)
    }
}
