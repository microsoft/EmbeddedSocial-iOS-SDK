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
    var peopleTab: SearchTabInfo!
    
    var selectedTab: SearchTabInfo? {
        didSet {
            guard let oldValue = oldValue, let selectedTab = selectedTab, oldValue != selectedTab else {
                return
            }
            view.switchTabs(to: selectedTab, from: oldValue)
        }
    }
}

extension SearchPresenter: SearchViewOutput {
    
    func viewIsReady() {
        peopleSearchModule.setupInitialState()
        
        peopleTab = interactor.makePeopleTab(with: peopleSearchModule)
        topicsTab = interactor.makeTopicsTab(feedViewController: feedViewController, searchResultsHandler: self)
        selectedTab = topicsTab
        
        view.setupInitialState(topicsTab)
        
        if let feedModuleInput = feedModuleInput {
            view.setLayoutAsset(feedModuleInput.layout.nextLayoutAsset)
        }
    }
    
    func onTopics() {
        selectedTab = topicsTab
    }
    
    func onPeople() {
        selectedTab = peopleTab
    }
    
    func onFlipFeedLayout() {
        guard let feedModuleInput = feedModuleInput else {
            return
        }
        feedModuleInput.layout = feedModuleInput.layout.flipped
        view.setLayoutAsset(feedModuleInput.layout.nextLayoutAsset)
    }
}

extension SearchPresenter: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        // Throttle search events https://stackoverflow.com/a/29760716/6870041
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.runSearchQuery(for:)),
                                               object: searchController)
        perform(#selector(self.runSearchQuery(for:)), with: searchController, afterDelay: 0.5)
    }
    
    @objc private func runSearchQuery(for searchController: UISearchController) {
        if let feedModule = feedModuleInput {
            interactor.runSearchQuery(for: searchController, feedModule: feedModule)
        }
    }
}

extension SearchPresenter: FeedModuleOutput {
    
    func shouldOpenProfile(for userID: String) -> Bool {
        return true
    }
}

extension SearchPresenter: SearchPeopleModuleOutput {
    
    func didFailToLoadSuggestedUsers(_ error: Error) { }
    
    func didFailToLoadSearchQuery(_ error: Error) {
        view.showError(error)
    }
}
