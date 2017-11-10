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
    var moduleOutput: MockSearchPeopleModuleOutput!
    
    override func setUp() {
        super.setUp()
        view = MockSearchPeopleView()
        interactor = MockSearchPeopleInteractor()
        usersListModule = MockUserListModuleInput()
        backgroundUsersListModule = MockUserListModuleInput()
        moduleOutput = MockSearchPeopleModuleOutput()
        sut = SearchPeoplePresenter()
        
        sut.view = view
        sut.interactor = interactor
        sut.usersListModule = usersListModule
        sut.backgroundUsersListModule = backgroundUsersListModule
        sut.moduleOutput = moduleOutput
    }
    
    override func tearDown() {
        super.tearDown()
        view = nil
        interactor = nil
        usersListModule = nil
        backgroundUsersListModule = nil
        sut = nil
        moduleOutput = nil
    }
    
    func testSearchErrorHandlingWhenListIsEmpty() {
        testSearchErrorHandling(listIsEmpty: true)
        
        resetModuleOutput()
        resetView()
        
        testSearchErrorHandling(listIsEmpty: false)
    }
    
    func testSearchErrorHandling(listIsEmpty: Bool) {
        usersListModule.isListEmpty = listIsEmpty
        
        sut.didFailToLoadList(listView: usersListModule.listView, error: APIError.unknown)
        
        XCTAssertTrue(moduleOutput.didFailToLoadSearchQueryCalled)
        guard let e = moduleOutput.didFailToLoadSearchQueryReceivedError as? APIError, case .unknown = e else {
            XCTFail()
            return
        }
        
        XCTAssertTrue(view.setIsEmptyCalled)
        XCTAssertEqual(view.setIsEmptyInputIsEmpty, listIsEmpty)
    }
    
    func resetView() {
        view = MockSearchPeopleView()
        sut.view = view
    }
    
    func resetModuleOutput() {
        moduleOutput = MockSearchPeopleModuleOutput()
        sut.moduleOutput = moduleOutput
    }
    
    func testBackgroundListErrorHandling() {
        sut.didFailToLoadList(listView: backgroundUsersListModule.listView, error: APIError.unknown)
        XCTAssertTrue(moduleOutput.didFailToLoadSuggestedUsersCalled)
        guard let e = moduleOutput.didFailToLoadSuggestedUsersReceivedError as? APIError, case .unknown = e else {
            XCTFail()
            return
        }
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
        XCTAssertTrue(usersListModule.clearListCalled)
    }
}
