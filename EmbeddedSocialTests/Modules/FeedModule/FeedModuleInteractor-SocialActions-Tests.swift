//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

private class SocialServicesMock: LikesServiceProtocol {
  
    var postLikeIsCalled = false
    var deleteLikeIsCalled = false
    var postPinIsCalled = false
    var deletePinIsCalled = false
    var error: FeedServiceError?
    
    func postLike(post: Post, completion: @escaping LikesServiceProtocol.CompletionHandler) {
        postLikeIsCalled = true
        completion(post.topicHandle, error)
    }
    
    func deleteLike(post: Post, completion: @escaping LikesServiceProtocol.CompletionHandler) {
        deleteLikeIsCalled = true
        completion(post.topicHandle, error)
    }
    
    func postPin(post: Post, completion: @escaping LikesServiceProtocol.CompletionHandler) {
        postPinIsCalled = true
        completion(post.topicHandle, error)
    }
    
    func deletePin(post: Post, completion: @escaping LikesServiceProtocol.CompletionHandler) {
        deletePinIsCalled = true
        completion(post.topicHandle, error)
    }
}

extension SocialServicesMock {
    func likeComment(commentHandle: String, completion: @escaping CommentCompletionHandler) { }
    func unlikeComment(commentHandle: String, completion: @escaping CompletionHandler) { }
}

private class FeedModulePresenterMock: FeedModuleInteractorOutput {
    
    var didPostAction: (post: PostHandle, action: PostSocialAction, error: Error?)?
    
    func didFetch(feed: Feed) { }
    
    func didFetchMore(feed: Feed) { }
    
    func didFail(error: Error) { }
    
    func didStartFetching() { }
    
    func didFinishFetching(with error: Error?) { }
    
    func didPostAction(post: PostHandle, action: PostSocialAction, error: Error?) {
        didPostAction = (post, action, error)
    }
    
    func didUpdateTopicHandle(from oldHandle: String, to newHandle: String) {
        
    }
}

class FeedModuleInteractor_SocialActions_Tests: XCTestCase {

    var sut: FeedModuleInteractor!
    var view: FeedModuleViewController!
    private var presenter: FeedModulePresenterMock!
    
    private var service: SocialServicesMock!
    
    override func setUp() {
        super.setUp()
        
        sut = FeedModuleInteractor()
        
        view = FeedModuleViewController()
        presenter = FeedModulePresenterMock()
        sut.output = presenter
        
        service = SocialServicesMock()
        sut.likesService = service
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testPostLikeIsCalled() {
        // given
        let action = PostSocialAction.like
        let post = Post.mock(seed: 0)
        
        
        // when
        sut.postAction(post: post, action: action)
        
        // then
        XCTAssertTrue(service.postLikeIsCalled)
    }
    
    func testDeleteLikeIsCalled() {
        
        // given
        let action = PostSocialAction.unlike
        let post = Post.mock(seed: 0)
        
        // when
        sut.postAction(post: post, action: action)
        
        // then
        XCTAssertTrue(service.deleteLikeIsCalled)
    }
    
    func testPostPinIsCalled() {
        
        // given
        let action = PostSocialAction.pin
        let post = Post.mock(seed: 0)
        
        // when
        sut.postAction(post: post, action: action)
        
        // then
        XCTAssertTrue(service.postPinIsCalled)
    }
    
    func testDeletePinIsCalled() {
        
        // given
        let action = PostSocialAction.unpin
        let post = Post.mock(seed: 0)
        
        // when
        sut.postAction(post: post, action: action)
        
        // then
        XCTAssertTrue(service.deletePinIsCalled)

    }
    
    func testSocialActionErrorIsHandled() {
        
        // given
        let action = PostSocialAction.unpin
        let post = Post.mock(seed: 0)
        service.error = FeedServiceError.failedToUnPin(message: "Ooops")
        
        // when
        sut.postAction(post: post, action: action)
        
        // then
        XCTAssertTrue(presenter.didPostAction?.action == .unpin)
        XCTAssertTrue(presenter.didPostAction?.error != nil)
        XCTAssertTrue(presenter.didPostAction?.post == post.topicHandle)
    }

}
