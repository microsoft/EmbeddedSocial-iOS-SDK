//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class SearchInteractor: SearchInteractorInput {
    
    func makeTabInfo(from searchPeopleModule: SearchPeopleModuleInput) -> SearchTabInfo {
        return SearchTabInfo(searchResultsController: searchPeopleModule.searchResultsController(),
                              searchResultsHandler: searchPeopleModule.searchResultsHandler(),
                              backgroundView: searchPeopleModule.backgroundView(),
                              searchBarPlaceholder: L10n.Search.Placeholder.searchPeople)
    }
    
    func runSearchQuery(for searchController: UISearchController, feedModule: FeedModuleInput) {
        guard let searchText = searchController.searchBar.text?.trimmingCharacters(in: .whitespaces),
            !searchText.isEmpty else {
                return
        }
        feedModule.feedType = .search(query: searchText)
    }
}
