//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class FetchUserCommandsOperation: Operation {
    private let cache: CacheType
    
    var commands: [UserCommand] = []
    
    init(cache: CacheType) {
        self.cache = cache
    }
    
    override func main() {
        guard !isCancelled else { return }
        
        let p = PredicateBuilder.predicate(typeID: UserCommand.typeIdentifier)
        
        let request = CacheFetchRequest(resultType: UserCommand.self,
                                        predicate: p,
                                        sortDescriptors: [Cache.createdAtSortDescriptor])
        
        commands = cache.fetchOutgoing(with: request)
    }
}
