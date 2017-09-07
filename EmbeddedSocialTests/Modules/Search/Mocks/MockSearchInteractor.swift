//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class MockSearchInteractor: SearchInteractorInput {
    
    //MARK: - makePeopleTab
    
    var makePeopleTabWithCalled = false
    var makePeopleTabWithReceivedSearchPeopleModule: SearchPeopleModuleInput?
    var makePeopleTabWithReturnValue: SearchTabInfo!
    
    func makePeopleTab(with searchPeopleModule: SearchPeopleModuleInput) -> SearchTabInfo {
        makePeopleTabWithCalled = true
        makePeopleTabWithReceivedSearchPeopleModule = searchPeopleModule
        return makePeopleTabWithReturnValue
    }
    
    //MARK: - makeTopicsTab
    
    var makeTopicsTabFeedViewControllerSearchResultsHandlerCalled = false
    var makeTopicsTabFeedViewControllerSearchResultsHandlerReceivedArguments: (feedViewController: UIViewController?, searchResultsHandler: SearchResultsUpdating)?
    var makeTopicsTabFeedViewControllerSearchResultsHandlerReturnValue: SearchTabInfo!
    
    func makeTopicsTab(feedViewController: UIViewController?, searchResultsHandler: SearchResultsUpdating) -> SearchTabInfo {
        makeTopicsTabFeedViewControllerSearchResultsHandlerCalled = true
        makeTopicsTabFeedViewControllerSearchResultsHandlerReceivedArguments = (feedViewController: feedViewController, searchResultsHandler: searchResultsHandler)
        return makeTopicsTabFeedViewControllerSearchResultsHandlerReturnValue
    }
    
    //MARK: - runSearchQuery
    
    var runSearchQueryForFeedModuleCalled = false
    var runSearchQueryForFeedModuleReceivedArguments: (searchBar: UISearchBar, feedModule: FeedModuleInput)?
    var runSearchQueryExpectation = XCTestExpectation(description: "runSearchQueryExpectation")
    
    func runSearchQuery(for searchBar: UISearchBar, feedModule: FeedModuleInput) {
        runSearchQueryForFeedModuleCalled = true
        runSearchQueryForFeedModuleReceivedArguments = (searchBar: searchBar, feedModule: feedModule)
        runSearchQueryExpectation.fulfill()
    }
    
}

