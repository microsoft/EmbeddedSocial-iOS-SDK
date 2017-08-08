//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class FollowersPresenterTests: XCTestCase {
    var view: MockFollowersView!
    var userListModule: MockUserListModuleInput!
    var sut: FollowersPresenter!
    
    override func setUp() {
        super.setUp()
        view = MockFollowersView()
        userListModule = MockUserListModuleInput()
        sut = FollowersPresenter()
        
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
        XCTAssertEqual(view.setupInitialStateCount, 1)
        XCTAssertEqual(userListModule.setupInitialStateCount, 1)
        XCTAssertEqual(userListModule.listView, view.userListView)
    }
}

//MARK: UserListModuleOutput test

extension FollowersPresenterTests {
    
    func testThatItShowsErrorWhenSocialRequestFails() {
        // given
        
        // when
        sut.viewIsReady()
        sut.didFailToPerformSocialRequest(listView: userListModule.listView, error: APIError.unknown)
        
        // then
        XCTAssertEqual(view.showErrorCount, 1)
        
        guard let e = view.error as? APIError, case .unknown = e else {
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
        XCTAssertEqual(view.showErrorCount, 1)
        
        guard let e = view.error as? APIError, case .unknown = e else {
            XCTFail("Unexpected error")
            return
        }
    }
}
