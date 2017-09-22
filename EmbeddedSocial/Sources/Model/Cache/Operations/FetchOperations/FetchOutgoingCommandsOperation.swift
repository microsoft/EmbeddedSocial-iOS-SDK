//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class FetchOutgoingCommandsOperation: Operation {
    private let cache: CacheType
    private let predicate: NSPredicate
    
    private(set) var commands: [OutgoingCommand] = []
    
    init(cache: CacheType, predicate: NSPredicate) {
        self.cache = cache
        self.predicate = predicate
    }
    
    override func main() {
        guard !isCancelled else {
            return
        }
        
        let request = CacheFetchRequest(resultType: OutgoingCommand.self,
                                        predicate: predicate,
                                        sortDescriptors: [Cache.createdAtSortDescriptor])
        
        commands = cache.fetchOutgoing(with: request)
    }
}
