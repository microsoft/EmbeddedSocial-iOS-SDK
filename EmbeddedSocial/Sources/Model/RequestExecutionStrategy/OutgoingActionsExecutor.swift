//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class OutgoingActionsExecutor<ResponseType> {
    
    private let networkTracker: NetworkStatusMulticast
    var cache: CacheType?
    var errorHandler: APIErrorHandler?

    init(networkTracker: NetworkStatusMulticast = SocialPlus.shared.networkTracker) {
        self.networkTracker = networkTracker
    }
    
    func execute(with builder: RequestBuilder<ResponseType>,
                 actionType: OutgoingAction.ActionType,
                 handle: String,
                 completion: @escaping (Result<Void>) -> Void) {
        
        if networkTracker.isReachable {
            builder.execute { [weak self] response, error in
                self?.processResponse(response, error, completion)
            }
        } else {
            cache(builder: builder, actionType: actionType, handle: handle)
            DispatchQueue.main.async {
                completion(.success())
            }
        }
    }
    
    func execute(command: UserCommand, builder: RequestBuilder<ResponseType>, completion: @escaping (Result<Void>) -> Void) {
        if networkTracker.isReachable {
            builder.execute { [weak self] response, error in
                self?.processResponse(response, error, completion)
            }
        } else {
            cache(builder: builder, actionType: actionType, handle: handle)
            DispatchQueue.main.async {
                completion(.success())
            }
        }
    }
    
    private func cache(builder: RequestBuilder<ResponseType>, actionType: OutgoingAction.ActionType, handle: String) {
        guard let cache = self.cache else {
            return
        }
        
        let action = OutgoingAction(type: actionType, entityHandle: handle)
        
        if let cachedInverseAction = self.cachedInverseAction(for: action) {
            deleteActionFromCache(cachedInverseAction)
        } else {
            cache.cacheOutgoing(action)
        }
    }
    
    private func cachedInverseAction(for action: OutgoingAction) -> OutgoingAction? {
        guard let inverseAction = action.inverseAction else {
            return nil
        }
        return cache?.firstOutgoing(ofType: OutgoingAction.self,
                                    predicate: PredicateBuilder.predicate(action: inverseAction),
                                    sortDescriptors: nil)
    }
    
    private func deleteActionFromCache(_ action: OutgoingAction) {
        cache?.deleteOutgoing(with: PredicateBuilder.predicate(action: action))
    }
    
    private func processResponse(_ data: Object?, _ error: Error?, _ completion: @escaping (Result<Void>) -> Void) {
        DispatchQueue.main.async {
            if error == nil {
                completion(.success())
            } else {
                self.errorHandler?.handle(error: error, completion: completion)
            }
        }
    }
}
