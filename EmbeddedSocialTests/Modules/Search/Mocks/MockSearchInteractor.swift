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
    var makeTopicsTabFeedViewControllerSearchResultsHandlerReceivedArguments: (feedViewController: UIViewController?, searchResultsHandler: UISearchResultsUpdating)?
    var makeTopicsTabFeedViewControllerSearchResultsHandlerReturnValue: SearchTabInfo!
    
    func makeTopicsTab(feedViewController: UIViewController?, searchResultsHandler: UISearchResultsUpdating) -> SearchTabInfo {
        makeTopicsTabFeedViewControllerSearchResultsHandlerCalled = true
        makeTopicsTabFeedViewControllerSearchResultsHandlerReceivedArguments = (feedViewController: feedViewController, searchResultsHandler: searchResultsHandler)
        return makeTopicsTabFeedViewControllerSearchResultsHandlerReturnValue
    }
    
    //MARK: - runSearchQuery
    
    var runSearchQueryForFeedModuleCalled = false
    var runSearchQueryForFeedModuleReceivedArguments: (searchController: UISearchController, feedModule: FeedModuleInput)?
    var runSearchQueryExpectation = XCTestExpectation(description: "runSearchQueryExpectation")
    
    func runSearchQuery(for searchController: UISearchController, feedModule: FeedModuleInput) {
        runSearchQueryForFeedModuleCalled = true
        runSearchQueryForFeedModuleReceivedArguments = (searchController: searchController, feedModule: feedModule)
        runSearchQueryExpectation.fulfill()
    }
    
}

