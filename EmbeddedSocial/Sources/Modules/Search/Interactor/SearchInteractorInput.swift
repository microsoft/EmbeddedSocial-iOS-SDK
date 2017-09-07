//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol SearchInteractorInput: class {
    func makePeopleTab(with searchPeopleModule: SearchPeopleModuleInput) -> SearchTabInfo
    
    func makeTopicsTab(feedViewController: UIViewController?, searchResultsHandler: SearchResultsUpdating) -> SearchTabInfo
    
    func runSearchQuery(for searchBar: UISearchBar, feedModule: FeedModuleInput)
}
