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
    private(set) var cachedUserCount = 0
    
    var processSocialRequestResult: Result<FollowStatus>?
    
    var meToReturn: User?
    var cachedUserToReturn: User?
    
    var getUserResult: Result<User>!
    
    func getUser(userID: String, completion: @escaping (Result<User>) -> Void) {
        getUserCount += 1
        completion(getUserResult)
    }
    
    func getMe(credentials: CredentialsList, completion: @escaping (Result<User>) -> Void) {
        getMeCount += 1
        if let user = meToReturn {
            completion(.success(user))
        }
    }
    
    func block(user: User, completion: @escaping (Result<Void>) -> Void) {
        blockCount += 1
        completion(.success())
    }
    
    func processSocialRequest(to user: User, completion: @escaping (Result<FollowStatus>) -> Void) {
        socialRequestCount += 1
        if let processSocialRequestResult = processSocialRequestResult {
            completion(processSocialRequestResult)
        }
    }
    
    func cachedUser(with handle: String) -> User? {
        cachedUserCount += 1
        return cachedUserToReturn
    }
}
