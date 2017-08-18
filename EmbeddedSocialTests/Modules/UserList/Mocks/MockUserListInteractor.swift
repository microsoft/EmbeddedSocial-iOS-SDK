//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

final class MockUserListInteractor: UserListInteractorInput {
    private(set) var getUsersListCount = 0
    private(set) var processSocialRequestCount = 0
    private(set) var setAPICount = 0
    var socialRequestResult: Result<FollowStatus>?
    var getUsersListResult: Result<UsersListResponse>?
    private(set) var api: UsersListAPI?

    func getUsersList(cursor: String?, limit: Int, completion: @escaping (Result<UsersListResponse>) -> Void) {
        getUsersListCount += 1
        if let result = getUsersListResult {
            completion(result)
        }
    }
    
    func processSocialRequest(to user: User, completion: @escaping (Result<FollowStatus>) -> Void) {
        processSocialRequestCount += 1
        if let result = socialRequestResult {
            completion(result)
        }
    }
    
    func setAPI(_ api: UsersListAPI) {
        setAPICount += 1
        self.api = api
    }
}
