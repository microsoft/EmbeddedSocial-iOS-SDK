//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit
import SnapKit

class SearchViewController: UIViewController {
    
    fileprivate var searchController: UISearchController!
    fileprivate var usersListModule: UserListModuleInput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let vc = UIViewController()
        setupUsersListModule(parentViewController: vc)
        setupSearchController(resultsController: vc)
    }
    
    private func setupSearchController(resultsController: UIViewController) {
        searchController = UISearchController(searchResultsController: resultsController)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        
        definesPresentationContext = true
        setupSearchBar()
    }
    
    private func setupSearchBar() {
        navigationItem.hidesBackButton = true
        navigationItem.titleView = searchController.searchBar
        navigationItem.rightBarButtonItem = nil
        searchController.searchBar.placeholder = L10n.Search.Placeholder.searchPeople
    }
    
    private func setupUsersListModule(parentViewController vc: UIViewController) {
        let conf = UserListConfigurator()
        usersListModule = conf.configure(api: QueryPeopleAPI(query: ""), output: nil)
        usersListModule.setupInitialState()
        let listView = usersListModule.listView
        listView.backgroundColor = .yellow
        vc.view.addSubview(listView)
        listView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension SearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        // Throttle search events. Shamelessly taken from https://stackoverflow.com/a/29760716/6870041
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.runSearchQuery), object: nil)
        perform(#selector(self.runSearchQuery), with: nil, afterDelay: 0.3)
    }
    
    @objc private func runSearchQuery() {
        guard let searchText = searchController.searchBar.text?.trimmingCharacters(in: .whitespaces) else {
            return
        }
        
        let queryAPI = QueryPeopleAPI(query: searchText)
        usersListModule.reload(with: queryAPI)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
