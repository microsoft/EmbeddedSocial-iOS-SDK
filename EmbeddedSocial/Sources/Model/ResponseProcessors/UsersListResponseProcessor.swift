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
        applyUserCommands(to: usersList) { usersList in
            DispatchQueue.main.async {
                completion(.success(usersList))
            }
        }
    }
    
    private func applyUserCommands(to usersList: UsersListResponse, completion: @escaping (UsersListResponse) -> Void) {
        let fetchCommands = FetchUserCommandsOperation(cache: cache)
        
        fetchCommands.completionBlock = { [weak self] in
            guard let strongSelf = self, !fetchCommands.isCancelled else {
                completion(usersList)
                return
            }
            
            strongSelf.queue.addOperation {
                let list = strongSelf.apply(commands: fetchCommands.commands, to: usersList)
                completion(list)
            }
        }
        
        queue.addOperation(fetchCommands)
    }
    
    func apply(commands: [UserCommand], to usersList: UsersListResponse) -> UsersListResponse {
        var updatedUsers: [User] = []
        var usersList = usersList
        
        for var user in usersList.users {
            let commandsToApply = commands.filter { $0.user.uid == user.uid }
            for command in commandsToApply {
                command.apply(to: &user)
            }
            updatedUsers.append(user)
        }
        
        usersList.users = updatedUsers
        
        return usersList
    }
    
}
