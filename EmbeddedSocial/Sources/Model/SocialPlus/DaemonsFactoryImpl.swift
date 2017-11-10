//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class DaemonsFactoryImpl: DaemonsFactory {
    
    private let cache: CacheType
    private let networkTracker: NetworkTrackerType
    
    init(cache: CacheType, networkTracker: NetworkTrackerType) {
        self.cache = cache
        self.networkTracker = networkTracker
    }
    
    func makeOutgoingCacheDaemon() -> Daemon {
        let queue = OperationQueue()
        queue.name = "OutgoingCommandsUploader-executionQueue"
        queue.qualityOfService = .background
        queue.maxConcurrentOperationCount = 1
        
        let strategy = OutgoingCommandsUploadStrategy(cache: self.cache,
                                                      operationsBuilderType: OutgoingCommandOperationsBuilder(),
                                                      executionQueue: queue)
        
        return OutgoingCommandsUploader(networkTracker: self.networkTracker,
                                        uploadStrategy: strategy,
                                        jsonDecoderType: Decoders.self)
    }
    
    func makeHandleUpdaterDaemon() -> Daemon {
        return HandleUpdateDaemon()
    }
}
