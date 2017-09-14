//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class MyFollowingResponseProcessor: UsersListResponseProcessor {
    
    override func apply(commands: [UserCommand], to usersList: UsersListResponse) -> UsersListResponse {
        var usersList = usersList
        let usersToExclude = self.usersToExclude(commands: commands, from: usersList)
        let usersToAdd = self.usersToAdd(commands: commands, to: usersList)
        
        usersList.users = usersList.users.filter { user in !usersToExclude.contains(where: { $0.uid == user.uid }) }
        usersList.users += usersToAdd
                
        return super.apply(commands: commands, to: usersList)
    }
    
    private func usersToExclude(commands: [UserCommand], from usersList: UsersListResponse) -> [User] {
        var usersToExclude: [User] = []
        
        for command in commands {
            guard command is UnfollowCommand else {
                continue
            }
            
            guard command.user.visibility == ._private else {
                usersToExclude.append(command.user)
                continue
            }
            
            let isPending = commands.contains(where: { $0 is FollowCommand && $0.user.uid == command.user.uid })
            
            if !isPending {
                usersToExclude.append(command.user)
            }
        }
        
        return usersToExclude
    }
    
    private func usersToAdd(commands: [UserCommand], to usersList: UsersListResponse) -> [User] {
        var usersToAdd: [User] = []
        
        for command in commands {
            let isFollowCommand = command is FollowCommand
            let isNew = !usersList.users.contains(where: { command.user.uid == $0.uid })
            
            if isFollowCommand && isNew {
                usersToAdd.append(command.user)
            }
        }
        
        return usersToAdd
    }
}
