//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

final class MockSearchResultsUpdating: NSObject, UISearchResultsUpdating {
    var searchController: UISearchController?
    private(set) var updateSearchResultsCount = 0
    
    func updateSearchResults(for searchController: UISearchController) {
        updateSearchResultsCount += 1
    }
}
