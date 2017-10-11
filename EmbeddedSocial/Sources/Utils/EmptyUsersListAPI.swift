//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class EmptyUsersListAPI: UsersListAPI {
    
    override func getUsersList(cursor: String?, limit: Int, completion: @escaping (Result<UsersListResponse>) -> Void) {
        let response = UsersListResponse(items: [], cursor: nil, isFromCache: false)
        completion(.success(response))
    }
}
