//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class SearchTopicsInteractorTests: XCTestCase {
    var sut: SearchTopicsInteractor!
    
    override func setUp() {
        super.setUp()
        sut = SearchTopicsInteractor()
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
    }
    
    func testThatItRunsSearchQueryAndReloadsUsersList() {
        // given
        let query = UUID().uuidString
        let feedModule = MockFeedModuleInput()
        let searchBar = UISearchBar()
        searchBar.text = query
        
        // when
        sut.runSearchQuery(for: searchBar, feedModule: feedModule)
        
        // then
        XCTAssertEqual(feedModule.feedType!, FeedType.search(query: query))
    }
}
