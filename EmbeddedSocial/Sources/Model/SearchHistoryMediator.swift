//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class SearchHistoryMediator: NSObject {
    private let storage: SearchHistoryStorage
    private let searchHistoryView: SearchHistoryView
    
    init(storage: SearchHistoryStorage, searchHistoryView: SearchHistoryView) {
        self.storage = storage
        self.searchHistoryView = searchHistoryView
        super.init()
    }
}

extension SearchHistoryMediator: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
    }
}
