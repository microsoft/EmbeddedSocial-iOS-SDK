//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

final class MockUsersListAPI: UsersListAPI {
    var resultToReturn: Result<UsersListResponse>?
    private(set) var getUsersListCount = 0
    
    func getUsersList(cursor: String?, limit: Int, completion: @escaping (Result<UsersListResponse>) -> Void) {
        getUsersListCount += 1
        if let result = resultToReturn {
            completion(result)
        }
    }
}
