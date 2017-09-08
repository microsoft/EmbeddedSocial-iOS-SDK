//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class SearchTopicsInteractor: SearchTopicsInteractorInput {
    
    func runSearchQuery(for searchBar: UISearchBar, feedModule: FeedModuleInput) {
        guard let searchText = searchBar.text?.trimmingCharacters(in: .whitespaces),
            !searchText.isEmpty else {
                return
        }
        feedModule.feedType = .search(query: searchText)
    }
}
