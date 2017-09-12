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
    private let networkTracker: NetworkStatusMulticast

    init(userService: UserServiceType,
         socialService: SocialServiceType,
         authorization: Authorization = SocialPlus.shared.authorization,
         cache: CacheType = SocialPlus.shared.cache,
         networkTracker: NetworkStatusMulticast = SocialPlus.shared.networkTracker) {
        
        self.userService = userService
        self.socialService = socialService
        self.authorization = authorization
        self.cache = cache
        self.networkTracker = networkTracker
    }
    
    func getUser(userID: String, completion: @escaping (Result<User>) -> Void) {
        userService.getUserProfile(userID: userID, completion: completion)
    }
    
    func getMe(credentials: CredentialsList, completion: @escaping (Result<User>) -> Void) {
        userService.getMyProfile(authorization: authorization, credentials: credentials, completion: completion)
    }
    
    func processSocialRequest(to user: User, completion: @escaping (Result<FollowStatus>) -> Void) {
        guard let currentStatus = user.followerStatus else {
            completion(.failure(APIError.missingUserData))
            return
        }
        
        let newStatus = FollowStatus.reduce(status: currentStatus, visibility: user.visibility ?? ._private)

        socialService.request(currentFollowStatus: currentStatus, userID: user.uid) { result in
            completion(result.map { _ in newStatus })
        }
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
