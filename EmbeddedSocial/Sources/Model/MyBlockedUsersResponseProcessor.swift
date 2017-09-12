//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class MyBlockedUsersResponseProcessor: UsersListResponseProcessor {
    
    override func apply(actions: [OutgoingAction], to usersList: UsersListResponse) -> UsersListResponse {
        var usersList = usersList
        var updatedUsers: [User] = []
        
        for user in usersList.users {
            guard actions.first(where: { $0.type == .unfollow && $0.entityHandle == user.uid }) == nil else {
                continue
            }
            updatedUsers.append(user)
        }
        
        usersList.users = updatedUsers
        
        return usersList
    }
}
