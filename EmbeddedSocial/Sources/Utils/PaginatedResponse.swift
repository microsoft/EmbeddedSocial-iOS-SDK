//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

struct PaginatedResponse<Item, Cursor> {
    let items: [Item]
    let hasMore: Bool
    let error: Error?
    let cursor: Cursor?
    
    init(items: [Item] = [], hasMore: Bool = true, error: Error? = nil, cursor: Cursor? = nil) {
        self.items = items
        self.hasMore = hasMore
        self.error = error
        self.cursor = cursor
    }
}

extension PaginatedResponse where Item == User, Cursor == String {
    func reduce(result: Result<UsersListResponse>) -> PaginatedResponse {
        let itemsToAdd = result.value?.users ?? []
        return PaginatedResponse(items: itemsToAdd + items,
                                 hasMore: result.value?.cursor != nil,
                                 error: result.error ?? error,
                                 cursor: result.value?.cursor)
    }
}
