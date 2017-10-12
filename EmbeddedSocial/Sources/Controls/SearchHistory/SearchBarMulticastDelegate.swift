//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class SearchBarMulticastDelegate: NSObject, UISearchBarDelegate {
    
    private let multicast = MulticastDelegate<UISearchBarDelegate>()
    
    init(searchBar: UISearchBar) {
        super.init()
        searchBar.delegate = self
    }
    
    func addDelegate(_ delegate: UISearchBarDelegate) {
        multicast.add(delegate)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        multicast.invoke { $0.searchBarSearchButtonClicked?(searchBar) }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        multicast.invoke { $0.searchBar?(searchBar, textDidChange: searchText) }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        multicast.invoke { $0.searchBarCancelButtonClicked?(searchBar) }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        multicast.invoke { $0.searchBarTextDidBeginEditing?(searchBar) }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        multicast.invoke { $0.searchBarTextDidEndEditing?(searchBar) }
    }
}
