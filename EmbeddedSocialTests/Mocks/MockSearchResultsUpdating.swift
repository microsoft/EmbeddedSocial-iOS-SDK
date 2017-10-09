//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit
@testable import EmbeddedSocial

final class MockSearchResultsUpdating: SearchResultsUpdating {
    var searchBar: UISearchBar?
    private(set) var updateSearchResultsCount = 0
    
    func updateSearchResults(for searchBar: UISearchBar) {
        updateSearchResultsCount += 1
        self.searchBar = searchBar
    }
}
