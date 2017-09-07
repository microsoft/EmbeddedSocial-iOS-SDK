//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class SearchInteractor: SearchInteractorInput {
    
    func makeTopicsTab(feedViewController: UIViewController?, searchResultsHandler: SearchResultsUpdating) -> SearchTabInfo {
        return SearchTabInfo(searchResultsController: feedViewController ?? UIViewController(),
                             searchResultsHandler: searchResultsHandler,
                             backgroundView: nil,
                             tab: .topics)
    }
    
    func makePeopleTab(with searchPeopleModule: SearchPeopleModuleInput) -> SearchTabInfo {
        return SearchTabInfo(searchResultsController: searchPeopleModule.searchResultsController(),
                             searchResultsHandler: searchPeopleModule.searchResultsHandler(),
                             backgroundView: searchPeopleModule.backgroundView(),
                             tab: .people)
    }
    
    func runSearchQuery(for searchBar: UISearchBar, feedModule: FeedModuleInput) {
        guard let searchText = searchBar.text?.trimmingCharacters(in: .whitespaces),
            !searchText.isEmpty else {
                return
        }
        feedModule.feedType = .search(query: searchText)
    }
}
