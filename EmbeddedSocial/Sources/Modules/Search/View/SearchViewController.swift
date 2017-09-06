//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit
import SnapKit

class SearchViewController: UIViewController {
    
    var output: SearchViewOutput!

    fileprivate var peopleSearchController: UISearchController?
    fileprivate var peopleSearchText: String?
    
    fileprivate var topicsSearchController: UISearchController?
    fileprivate var topicsSearchText: String?
    
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
//        activeSearchController?.isActive = false
    }
    
    fileprivate func makeTabActive(_ tab: SearchTabInfo) {
        if tab.tab == .topics {
            setupTopicsSearchController(with: tab)
        } else if tab.tab == .people {
            setupPeopleSearchController(with: tab)
        }
        if let backgroundView = tab.backgroundView {
            addBackgroundView(backgroundView)
        }
    }
    
    private func setupPeopleSearchController(with tab: SearchTabInfo) {
        if peopleSearchController == nil {
            peopleSearchController = makeSearchController(with: tab)
        } else {
            peopleSearchController?.isActive = true
        }
        navigationItem.titleView = peopleSearchController?.searchBar
        navigationItem.rightBarButtonItem = nil
        peopleSearchController?.searchBar.text = peopleSearchText
    }
    
    private func setupTopicsSearchController(with tab: SearchTabInfo) {
        if topicsSearchController == nil {
            topicsSearchController = makeSearchController(with: tab)
        } else {
            topicsSearchController?.isActive = true
        }
        
        navigationItem.titleView = topicsSearchController?.searchBar
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: feedLayoutButton)
        topicsSearchController?.searchBar.text = self.topicsSearchText
    }
    
    fileprivate func makeSearchController(with tabInfo: SearchTabInfo) -> UISearchController {
        let searchController = UISearchController(searchResultsController: tabInfo.searchResultsController)
        searchController.searchResultsUpdater = tabInfo.searchResultsHandler
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.placeholder = tabInfo.tab.searchBarPlaceholder
        searchController.delegate = self
        return searchController
    }
    
    fileprivate func hideTab(_ tab: SearchTabInfo) {
        if tab.tab == .topics {
            topicsSearchController?.isActive = false
        } else if tab.tab == .people {
            peopleSearchController?.isActive = false
        }
        if let backgroundView = tab.backgroundView {
            backgroundView.removeFromSuperview()
        }
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
        hideTab(previousTab)
        makeTabActive(tab)
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
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if peopleSearchController?.isActive == true {
            peopleSearchText = searchText
        } else if topicsSearchController?.isActive == true {
            topicsSearchText = searchText
        }
    }
}

extension SearchViewController: UISearchControllerDelegate {
    
//    func willPresentSearchController(_ searchController: UISearchController) {
//        updateSearchControllerFrame(searchController)
//    }

    func didPresentSearchController(_ searchController: UISearchController) {
        updateSearchControllerFrame(searchController)
    }
    
    private func updateSearchControllerFrame(_ searchController: UISearchController) {
        var frame = searchController.view.frame
        frame.origin.y += Constants.Search.filterHeight
        frame.size.height -= Constants.Search.filterHeight
        searchController.view.frame = frame
    }
}
