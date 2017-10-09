//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

extension UIScrollView {
    
    func isReachingEndOfContent(cellHeight: CGFloat, cellsPerPage: Int) -> Bool {
        let contentLeft = contentSize.height - contentOffset.y - bounds.height
        let cellsLeft = contentLeft / cellHeight
        return cellsLeft < CGFloat(Constants.FollowRequests.pageSize) / CGFloat(cellsPerPage)
    }
}
