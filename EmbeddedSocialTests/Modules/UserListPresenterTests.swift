//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class UserListPresenterTests: XCTestCase {
    var interactor: MockUserListInteractor!
    var moduleOutput: MockUserListModuleOutput!
    var view: MockUserListView!
    var sut: UserListPresenter!
    
    private let timeout: TimeInterval = 5.0
    
    override func setUp() {
        super.setUp()
        interactor = MockUserListInteractor()
        view = MockUserListView()
        moduleOutput = MockUserListModuleOutput()
        
        sut = UserListPresenter()
        sut.interactor = interactor
        sut.view = view
        sut.moduleOutput = moduleOutput
    }
    
    override func tearDown() {
        super.tearDown()
        interactor = nil
        moduleOutput = nil
        view = nil
        sut = nil
    }
    
    func testThatItSetsInitialState() {
        // given
        
        // when
        sut.setupInitialState()
        
        // then
        XCTAssertEqual(view.setupInitialStateCount, 1)
        XCTAssertEqual(interactor.getUsersListCount, 1)
    }
    
    func testThatItLoadsNextPage() {
        // given
        interactor.getUsersListResult = .success(UsersListResponse(users: [], cursor: nil))
        
        // when
        sut.loadNextPage()
        
        // then
        validateNextPageLoaded()
    }
    
    private func validateNextPageLoaded() {
        XCTAssertEqual(interactor.getUsersListCount, 1)
        XCTAssertEqual(view.setUsersCount, 1)
        XCTAssertEqual(moduleOutput.didUpdateListCount, 1)
    }
    
    func testThatItNotifiesModuleOutputWhenFailsToLoadNextPage() {
        // given
        interactor.getUsersListResult = .failure(APIError.unknown)

        // when
        sut.loadNextPage()
        
        // then
        XCTAssertEqual(interactor.getUsersListCount, 1)
        XCTAssertEqual(view.setUsersCount, 0)
        XCTAssertEqual(moduleOutput.didUpdateListCount, 0)
        XCTAssertEqual(moduleOutput.didFailToLoadListCount, 1)
    }
    
    func testThatItPerformsItemActionWhenResponseIsSuccess() {
        // given
        let user = User(uid: UUID().uuidString, followerStatus: .empty)
        let indexPath = IndexPath(row: 0, section: 0)
        let listItem = UserListItem(user: user, indexPath: indexPath, action: nil)
        interactor.socialRequestResult = .success(.empty)

        // when
        sut.onItemAction(item: listItem)
        
        // then
        
        // not loading the whole view
        XCTAssertNil(view.isLoading)
        
        // loading animation for item
        XCTAssertEqual(view.setIsLoadingItemAtCount, 2)
        XCTAssertNotNil(view.isLoadingItemAtParams)
        XCTAssertEqual(view.isLoadingItemAtParams!.0, false)
        XCTAssertEqual(view.isLoadingItemAtParams!.1, indexPath)
        
        // item updated
        XCTAssertEqual(view.updateListItemCount, 1)
        XCTAssertNotNil(view.updateListItemParams)
        XCTAssertEqual(view.updateListItemParams!.0, user)
        XCTAssertEqual(view.updateListItemParams!.1, indexPath)
    }
    
    func testThatItDoesNotUpdateViewAndNotifiesModuleOutputWhenItemActionIsFailed() {
        // given
        let user = User(uid: UUID().uuidString, followerStatus: .empty)
        let indexPath = IndexPath(row: 0, section: 0)
        let listItem = UserListItem(user: user, indexPath: indexPath, action: nil)
        interactor.socialRequestResult = .failure(APIError.unknown)
        
        // when
        sut.onItemAction(item: listItem)
        
        // then
        
        // not loading the whole view
        XCTAssertNil(view.isLoading)
        
        // loading animation for item
        XCTAssertEqual(view.setIsLoadingItemAtCount, 2)
        XCTAssertNotNil(view.isLoadingItemAtParams)
        XCTAssertEqual(view.isLoadingItemAtParams!.0, false)
        XCTAssertEqual(view.isLoadingItemAtParams!.1, indexPath)
        
        // item not updated
        XCTAssertEqual(view.updateListItemCount, 0)
        XCTAssertNil(view.updateListItemParams)
        
        // error propagated to module output
        XCTAssertEqual(moduleOutput.didFailToPerformSocialRequestCount, 1)
    }
    
    func testThatItLoadsNextPageWhenReachingEndOfContent() {
        // given

        // when
        sut.onReachingEndOfPage()
        
        // then
        validateNextPageLoaded()
    }
}



