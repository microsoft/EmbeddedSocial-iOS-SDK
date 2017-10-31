//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class DaemonsController: Daemon {
    private let networkTracker: NetworkStatusMulticast
    private let cache: CacheType
    
    private lazy var outgoingCacheDaemon: OutgoingCommandsUploader = { [unowned self] in
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
    }()
    
    private lazy var daemons: [Daemon] = { [unowned self] in
        return [self.outgoingCacheDaemon]
    }()
    
    init(networkTracker: NetworkStatusMulticast, cache: CacheType) {
        self.networkTracker = networkTracker
        self.cache = cache
    }
    
    func start() {
        daemons.forEach { $0.start() }
    }
    
    func stop() {
        daemons.forEach { $0.stop() }
    }
}
