//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

private class SocialServiceMock: SocialServiceType {
    
    var followResult: Result<Void>?
    var followUser: String?
    var unfollowResult: Result<Void>?
    var unfollowUser: String?
    var blockResult: Result<Void>?
    var blockUser: String?
    var unblockResult: Result<Void>?
    var unblockUser: String?
    var deletePostResult: Result<Void>?
    var deletePost: String?
    
    func follow(userID: String, completion: @escaping (Result<Void>) -> Void) {
        followUser = userID
        if let result = followResult {
            completion(result)
        }
    }
    
    func unfollow(userID: String, completion: @escaping (Result<Void>) -> Void) {
        unfollowUser = userID
        if let result = unfollowResult {
            completion(result)
        }
    }
    
    func unblock(userID: String, completion: @escaping (Result<Void>) -> Void) {
        unblockUser = userID
        if let result = unblockResult {
            completion(result)
        }
    }
    
    func block(userID: String, completion: @escaping (Result<Void>) -> Void) {
        blockUser = userID
        if let result = blockResult {
            completion(result)
        }
    }
    
    func deletePostFromMyFollowing(postID: String, completion: @escaping (Result<Void>) -> Void) {
        deletePost = postID
        if let result = deletePostResult {
            completion(result)
        }
    }
}

private class TopicsServiceMock: PostServiceProtocol {
    
    var deletePostResult: Result<Void>?
    var deletePost: String?
    
    func deletePost(post: PostHandle, completion: @escaping ((Result<Void>) -> Void)) {
        deletePost = post
        if let result = deletePostResult {
            completion(result)
        }
    }
    
    func fetchMyPins(query: FeedQuery, completion: @escaping FetchResultHandler) {
        
    }
}

extension TopicsServiceMock {
    func fetchHome(query: FeedQuery, completion: @escaping FetchResultHandler) {}
    func fetchPopular(query: PopularFeedQuery, completion: @escaping FetchResultHandler) {}
    func fetchRecent(query: FeedQuery, completion: @escaping FetchResultHandler) {}
    func fetchRecent(query: UserFeedQuery, completion: @escaping FetchResultHandler) {}
    func fetchPopular(query: UserFeedQuery, completion: @escaping FetchResultHandler) {}
    func fetchPost(post: PostHandle, completion: @escaping FetchResultHandler) {}
    func fetchMyPosts(query: FeedQuery, completion: @escaping FetchResultHandler) {}
    func fetchMyPopular(query: FeedQuery, completion: @escaping FetchResultHandler) {}
}

private class PostMenuModulePresenterMock: PostMenuModuleInteractorOutput {
    
    var blockedUser: UserHandle?
    var blockedUserError: Error?
    
    func didBlock(user: UserHandle, error: Error?) {
        blockedUser = user
        blockedUserError = error
    }
    
    var unblockedUser: UserHandle?
    var unblockedUserError: Error?
    
    func didUnblock(user: UserHandle, error: Error?) {
        unblockedUser = user
        unblockedUserError = error
    }
 
    var followedUser: UserHandle?
    var followedUserError: Error?
    
    func didFollow(user: UserHandle, error: Error?) {
        followedUser = user
        followedUserError = error
    }
    
    var unfollowedUser: UserHandle?
    var unfollowedUserError: Error?
    
    func didUnfollow(user: UserHandle, error: Error?) {
        unfollowedUser = user
        unfollowedUserError = error
    }
    
    var hiddenPost: PostHandle?
    var hiddenPostError: Error?
    
    func didHide(post: PostHandle, error: Error?) {
        hiddenPost = post
        hiddenPostError = error
    }
    
    var editedPost: PostHandle?
    var editedPostError: Error?
    
    func didEdit(post: PostHandle, error: Error?) {
        editedPost = post
        editedPostError = error
    }
    
    var removedPost: PostHandle?
    var removedPostError: Error?
    
    func didRemove(post: PostHandle, error: Error?) {
        removedPost = post
        removedPostError = error
    }
    
    var reportedPost: PostHandle?
    var reportedPostError: Error?
    
    func didReport(post: PostHandle, error: Error?) {
        reportedPost = post
        reportedPostError = error
    }
}

class PostMenuModuleInteractorTests: XCTestCase {
    
    var sut: PostMenuModuleInteractor!
    private var topicsService: TopicsServiceMock!
    private var socialService: SocialServiceMock!
    private var presenter: PostMenuModulePresenterMock!
    
    override func setUp() {
        super.setUp()
        
        sut = PostMenuModuleInteractor()
        topicsService = TopicsServiceMock()
        socialService = SocialServiceMock()
        presenter = PostMenuModulePresenterMock()
        
        sut.output = presenter
        sut.socialService = socialService
        sut.topicsService = topicsService
    }
    
    func testThatBlockUserIsSuccessfull() {
        
        // given
        socialService.blockResult = .success()
        
        // when
        let handle = randomHandle
        sut.block(user: handle)
        
        // then
        XCTAssertTrue(socialService.blockUser == handle)
        XCTAssertTrue(presenter.blockedUser == handle)
    }
    
    func testThatFollowWorksProperly() {
        
        // given
        socialService.followResult = .success()
        
        // when
        let handle = randomHandle
        sut.follow(user: handle)
        
        // then
        XCTAssertTrue(socialService.followUser == handle)
        XCTAssertTrue(presenter.followedUser == handle)
    }
    
    func testThatUnfollowWorksProperly() {
        
        // given
        socialService.unfollowResult = .success()
        
        // when
        let handle = randomHandle
        sut.unfollow(user: handle)
        
        // then
        XCTAssertTrue(socialService.unfollowUser == handle)
        XCTAssertTrue(presenter.unfollowedUser == handle)
    }
    
    func testThatHidePostWorksProperly() {
        
        // given
        socialService.deletePostResult = .success()
        
        // when
        let handle = randomHandle
        sut.hide(post: handle)
        
        // then
        XCTAssertTrue(socialService.deletePost == handle)
        XCTAssertTrue(presenter.hiddenPost == handle)
    }
    
    func testThatBlockPostWorksProperly() {
        
        // given
        socialService.blockResult = .success()
        
        // when
        let handle = randomHandle
        sut.block(user: handle)
        
        // then
        XCTAssertTrue(socialService.blockUser == handle)
        XCTAssertTrue(presenter.blockedUser == handle)
    }
    
    private var randomHandle: String {
        return UUID().uuidString
    }
}
