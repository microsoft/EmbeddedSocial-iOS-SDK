//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class SuggestedUsersPresenterTests: XCTestCase {
    var view: MockSuggestedUsersView!
    var userListModule: MockUserListModuleInput!
    var sut: SuggestedUsersPresenter!
    
    override func setUp() {
        super.setUp()
        view = MockSuggestedUsersView()
        userListModule = MockUserListModuleInput()
        sut = SuggestedUsersPresenter()
        
        sut.view = view
        sut.usersList = userListModule
    }
    
    override func tearDown() {
        super.tearDown()
        view = nil
        userListModule = nil
        sut = nil
    }
    
    func testThatItSucceedsToSetupInitialState() {
        // given
        
        // when
        sut.viewIsReady()
        
        // then
        XCTAssertTrue(view.setupInitialStateUserListViewCalled)
        XCTAssertTrue(userListModule.setupInitialStateCalled)
        XCTAssertEqual(userListModule.listView, view.setupInitialStateUserListViewReceivedUserListView)
    }
}

//MARK: UserListModuleOutput test

extension SuggestedUsersPresenterTests {
    
    func testThatItShowsErrorWhenSocialRequestFails() {
        // given
        
        // when
        sut.viewIsReady()
        sut.didFailToPerformSocialRequest(listView: userListModule.listView, error: APIError.unknown)
        
        // then
        XCTAssertTrue(view.showErrorCalled)
        
        guard let e = view.showErrorReceivedError as? APIError, case .unknown = e else {
            XCTFail("Unexpected error")
            return
        }
    }
    
    func testThatItShowsErrorWhenFailsToLoadList() {
        // given
        
        // when
        sut.viewIsReady()
        sut.didFailToLoadList(listView: userListModule.listView, error: APIError.unknown)
        
        // then
        XCTAssertTrue(view.showErrorCalled)
        
        guard let e = view.showErrorReceivedError as? APIError, case .unknown = e else {
            XCTFail("Unexpected error")
            return
        }
    }
}
