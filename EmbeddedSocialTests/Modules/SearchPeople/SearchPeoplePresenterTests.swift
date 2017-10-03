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
    var backgroundUsersListModule: MockUserListModuleInput!
    var sut: SearchPeoplePresenter!
    
    override func setUp() {
        super.setUp()
        view = MockSearchPeopleView()
        interactor = MockSearchPeopleInteractor()
        usersListModule = MockUserListModuleInput()
        backgroundUsersListModule = MockUserListModuleInput()
        sut = SearchPeoplePresenter()
        
        sut.view = view
        sut.interactor = interactor
        sut.usersListModule = usersListModule
        sut.backgroundUsersListModule = backgroundUsersListModule
    }
    
    override func tearDown() {
        super.tearDown()
        view = nil
        interactor = nil
        usersListModule = nil
        backgroundUsersListModule = nil
        sut = nil
    }
}

//MARK: - SearchPeopleModuleInput

extension SearchPeoplePresenterTests {
    
    func testThatItSetsInitialStateWhenUserIsLoggedIn() {
        // given
        usersListModule.listView = UIView()
        interactor.backgroundListHeaderView = UIView()
        
        // when
        sut.setupInitialState()
        
        // then
        validateViewAndUsersListInitialState()

        XCTAssertEqual(interactor.makeBackgroundListHeaderViewCount, 1)
        
        XCTAssertTrue(backgroundUsersListModule.setupInitialStateCalled)
        XCTAssertTrue(backgroundUsersListModule.setListHeaderViewCalled)
        XCTAssertEqual(backgroundUsersListModule.setListHeaderViewReceivedView, interactor.backgroundListHeaderView)
    }
    
    func testThatItSetsInitialStateWhenUserIsNotLoggedIn() {
        // given
        usersListModule.listView = UIView()
        sut.backgroundUsersListModule = nil
        
        // when
        sut.setupInitialState()
        
        // then
        validateViewAndUsersListInitialState()
        
        XCTAssertEqual(interactor.makeBackgroundListHeaderViewCount, 0)
        
        XCTAssertFalse(backgroundUsersListModule.setupInitialStateCalled)
    }
    
    func validateViewAndUsersListInitialState() {
        XCTAssertTrue(usersListModule.setupInitialStateCalled)
        
        XCTAssertEqual(view.setupInitialStateCount, 1)
        XCTAssertEqual(view.listView, usersListModule.listView)
    }
    
    func testThatItReturnsSelfAsSearchResultsHandler() {
        XCTAssertTrue(sut.searchResultsHandler() === sut)
    }
    
    func testThatItReturnsBackgroundView() {
        // given
        let backgroundView = UIView()
        backgroundUsersListModule.listView = backgroundView
        
        // when
        let returnedBackgroundView = sut.backgroundView()
        
        // then
        XCTAssertEqual(backgroundView, returnedBackgroundView)
    }
    
    func testThatItReturnsViewAsSearchResultsController() {
        XCTAssertEqual(sut.searchResultsController(), view)
    }
    
    func testThatItSetsViewIsEmptyWhenListDidUpdate() {
        testThatItSetsViewIsEmptyWhenListDidUpdate(users: [], isViewExpectedToBeEmpty: true)
        
        testThatItSetsViewIsEmptyWhenListDidUpdate(users: [User()], isViewExpectedToBeEmpty: false)
    }
    
    func testThatItSetsViewIsEmptyWhenListDidUpdate(users: [User], isViewExpectedToBeEmpty: Bool) {
        sut.didUpdateList(usersListModule.listView, with: users)
        
        XCTAssertTrue(view.setIsEmptyCalled)
        XCTAssertEqual(view.setIsEmptyInputIsEmpty, isViewExpectedToBeEmpty)
    }
}

//MARK: - UISearchResultsUpdating

extension SearchPeoplePresenterTests {
    
    func testThatItUpdatesSearchResults() {
        let helper = SearchUpdatingTestsHelper(sut: sut,
                                               executeQueryExpectation: interactor.runSearchQueryExpectation,
                                               testCase: self)
        
        helper.searchQueryHasRunValidator = validateSearchQueryHasRun
        
        helper.validateThatItUpdatesSearchResults()
    }
    
    func testThatItThrottlesSearchUpdates() {
        let helper = SearchUpdatingTestsHelper(sut: sut,
                                               executeQueryExpectation: interactor.runSearchQueryExpectation,
                                               testCase: self)
        
        helper.searchQueryHasRunValidator = validateSearchQueryHasRun
        
        helper.validateThatItThrottlesSearchUpdates()
    }
    
    private func validateSearchQueryHasRun(_ query: String, searchBar: UISearchBar) {
        XCTAssertEqual(interactor.runSearchQueryCount, 1)
        guard let (interactorSearchBar, interactorUsersListModule) = interactor.runSearchQueryParams else {
            XCTFail("Interactor must handle the query")
            return
        }
        XCTAssertEqual(interactorSearchBar, searchBar)
        XCTAssertTrue(interactorUsersListModule === sut.usersListModule)
    }
}
