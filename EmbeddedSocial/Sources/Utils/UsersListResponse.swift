//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

struct UsersListResponse {
    let users: [User]
    let cursor: String?
    let isFromCache: Bool
}

extension UsersListResponse {
    init(response: FeedResponseUserCompactView?, isFromCache: Bool) {
        users = response?.data?.map(User.init) ?? []
        cursor = response?.cursor
        self.isFromCache = isFromCache
    }
}
