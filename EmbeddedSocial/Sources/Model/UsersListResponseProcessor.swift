//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class UsersListResponseProcessor: ResponseProcessor<FeedResponseUserCompactView, UsersListResponse> {
    
    private let queue: OperationQueue = {
        let q = OperationQueue()
        q.name = "UsersListResponseProcessor-queue"
        q.qualityOfService = .userInitiated
        return q
    }()
    
    let cache: CacheType
    
    init(cache: CacheType) {
        self.cache = cache
    }
    
    override func process(_ response: FeedResponseUserCompactView?,
                          isFromCache: Bool,
                          completion: @escaping (Result<UsersListResponse>) -> Void) {
        
        let usersList = UsersListResponse(response: response, isFromCache: isFromCache)
        applyOutgoingActions(to: usersList) { usersList in
            DispatchQueue.main.async {
                completion(.success(usersList))
            }
        }
    }
    
    private func applyOutgoingActions(to usersList: UsersListResponse, completion: @escaping (UsersListResponse) -> Void) {
        let fetchActions = FetchOutgoingActionsOperation(cache: cache)
        
        fetchActions.completionBlock = { [weak self] in
            guard let strongSelf = self, !fetchActions.isCancelled else {
                completion(usersList)
                return
            }
            
            strongSelf.queue.addOperation {
                let list = strongSelf.apply(actions: fetchActions.actions, to: usersList)
                completion(list)
            }
        }
        
        queue.addOperation(fetchActions)
    }
    
    func apply(actions: [OutgoingAction], to usersList: UsersListResponse) -> UsersListResponse {
        var updatedUsers: [User] = []
        var usersList = usersList
        
        for var user in usersList.users {
            let actionsToApply = actions.filter { $0.entityHandle == user.uid }
            user.apply(actions: actionsToApply)
            updatedUsers.append(user)
        }
        
        usersList.users = updatedUsers
        
        return usersList
    }
    
}
