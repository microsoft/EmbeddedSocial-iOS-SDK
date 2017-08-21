//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class SearchPeopleInteractorTests: XCTestCase {
    var sut: SearchPeopleInteractor!
    
    override func setUp() {
        super.setUp()
        sut = SearchPeopleInteractor()
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
    }
    
    func testThatBackgroundViewIsCached() {
        let view1 = sut.makeBackgroundView()
        let view2 = sut.makeBackgroundView()
        XCTAssertEqual(view1, view2)
    }
    
    func testThatItRunsSearchQueryAndReloadsUsersList() {
        // given
        let query = UUID().uuidString
        let usersListModule = MockUserListModuleInput()
        let searchController = UISearchController(searchResultsController: UIViewController())
        searchController.searchBar.text = query
        
        // when
        sut.runSearchQuery(for: searchController, usersListModule: usersListModule)
        
        // then
        guard let api = usersListModule.api as? QueryPeopleAPI else {
            XCTFail("Query users API must be set")
            return
        }
        XCTAssertEqual(api.query, query)
        XCTAssertEqual(usersListModule.reloadCount, 1)
    }
}
