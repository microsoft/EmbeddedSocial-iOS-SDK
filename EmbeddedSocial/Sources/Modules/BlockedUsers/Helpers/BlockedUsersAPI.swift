//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class BlockedUsersAPI: UsersListAPI {
    private let socialService: SocialServiceType

    init(socialService: SocialServiceType) {
        self.socialService = socialService
    }
    
    override func getUsersList(cursor: String?, limit: Int, completion: @escaping (Result<UsersListResponse>) -> Void) {
        socialService.getMyBlockedUsers(cursor: cursor, limit: limit, completion: completion)
    }
}
