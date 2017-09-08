//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class SearchTopicsPresenterTests: XCTestCase {
    var view: MockSearchTopicsView!
    var interactor: MockSearchTopicsInteractor!
    var moduleOutput: MockSearchTopicsModuleOutput!
    var feedModule: MockFeedModuleInput!
    var feedViewController: UIViewController!
    var sut: SearchTopicsPresenter!
    
    override func setUp() {
        super.setUp()
        view = MockSearchTopicsView()
        interactor = MockSearchTopicsInteractor()
        moduleOutput = MockSearchTopicsModuleOutput()
        feedModule = MockFeedModuleInput()
        feedViewController = UIViewController()
        sut = SearchTopicsPresenter()
        
        sut.view = view
        sut.interactor = interactor
        sut.moduleOutput = moduleOutput
        sut.feedModule = feedModule
        sut.feedViewController = feedViewController
    }
    
    override func tearDown() {
        super.tearDown()
        view = nil
        interactor = nil
        moduleOutput = nil
        feedModule = nil
        feedViewController = nil
        sut = nil
    }
    
    func testThatItOpensUserProfile() {
        XCTAssertTrue(sut.shouldOpenProfile(for: UUID().uuidString))
    }
    
    func testThatItFlipsLayout() {
        // given
        let layoutBeforeFlip = feedModule.layout
        
        // when
        sut.flipLayout()
        
        // then
        XCTAssertEqual(layoutBeforeFlip.flipped, feedModule.layout)
    }
    
    func testThatItSetsInitialState() {
        // given
        
        // when
        sut.setupInitialState()
        
        // then
        XCTAssertTrue(view.setupInitialStateWithCalled)
        XCTAssertEqual(view.setupInitialStateWithReceivedFeedViewController, feedViewController)
    }
    
    func testThatItSetsViewIsEmptyWhenFeedIsUpdated() {
        testThatItSetsViewIsEmptyWhenFeedIsUpdated(feedIsEmpty: true, isViewExpectedToBeEmpty: true)
        
        testThatItSetsViewIsEmptyWhenFeedIsUpdated(feedIsEmpty: false, isViewExpectedToBeEmpty: false)
    }
    
    func testThatItSetsViewIsEmptyWhenFeedIsUpdated(feedIsEmpty: Bool, isViewExpectedToBeEmpty: Bool) {
        // given
        feedModule.isEmpty = feedIsEmpty
        
        // when
        sut.didUpdateFeed()
        
        // then
        XCTAssertTrue(view.setIsEmptyCalled)
        XCTAssertEqual(view.setIsEmptyReceivedIsEmpty, isViewExpectedToBeEmpty)
    }
}

/// MARK: - UISearchResultsUpdating

extension SearchTopicsPresenterTests {
    
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
        XCTAssertTrue(interactor.runSearchQueryForFeedModuleCalled)
        
        guard let (interactorSearchBar, feedModule) = interactor.runSearchQueryForFeedModuleReceivedArguments else {
            XCTFail("Interactor must handle the query")
            return
        }
        
        XCTAssertEqual(interactorSearchBar, searchBar)
        XCTAssertTrue(feedModule === sut.feedModule)
    }
    
}
