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
    var noDataText: NSAttributedString!
    var noDataView: UIView!
    var actionStrategy: CommonAuthorizedActionStrategy!

    private let timeout: TimeInterval = 5.0
    
    override func setUp() {
        super.setUp()
        interactor = MockUserListInteractor()
        view = MockUserListView()
        moduleOutput = MockUserListModuleOutput()
        router = MockUserListRouter()
        myProfileHolder = MyProfileHolder()
        noDataText = NSAttributedString(string: "No data text")
        noDataView = UIView()
        actionStrategy = CommonAuthorizedActionStrategy(
            myProfileHolder: myProfileHolder,
            loginParent: nil,
            loginOpener: MockLoginModalOpener()
        )
        
        sut = UserListPresenter(actionStrategy: actionStrategy)
        sut.interactor = interactor
        sut.view = view
        sut.moduleOutput = moduleOutput
        sut.router = router
        sut.noDataText = noDataText
        sut.noDataView = noDataView
    }
    
    override func tearDown() {
        super.tearDown()
        interactor = nil
        moduleOutput = nil
        view = nil
        router = nil
        sut = nil
        myProfileHolder = nil
        noDataText = nil
        noDataView = nil
        actionStrategy = nil
    }
    
    func testThatItSetsInitialState() {
        // given
        let users = [User(), User(), User()]
        interactor.getNextListPageReturnValue = .success(users)

        // when
        sut.setupInitialState()
        
        // then
        XCTAssertTrue(view.setupInitialStateCalled)
        
        XCTAssertTrue(view.setNoDataTextCalled)
        XCTAssertTrue(view.setNoDataViewCalled)
        
        XCTAssertEqual(view.setNoDataTextReceivedText, noDataText)
        XCTAssertEqual(view.setNoDataViewReceivedView, noDataView)
        
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
    
    func testPageLoadingWithAnonymousUser() {
        // given
        let users = [User(), User(), User()]
        interactor.getNextListPageReturnValue = .success(users)
        
        myProfileHolder.me = nil
        
        // when
        sut.loadNextPage()
        
        // then
        XCTAssertEqual(interactor.getNextListPageCount, 0)
        XCTAssertFalse(view.setUsersCalled)
        XCTAssertFalse(view.setIsEmptyCalled)
    }
    
    func testThatItHandlesLoadNextPageError() {
        // given
        interactor.getNextListPageReturnValue = .failure(APIError.unknown)
        
        // when
        sut.loadNextPage()
        
        // then
        XCTAssertEqual(interactor.getNextListPageCount, 1)
        XCTAssertFalse(view.setUsersCalled)
        XCTAssertTrue(moduleOutput.didFailToLoadListListViewErrorCalled)
    }
    
    func testThatItNotifiesModuleOutputWhenFailsToLoadNextPage() {
        // given
        interactor.getNextListPageReturnValue = .failure(APIError.unknown)

        // when
        sut.loadNextPage()
        
        // then
        XCTAssertEqual(interactor.getNextListPageCount, 1)
        XCTAssertFalse(view.setUsersCalled)
        XCTAssertTrue(moduleOutput.didFailToLoadListListViewErrorCalled)
    }
    
    func testThatItPerformsItemActionWhenResponseIsSuccess() {
        // given
        let user = User(uid: UUID().uuidString, followerStatus: .empty)
        let listItem = UserListItem(user: user, action: nil)
        interactor.socialRequestResult = .success(.empty)

        // when
        sut.onItemAction(item: listItem)
        
        // then
        
        // not loading the whole view
        XCTAssertFalse(view.setIsLoadingCalled)
        
        // loading animation for item
        XCTAssertTrue(view.setIsLoadingItemCalled)
        
        XCTAssertEqual(view.setIsLoadingItemReceivedArguments?.isLoading, false)
        XCTAssertEqual(view.setIsLoadingItemReceivedArguments?.item.user, user)
        
        // item updated
        XCTAssertTrue(view.updateListItemWithCalled)
        XCTAssertEqual(view.updateListItemWithReceivedUser, user)
    }
    
    func testThatItOpensLoginWhenAnonymousUserSubmitsFollowRequest() {
        // given
        let user = User(uid: UUID().uuidString, followerStatus: .empty)
        let listItem = UserListItem(user: user, action: nil)
        
        myProfileHolder.me = nil
        
        // when
        sut.onItemAction(item: listItem)
        
        // then        
        XCTAssertEqual(interactor.processSocialRequestCount, 0)
        
        XCTAssertFalse(view.setIsLoadingCalled)
        XCTAssertFalse(view.setIsLoadingItemCalled)
        XCTAssertFalse(view.updateListItemWithCalled)
    }
    
    func testThatItDoesNotUpdateViewAndNotifiesModuleOutputWhenItemActionIsFailed() {
        // given
        let user = User(uid: UUID().uuidString, followerStatus: .empty)
        let listItem = UserListItem(user: user, action: nil)
        interactor.socialRequestResult = .failure(APIError.unknown)
        
        // when
        sut.onItemAction(item: listItem)
        
        // then
        
        // not loading the whole view
        XCTAssertFalse(view.setIsLoadingCalled)
        
        // loading animation for item
        XCTAssertTrue(view.setIsLoadingItemCalled)
        XCTAssertEqual(view.setIsLoadingItemReceivedArguments?.isLoading, false)
        XCTAssertEqual(view.setIsLoadingItemReceivedArguments?.item.user, user)
        
        // item not updated
        XCTAssertFalse(view.updateListItemWithCalled)
        
        // error propagated to module output
        XCTAssertTrue(moduleOutput.didFailToPerformSocialRequestListViewErrorCalled)
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
        XCTAssertEqual(view.setUsersReceivedUsers ?? [], firstAndSecondPage)
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
        XCTAssertTrue(view.setListHeaderViewCalled)
        XCTAssertEqual(view.setListHeaderViewReceivedView, headerView)
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
        XCTAssertEqual(view.setIsLoadingReceivedIsLoading, true)
        
        sut.didUpdateListLoadingState(false)
        XCTAssertEqual(view.setIsLoadingReceivedIsLoading, false)
    }
    
    func testThatItOpensMyProfileWhenItemIsSelected() {
        let creds = CredentialsList(provider: .facebook, accessToken: "", socialUID: "")
        let user = User(credentials: creds)
        let listItem = UserListItem(user: user, action: nil)
        testThatItOpensProfileWhenItemIsSelected(listItem)
    }
    
    func testThatItOpensUserProfileWhenItemIsSelected() {
        let user = User()
        let listItem = UserListItem(user: user, action: nil)
        testThatItOpensProfileWhenItemIsSelected(listItem)
    }
    
    func testThatItOpensProfileWhenItemIsSelected(_ item: UserListItem) {
        // given 
        
        // when
        sut.onItemSelected(item)
        
        // then
        if item.user.isMe {
            XCTAssertEqual(router.openMyProfileCount, 1)
        } else {
            XCTAssertEqual(router.openUserProfileCount, 1)
            XCTAssertEqual(router.openUserProfileUserID, item.user.uid)
        }
    }
    
    func testThatItCorrectlyProcessesPullToRefresh() {
        // given
        let users = [User(), User()]
        interactor.reloadListReturnValue = .success(users)
        
        // when
        sut.onPullToRefresh()
        
        // then
        XCTAssertEqual(interactor.reloadListCount, 1)
        
        XCTAssertTrue(view.setUsersCalled)
        XCTAssertEqual(view.setUsersReceivedUsers ?? [], users)
        XCTAssertTrue(view.endPullToRefreshAnimationCalled)
        XCTAssertFalse(view.setIsLoadingCalled)
    }
    
    private func validateNextPageLoaded(with users: [User]) {
        validatePageLoaded(page: 1, with: users)
    }
    
    private func validatePageLoaded(page: Int, with users: [User]) {
        XCTAssertEqual(interactor.getNextListPageCount, page)
        XCTAssertTrue(view.setUsersCalled)
        XCTAssertEqual(view.setUsersReceivedUsers ?? [], users)
        XCTAssertTrue(view.setIsEmptyCalled)
        XCTAssertEqual(view.setIsEmptyReceivedIsEmpty, users.isEmpty)
    }
}
