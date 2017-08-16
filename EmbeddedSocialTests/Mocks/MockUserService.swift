//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

final class MockUserService: UserServiceType {
    private(set) var getMyProfileCount = 0
    private(set) var createAccountCount = 0
    private(set) var getUserProfileCount = 0
    private(set) var updateProfileCount = 0

    func getMyProfile(credentials: CredentialsList, completion: @escaping (Result<User>) -> Void) {
        getMyProfileCount += 1
    }
    
    func createAccount(for user: User, completion: @escaping (Result<(user: User, sessionToken: String)>) -> Void) {
        createAccountCount += 1
    }
    
    func getUserProfile(userID: String, completion: @escaping (Result<User>) -> Void) {
        getUserProfileCount += 1
    }
    
    func updateProfile(me: User, completion: @escaping (Result<User>) -> Void) {
        updateProfileCount += 1
        completion(.success(me))
    }
}
