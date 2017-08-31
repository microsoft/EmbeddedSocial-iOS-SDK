//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class UserProfileInteractor: UserProfileInteractorInput {
    private let userService: UserServiceType
    private let socialService: SocialServiceType
    private let authorization: Authorization
    private let cache: CacheType

    init(userService: UserServiceType,
         socialService: SocialServiceType,
         authorization: Authorization = SocialPlus.shared.authorization,
         cache: CacheType = SocialPlus.shared.cache) {
        self.userService = userService
        self.socialService = socialService
        self.authorization = authorization
        self.cache = cache
    }
    
    func getUser(userID: String, completion: @escaping (Result<User>) -> Void) {
        userService.getUserProfile(userID: userID, completion: completion)
    }
    
    func getMe(credentials: CredentialsList, completion: @escaping (Result<User>) -> Void) {
        userService.getMyProfile(authorization: authorization, credentials: credentials, completion: completion)
    }
    
    func processSocialRequest(currentFollowStatus: FollowStatus, userID: String, completion: @escaping (Result<Void>) -> Void) {
        socialService.request(currentFollowStatus: currentFollowStatus, userID: userID, completion: completion)
    }
    
    func block(userID: String, completion: @escaping (Result<Void>) -> Void) {
        socialService.block(userID: userID, completion: completion)
    }
    
    func cachedUser(with handle: String) -> User? {
        guard let profileView = cache.firstIncoming(ofType: UserProfileView.self, handle: handle) else {
            return nil
        }
        return User(profileView: profileView)
    }
}
