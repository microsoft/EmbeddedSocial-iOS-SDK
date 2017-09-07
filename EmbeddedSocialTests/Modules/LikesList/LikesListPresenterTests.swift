//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class LikesListPresenterTests: XCTestCase {
    var view: MockLikesListView!
    var usersListModule: MockUserListModuleInput!
    var sut: LikesListPresenter!
    
    override func setUp() {
        super.setUp()
        view = MockLikesListView()
        usersListModule = MockUserListModuleInput()
        
        sut = LikesListPresenter()
        sut.view = view
        sut.usersListModule = usersListModule
    }
    
    override func tearDown() {
        super.tearDown()
        view = nil
        usersListModule = nil
        sut = nil
    }
    
    func testThatItSetsInitialState() {
        // given
        
        // when
        sut.viewIsReady()
        
        // then
        XCTAssertTrue(view.setupInitialState_userListView_Called)
        XCTAssertEqual(view.setupInitialState_userListView_ReceivedUserListView, usersListModule.listView)
        XCTAssertTrue(usersListModule.setupInitialStateCalled)
    }
}

//MARK: - UserListModuleOutput

extension LikesListPresenterTests {
    
    func testThatItHandlesFailedSocialRequest() {
        testThatItHandlesError(sut.didFailToPerformSocialRequest(listView:error:))
    }
    
    func testThatItHandlesLoadListError() {
        testThatItHandlesError(sut.didFailToLoadList(listView:error:))
    }
    
    private func testThatItHandlesError(_ errorHandler: (UIView, Error) -> Void) {
        // given
        let listView = UIView()
        let error = APIError.unknown
        
        // when
        errorHandler(listView, error)
        
        // then
        XCTAssertTrue(view.showError___Called)
        guard let shownError = view.showError___ReceivedError as? APIError, case .unknown = shownError else {
            XCTFail("Incorrect error passed to view \(view.showError___ReceivedError as Optional), expected \(error)")
            return
        }
    }
}
