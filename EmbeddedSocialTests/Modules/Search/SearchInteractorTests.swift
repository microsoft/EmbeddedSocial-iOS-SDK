//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class SearchInteractorTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testThatItCorrectlyMakesPeopleTab() {
        // given
        let sut = SearchInteractor()
        let searchPeopleModule = MockSearchPeopleModule()
        let view = UIView()
        searchPeopleModule.backgroundViewToReturn = view
        
        // when
        let pageInfo = sut.makePeopleTab(with: searchPeopleModule)
        
        // then
        XCTAssertEqual(pageInfo.backgroundView, searchPeopleModule.backgroundView())
        XCTAssertEqual(pageInfo.searchResultsController, searchPeopleModule.searchResultsController())
        XCTAssertTrue(pageInfo.searchResultsHandler === searchPeopleModule.searchResultsHandler())
    }
}

