//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class MockSearchTopicsInteractor: SearchTopicsInteractorInput {
    
    //MARK: - runSearchQuery
    
    var runSearchQueryForFeedModuleCalled = false
    var runSearchQueryForFeedModuleReceivedArguments: (searchBar: UISearchBar, feedModule: FeedModuleInput)?
    var runSearchQueryExpectation = XCTestExpectation(description: "MockSearchTopicsInteractor-runSearchQuery")
    
    func runSearchQuery(for searchBar: UISearchBar, feedModule: FeedModuleInput) {
        runSearchQueryForFeedModuleCalled = true
        runSearchQueryForFeedModuleReceivedArguments = (searchBar: searchBar, feedModule: feedModule)
        runSearchQueryExpectation.fulfill()
    }
    
}
