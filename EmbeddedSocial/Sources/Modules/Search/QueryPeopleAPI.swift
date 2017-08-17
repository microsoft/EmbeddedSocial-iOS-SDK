//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class QueryPeopleAPI: UsersListAPI {
    private let query: String
    private let authorization: Authorization
    private let errorHandler: APIErrorHandler

    init(query: String,
         authorization: Authorization = SocialPlus.shared.authorization,
         errorHandler: APIErrorHandler = UnauthorizedErrorHandler()) {
        self.query = query
        self.authorization = authorization
        self.errorHandler = errorHandler
    }
    
    func getUsersList(cursor: String?, limit: Int, completion: @escaping (Result<UsersListResponse>) -> Void) {
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
