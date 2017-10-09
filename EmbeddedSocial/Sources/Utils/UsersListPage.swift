//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

struct UsersListPage: Hashable {
    let uid: String
    let response: UsersListResponse
    
    var hashValue: Int {
        return uid.hashValue
    }
    
    static func ==(lhs: UsersListPage, rhs: UsersListPage) -> Bool {
        return lhs.uid == rhs.uid
    }
}
