//
//  UserProfilePresenterTests.swift
//  EmbeddedSocial
//
//  Created by Vadim Bulavin on 7/31/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import XCTest
@testable import EmbeddedSocial

class UserProfilePresenterTests: XCTestCase {
    var view: MockUserProfileView!
    var router: MockUserProfileRouter!
    var interactor: MockUserProfileInteractor!
    
    private let me: User = {
        return User(uid: UUID().uuidString)
    }()
    
    override func setUp() {
        super.setUp()
        view = MockUserProfileView()
        router = MockUserProfileRouter()
        interactor = MockUserProfileInteractor()
    }
    
    override func tearDown() {
        super.tearDown()
        view = nil
        router = nil
        interactor = nil
    }
    
    func testThatItSetsInitialStateWhenUserIsMe() {
        // given
        let presenter = makeDefaultPresenter()
        
        // when
        presenter.viewIsReady()
        
        // then
        XCTAssertEqual(view.setupInitialStateCount, 1)
        XCTAssertEqual(view.setUserCount, 1)
        XCTAssertEqual(view.lastSetUser, me)
        XCTAssertEqual(interactor.getUserCount, 0)

        // If current user is 'Me', it's set immediately
        XCTAssertNil(view.isLoading)
    }
    
    func testThatItSetsInitialStateWithOtherUser() {
        // given
        let user = User(uid: UUID().uuidString)
        interactor.userToReturn = user
        
        let presenter = makeDefaultPresenter(userID: user.uid)
        
        // when
        presenter.viewIsReady()
        
        // then
        XCTAssertEqual(view.setupInitialStateCount, 1)
        XCTAssertEqual(view.setUserCount, 1)
        XCTAssertEqual(view.lastSetUser, user)
        XCTAssertEqual(interactor.getUserCount, 1)
        
        // If current user is 'Me', it's set immediately
        XCTAssertNotNil(view.isLoading)
        XCTAssertFalse(view.isLoading!)
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
    
    func testThatItSendsFollowRequestForPublicUser() {
        // given
        let followingStatus = FollowStatus.empty
        let visibility = Visibility._public
        let user = User(uid: UUID().uuidString, visibility: visibility, followingStatus: followingStatus)
        interactor.userToReturn = user
        
        let presenter = makeDefaultPresenter(userID: user.uid)
        
        // when
        presenter.onFollowRequest(currentStatus: followingStatus)
        
        // then
//        let expectedStatus = FollowStatus.reduce(status: <#T##FollowStatus#>)
    }
    
    private func makeDefaultPresenter(userID: String? = nil) -> UserProfilePresenter {
        let presenter = UserProfilePresenter(userID: userID, me: me)
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        return presenter
    }
}
