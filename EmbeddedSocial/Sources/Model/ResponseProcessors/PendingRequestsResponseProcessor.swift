//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class PendingRequestsResponseProcessor: UsersListResponseProcessor {
    
    override func apply(commands: [UserCommand], to usersList: UsersListResponse) -> UsersListResponse {
        var usersList = usersList
        let usersToExclude = self.usersToExclude(commands: commands, from: usersList)
        usersList.users = usersList.users.filter { user in !usersToExclude.contains(where: { $0.uid == user.uid }) }
        return usersList
    }
    
    private func usersToExclude(commands: [UserCommand], from usersList: UsersListResponse) -> [User] {
        var usersToExclude: [User] = []
        
        for case let command in commands where command is AcceptPendingCommand || command is CancelPendingCommand {
            usersToExclude.append(command.user)
        }
        
        return usersToExclude
    }
}
