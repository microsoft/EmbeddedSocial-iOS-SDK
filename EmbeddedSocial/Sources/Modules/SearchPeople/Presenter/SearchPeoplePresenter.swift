//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class SearchPeoplePresenter: NSObject {
    var view: SearchPeopleViewInput!
    var usersListModule: UserListModuleInput!
    var backgroundUsersListModule: UserListModuleInput?
    var interactor: SearchPeopleInteractorInput!
    weak var moduleOutput: SearchPeopleModuleOutput?
}

extension SearchPeoplePresenter: SearchPeopleViewOutput {
    
}

extension SearchPeoplePresenter: SearchPeopleModuleInput {
    
    func setupInitialState() {
        usersListModule.setupInitialState()
        backgroundUsersListModule?.setupInitialState()
        backgroundUsersListModule?.setListHeaderView(interactor.makeBackgroundListHeaderView())
        view.setupInitialState(listView: usersListModule.listView)
    }
    
    func searchResultsHandler() -> UISearchResultsUpdating {
        return self
    }
    
    func backgroundView() -> UIView? {
        return backgroundUsersListModule?.listView
    }
    
    func searchResultsController() -> UIViewController {
        return (view as? UIViewController) ?? UIViewController()
    }
}

extension SearchPeoplePresenter: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        // Throttle search events https://stackoverflow.com/a/29760716/6870041
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.runSearchQuery(for:)), object: searchController)
        perform(#selector(self.runSearchQuery(for:)), with: searchController, afterDelay: 0.5)
    }
    
    @objc private func runSearchQuery(for searchController: UISearchController) {
        interactor.runSearchQuery(for: searchController, usersListModule: usersListModule)
    }
}

extension SearchPeoplePresenter: UserListModuleOutput {
    
    func didFailToLoadList(listView: UIView, error: Error) {
        if listView == backgroundUsersListModule?.listView {
            moduleOutput?.didFailToLoadSuggestedUsers(error)
        } else if listView == usersListModule.listView {
            moduleOutput?.didFailToLoadSearchQuery(error)
        }
    }
}
