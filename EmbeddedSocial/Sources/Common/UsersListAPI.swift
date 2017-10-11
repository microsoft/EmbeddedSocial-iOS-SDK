//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class UsersListAPI: ListAPI<User> {
    
    override func getPage(cursor: String?, limit: Int, completion: @escaping (Result<PaginatedResponse<User>>) -> Void) {
        getUsersList(cursor: cursor, limit: limit, completion: completion)
    }
    
    func getUsersList(cursor: String?, limit: Int, completion: @escaping (Result<UsersListResponse>) -> Void) {
        completion(.failure(APIError.notImplemented))
    }
}
