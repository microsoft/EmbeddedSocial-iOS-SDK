//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol SearchServiceType {
    func queryUsers(query: String, cursor: String?, limit: Int, completion: @escaping (Result<UsersListResponse>) -> Void)
}

final class SearchService: BaseService, SearchServiceType {
    
    func queryUsers(query: String, cursor: String?, limit: Int, completion: @escaping (Result<UsersListResponse>) -> Void) {
        SearchAPI.searchGetUsers(
            query: query, authorization: authorization,
            cursor: Int32(cursor ?? ""), limit: Int32(limit)) { response, error in
                if let response = response {
                    let users = response.data?.map(User.init) ?? []
                    completion(.success(UsersListResponse(users: users, cursor: response.cursor)))
                } else {
                    self.errorHandler.handle(error: error, completion: completion)
                }
        }
    }
}
