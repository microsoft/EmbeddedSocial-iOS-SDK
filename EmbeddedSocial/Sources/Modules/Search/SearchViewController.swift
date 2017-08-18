//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit
import SnapKit

class SearchViewController: UIViewController {
    
    fileprivate var searchController: UISearchController!
    
    var output: SearchViewOutput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
    }
    
    fileprivate func setupSearchController(_ pageInfo: SearchPageInfo) {
        searchController = UISearchController(searchResultsController: pageInfo.searchResultsController)
        searchController.searchResultsUpdater = pageInfo.searchResultsHandler
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        
        definesPresentationContext = true
        
        setupSearchBar()
    }
    
    fileprivate func addBackgroundView(_ backgroundView: UIView) {
        view.addSubview(backgroundView)
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupSearchBar() {
        navigationItem.hidesBackButton = true
        navigationItem.titleView = searchController.searchBar
        navigationItem.rightBarButtonItem = nil
        searchController.searchBar.placeholder = L10n.Search.Placeholder.searchPeople
    }
}

extension SearchViewController: SearchViewInput {
    
    func setupInitialState(_ pageInfo: SearchPageInfo) {
        setupSearchController(pageInfo)
        addBackgroundView(pageInfo.backgroundView)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
