//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

struct EmptyUsersListAPI: UsersListAPI {
    
    func getUsersList(cursor: String?, limit: Int, completion: @escaping (Result<UsersListResponse>) -> Void) {
        let response = UsersListResponse(users: [], cursor: nil)
        completion(.success(response))
    }
}
