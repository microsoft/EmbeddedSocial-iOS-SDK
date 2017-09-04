//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit
import SnapKit

class SearchViewController: UIViewController {
    
    var output: SearchViewOutput!

    fileprivate var searchController: UISearchController?
    
    fileprivate lazy var filterView: SegmentedControlView = { [unowned self] in
        return SegmentedControlView.searchModuleControl(
            superview: self.view,
            onTopics: self.output.onTopics,
            onPeople: self.output.onPeople)
    }()
    
    fileprivate lazy var feedLayoutButton: UIButton = { [unowned self] in
        return UIButton.makeButton(asset: nil, color: Palette.defaultTint, action: self.output.onFlipTopicsLayout)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchController?.isActive = false
    }
    
    fileprivate func setupSearchController(_ tabInfo: SearchTabInfo) {
        searchController = UISearchController(searchResultsController: tabInfo.searchResultsController)
        searchController?.searchResultsUpdater = tabInfo.searchResultsHandler
        searchController?.dimsBackgroundDuringPresentation = false
        searchController?.searchBar.delegate = self
        searchController?.hidesNavigationBarDuringPresentation = false
        searchController?.searchBar.searchBarStyle = .minimal
        searchController?.searchBar.placeholder = tabInfo.tab.searchBarPlaceholder
        searchController?.delegate = self
        
        navigationItem.titleView = searchController?.searchBar
        navigationItem.rightBarButtonItem =
            tabInfo.tab.showsRightNavigationButton ? UIBarButtonItem(customView: feedLayoutButton) : nil
    }
    
    fileprivate func addBackgroundView(_ backgroundView: UIView) {
        view.addSubview(backgroundView)
        backgroundView.snp.makeConstraints { make in
            make.top.equalTo(filterView.snp.bottom)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}

extension SearchViewController: SearchViewInput {
    
    func setupInitialState(_ tab: SearchTabInfo) {
        definesPresentationContext = true
        _ = filterView
        makeTabActive(tab)
    }
    
    func switchTabs(to tab: SearchTabInfo, from previousTab: SearchTabInfo) {
        removeTab(previousTab)
        makeTabActive(tab)
    }
    
    private func makeTabActive(_ tab: SearchTabInfo) {
        setupSearchController(tab)
        if let backgroundView = tab.backgroundView {
            addBackgroundView(backgroundView)
        }
    }
    
    private func removeTab(_ tab: SearchTabInfo) {
        if let searchController = searchController {
            searchController.isActive = false
            searchController.removeFromParentViewController()
        }
        if let backgroundView = tab.backgroundView {
            backgroundView.removeFromSuperview()
        }
    }
    
    func showError(_ error: Error) {
        showErrorAlert(error)
    }
    
    func setLayoutAsset(_ asset: Asset) {
        feedLayoutButton.setImage(UIImage(asset: asset), for: .normal)
        feedLayoutButton.sizeToFit()
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension SearchViewController: UISearchControllerDelegate {

    func didPresentSearchController(_ searchController: UISearchController) {
        var frame = searchController.view.frame
        frame.origin.y += Constants.Search.filterHeight
        frame.size.height -= Constants.Search.filterHeight
        searchController.view.frame = frame
    }
}
