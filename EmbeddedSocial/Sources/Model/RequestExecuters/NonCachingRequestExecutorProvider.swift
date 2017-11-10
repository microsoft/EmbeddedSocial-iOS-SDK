//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class NonCachingRequestExecutorProvider: CacheRequestExecutorProvider {

    override class func makeAtomicOutgoingCommandsExecutor(for service: BaseService) -> AtomicOutgoingCommandsExecutor {
        let executor = NonCachingAtomicOutgoingExecutor()
        executor.cache = service.cache
        executor.errorHandler = service.errorHandler
        return executor
    }
    
}
