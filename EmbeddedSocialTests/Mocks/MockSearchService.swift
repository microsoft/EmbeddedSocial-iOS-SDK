//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

class MockSearchService: SearchServiceType {
    var queryResult: Result<UsersListResponse>?
    private(set) var queryUsersCount = 0
    private(set) var lastQuery: String?
    
    func queryUsers(query: String, cursor: String?, limit: Int, completion: @escaping (Result<UsersListResponse>) -> Void) {
        queryUsersCount += 1
        lastQuery = query
        if let result = queryResult {
            completion(result)
        }
    }
}
