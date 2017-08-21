//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class SearchPeoplePresenterTests: XCTestCase {
    var view: MockSearchPeopleView!
    var interactor: MockSearchPeopleInteractor!
    var usersListModule: MockUserListModuleInput!
    var sut: SearchPeoplePresenter!
    
    override func setUp() {
        super.setUp()
        view = MockSearchPeopleView()
        interactor = MockSearchPeopleInteractor()
        usersListModule = MockUserListModuleInput()
        sut = SearchPeoplePresenter()
        
        sut.view = view
        sut.interactor = interactor
        sut.usersListModule = usersListModule
    }
    
    override func tearDown() {
        super.tearDown()
        view = nil
        interactor = nil
        usersListModule = nil
        sut = nil
    }
}

//MARK: - SearchPeopleModuleInput

extension SearchPeoplePresenterTests {
    
    func testThatItSetsInitialState() {
        // given
        let listView = UIView()
        usersListModule.listView = listView
        
        // when
        sut.setupInitialState()
        
        // then
        XCTAssertEqual(usersListModule.setupInitialStateCount, 1)
        XCTAssertEqual(view.setupInitialStateCount, 1)
        
        XCTAssertEqual(view.listView, listView)
    }
    
    func testThatItReturnsSelfAsSearchResultsHandler() {
        XCTAssertTrue(sut.searchResultsHandler() === sut)
    }
    
    func testThatItReturnsBackgroundView() {
        // given
        let backgroundView = UIView()
        interactor.backgroundViewToReturn = backgroundView
        
        // when
        let returnedBackgroundView = sut.backgroundView()
        
        // then
        XCTAssertEqual(backgroundView, returnedBackgroundView)
        XCTAssertEqual(interactor.makeBackgroundViewCount, 1)
    }
    
    func testThatItReturnsViewAsSearchResultsController() {
        XCTAssertEqual(sut.searchResultsController(), view)
    }
}

//MARK: - UISearchResultsUpdating

extension SearchPeoplePresenterTests {
    
    func testThatItUpdatesSearchResults() {
        // given
        let runQueryTimeout: TimeInterval = 1
        let query = UUID().uuidString
        let searchController = UISearchController(searchResultsController: UIViewController())
        searchController.searchBar.text = query
        
        // when
        sut.updateSearchResults(for: searchController)
        wait(for: [interactor.runSearchQueryExpectation], timeout: runQueryTimeout)
        
        // then
        validateSearchQueryHasRun(query, searchController: searchController)
    }
    
    func testThatItThrottlesSearchUpdates() {
        // given
        let runQueryTimeout: TimeInterval = 1
        let searchController = UISearchController(searchResultsController: UIViewController())
        let updatesCount = 5
        
        var queries: [String] = []
        for _ in 0..<updatesCount {
            queries.append(UUID().uuidString)
        }
        
        // when
        for i in 0..<updatesCount {
            searchController.searchBar.text = queries[i]
            sut.updateSearchResults(for: searchController)
        }
        wait(for: [interactor.runSearchQueryExpectation], timeout: runQueryTimeout)

        // then
        // only the last query has been run
        validateSearchQueryHasRun(queries.last!, searchController: searchController)
    }
    
    private func validateSearchQueryHasRun(_ query: String, searchController: UISearchController) {
        XCTAssertEqual(interactor.runSearchQueryCount, 1)
        guard let (interactorSearchController, interactorUsersListModule) = interactor.runSearchQueryParams else {
            XCTFail("Interactor must handle the query")
            return
        }
        XCTAssertEqual(interactorSearchController, searchController)
        XCTAssertTrue(interactorUsersListModule === sut.usersListModule)
    }
}
