//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

struct ListPage<ListItem>: Hashable {
    let uid: String
    let response: PaginatedResponse<ListItem>
    
    var hashValue: Int {
        return uid.hashValue
    }
    
    static func ==(lhs: ListPage<ListItem>, rhs: ListPage<ListItem>) -> Bool {
        return lhs.uid == rhs.uid
    }
}
