//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

struct UserFollowersAPI: UsersListAPI {
    private let service: SocialServiceType
    private let userID: String
    
    init(userID: String, service: SocialServiceType) {
        self.userID = userID
        self.service = service
    }
    
    func getUsersList(cursor: String?, limit: Int, completion: @escaping (Result<([User], String?)>) -> Void) {
        service.getMyFollowers(cursor: cursor, limit: limit, completion: completion)
    }
}
