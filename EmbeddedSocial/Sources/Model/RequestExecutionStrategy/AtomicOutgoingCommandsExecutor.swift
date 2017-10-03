//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class AtomicOutgoingCommandsExecutor<ResponseType> {
    
    private let networkTracker: NetworkStatusMulticast
    var cache: CacheType?
    var errorHandler: APIErrorHandler?

    init(networkTracker: NetworkStatusMulticast = SocialPlus.shared.networkTracker) {
        self.networkTracker = networkTracker
    }
    
    func execute(command: OutgoingCommand,
                 builder: RequestBuilder<ResponseType>,
                 completion: @escaping (Result<Void>) -> Void) {
        
        if networkTracker.isReachable {
            builder.execute { [weak self] response, error in
                self?.processResponse(response?.body, error, completion)
            }
        } else {
            cacheCommand(command)
            DispatchQueue.main.async {
                completion(.success())
            }
        }
    }
    
    private func cacheCommand(_ command: OutgoingCommand) {
        if let cachedInverseCommand = self.cachedInverseCommand(for: command) {
            cache?.deleteOutgoing(with: PredicateBuilder().predicate(for: cachedInverseCommand))
        } else {
            cache?.cacheOutgoing(command)
        }
    }
    
    private func cachedInverseCommand(for command: OutgoingCommand) -> OutgoingCommand? {
        guard let inverseCommand = command.inverseCommand else {
            return nil
        }
        return cache?.firstOutgoing(ofType: type(of: inverseCommand),
                                    predicate: PredicateBuilder().predicate(for: inverseCommand),
                                    sortDescriptors: nil)
    }
    
    private func processResponse(_ data: ResponseType?, _ error: Error?, _ completion: @escaping (Result<Void>) -> Void) {
        DispatchQueue.main.async {
            if error == nil {
                completion(.success())
            } else {
                self.errorHandler?.handle(error: error, completion: completion)
            }
        }
    }
}
