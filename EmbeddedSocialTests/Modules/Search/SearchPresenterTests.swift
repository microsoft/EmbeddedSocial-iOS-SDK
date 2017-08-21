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
    var sut: SearchPresenter!
    
    override func setUp() {
        super.setUp()
        interactor = MockSearchInteractor()
        view = MockSearchView()
        peopleSearchModule = MockSearchPeopleModule()
        
        sut = SearchPresenter()
        sut.interactor = interactor
        sut.view = view
        sut.peopleSearchModule = peopleSearchModule
    }
    
    override func tearDown() {
        super.tearDown()
        interactor = nil
        view = nil
        peopleSearchModule = nil
        sut = nil
    }
    
    func testThatItSetsInitialState() {
        // given
        let pageInfo = SearchPageInfo(searchResultsController: UIViewController(),
                                      searchResultsHandler: MockSearchResultsUpdating(),
                                      backgroundView: nil)
        interactor.pageInfoToReturn = pageInfo
        
        // when
        sut.viewIsReady()
        
        // then
        XCTAssertEqual(peopleSearchModule.setupInitialStateCount, 1)
        XCTAssertEqual(interactor.makePageInfoCount, 1)
        XCTAssertEqual(view.setupInitialStateCount, 1)
        XCTAssertEqual(pageInfo, view.pageInfo)
    }
}
