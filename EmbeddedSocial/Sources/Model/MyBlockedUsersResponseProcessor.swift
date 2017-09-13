//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class MyBlockedUsersResponseProcessor: UsersListResponseProcessor {
    
    override func apply(commands: [UserCommand], to usersList: UsersListResponse) -> UsersListResponse {
        let uniqueBlockCommands = commands.filter { command -> Bool in
            command is BlockCommand && !usersList.users.contains(where: { $0.uid == command.user.uid })
        }
        
        var usersList = usersList
        usersList.users += uniqueBlockCommands.flatMap { $0.user }
        return usersList
    }
}
