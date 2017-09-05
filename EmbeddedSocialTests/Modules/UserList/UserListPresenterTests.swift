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
    var router: MockUserListRouter!
    var myProfileHolder: MyProfileHolder!
    var sut: UserListPresenter!
    
    private let timeout: TimeInterval = 5.0
    
    override func setUp() {
        super.setUp()
        interactor = MockUserListInteractor()
        view = MockUserListView()
        moduleOutput = MockUserListModuleOutput()
        router = MockUserListRouter()
        myProfileHolder = MyProfileHolder()
        
        sut = UserListPresenter(myProfileHolder: myProfileHolder)
        sut.interactor = interactor
        sut.view = view
        sut.moduleOutput = moduleOutput
        sut.router = router
    }
    
    override func tearDown() {
        super.tearDown()
        interactor = nil
        moduleOutput = nil
        view = nil
        router = nil
        sut = nil
        myProfileHolder = nil
    }
    
    func testThatItSetsInitialState() {
        // given
        let users = [User(), User(), User()]
        interactor.getNextListPageReturnValue = .success(users)

        // when
        sut.setupInitialState()
        
        // then
        XCTAssertEqual(view.setupInitialStateCount, 1)
        validatePageLoaded(page: 1, with: users)
    }
    
    func testThatItLoadsNextPage() {
        // given
        let users = [User(), User(), User()]
        interactor.getNextListPageReturnValue = .success(users)
        
        // when
        sut.loadNextPage()
        
        // then
        validateNextPageLoaded(with: users)
    }
    
    func testThatItHandlesLoadNextPageError() {
        // given
        interactor.getNextListPageReturnValue = .failure(APIError.unknown)
        
        // when
        sut.loadNextPage()
        
        // then
        XCTAssertEqual(interactor.getNextListPageCount, 1)
        XCTAssertEqual(view.setUsersCount, 0)
        XCTAssertNil(view.users)
        XCTAssertEqual(moduleOutput.didUpdateListCount, 0)
        XCTAssertEqual(moduleOutput.didFailToLoadListCount, 1)
    }
    
    func testThatItNotifiesModuleOutputWhenFailsToLoadNextPage() {
        // given
        interactor.getNextListPageReturnValue = .failure(APIError.unknown)

        // when
        sut.loadNextPage()
        
        // then
        XCTAssertEqual(interactor.getNextListPageCount, 1)
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
        interactor.getNextListPageReturnValue = .success([])
        interactor.listHasMoreItems = true
        interactor.isLoadingList = false

        // when
        sut.onReachingEndOfPage()
        
        // then
        validateNextPageLoaded(with: [])
    }
    
    func testThatItDoesNotLoadsMultiplePagesWithCorrectOrder() {
        // given
        let firstPage = [User(), User()]
        let firstAndSecondPage = firstPage + [User(), User()]
        interactor.listHasMoreItems = true
        interactor.isLoadingList = false
        
        // when
        interactor.getNextListPageReturnValue = .success(firstPage)
        sut.onReachingEndOfPage()
        validatePageLoaded(page: 1, with: firstPage)
        
        interactor.getNextListPageReturnValue = .success(firstAndSecondPage)
        sut.onReachingEndOfPage()
        
        // then
        validatePageLoaded(page: 2, with: firstAndSecondPage)
        XCTAssertEqual(view.users ?? [], firstAndSecondPage)
    }
    
    func testThatItDoesNotLoadNextPageIfInteractorHasNoMoreItems() {
        // given
        let firstPage = [User(), User()]
        let firstAndSecondPage = firstPage + [User(), User()]
        interactor.listHasMoreItems = true
        interactor.isLoadingList = false
        
        // when
        interactor.getNextListPageReturnValue = .success(firstPage)
        sut.onReachingEndOfPage()
        validatePageLoaded(page: 1, with: firstPage)
        
        interactor.getNextListPageReturnValue = .success(firstAndSecondPage)
        interactor.listHasMoreItems = false
        sut.onReachingEndOfPage()
        
        // then
        // second page not loaded
        validatePageLoaded(page: 1, with: firstPage)
    }
    
    func testThatItSetsListHeaderView() {
        // given
        let headerView = UIView()
        
        // when
        sut.setListHeaderView(headerView)
        
        // then
        XCTAssertEqual(view.setListHeaderViewCount, 1)
        XCTAssertEqual(view.headerView, headerView)
    }
    
    func testThatItReloadsWithNewAPI() {
        // given
        let api = MockUsersListAPI()
        interactor.getNextListPageReturnValue = .success([])

        // when
        sut.reload(with: api)
        
        // then
        XCTAssertEqual(interactor.setAPICount, 1)
        let interactorAPI = interactor.api as? MockUsersListAPI
        XCTAssertTrue(interactorAPI === api)
        
        validatePageLoaded(page: 1, with: [])
    }
    
    func testThatItUpdatesViewLoadingState() {
        sut.didUpdateListLoadingState(true)
        XCTAssertEqual(view.isLoading, true)
        
        sut.didUpdateListLoadingState(false)
        XCTAssertEqual(view.isLoading, false)
    }
    
    func testThatItOpensMyProfileWhenItemIsSelected() {
        let creds = CredentialsList(provider: .facebook, accessToken: "", socialUID: "")
        let user = User(credentials: creds)
        let indexPath = IndexPath(row: Int(arc4random() % 100), section: Int(arc4random() % 100))
        let listItem = UserListItem(user: user, indexPath: indexPath) { _ in
            ()
        }
        testThatItOpensProfileWhenItemIsSelected(listItem)
    }
    
    func testThatItOpensUserProfileWhenItemIsSelected() {
        let user = User()
        let indexPath = IndexPath(row: Int(arc4random() % 100), section: Int(arc4random() % 100))
        let listItem = UserListItem(user: user, indexPath: indexPath) { _ in
            ()
        }
        testThatItOpensProfileWhenItemIsSelected(listItem)
    }
    
    func testThatItOpensProfileWhenItemIsSelected(_ item: UserListItem) {
        // given 
        
        // when
        sut.onItemSelected(item)
        
        // then
        XCTAssertEqual(moduleOutput.didSelectListItemCount, 1)
        XCTAssertEqual(moduleOutput.didSelectListItemInputValues?.listView, sut.listView)
        XCTAssertEqual(moduleOutput.didSelectListItemInputValues?.indexPath, item.indexPath)
        
        if item.user.isMe {
            XCTAssertEqual(router.openMyProfileCount, 1)
        } else {
            XCTAssertEqual(router.openUserProfileCount, 1)
            XCTAssertEqual(router.openUserProfileUserID, item.user.uid)
        }
    }
    
    private func validateNextPageLoaded(with users: [User]) {
        validatePageLoaded(page: 1, with: users)
    }
    
    private func validatePageLoaded(page: Int, with users: [User]) {
        XCTAssertEqual(interactor.getNextListPageCount, page)
        XCTAssertEqual(view.setUsersCount, page)
        XCTAssertEqual(view.users ?? [], users)
        XCTAssertEqual(moduleOutput.didUpdateListCount, page)
    }
}
