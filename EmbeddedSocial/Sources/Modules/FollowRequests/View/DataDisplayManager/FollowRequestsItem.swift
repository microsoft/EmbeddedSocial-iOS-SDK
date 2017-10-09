//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

struct FollowRequestItem {
    let user: User
}

extension FollowRequestItem: CellModel {
    var cellClass: UITableViewCell.Type {
        return FollowRequestCell.self
    }
    
    var reuseID: String {
        return FollowRequestCell.reuseID
    }
}
