//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

struct SearchPageInfo {
    let searchResultsController: UIViewController
    let searchResultsHandler: UISearchResultsUpdating
    let backgroundView: UIView?
}

extension SearchPageInfo: Equatable {
    static func ==(lhs: SearchPageInfo, rhs: SearchPageInfo) -> Bool {
        return lhs.searchResultsController == rhs.searchResultsController &&
            lhs.searchResultsHandler === rhs.searchResultsHandler &&
            lhs.backgroundView == rhs.backgroundView
    }
}
