//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

struct UserFollowingAPI: UsersListAPI {
    private let service: SocialServiceType
    private let userID: String
    
    init(userID: String, service: SocialServiceType) {
        self.userID = userID
        self.service = service
    }
    
    func getUsersList(cursor: String?, limit: Int, completion: @escaping (Result<UsersListResponse>) -> Void) {
        service.getUserFollowing(userID: userID, cursor: cursor, limit: limit, completion: completion)
    }
}
