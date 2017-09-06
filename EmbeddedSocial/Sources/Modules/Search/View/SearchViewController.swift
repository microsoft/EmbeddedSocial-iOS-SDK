//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit
import SnapKit

class SearchViewController: UIViewController {
    
    var output: SearchViewOutput!

    fileprivate var peopleSearchContainer: UISearchContainerViewController?
    fileprivate var peopleSearchText: String?
    
    fileprivate var topicsSearchContainer: UISearchContainerViewController?
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
    }
    
    private func setupPeopleSearchController(with tab: SearchTabInfo) {
        if peopleSearchContainer == nil {
            peopleSearchContainer = makeSearchContainer(with: tab)
        }
        
        displayContentController(peopleSearchContainer!)

        navigationItem.titleView = peopleSearchContainer?.searchController.searchBar
        navigationItem.rightBarButtonItem = nil
//        peopleSearchContainer?.searchBar.text = peopleSearchText
    }
    
    private func setupTopicsSearchController(with tab: SearchTabInfo) {
        if topicsSearchContainer == nil {
            topicsSearchContainer = makeSearchContainer(with: tab)
        }
        
        displayContentController(topicsSearchContainer!)
        
        navigationItem.titleView = topicsSearchContainer?.searchController.searchBar
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: feedLayoutButton)
//        topicsSearchContainer?.searchBar.text = topicsSearchText
    }
    
    fileprivate func makeSearchContainer(with tabInfo: SearchTabInfo) -> UISearchContainerViewController {
        let searchController = UISearchController(searchResultsController: tabInfo.searchResultsController)
        searchController.searchResultsUpdater = tabInfo.searchResultsHandler
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.placeholder = tabInfo.tab.searchBarPlaceholder
//        searchController.delegate = self
        
        let container = UISearchContainerViewController(searchController: searchController)
        
        if let backgroundView = tabInfo.backgroundView {
            addBackgroundView(backgroundView, to: container.view)
        }
        
        return container
    }
    
    func displayContentController(_ content: UIViewController) {
        addChildViewController(content)
        
        var frame = view.bounds
        frame.origin.y += Constants.Search.filterHeight
        frame.size.height -= Constants.Search.filterHeight
        content.view.frame = frame
        
        view.addSubview(content.view)
        content.didMove(toParentViewController: self)
        
        view.bringSubview(toFront: content.view)
    }
    
    func hideContentController(_ content: UIViewController) {
        content.willMove(toParentViewController: nil)
        content.view.removeFromSuperview()
        content.removeFromParentViewController()
    }
    
    fileprivate func hideTab(_ tab: SearchTabInfo) {
        if tab.tab == .topics {
            hideContentController(topicsSearchContainer!)
        } else if tab.tab == .people {
            hideContentController(peopleSearchContainer!)
        }
    }
    
    fileprivate func addBackgroundView(_ backgroundView: UIView, to superview: UIView) {
        superview.addSubview(backgroundView)
        backgroundView.snp.makeConstraints { make in
//            make.top.equalTo(filterView.snp.bottom)
//            make.left.equalToSuperview()
//            make.right.equalToSuperview()
//            make.bottom.equalToSuperview()
            make.edges.equalToSuperview()
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
        if peopleSearchContainer?.searchController.isActive == true {
            peopleSearchText = searchText
        } else if topicsSearchContainer?.searchController.isActive == true {
            topicsSearchText = searchText
        }
    }
}

//extension SearchViewController: UISearchControllerDelegate {
//    
////    func willPresentSearchController(_ searchController: UISearchController) {
////        updateSearchControllerFrame(searchController)
////    }
//
//    func didPresentSearchController(_ searchController: UISearchController) {
//        updateSearchControllerFrame(searchController)
//    }
//    
//    private func updateSearchControllerFrame(_ searchController: UISearchController) {
//        var frame = searchController.view.frame
//        frame.origin.y += Constants.Search.filterHeight
//        frame.size.height -= Constants.Search.filterHeight
//        searchController.view.frame = frame
//    }
//}
