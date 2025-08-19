//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

typealias UsersListResponse = PaginatedResponse<User>

struct PaginatedResponse<Item> {
    var items: [Item]
    let cursor: String?
    let isFromCache: Bool
    
    var hasMore: Bool {
        return cursor != nil
    }
    
    init(items: [Item] = [], cursor: String? = nil, isFromCache: Bool = false) {
        self.items = items
        self.cursor = cursor
        self.isFromCache = isFromCache
    }
}

extension PaginatedResponse where Item == User {
    func reduce(result: Result<UsersListResponse>, isFromCache: Bool) -> PaginatedResponse {
        let itemsToAdd = result.value?.items ?? []
        return PaginatedResponse(items: items + itemsToAdd,
                                 cursor: result.value?.cursor,
                                 isFromCache: isFromCache)
    }
    
    init(response: FeedResponseUserCompactView?, isFromCache: Bool) {
        items = response?.data?.map(User.init) ?? []
        cursor = response?.cursor
        self.isFromCache = isFromCache
    }
    
    init(response: FeedResponseUserProfileView?, isFromCache: Bool) {
        items = response?.data?.flatMap { User(profileView: $0) } ?? []
        cursor = response?.cursor
        self.isFromCache = isFromCache
    }
}
