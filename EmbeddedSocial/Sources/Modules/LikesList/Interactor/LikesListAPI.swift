//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

struct LikesListAPI: UsersListAPI {
    private let likesService: LikesServiceProtocol
    private let postHandle: String

    init(postHandle: String, likesService: LikesServiceProtocol) {
        self.likesService = likesService
        self.postHandle = postHandle
    }
    
    func getUsersList(cursor: String?, limit: Int, completion: @escaping (Result<UsersListResponse>) -> Void) {
        likesService.getPostLikes(postHandle: postHandle, cursor: cursor, limit: limit, completion: completion)
    }
}
