//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit
import SnapKit

class SearchViewController: UIViewController {
    
    fileprivate var searchController: UISearchController?
    
    var output: SearchViewOutput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchController?.isActive = false
    }
    
    fileprivate func setupSearchController(_ pageInfo: SearchTabInfo) {
        searchController = UISearchController(searchResultsController: pageInfo.searchResultsController)
        searchController?.searchResultsUpdater = pageInfo.searchResultsHandler
        searchController?.dimsBackgroundDuringPresentation = false
        searchController?.searchBar.delegate = self
        searchController?.hidesNavigationBarDuringPresentation = false
    }
    
    fileprivate func addBackgroundView(_ backgroundView: UIView) {
        view.addSubview(backgroundView)
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    fileprivate func setupSearchBar() {
        navigationItem.titleView = searchController?.searchBar
        navigationItem.rightBarButtonItem = nil
        searchController?.searchBar.placeholder = L10n.Search.Placeholder.searchPeople
        searchController?.searchBar.searchBarStyle = .minimal
    }
}

extension SearchViewController: SearchViewInput {
    
    func setupInitialState(_ pageInfo: SearchTabInfo) {
        definesPresentationContext = true
        setupSearchController(pageInfo)
        setupSearchBar()
        if let backgroundView = pageInfo.backgroundView {
            addBackgroundView(backgroundView)
        }
    }
    
    func showError(_ error: Error) {
        showErrorAlert(error)
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
