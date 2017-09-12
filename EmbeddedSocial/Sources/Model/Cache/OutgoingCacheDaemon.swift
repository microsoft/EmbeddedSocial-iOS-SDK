//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class OutgoingCacheDaemon: Daemon, NetworkStatusListener {
    
    private let networkTracker: NetworkStatusMulticast
    private let cache: CacheType
    private let executionQueue: OperationQueue = {
       let q = OperationQueue()
        q.name = "OutgoingActionsDaemon-executionQueue"
        q.qualityOfService = .background
        return q
    }()
    
    init(networkTracker: NetworkStatusMulticast, cache: CacheType, jsonDecoderType: JSONDecoder.Type = Decoders.self) {
        self.networkTracker = networkTracker
        self.cache = cache
        jsonDecoderType.setupDecoders()
    }
    
    func start() {
        networkTracker.addListener(self)
    }
    
    func stop() {
        networkTracker.removeListener(self)
    }
    
    func networkStatusDidChange(_ isReachable: Bool) {
        guard isReachable else { return }
        executionQueue.cancelAllOperations()
        executePendingActions()
    }
    
    private func executePendingActions() {
        let fetchOperation = FetchOutgoingActionsOperation(cache: cache)
        
        fetchOperation.completionBlock = { [weak self] in
            guard !fetchOperation.isCancelled else { return }
            self?.executeActionsOperations(fetchOperation.actions)
        }
        
        executionQueue.addOperation(fetchOperation)
    }
    
    private func executeActionsOperations(_ actions: [OutgoingAction]) {
        let operations = makeActionOperations(from: actions)
        executionQueue.addOperations(operations, waitUntilFinished: false)
    }
    
    private func makeActionOperations(from actions: [OutgoingAction]) -> [OutgoingActionOperation] {
        let predicateBuilder = PredicateBuilder()
        
        let operations = actions.flatMap { [weak self] action -> OutgoingActionOperation? in
            let op = OutgoingActionOperationsBuilder.operation(for: action)
            op?.completionBlock = {
                guard op?.isCancelled != true else { return }
                let predicate = predicateBuilder.predicate(action: action)
                self?.cache.deleteOutgoing(with: predicate)
            }
            return op
        }
        
        return operations
    }
}
