//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

class MockUserProfileInteractor: UserProfileInteractorInput {
    private(set) var getUserCount = 0
    private(set) var getMeCount = 0
    private(set) var getRecentPostsCount = 0
    private(set) var getPopularPostsCount = 0
    private(set) var getMyRecentPostsCount = 0
    private(set) var getMyPopularPostsCount = 0
    private(set) var socialRequestCount = 0
    private(set) var blockCount = 0
    
    var userToReturn: User?
    var meToReturn: User?

    func getUser(userID: String, completion: @escaping (Result<User>) -> Void) {
        getUserCount += 1
        if let user = userToReturn {
            completion(.success(user))
        }
    }
    
    func getMe(credentials: CredentialsList, completion: @escaping (Result<User>) -> Void) {
        getMeCount += 1
        if let user = meToReturn {
            completion(.success(user))
        }
    }
    
    func getRecentPosts(userID: String, completion: @escaping (Result<[Any]>) -> Void) {
        getRecentPostsCount += 1
        completion(.success([]))
    }
    
    func getPopularPosts(userID: String, completion: @escaping (Result<[Any]>) -> Void) {
        getPopularPostsCount += 1
        completion(.success([]))
    }
    
    func getMyRecentPosts(completion: @escaping (Result<[Any]>) -> Void) {
        getMyRecentPostsCount += 1
        completion(.success([]))
    }
    
    func getMyPopularPosts(completion: @escaping (Result<[Any]>) -> Void) {
        getMyPopularPostsCount += 1
        completion(.success([]))
    }
    
    func block(userID: String, completion: @escaping (Result<Void>) -> Void) {
        blockCount += 1
        completion(.success())
    }
    
    func processSocialRequest(currentFollowStatus: FollowStatus, userID: String, completion: @escaping (Result<Void>) -> Void) {
        socialRequestCount += 1
        completion(.success())
    }
}
