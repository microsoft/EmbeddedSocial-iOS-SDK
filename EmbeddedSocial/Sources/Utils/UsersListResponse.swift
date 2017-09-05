//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

struct UsersListResponse {
    let users: [User]
    let cursor: String?
}

extension UsersListResponse {
    init(response: FeedResponseUserCompactView?) {
        users = response?.data?.map(User.init) ?? []
        cursor = response?.cursor
    }
}
