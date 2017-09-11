//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol UsersListOutgoingActionsProcessor {
    func applyOutgoingActions(to usersList: UsersListResponse, completion: @escaping (UsersListResponse) -> Void)
}

final class OutgoingActionsProcessor: UsersListOutgoingActionsProcessor {
    
    private let cache: CacheType
    
    private let queue: OperationQueue = {
        let q = OperationQueue()
        q.name = "OutgoingActionsProcessor-queue"
        q.qualityOfService = .userInitiated
        return q
    }()
    
    init(cache: CacheType) {
        self.cache = cache
    }
    
    func applyOutgoingActions(to usersList: UsersListResponse, completion: @escaping (UsersListResponse) -> Void) {
        let fetchActions = FetchOutgoingActionsOperation(cache: cache)
        
        fetchActions.completionBlock = { [weak self] in
            guard let strongSelf = self, !fetchActions.isCancelled else {
                completion(usersList)
                return
            }
            
            let list = strongSelf.apply(actions: fetchActions.actions, to: usersList)
            completion(list)
        }
        
        queue.addOperation(fetchActions)
    }
    
    private func apply(actions: [OutgoingAction], to usersList: UsersListResponse) -> UsersListResponse {
        return usersList
    }
}
