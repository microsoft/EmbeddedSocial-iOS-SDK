//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class MyFollowersResponseProcessor: UsersListResponseProcessor {
    
    override func apply(commands: [UserCommand], to usersList: UsersListResponse) -> UsersListResponse {
        var usersList = usersList
        usersList.users += usersToAdd(commands: commands, to: usersList)
        return super.apply(commands: commands, to: usersList)
    }
    
    private func usersToAdd(commands: [UserCommand], to usersList: UsersListResponse) -> [User] {
        var usersToAdd: [User] = []
        
        for command in commands {
            let isAcceptPendingCommand = command is AcceptPendingCommand
            let isNew = !usersList.users.contains(where: { command.user.uid == $0.uid })
            
            if isAcceptPendingCommand && isNew {
                usersToAdd.append(command.user)
            }
        }
        
        return usersToAdd
    }
}
