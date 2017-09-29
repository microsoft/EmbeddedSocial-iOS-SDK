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
    let operationsBuilder: OutgoingCommandOperationsBuilderType
    let predicateBuilder: OutgoingCommandsPredicateBuilder

    init(cache: CacheType,
         operationsBuilder: OutgoingCommandOperationsBuilderType = OutgoingCommandOperationsBuilder(),
         predicateBuilder: OutgoingCommandsPredicateBuilder = PredicateBuilder()) {
        self.cache = cache
        self.operationsBuilder = operationsBuilder
        self.predicateBuilder = predicateBuilder
    }
    
    override func process(_ response: FeedResponseUserCompactView?,
                          isFromCache: Bool,
                          completion: @escaping (Result<UsersListResponse>) -> Void) {
        
        let usersList = UsersListResponse(response: response, isFromCache: isFromCache)
        
        guard isFromCache else {
            DispatchQueue.main.async {
                completion(.success(usersList))
            }
            return
        }
        
        applyUserCommands(to: usersList) { usersList in
            DispatchQueue.main.async {
                completion(.success(usersList))
            }
        }
    }
    
    private func applyUserCommands(to usersList: UsersListResponse, completion: @escaping (UsersListResponse) -> Void) {
        let fetchCommands = operationsBuilder.fetchCommandsOperation(cache: cache, predicate: predicateBuilder.allUserCommands())
        
        fetchCommands.completionBlock = { [weak self] in
            guard let strongSelf = self, !fetchCommands.isCancelled else {
                completion(usersList)
                return
            }
            
            strongSelf.queue.addOperation {
                let commands = fetchCommands.commands as? [UserCommand] ?? []
                let list = strongSelf.apply(commands: commands, to: usersList)
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
