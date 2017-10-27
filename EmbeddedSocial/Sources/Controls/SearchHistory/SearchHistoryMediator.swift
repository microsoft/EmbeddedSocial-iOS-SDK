//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

class SearchHistoryMediator: NSObject {
    private let searchBar: UISearchBar
    fileprivate let storage: SearchHistoryStorage
    fileprivate let searchHistoryView: SearchHistoryView
    private let multicast: SearchBarMulticastDelegate
    
    fileprivate var hasSetHistoryView = false
    
    var activeTab: SearchTabInfo.Tab? {
        didSet {
            if let scope = activeTab?.rawValue {
                storage.scope = String(scope)
                searchHistoryView.searchRequests = storage.searchRequests()
                updateSearchHistoryVisibility()
            }
        }
    }
    
    init(searchBar: UISearchBar,
         searchBarDelegate: UISearchBarDelegate,
         storage: SearchHistoryStorage,
         searchHistoryView: SearchHistoryView) {
        
        multicast = SearchBarMulticastDelegate(searchBar: searchBar)
        self.searchBar = searchBar
        self.storage = storage
        self.searchHistoryView = searchHistoryView
        super.init()
        
        multicast.addDelegate(self)
        multicast.addDelegate(searchBarDelegate)
        
        searchHistoryView.isHidden = true
    }
    
    func handleSearchedText(_ searchText: String) {
        storage.save(searchText)
        searchHistoryView.isHidden = true
        searchHistoryView.searchRequests = storage.searchRequests()
    }
    
    fileprivate func setupHistoryView() {
        guard let parentView = searchHistoryView.superview else {
            return
        }
        
        let searchBarFrame = parentView.convert(searchBar.frame, from: searchBar.superview)
        var frame = CGRect()
        frame.size.width = searchBarFrame.size.width
        frame.origin = CGPoint(x: (parentView.bounds.width - frame.width) / 2.0, y: searchBarFrame.maxY)
        
        searchHistoryView.frame = frame
        searchHistoryView.maxHeight = Constants.Search.historyMaxHeight
        searchHistoryView.searchRequests = storage.searchRequests()

        hasSetHistoryView = true
    }
    
    fileprivate func updateSearchHistoryVisibility() {
        let searchText = searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let shouldShowHistory = searchBar.isFirstResponder && searchText.isEmpty
        searchHistoryView.isHidden = !shouldShowHistory
    }
}

extension SearchHistoryMediator: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchHistoryView.isHidden = true
        if let searchText = searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
            handleSearchedText(searchText)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
       updateSearchHistoryVisibility()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchHistoryView.isHidden = true
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if !hasSetHistoryView {
            setupHistoryView()
        }
        updateSearchHistoryVisibility()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchHistoryView.isHidden = true
    }
}
