//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class BlockedUsersListItemsBuilder: UserListItemsBuilder {
    
    override func configuredUser(_ user: User) -> User {
        var user = user
        user.followerStatus = .blocked
        return user
    }
}
