//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

struct MeFollowingAPI: UsersListAPI {
    private let service: SocialServiceType
    
    init(service: SocialServiceType) {
        self.service = service
    }
    
    func getUsersList(cursor: String?, limit: Int, completion: @escaping (Result<UsersListResponse>) -> Void) {
        service.getMyFollowing(cursor: cursor, limit: limit, completion: completion)
    }
}
