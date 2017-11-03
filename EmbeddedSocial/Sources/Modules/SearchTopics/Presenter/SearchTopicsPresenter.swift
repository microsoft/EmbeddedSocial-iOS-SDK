//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

final class SearchTopicsPresenter: NSObject {
    var view: SearchTopicsViewInput!
    var feedModule: FeedModuleInput!
    var feedViewController: UIViewController!
    var interactor: SearchTopicsInteractorInput!
    var trendingTopicsModule: TrendingTopicsModuleInput!
    weak var moduleOutput: SearchTopicsModuleOutput?
}

extension SearchTopicsPresenter: SearchTopicsModuleInput {
    
    func setupInitialState() {
        view.setupInitialState(with: feedViewController)
    }
    
    func searchResultsHandler() -> SearchResultsUpdating {
        return self
    }
    
    func backgroundView() -> UIView? {
        return trendingTopicsModule.viewController.view
    }
    
    func searchResultsController() -> UIViewController {
        return (view as? UIViewController) ?? UIViewController()
    }
    
    func flipLayout() {
        feedModule.layout = feedModule.layout.flipped
    }
    
    var layoutAsset: Asset {
        return feedModule.layout.nextLayoutAsset
    }
}

extension SearchTopicsPresenter: SearchResultsUpdating {
    
    func updateSearchResults(for searchBar: UISearchBar) {
        // Throttle search events https://stackoverflow.com/a/29760716/6870041
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.runSearchQuery(for:)),
                                               object: searchBar)
        perform(#selector(self.runSearchQuery(for:)), with: searchBar, afterDelay: 0.5)
    }
    
    @objc private func runSearchQuery(for searchBar: UISearchBar) {
        interactor.runSearchQuery(for: searchBar, feedModule: feedModule)
    }
}

extension SearchTopicsPresenter: SearchTopicsViewOutput { }

extension SearchTopicsPresenter: FeedModuleOutput {
    
    func shouldOpenProfile(for userID: String) -> Bool {
        return true
    }
    
    func didStartRefreshingData() {
        moduleOutput?.didStartLoadingSearchTopicsQuery()
    }
    
    func didFinishRefreshingData(_ error: Error?) {
        view.setIsEmpty(feedModule.isEmpty)
        moduleOutput?.didLoadSearchTopicsQuery()
    }
}

extension SearchTopicsPresenter: TrendingTopicsModuleOutput {
    
    func didSelectHashtag(_ hashtag: Hashtag) {
        moduleOutput?.didSelectHashtag(hashtag)
    }
}
