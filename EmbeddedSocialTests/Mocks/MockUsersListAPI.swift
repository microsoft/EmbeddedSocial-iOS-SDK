//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

final class MockUsersListAPI: UsersListAPI {
    
    //MARK: - getUsersList
    
    var getUsersListCalled = false
    var getUsersListReceivedArguments: (cursor: String?, limit: Int)?
    var getUsersListReturnValue: Result<UsersListResponse>!
    
    override func getUsersList(cursor: String?, limit: Int, completion: @escaping (Result<UsersListResponse>) -> Void) {
        getUsersListCalled = true
        getUsersListReceivedArguments = (cursor: cursor, limit: limit)
        completion(getUsersListReturnValue)
    }
    
}
