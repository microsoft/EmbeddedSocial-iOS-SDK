//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class DaemonsController: Daemon {
    private let networkTracker: NetworkStatusMulticast
    private let cache: CacheType
    
    private lazy var outgoingCacheDaemon: OutgoingCommandsUploader = { [unowned self] in
        return OutgoingCommandsUploader(networkTracker: self.networkTracker,
                                       cache: self.cache,
                                       jsonDecoderType: Decoders.self,
                                       operationsBuilderType: OutgoingCommandOperationsBuilder.self)
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
