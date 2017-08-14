//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class UserProfileInteractor: UserProfileInteractorInput {
    private let userService: UserServiceType
    private let socialService: SocialServiceType
    private let cache: CacheType

    init(userService: UserServiceType, socialService: SocialServiceType, cache: CacheType = SocialPlus.shared.cache) {
        self.userService = userService
        self.socialService = socialService
        self.cache = cache
    }
    
    func getUser(userID: String, completion: @escaping (Result<User>) -> Void) {
        userService.getUserProfile(userID: userID, completion: completion)
    }
    
    func getMe(credentials: CredentialsList, completion: @escaping (Result<User>) -> Void) {
        userService.getMyProfile(credentials: credentials, completion: completion)
    }

    func getRecentPosts(userID: String, completion: @escaping (Result<[Any]>) -> Void) {
        completion(.success([]))
    }
    
    func getPopularPosts(userID: String, completion: @escaping (Result<[Any]>) -> Void) {
        completion(.success([]))
    }
    
    func getMyRecentPosts(completion: @escaping (Result<[Any]>) -> Void) {
        completion(.success([]))
    }
    
    func getMyPopularPosts(completion: @escaping (Result<[Any]>) -> Void) {
        completion(.success([]))
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
        
//        cache.fetchIncoming(type: UserProfileView.self, sortDescriptors: nil) { profiles in
//            print(profiles)
//        }
    }
}
