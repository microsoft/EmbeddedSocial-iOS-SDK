//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class OutgoingActionRequestExecutionStrategy<ResponseType> {
    
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
            completion(.success())
        }
    }
    
    private func cache(builder: RequestBuilder<ResponseType>, actionType: OutgoingAction.ActionType, handle: String) {
        guard let cache = self.cache, let method = builder.httpMethod else {
            return
        }
        let action = OutgoingAction(type: actionType, method: method, entityHandle: handle)
        cache.cacheOutgoing(action)
    }
    
    private func processResponse(_ data: Object?, _ error: Error?, _ completion: @escaping (Result<Void>) -> Void) {
        if error == nil {
            completion(.success())
        } else {
            errorHandler?.handle(error: error, completion: completion)
        }
    }
}
