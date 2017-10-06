//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class UserFollowersAPI: UsersListAPI {
    private let service: SocialServiceType
    private let userID: String
    
    init(userID: String, service: SocialServiceType) {
        self.userID = userID
        self.service = service
    }
    
    override func getUsersList(cursor: String?, limit: Int, completion: @escaping (Result<UsersListResponse>) -> Void) {
        service.getUserFollowers(userID: userID, cursor: cursor, limit: limit, completion: completion)
    }
}
