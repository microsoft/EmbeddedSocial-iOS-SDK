//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit
import SnapKit

class SearchViewController: UIViewController {
    
    var output: SearchViewOutput!
    
    fileprivate var activeTab: SearchTabInfo?
    
    @IBOutlet fileprivate weak var filterContainer: UIView!
    
    @IBOutlet fileprivate weak var searchResultsContainer: UIView!
    
    fileprivate lazy var filterView: SegmentedControlView = { [unowned self] in
        return SegmentedControlView.searchModuleControl(
            superview: self.filterContainer,
            onTopics: self.output.onTopics,
            onPeople: self.output.onPeople)
    }()
    
    fileprivate lazy var feedLayoutButton: UIButton = { [unowned self] in
        return UIButton.makeButton(asset: nil, color: Palette.defaultTint, action: self.output.onFlipTopicsLayout)
    }()
    
    fileprivate lazy var searchBar: UISearchBar = { [unowned self] in
        let searchBar = UISearchBar(frame: CGRect(x: 0.0, y: 0.0, width: 320.0, height: 44.0))
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
        return searchBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        apply(theme: theme)
        output.viewIsReady()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchBar.resignFirstResponder()
    }
    
    fileprivate func makeTabActive(_ tab: SearchTabInfo) {
        activeTab = tab
        searchBar.text = activeTab?.searchText
        searchBar.placeholder = activeTab?.tab.searchBarPlaceholder
        filterView.selectSegment(tab.tab.rawValue)

        addChildController(tab.searchResultsController, containerView: searchResultsContainer)
        
        tab.searchResultsController.view.isHidden = !(tab.searchText?.isEmpty == false)

        if let backgroundView = tab.backgroundView {
            addBackgroundView(backgroundView)
        }
        
        navigationItem.rightBarButtonItem =
            tab.tab.showsRightNavigationButton ? UIBarButtonItem(customView: feedLayoutButton) : nil
    }
    
    fileprivate func addBackgroundView(_ backgroundView: UIView) {
        searchResultsContainer.addSubview(backgroundView)
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        searchResultsContainer.sendSubview(toBack: backgroundView)
    }
    
    fileprivate func hideTab(_ tab: SearchTabInfo) {
        removeChildController(tab.searchResultsController)
        if let backgroundView = tab.backgroundView {
            backgroundView.removeFromSuperview()
        }
    }
    
    fileprivate func search(text searchText: String) {
        activeTab?.searchResultsController.view.isHidden = searchText.isEmpty
        activeTab?.searchText = searchText
        activeTab?.searchResultsHandler.updateSearchResults(for: searchBar)
    }
}

extension SearchViewController: SearchViewInput {
    
    func setupInitialState(_ tab: SearchTabInfo) {
        _ = filterView
        navigationItem.titleView = searchBar
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
    
    func search(hashtag: Hashtag) {
        searchBar.text = hashtag
        search(text: hashtag)
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        search(text: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: false)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: false)
    }
}

extension SearchViewController: Themeable {
    
    func apply(theme: Theme?) {
        guard let palette = theme?.palette else {
            return
        }
        view.backgroundColor = palette.contentBackground
        feedLayoutButton.tintColor = palette.navigationBarTint
        searchBar.tintColor = palette.navigationBarTint
        filterView.apply(theme: theme)
    }
}
