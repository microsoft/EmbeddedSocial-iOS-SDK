//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class DaemonsController: Daemon {
    private let networkTracker: NetworkStatusMulticast
    private let cache: CacheType
    
    private lazy var outgoingCacheDaemon: UserCommandsCacheDaemon = { [unowned self] in
        return UserCommandsCacheDaemon(networkTracker: self.networkTracker, cache: self.cache, jsonDecoderType: Decoders.self)
    }()
    
    private lazy var feedUserCommandsCacheDaemon: FeedCachedActionsExecutor = { [unowned self] in
        return FeedCachedActionsExecutor(networkTracker: self.networkTracker,
                                         cacheAdapter: FeedCacheActionsAdapter(cache: self.cache),
                                         likesService: LikesService())
    }()
    
    private lazy var daemons: [Daemon] = { [unowned self] in
        return [self.outgoingCacheDaemon, self.feedUserCommandsCacheDaemon]
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
    
    deinit {
        stop()
    }
}
