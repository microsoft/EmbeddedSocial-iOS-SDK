//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

struct SearchTabInfo {
    let searchResultsController: UIViewController
    let searchResultsHandler: UISearchResultsUpdating
    let backgroundView: UIView?
    let searchBarPlaceholder: String?
}

extension SearchTabInfo: Equatable {
    static func ==(lhs: SearchTabInfo, rhs: SearchTabInfo) -> Bool {
        return lhs.searchResultsController == rhs.searchResultsController &&
            lhs.searchResultsHandler === rhs.searchResultsHandler &&
            lhs.backgroundView == rhs.backgroundView &&
            lhs.searchBarPlaceholder == rhs.searchBarPlaceholder
    }
}
