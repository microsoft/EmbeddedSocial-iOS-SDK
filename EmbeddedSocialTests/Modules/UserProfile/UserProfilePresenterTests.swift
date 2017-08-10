//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class UserProfilePresenterTests: XCTestCase {
    var view: MockUserProfileView!
    var router: MockUserProfileRouter!
    var interactor: MockUserProfileInteractor!
    var myProfileHolder: MyProfileHolder!
    var feedInput: MockFeedModuleInput!
    
    var randomValue: Int {
        return Int(arc4random() % 100)
    }
    
    override func setUp() {
        super.setUp()
        myProfileHolder = MyProfileHolder()
        view = MockUserProfileView()
        router = MockUserProfileRouter()
        interactor = MockUserProfileInteractor()
        feedInput = MockFeedModuleInput()
    }
    
    override func tearDown() {
        super.tearDown()
        myProfileHolder = nil
        view = nil
        router = nil
        interactor = nil
        feedInput = nil
    }
    
    func testThatItSetsInitialStateWhenUserIsMe() {
        // given
        let credentials = CredentialsList(provider: .facebook, accessToken: "", socialUID: "")
        myProfileHolder.me = User(uid: UUID().uuidString, credentials: credentials,
                                  followersCount: randomValue, followingCount: randomValue)
        interactor.meToReturn = myProfileHolder.me

        let presenter = makeDefaultPresenter()
        
        // when
        presenter.viewIsReady()
        
        // then
        XCTAssertEqual(myProfileHolder.setMeCount, 2)
        XCTAssertEqual(interactor.getMeCount, 1)
        validateInitialState(with: myProfileHolder.me)
    }
    
    func testThatItSetsInitialStateWithOtherUser() {
        // given
        let user = User(uid: UUID().uuidString, followersCount: randomValue, followingCount: randomValue)
        interactor.userToReturn = user
        
        let presenter = makeDefaultPresenter(userID: user.uid)
        
        // when
        presenter.viewIsReady()
        
        // then
        validateInitialState(with: user)
        XCTAssertEqual(interactor.getUserCount, 1)
    }
    
    func testThatItFailsToSetFeedWithoutFeedViewController() {
        // given
        let user = User(uid: UUID().uuidString)
        interactor.userToReturn = user
        
        let presenter = makeDefaultPresenter(userID: user.uid)
        presenter.feedViewController = nil
        
        // when
        presenter.viewIsReady()
        
        // then
        validateViewInitialState(with: user)
        
        XCTAssertEqual(feedInput.registerHeaderCount, 0)
        XCTAssertEqual(view.setFeedViewControllerCount, 0)
        XCTAssertEqual(feedInput.setFeedCount, 0)
        XCTAssertNil(feedInput.feedType)
    }
    
    func testThatItFailsToSetFeedViewControllerWithoutFeedModuleInput() {
        // given
        let user = User(uid: UUID().uuidString)
        interactor.userToReturn = user
        
        let presenter = makeDefaultPresenter(userID: user.uid)
        presenter.feedModuleInput = nil
        
        // when
        presenter.viewIsReady()
        
        // then
        validateViewInitialState(with: user)
        
        XCTAssertEqual(feedInput.registerHeaderCount, 0)
        XCTAssertEqual(view.setFeedViewControllerCount, 0)
        XCTAssertEqual(feedInput.setFeedCount, 0)
        XCTAssertNil(feedInput.feedType)
    }
    
    private func validateInitialState(with user: User) {
        validateViewInitialState(with: user)
        validateFeedInitialState(with: user)
    }
    
    private func validateViewInitialState(with user: User) {
        XCTAssertEqual(view.setupInitialStateCount, 1)
        XCTAssertEqual(view.setUserCount, 1)
        XCTAssertEqual(view.lastSetUser, user)
        
        XCTAssertEqual(view.setFollowingCount, 1)
        XCTAssertEqual(view.lastFollowingCount, user.followingCount)
        
        XCTAssertEqual(view.lastFollowersCount, user.followersCount)
        XCTAssertEqual(view.setFollowersCount, 1)
        
        XCTAssertNotNil(view.isLoadingUser)
        XCTAssertFalse(view.isLoadingUser!)
    }
    
    private func validateFeedInitialState(with user: User) {
        XCTAssertEqual(feedInput.registerHeaderCount, 1)
        XCTAssertEqual(view.setFeedViewControllerCount, 1)
        XCTAssertEqual(feedInput.setFeedCount, 1)
        XCTAssertEqual(feedInput.feedType, .user(user: user.uid, scope: .recent))
    }
    
    func testThatItOpensFollowingScreen() {
        // given
        let presenter = makeDefaultPresenter()
        
        // when
        presenter.onFollowing()
        
        // then
        XCTAssertEqual(router.openFollowingCount, 1)
    }
    
    func testThatItOpensFollowersScreen() {
        // given
        let presenter = makeDefaultPresenter()
        
        // when
        presenter.onFollowers()
        
        // then
        XCTAssertEqual(router.openFollowersCount, 1)
    }
    
    func testThatItOpensEditScreen() {
        // given
        let presenter = makeDefaultPresenter()
        
        // when
        presenter.onFollowers()
        
        // then
        XCTAssertEqual(router.openFollowersCount, 1)
    }
    
    func testThatItFollowsUser() {
        // given
        let followingStatus = FollowStatus.empty
        let visibility = Visibility._public
        let expectedStatus = FollowStatus.reduce(status: followingStatus, visibility: visibility)

        let user = User(uid: UUID().uuidString, visibility: visibility, followingStatus: followingStatus)
        interactor.userToReturn = user
        
        let presenter = makeDefaultPresenter(userID: user.uid)
        
        // when
        presenter.onFollowRequest(currentStatus: followingStatus)
        
        // then
        validateFollowStatusChanged(to: expectedStatus)
        XCTAssertEqual(view.lastFollowersCount!, 1)
    }
    
    func testThatItUnfollowsUser() {
        // given
        let followingStatus = FollowStatus.accepted
        let visibility = Visibility._public
        let expectedStatus = FollowStatus.reduce(status: followingStatus, visibility: visibility)
        
        let user = User(uid: UUID().uuidString, visibility: visibility, followingStatus: followingStatus)
        interactor.userToReturn = user
        
        let presenter = makeDefaultPresenter(userID: user.uid)
        
        // when
        presenter.onFollowRequest(currentStatus: followingStatus)
        
        // then
        validateFollowStatusChanged(to: expectedStatus)
        XCTAssertEqual(view.lastFollowersCount!, 0)
    }
    
    func testThatMyMoreMenuIsShown() {
        // given
        let presenter = makeDefaultPresenter()
        
        // when
        presenter.viewIsReady()
        presenter.onMore()
        
        // then
        XCTAssertEqual(router.showMyMenuCount, 1)
        XCTAssertEqual(router.showUserMenuCount, 0)
    }
    
    func testThatUserMoreMenuIsShown() {
        // given
        let user = User(uid: UUID().uuidString)
        interactor.userToReturn = user
        
        let presenter = makeDefaultPresenter(userID: user.uid)
        
        // when
        presenter.viewIsReady()
        presenter.onMore()
        
        // then
        XCTAssertEqual(router.showUserMenuCount, 1)
        XCTAssertEqual(router.showMyMenuCount, 0)
    }
    
    func testThatRecentFeedIsSetWhenUserIsMe() {
        // given
        let presenter = makeDefaultPresenter()
        
        // when
        presenter.viewIsReady()
        presenter.onRecent()
        
        // then
        validateFeedScope(.recent, user: myProfileHolder.me)
    }
    
    func testThatPopularFeedIsSetWhenUserIsMe() {
        // given
        let presenter = makeDefaultPresenter()
        
        // when
        presenter.viewIsReady()
        presenter.onPopular()
        
        // then
        validateFeedScope(.popular, user: myProfileHolder.me)
    }
    
    func testThatRecentFeedIsSetForUser() {
        // given
        let user = User(uid: UUID().uuidString)
        interactor.userToReturn = user
        
        let presenter = makeDefaultPresenter(userID: user.uid)
        
        // when
        presenter.viewIsReady()
        presenter.onRecent()
        
        // then
        validateFeedScope(.recent, user: user)
    }
    
    func testThatPopularFeedIsSetForUser() {
        // given
        let user = User(uid: UUID().uuidString)
        interactor.userToReturn = user
        
        let presenter = makeDefaultPresenter(userID: user.uid)
        
        // when
        presenter.viewIsReady()
        presenter.onPopular()
        
        // then
        validateFeedScope(.popular, user: user)
    }
    
    private func validateFeedScope(_ scope: FeedType.UserFeedScope, user: User) {
        XCTAssertEqual(feedInput.setFeedCount, 2)
        XCTAssertEqual(feedInput.feedType, .user(user: user.uid, scope: scope))
        XCTAssertEqual(view.setFilterEnabledCount, 2)
        XCTAssertEqual(view.isFilterEnabled, false)
    }
    
    private func validateFollowStatusChanged(to expectedStatus: FollowStatus) {
        XCTAssertNotNil(view.lastFollowStatus)
        XCTAssertEqual(view.lastFollowStatus!, expectedStatus)
        
        XCTAssertNotNil(view.isProcessingFollowRequest)
        XCTAssertFalse(view.isProcessingFollowRequest!)
        
        XCTAssertEqual(view.setFollowersCount, 1)
        XCTAssertNotNil(view.lastFollowersCount)
    }
    
    fileprivate func makeDefaultPresenter(userID: String? = nil) -> UserProfilePresenter {
        let presenter = UserProfilePresenter(userID: userID, myProfileHolder: myProfileHolder)
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        presenter.feedModuleInput = feedInput
        presenter.feedViewController = UIViewController()
        return presenter
    }
}

//MARK: FeedModuleOutput tests

extension UserProfilePresenterTests {
    
    func testThatItDoesNotShowStickyHeaderWithoutOffset() {
        // given
        let scrollView = UIScrollView()
        scrollView.contentOffset = CGPoint(x: 0.0, y: 0.0)
        let presenter = makeDefaultPresenter()

        // when
        presenter.didScrollFeed(scrollView)
        
        // then
        XCTAssertEqual(view.setStickyFilterHiddenCount, 1)
        XCTAssertEqual(view.isStickyFilterHidden!, true)
    }
    
    func testThatItShowsStickyHeaderWithBoundaryOffset() {
        // given
        let scrollView = UIScrollView()
        scrollView.contentOffset = CGPoint(x: 0.0, y: UserProfilePresenter.headerHeight - Constants.UserProfile.filterHeight)
        let presenter = makeDefaultPresenter()
        
        // when
        presenter.didScrollFeed(scrollView)
        
        // then
        XCTAssertEqual(view.setStickyFilterHiddenCount, 1)
        XCTAssertEqual(view.isStickyFilterHidden!, false)
    }
    
    func testThatFilterIsEnabledWhenDataFinishesLoading() {
        // given
        let presenter = makeDefaultPresenter()

        // when
        presenter.didRefreshData()
        
        // then
        XCTAssertEqual(view.setFilterEnabledCount, 1)
        XCTAssertEqual(view.isFilterEnabled, true)
    }
    
    func didFailToRefreshData(_ error: Error) {
        // given
        let presenter = makeDefaultPresenter()
        
        // when
        presenter.didFailToRefreshData(APIError.unknown)
        
        // then
        XCTAssertEqual(view.setFilterEnabledCount, 1)
        XCTAssertEqual(view.isFilterEnabled, true)
    }
}

//MARK: FollowersModuleOutput tests

extension UserProfilePresenterTests {
    
    func testThatFollowersModuleUpdatesFollowingStatusWhenUserIsMe() {
        testThatItUpdateFollowingStatus(with: nil, expectedFollowingCount: myProfileHolder.me.followingCount + 1) {
            $0.didUpdateFollowersStatus(newStatus: .accepted)
        }
    }
    
    func testThatFollowersModuleDoesNotUpdateFollowingStatusWhenUserIsNotMe() {
        let user = User(uid: UUID().uuidString, followingCount: randomValue)
        interactor.userToReturn = user
        
        testThatItUpdateFollowingStatus(with: user, expectedFollowingCount: user.followingCount) {
            $0.didUpdateFollowersStatus(newStatus: .accepted)
        }
    }

    func testThatItUpdateFollowingStatus(with user: User?, expectedFollowingCount: Int, update: (UserProfilePresenter) -> Void) {
        // given
        let presenter = makeDefaultPresenter(userID: user?.uid)
        
        // when
        presenter.viewIsReady()
        update(presenter)
        
        // then
        XCTAssertEqual(view.setFollowingCount, 1)
        XCTAssertEqual(view.lastFollowingCount!, expectedFollowingCount)
    }
}

//MARK: FollowingModuleOutput tests

extension UserProfilePresenterTests {
    
    func testThatFollowingModuleUpdatesFollowingStatusWhenUserIsMe() {
        testThatItUpdateFollowingStatus(with: nil, expectedFollowingCount: myProfileHolder.me.followingCount + 1) {
            $0.didUpdateFollowingStatus(newStatus: .accepted)
        }
    }
    
    func testThatFollowingModuleDoesNotUpdateFollowingStatusWhenUserIsNotMe() {
        let user = User(uid: UUID().uuidString, followingCount: randomValue)
        interactor.userToReturn = user
        
        testThatItUpdateFollowingStatus(with: user, expectedFollowingCount: user.followingCount) {
            $0.didUpdateFollowingStatus(newStatus: .accepted)
        }
    }
}

//MARK: CreatePostModuleOutput tests

extension UserProfilePresenterTests {
    
    func testThatFeedIsRefreshedWhenNewPostHasBeenAdded() {
        // given
        let presenter = makeDefaultPresenter()
        
        // when
        presenter.didCreatePost()
        
        // then
        XCTAssertEqual(feedInput.refreshDataCount, 1)
    }
}
