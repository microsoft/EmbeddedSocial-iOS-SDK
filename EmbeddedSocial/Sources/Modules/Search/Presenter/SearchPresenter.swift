//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class SearchPresenter: NSObject {
    weak var view: SearchViewInput!
    var peopleSearchModule: SearchPeopleModuleInput!
    var interactor: SearchInteractorInput!
    
    var feedViewController: UIViewController?
    var feedModuleInput: FeedModuleInput?
    
    var topicsTab: SearchTabInfo!
    var usersTab: SearchTabInfo!
}

extension SearchPresenter: SearchViewOutput {
    
    func viewIsReady() {
        peopleSearchModule.setupInitialState()
        
//        usersTab = interactor.makeTabInfo(from: peopleSearchModule)
//        view.setupInitialState(usersTab)
        
        setupFeed()
    }
    
    private func setupFeed() {
        guard let feedViewController = feedViewController, let feedModuleInput = feedModuleInput else {
            return
        }
        topicsTab = SearchTabInfo(searchResultsController: feedViewController, searchResultsHandler: self, backgroundView: nil)
        view.setupInitialState(topicsTab)
    }
}

extension SearchPresenter: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        // Throttle search events https://stackoverflow.com/a/29760716/6870041
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.runSearchQuery(for:)), object: searchController)
        perform(#selector(self.runSearchQuery(for:)), with: searchController, afterDelay: 0.5)
    }
    
    @objc private func runSearchQuery(for searchController: UISearchController) {
        if let feedModule = feedModuleInput {
            interactor.runSearchQuery(for: searchController, feedModule: feedModule)
        }
    }
}

extension SearchPresenter: FeedModuleOutput {
    
}

extension SearchPresenter: SearchPeopleModuleOutput {
    
    func didFailToLoadSuggestedUsers(_ error: Error) {
        view.showError(error)
    }
    
    func didFailToLoadSearchQuery(_ error: Error) {
        view.showError(error)
    }
}
