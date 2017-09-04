//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class SearchPresenterTests: XCTestCase {
    var interactor: MockSearchInteractor!
    var view: MockSearchView!
    var peopleSearchModule: MockSearchPeopleModule!
    var feedViewController: UIViewController!
    var feedModule: MockFeedModuleInput!
    var sut: SearchPresenter!
    
    override func setUp() {
        super.setUp()
        interactor = MockSearchInteractor()
        view = MockSearchView()
        peopleSearchModule = MockSearchPeopleModule()
        feedViewController = UIViewController()
        feedModule = MockFeedModuleInput()
        
        sut = SearchPresenter()
        sut.interactor = interactor
        sut.view = view
        sut.peopleSearchModule = peopleSearchModule
        sut.feedViewController = feedViewController
        sut.feedModuleInput = feedModule
    }
    
    override func tearDown() {
        super.tearDown()
        interactor = nil
        view = nil
        peopleSearchModule = nil
        feedViewController = nil
        feedModule = nil
        sut = nil
    }
    
    func testThatItSetsInitialState() {
        // given
        let topicsTab = makeTopicsTab()
        interactor.makeTopicsTabFeedViewControllerSearchResultsHandlerReturnValue = topicsTab
        interactor.makePeopleTabWithReturnValue = makePeopleTab()
        
        // when
        sut.viewIsReady()
        
        // then
        
        // people search module is initialized
        XCTAssertEqual(peopleSearchModule.setupInitialStateCount, 1)
        
        // search tabs are correctly set
        XCTAssertTrue(interactor.makeTopicsTabFeedViewControllerSearchResultsHandlerCalled)
        XCTAssertTrue(interactor.makePeopleTabWithCalled)
        
        let makeTopicsTabArgs = interactor.makeTopicsTabFeedViewControllerSearchResultsHandlerReceivedArguments
        XCTAssertTrue(makeTopicsTabArgs?.feedViewController === feedViewController)
        XCTAssertTrue(makeTopicsTabArgs?.searchResultsHandler === sut)
        
        XCTAssertTrue(interactor.makePeopleTabWithReceivedSearchPeopleModule === peopleSearchModule)
        
        // view is correctly initialized
        XCTAssertTrue(view.setupInitialStateCalled)
        XCTAssertTrue(view.setLayoutAssetCalled)
        XCTAssertEqual(view.setLayoutAssetReceivedAsset, feedModule.layout.nextLayoutAsset)
        XCTAssertEqual(topicsTab, view.setupInitialStateReceivedTab)
    }
    
    func testThatItSwitchesToPeopleTab() {
        // given
        let peopleTab = makePeopleTab()
        let topicsTab = makeTopicsTab()
        interactor.makeTopicsTabFeedViewControllerSearchResultsHandlerReturnValue = topicsTab
        interactor.makePeopleTabWithReturnValue = peopleTab
        
        // when
        sut.viewIsReady()
        sut.onPeople()
        
        // then
        XCTAssertTrue(view.switchTabsToFromCalled)
        XCTAssertEqual(view.switchTabsToFromReceivedArguments?.tab, peopleTab)
        XCTAssertEqual(view.switchTabsToFromReceivedArguments?.previousTab, topicsTab)
    }
    
    func testThatItSwitchesToTopicsTab() {
        // given
        let peopleTab = makePeopleTab()
        let topicsTab = makeTopicsTab()
        interactor.makeTopicsTabFeedViewControllerSearchResultsHandlerReturnValue = topicsTab
        interactor.makePeopleTabWithReturnValue = peopleTab
        
        // when
        sut.viewIsReady()
        sut.onPeople()
        sut.onTopics()

        // then
        XCTAssertTrue(view.switchTabsToFromCalled)
        XCTAssertEqual(view.switchTabsToFromReceivedArguments?.tab, topicsTab)
        XCTAssertEqual(view.switchTabsToFromReceivedArguments?.previousTab, peopleTab)
    }
    
    func testThatItFlipsLayoutForTopicsTab() {
        // given
        let peopleTab = makePeopleTab()
        let topicsTab = makeTopicsTab()
        interactor.makeTopicsTabFeedViewControllerSearchResultsHandlerReturnValue = topicsTab
        interactor.makePeopleTabWithReturnValue = peopleTab
        
        let layout = feedModule.layout
        
        // when
        sut.viewIsReady()
        sut.onFlipTopicsLayout()
        
        // then
        XCTAssertEqual(feedModule.layout, layout.flipped)
        XCTAssertEqual(feedModule.setLayoutCount, 1)
        
        XCTAssertTrue(view.setLayoutAssetCalled)
        XCTAssertEqual(view.setLayoutAssetReceivedAsset, feedModule.layout.nextLayoutAsset)
    }
    
    func testThatItHandlesSearchResults() {
        // given
        let query = UUID().uuidString
        let searchController = UISearchController(searchResultsController: UIViewController())
        searchController.searchBar.text = query
        
        // when
        sut.updateSearchResults(for: searchController)
        wait(for: [interactor.runSearchQueryExpectation], timeout: 5.0)

        // then
        XCTAssertTrue(interactor.runSearchQueryForFeedModuleCalled)
        XCTAssertEqual(interactor.runSearchQueryForFeedModuleReceivedArguments?.searchController, searchController)
        XCTAssertTrue(interactor.runSearchQueryForFeedModuleReceivedArguments?.feedModule === feedModule)
    }
    
    func testThatItThrottlesSearchQueries() {
        // given
        let query = UUID().uuidString
        let searchController = UISearchController(searchResultsController: UIViewController())
        searchController.searchBar.text = query
        
        // when
        sut.updateSearchResults(for: searchController)
        
        // then
        XCTAssertFalse(interactor.runSearchQueryForFeedModuleCalled)
        XCTAssertNotEqual(interactor.runSearchQueryForFeedModuleReceivedArguments?.searchController, searchController)
        XCTAssertFalse(interactor.runSearchQueryForFeedModuleReceivedArguments?.feedModule === feedModule)
        
        wait(for: [interactor.runSearchQueryExpectation], timeout: 5.0)
        
        XCTAssertTrue(interactor.runSearchQueryForFeedModuleCalled)
        XCTAssertEqual(interactor.runSearchQueryForFeedModuleReceivedArguments?.searchController, searchController)
        XCTAssertTrue(interactor.runSearchQueryForFeedModuleReceivedArguments?.feedModule === feedModule)
    }
    
    func testThatItOpensUserProfile() {
        XCTAssertTrue(sut.shouldOpenProfile(for: UUID().uuidString))
    }
    
    func testThatItShowsErrorWhenUserListFailsToLoad() {
        // given
        let error = APIError.unknown
        
        // when
        sut.didFailToLoadSearchQuery(error)
        
        // then
        XCTAssertTrue(view.showErrorCalled)
        guard let shownError = view.showErrorReceivedError as? APIError, case .unknown = shownError else {
            XCTFail("Error must be shown")
            return
        }
    }
    
    private func makePeopleTab() -> SearchTabInfo {
        return SearchTabInfo(searchResultsController: UIViewController(),
                             searchResultsHandler: MockSearchResultsUpdating(),
                             backgroundView: nil,
                             tab: .people)
    }
    
    private func makeTopicsTab() -> SearchTabInfo {
        return SearchTabInfo(searchResultsController: UIViewController(),
                             searchResultsHandler: MockSearchResultsUpdating(),
                             backgroundView: nil,
                             tab: .topics)
    }
}
