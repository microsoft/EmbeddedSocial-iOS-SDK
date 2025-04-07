//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

struct TrendingTopicsListItem {
    let hashtag: Hashtag
}

extension TrendingTopicsListItem: CellModel {
    var cellClass: UITableViewCell.Type {
        return UITableViewCell.self
    }
    
    var reuseID: String {
        return UITableViewCell.reuseID
    }
}
