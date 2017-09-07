//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class BlockedUsersPresenterTests: XCTestCase {
    var usersListModule: MockUserListModuleInput!
    var view: MockBlockedUsersView!
    var sut: BlockedUsersPresenter!
    
    override func setUp() {
        super.setUp()
        usersListModule = MockUserListModuleInput()
        view = MockBlockedUsersView()
        sut = BlockedUsersPresenter()
        
        sut.view = view
        sut.usersListModule = usersListModule
    }
    
    override func tearDown() {
        super.tearDown()
        usersListModule = nil
        view = nil
        sut = nil
    }
    
    func testThatItSetsInitialState() {
        // given
        
        // when
        sut.viewIsReady()
        
        // then
        XCTAssertTrue(view.setupInitialState_userListView_Called)
        XCTAssertEqual(view.setupInitialState_userListView_ReceivedUserListView, usersListModule.listView)
        XCTAssertEqual(usersListModule.setupInitialStateCount, 1)
    }
}

//MARK: - UserListModuleOutput

extension BlockedUsersPresenterTests {
    
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
    
    func testThatItRemovesUnblockedItem() {
        // given
        let indexPath = IndexPath(row: Int(arc4random() % 100), section: Int(arc4random() % 100))
        
        // when
        sut.didUpdateFollowStatus(listView: UIView(), followStatus: .blocked, forUserAt: indexPath)
        
        // then
        XCTAssertEqual(usersListModule.removeListItemCount, 1)
        XCTAssertEqual(usersListModule.removeListItemInputIndexPath, indexPath)
    }
}




