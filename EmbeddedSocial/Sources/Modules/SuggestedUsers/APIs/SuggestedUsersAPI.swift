//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class SuggestedUsersAPI: UsersListAPI {
    private let socialService: SocialServiceType
    private let authorization: Authorization

    init(socialService: SocialServiceType, authorization: Authorization) {
        self.socialService = socialService
        self.authorization = authorization
    }
    
    override func getUsersList(cursor: String?, limit: Int, completion: @escaping (Result<UsersListResponse>) -> Void) {
        socialService.getSuggestedUsers(authorization: authorization, completion: completion)
    }
}
