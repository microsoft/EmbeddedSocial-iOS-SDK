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
    var topicsSearchModule: MockSearchTopicsModule!
    var sut: SearchPresenter!
    
    override func setUp() {
        super.setUp()
        interactor = MockSearchInteractor()
        view = MockSearchView()
        peopleSearchModule = MockSearchPeopleModule()
        topicsSearchModule = MockSearchTopicsModule()
        
        sut = SearchPresenter()
        sut.interactor = interactor
        sut.view = view
        sut.peopleSearchModule = peopleSearchModule
        sut.topicsSearchModule = topicsSearchModule
    }
    
    override func tearDown() {
        super.tearDown()
        interactor = nil
        view = nil
        peopleSearchModule = nil
        topicsSearchModule = nil
        sut = nil
    }
    
    func testThatItSetsInitialState() {
        // given
        interactor.makeTopicsTabWithReturnValue = makeTopicsTab()
        interactor.makePeopleTabWithReturnValue = makePeopleTab()
        topicsSearchModule.layoutAsset = .iconAccept
        
        // when
        sut.viewIsReady()
        
        // then
        
        // people search module is initialized
        XCTAssertEqual(peopleSearchModule.setupInitialStateCount, 1)
        
        // search tabs are correctly set
        XCTAssertTrue(interactor.makeTopicsTabWithCalled)
        XCTAssertTrue(interactor.makePeopleTabWithCalled)
        
        XCTAssertTrue(interactor.makeTopicsTabWithReceivedSearchTopicsModule === topicsSearchModule)
        XCTAssertTrue(interactor.makePeopleTabWithReceivedSearchPeopleModule === peopleSearchModule)
        
        // view is correctly initialized
        XCTAssertTrue(view.setupInitialStateCalled)
        XCTAssertTrue(view.setLayoutAssetCalled)
        XCTAssertEqual(view.setLayoutAssetReceivedAsset, topicsSearchModule.layoutAsset)
        XCTAssertEqual(interactor.makeTopicsTabWithReturnValue, view.setupInitialStateReceivedTab)
    }
    
    func testThatItSwitchesToPeopleTab() {
        // given
        let peopleTab = makePeopleTab()
        let topicsTab = makeTopicsTab()
        interactor.makeTopicsTabWithReturnValue = topicsTab
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
        interactor.makeTopicsTabWithReturnValue = topicsTab
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
        let asset = Asset.iconAccept
        interactor.makeTopicsTabWithReturnValue = topicsTab
        interactor.makePeopleTabWithReturnValue = peopleTab
        topicsSearchModule.layoutAsset = asset
        
        // when
        sut.viewIsReady()
        sut.onFlipTopicsLayout()
        
        // then
        XCTAssertTrue(topicsSearchModule.flipLayoutCalled)
        
        XCTAssertTrue(view.setLayoutAssetCalled)
        XCTAssertEqual(view.setLayoutAssetReceivedAsset, asset)
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
    
    func testThatItUsesPeopleTabIfItWasSelectedBeforeViewHasBeenLoaded() {
        // given
        let peopleTab = makePeopleTab()
        let topicsTab = makeTopicsTab()
        interactor.makeTopicsTabWithReturnValue = topicsTab
        interactor.makePeopleTabWithReturnValue = peopleTab
        
        // when
        sut.selectPeopleTab()
        sut.viewIsReady()

        // then
        XCTAssertEqual(view.setupInitialStateReceivedTab, peopleTab)
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
