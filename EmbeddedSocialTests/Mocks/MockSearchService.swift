//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

class MockSearchService: SearchServiceType {
    var queryUsersResult: Result<UsersListResponse>?
    private(set) var queryUsersCount = 0
    private(set) var queryUsersInputValues: (query: String, cursor: String?, limit: Int)?
    
    func queryUsers(query: String, cursor: String?, limit: Int, completion: @escaping (Result<UsersListResponse>) -> Void) {
        queryUsersCount += 1
        queryUsersInputValues = (query, cursor, limit)
        if let result = queryUsersResult {
            completion(result)
        }
    }
    
    var queryTopicsResult: Result<FeedFetchResult>?
    private(set) var queryTopicsCount = 0
    private(set) var queryTopicsInputValues: (query: String, cursor: String?, limit: Int)?
    
    func queryTopics(query: String, cursor: String?, limit: Int, completion: @escaping (Result<FeedFetchResult>) -> Void) {
        queryTopicsCount += 1
        queryTopicsInputValues = (query, cursor, limit)
        if let result = queryTopicsResult {
            completion(result)
        }
    }
}
