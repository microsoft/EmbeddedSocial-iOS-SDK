//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

struct UsersListResponse {
    let users: [User]
    let cursor: String?
}

extension UsersListResponse: Equatable {
    static func ==(lhs: UsersListResponse, rhs: UsersListResponse) -> Bool {
        return lhs.users == rhs.users && lhs.cursor == rhs.cursor
    }
}
