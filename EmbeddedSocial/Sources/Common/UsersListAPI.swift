//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol UsersListAPI {
    func getUsersList(cursor: String?, limit: Int, completion: @escaping (Result<UsersListResponse>) -> Void)
}

extension UsersListAPI {
    
    func getUsersList(cursor: String?, limit: Int, skipCache: Bool, completion: @escaping (Result<UsersListResponse>) -> Void) {
        getUsersList(cursor: cursor, limit: limit) { response in
            if skipCache && response.value?.isFromCache == true {
                return
            }
            completion(response)
        }
    }
}
