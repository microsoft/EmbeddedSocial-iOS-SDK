//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

struct UserListItem {
    let user: User
    let action: ((UserListItem) -> Void)?
}

extension UserListItem: CellModel {
    var cellClass: UITableViewCell.Type {
        return UserListCell.self
    }
    
    var reuseID: String {
        return UserListCell.reuseID
    }
}
