//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit
import SnapKit

class SearchViewController: UIViewController {
    
    var output: SearchViewOutput!

    fileprivate var peopleSearchContainer: UISearchContainerViewController?
    fileprivate var topicsSearchContainer: UISearchContainerViewController?
    
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
//            addChildController(peopleSearchContainer!)
            setupSearchResultsControllerFrame(peopleSearchContainer!.searchController.searchResultsController!)
        }
        
        displaySearchController(peopleSearchContainer!)

        navigationItem.titleView = peopleSearchContainer?.searchController.searchBar
        navigationItem.rightBarButtonItem = nil
    }
    
    private func setupTopicsSearchController(with tab: SearchTabInfo) {
        if topicsSearchContainer == nil {
            topicsSearchContainer = makeSearchContainer(with: tab)
//            addChildController(topicsSearchContainer!)
            setupSearchResultsControllerFrame(topicsSearchContainer!.searchController.searchResultsController!)
        }
        
        displaySearchController(topicsSearchContainer!)
        
        navigationItem.titleView = topicsSearchContainer?.searchController.searchBar
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: feedLayoutButton)
    }
    
    fileprivate func makeSearchContainer(with tabInfo: SearchTabInfo) -> UISearchContainerViewController {
        let searchController = UISearchController(searchResultsController: tabInfo.searchResultsController)
        searchController.searchResultsUpdater = tabInfo.searchResultsHandler
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.placeholder = tabInfo.tab.searchBarPlaceholder
        searchController.delegate = self
        
        let container = UISearchContainerViewController(searchController: searchController)
        
        _ = container.view
        _ = container.searchController.view
        _ = container.searchController.searchResultsController?.view
        
        if let backgroundView = tabInfo.backgroundView {
            addBackgroundView(backgroundView, to: container.view)
        }
        
        return container
    }
    
    private func setupSearchResultsControllerFrame(_ controller: UIViewController) {
        controller.edgesForExtendedLayout = []
        
        let navBarAndTabBarHeight: CGFloat = 64.0
        var frame = controller.view.frame
        frame.origin.y -= navBarAndTabBarHeight
        frame.size.height += navBarAndTabBarHeight
        controller.view.frame = frame
    }
    
    fileprivate func addBackgroundView(_ backgroundView: UIView, to superview: UIView) {
        superview.addSubview(backgroundView)
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func addChildController(_ content: UIViewController) {
        addChildViewController(content)
        
        view.addSubview(content.view)
        content.view.snp.makeConstraints { make in
            make.top.equalTo(self.filterView.snp.bottom)
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        content.didMove(toParentViewController: self)
    }
    
    func displaySearchController(_ controller: UISearchContainerViewController) {
        controller.view.isHidden = false
        controller.searchController.view.isHidden = false
        controller.searchController.searchResultsController?.view.isHidden = false
        controller.searchController.searchBar.becomeFirstResponder()
    }
    
    fileprivate func hideTab(_ tab: SearchTabInfo) {
        if tab.tab == .topics {
            hideSearchController(topicsSearchContainer!)
        } else if tab.tab == .people {
            hideSearchController(peopleSearchContainer!)
        }
    }
    
    func hideSearchController(_ controller: UISearchContainerViewController) {
        controller.view.isHidden = true
        controller.searchController.view.isHidden = true
        controller.searchController.searchResultsController?.view.isHidden = true
    }
    
    func removeChildController(_ controller: UIViewController) {
        controller.willMove(toParentViewController: nil)
        controller.view.removeFromSuperview()
        controller.removeFromParentViewController()
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
}

extension SearchViewController: UISearchControllerDelegate {
    func willPresentSearchController(_ searchController: UISearchController) {
        updateSearchControllerFrame(searchController)
    }
    
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
