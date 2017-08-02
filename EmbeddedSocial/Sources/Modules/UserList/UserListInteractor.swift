//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class UserListInteractor: UserListInteractorInput {
    private let api: UsersListAPI
    private let socialService: SocialServiceType

    init(api: UsersListAPI, socialService: SocialServiceType) {
        self.api = api
        self.socialService = socialService
    }
    
    func getUsersList(cursor: String?, limit: Int, completion: @escaping (Result<([User], String?)>) -> Void) {
        api.getUsersList(cursor: cursor, limit: limit, completion: completion)
    }
    
    func processSocialRequest(to user: User, completion: @escaping (Result<FollowStatus>) -> Void) {
        guard let followStatus = user.followerStatus else {
            completion(.failure(APIError.missingUserData))
            return
        }
        
        let nextStatus = FollowStatus.reduce(status: followStatus, visibility: user.visibility ?? ._private)
        
        socialService.request(currentFollowStatus: user.followerStatus ?? .empty, userID: user.uid) { result in
            if result.isSuccess {
                completion(.success(nextStatus))
            } else {
                completion(.failure(result.error ?? APIError.unknown))
            }
        }
    }
}
