//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

final class SearchTabInfo {
    
    enum Tab: Int {
        case topics
        case people
        
        var searchBarPlaceholder: String {
            switch self {
            case .topics: return L10n.Search.Placeholder.searchTopics
            case .people: return L10n.Search.Placeholder.searchPeople
            }
        }
        
        var showsRightNavigationButton: Bool {
            switch self {
            case .topics: return true
            case .people: return false
            }
        }
    }
    
    let searchResultsController: UIViewController
    let searchResultsHandler: SearchResultsUpdating
    let backgroundView: UIView?
    let tab: Tab
    var searchText: String?
    
    init(searchResultsController: UIViewController,
         searchResultsHandler: SearchResultsUpdating,
         backgroundView: UIView?,
         tab: Tab,
         searchText: String? = nil) {
        
        self.searchResultsController = searchResultsController
        self.searchResultsHandler = searchResultsHandler
        self.backgroundView = backgroundView
        self.tab = tab
        self.searchText = searchText
    }
}

extension SearchTabInfo: Equatable {
    
    static func ==(lhs: SearchTabInfo, rhs: SearchTabInfo) -> Bool {
        return lhs.searchResultsController == rhs.searchResultsController &&
            lhs.searchResultsHandler === rhs.searchResultsHandler &&
            lhs.backgroundView == rhs.backgroundView &&
            lhs.tab == rhs.tab &&
            lhs.searchText == rhs.searchText
    }
}
