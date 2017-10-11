//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

private protocol SearchBarDelegateHandlerDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar)
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar)
}

final class SearchBarMulticastDelegate: MulticastDelegate<UISearchBarDelegate> {
    

    
    private class SearchBarDelegateHandler: NSObject, UISearchBarDelegate, SearchBarDelegateHandlerDelegate {
        
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
    
    init(searchBar: UISearchBar) {
        searchBar.delegate = self
        super.init()
    }
}
