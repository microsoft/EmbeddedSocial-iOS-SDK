//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class QueryPeopleAPI: UsersListAPI {
    private let query: String
    private let searchService: SearchServiceType

    init(query: String, searchService: SearchServiceType) {
        self.query = query
        self.searchService = searchService
    }
    
    func getUsersList(cursor: String?, limit: Int, completion: @escaping (Result<UsersListResponse>) -> Void) {
        searchService.queryUsers(query: query, cursor: cursor, limit: limit, completion: completion)
    }
}
