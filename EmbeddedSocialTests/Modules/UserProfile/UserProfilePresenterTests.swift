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
    var moduleOutput: MockUserProfileModuleOutput!
    var actionStrategy: CommonAuthorizedActionStrategy!
    
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
        moduleOutput = MockUserProfileModuleOutput()
        actionStrategy = CommonAuthorizedActionStrategy(myProfileHolder: myProfileHolder, loginParent: nil, loginOpener: MockLoginModalOpener())
    }
    
    override func tearDown() {
        super.tearDown()
        myProfileHolder = nil
        view = nil
        router = nil
        interactor = nil
        feedInput = nil
        moduleOutput = nil
        actionStrategy = nil
    }
    
    func testThatItSetsInitialStateWhenUserIsMe() {
        // given
        let credentials = CredentialsList(provider: .facebook, accessToken: "", socialUID: "")
        let user = User(uid: UUID().uuidString, credentials: credentials,
                        followersCount: randomValue, followingCount: randomValue)
        myProfileHolder.me = user
        interactor.meToReturn = user

        let presenter = makeDefaultPresenter()
        
        // when
        presenter.viewIsReady()
        
        // then
        XCTAssertEqual(myProfileHolder.setMeCount, 2)
        XCTAssertEqual(interactor.getMeCount, 1)
        XCTAssertEqual(interactor.cachedUserCount, 0)
        XCTAssertEqual(view.layoutAsset, feedInput.layout.nextLayoutAsset)

        validateViewInitialState(with: user, userIsCached: true)
        validateFeedInitialState(with: user, userIsCached: true)
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
        
        XCTAssertEqual(view.layoutAsset, feedInput.layout.nextLayoutAsset)

        XCTAssertEqual(interactor.getUserCount, 1)
        XCTAssertEqual(interactor.cachedUserCount, 1)
    }
    
    func testThatItSetsInitialStateAnonymously() {
        // given
        myProfileHolder.me = nil
        let user = User(uid: UUID().uuidString, followersCount: randomValue, followingCount: randomValue)
        interactor.userToReturn = user
        
        let presenter = makeDefaultPresenter(userID: user.uid)
        
        // when
        presenter.viewIsReady()
        
        // then
        validateInitialState(with: user)
        
        XCTAssertEqual(view.layoutAsset, feedInput.layout.nextLayoutAsset)
        
        XCTAssertEqual(interactor.getUserCount, 1)
        XCTAssertEqual(interactor.cachedUserCount, 1)
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
    
    private func validateViewInitialState(with user: User, userIsCached: Bool = false) {
        XCTAssertEqual(view.setupInitialStateCount, 1)
        XCTAssertEqual(view.setUserCount, userIsCached ? 2 : 1)
        XCTAssertEqual(view.lastSetUser, user)
        
        XCTAssertEqual(view.setFollowingCount, userIsCached ? 2 : 1)
        XCTAssertEqual(view.lastFollowingCount, user.followingCount)
        
        XCTAssertEqual(view.lastFollowersCount, user.followersCount)
        XCTAssertEqual(view.setFollowersCount, userIsCached ? 2 : 1)
        
        XCTAssertNotNil(view.isLoadingUser)
        XCTAssertFalse(view.isLoadingUser!)
    }
    
    private func validateFeedInitialState(with user: User, userIsCached: Bool = false) {
        XCTAssertEqual(feedInput.registerHeaderCount, 1)
        XCTAssertEqual(view.setFeedViewControllerCount, 1)
        XCTAssertEqual(view.setLayoutAssetCount, 1)
        XCTAssertEqual(view.layoutAsset, Asset.iconList)
        XCTAssertEqual(feedInput.setFeedCount, 1)
        XCTAssertEqual(feedInput.feedType, .user(user: user.uid, scope: .recent))
        XCTAssertEqual(feedInput.setHeaderHeightCount, userIsCached ? 2 : 1)
        XCTAssertTrue(abs(feedInput.headerHeight! - view.headerContentHeight) < 0.0001)
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
        testThatItChangesFollowingStatus(to: .accepted, from: .empty, visibility: ._public)
        XCTAssertEqual(view.lastFollowersCount!, 1)
    }
    
    func testThatItUnfollowsUser() {
        testThatItChangesFollowingStatus(to: .empty, from: .accepted, visibility: ._public)
        XCTAssertEqual(view.lastFollowersCount!, 0)
    }
    
    func testThatItUnblocksUser() {
        testThatItChangesFollowingStatus(to: .empty, from: .blocked, visibility: ._public)
    }
    
    func testThatItChangesFollowingStatus(to newStatus: FollowStatus, from oldStatus: FollowStatus, visibility: Visibility) {
        // given
        let user = User(uid: UUID().uuidString, visibility: visibility, followingStatus: oldStatus)
        interactor.userToReturn = user
        interactor.processSocialRequestResult = .success(newStatus)
        
        let presenter = makeDefaultPresenter(userID: user.uid)
        
        // when
        presenter.viewIsReady()
        presenter.onFollowRequest(currentStatus: oldStatus)
        
        // then
        validateFollowStatusChanged(to: newStatus)
    }
    
    func testThatItOpensLoginWhenAnonymousUserAttemptsToFollow() {
        // given
        let followStatus = FollowStatus.empty
        let user = User(uid: UUID().uuidString, visibility: ._public, followingStatus: followStatus)
        interactor.userToReturn = user
        
        myProfileHolder.me = nil

        let presenter = makeDefaultPresenter(userID: user.uid)
        
        // when
        presenter.viewIsReady()
        presenter.onFollowRequest(currentStatus: followStatus)
        
        // then
        XCTAssertEqual(interactor.socialRequestCount, 0)
                
        XCTAssertNil(view.lastFollowStatus)
        XCTAssertNil(view.isProcessingFollowRequest)
        XCTAssertEqual(view.lastFollowersCount, user.followersCount)
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
        validateFeedScope(.recent, user: myProfileHolder.me!)
    }
    
    func testThatPopularFeedIsSetWhenUserIsMe() {
        // given
        let presenter = makeDefaultPresenter()
        
        // when
        presenter.viewIsReady()
        presenter.onPopular()
        
        // then
        validateFeedScope(.popular, user: myProfileHolder.me!)
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
        
        XCTAssertNotNil(view.lastFollowersCount)
        
        XCTAssertTrue(moduleOutput.didChangeUserFollowStatusCalled)
    }
    
    func testThatItFlipsFeedLayout() {
        // given
        let initialLayout = feedInput.layout
        let flippedLayout = initialLayout.flipped
        let presenter = makeDefaultPresenter()
        
        // when
        presenter.onFlipFeedLayout()
        
        // then
        XCTAssertEqual(feedInput.setLayoutCount, 1)
        XCTAssertEqual(feedInput.layout, flippedLayout)
        
        XCTAssertEqual(view.setLayoutAssetCount, 1)
        XCTAssertEqual(view.layoutAsset, flippedLayout.nextLayoutAsset)
    }
    
    fileprivate func makeDefaultPresenter(userID: String? = nil) -> UserProfilePresenter {
        let presenter = UserProfilePresenter(userID: userID, myProfileHolder: myProfileHolder, actionStrategy: actionStrategy)
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        presenter.feedModuleInput = feedInput
        presenter.feedViewController = UIViewController()
        presenter.moduleOutput = moduleOutput
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
        view.headerContentHeight = UserProfilePresenter.headerHeight
 
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
        presenter.didFinishRefreshingData(nil)
        
        // then
        XCTAssertEqual(view.setFilterEnabledCount, 1)
        XCTAssertEqual(view.isFilterEnabled, true)
    }
    
    func didFailToRefreshData(_ error: Error) {
        // given
        let presenter = makeDefaultPresenter()
        
        // when
        presenter.didFinishRefreshingData(APIError.unknown)
        
        // then
        XCTAssertEqual(view.setFilterEnabledCount, 1)
        XCTAssertEqual(view.isFilterEnabled, true)
    }
    
    func testThatItShouldNotOpenMyProfileFromMyFeed() {
        // given
        let presenter = makeDefaultPresenter()
        
        // when
        
        // then
        XCTAssertFalse(presenter.shouldOpenProfile(for: myProfileHolder.me!.uid))
        XCTAssertTrue(presenter.shouldOpenProfile(for: UUID().uuidString))
    }
    
    func testThatItShouldNotOpenOtherUserProfileFromHisFeed() {
        // given
        let userID = UUID().uuidString
        let presenter = makeDefaultPresenter(userID: userID)
        
        // when
        
        // then
        XCTAssertFalse(presenter.shouldOpenProfile(for: myProfileHolder.me!.uid))
        XCTAssertFalse(presenter.shouldOpenProfile(for: userID))
        XCTAssertTrue(presenter.shouldOpenProfile(for: UUID().uuidString))
    }
}

//MARK: FollowersModuleOutput tests

extension UserProfilePresenterTests {
    
    func testThatFollowersModuleUpdatesFollowingStatusWhenUserIsMe() {
        testThatItUpdateFollowingStatus(with: nil, expectedFollowingCount: myProfileHolder.me!.followingCount + 1) {
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
        testThatItUpdateFollowingStatus(with: nil, expectedFollowingCount: myProfileHolder.me!.followingCount + 1) {
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

//MARK: FollowRequestsModuleOutput tests

extension UserProfilePresenterTests {
    
    func testThatItUpdatesFollowersCountWhenFollowRequestIsAccepted() {
        // given
        let presenter = makeDefaultPresenter()
        
        // when
        presenter.didAcceptFollowRequest()
        
        // then
        XCTAssertEqual(view.setFollowersCount, 1)
    }
}
