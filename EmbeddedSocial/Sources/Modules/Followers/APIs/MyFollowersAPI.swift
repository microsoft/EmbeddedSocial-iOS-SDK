//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class MyFollowersAPI: UsersListAPI {
    private let service: SocialServiceType
    
    init(service: SocialServiceType) {
        self.service = service
    }
    
    override func getUsersList(cursor: String?, limit: Int, completion: @escaping (Result<UsersListResponse>) -> Void) {
        service.getMyFollowers(cursor: cursor, limit: limit, completion: completion)
    }
}
