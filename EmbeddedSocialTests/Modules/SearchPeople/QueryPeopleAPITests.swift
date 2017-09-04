//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class QueryPeopleAPITests: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testThatItCallsCorrectServiceAPI() {
        // given
        let query = UUID().uuidString
        let searchService = MockSearchService()
        let sut = QueryPeopleAPI(query: query, searchService: searchService)
        
        // when
        sut.getUsersList(cursor: nil, limit: 0) { _ in }
        
        // then
        XCTAssertEqual(searchService.queryUsersInputValues?.query, query)
        XCTAssertEqual(searchService.queryUsersCount, 1)
    }
}
