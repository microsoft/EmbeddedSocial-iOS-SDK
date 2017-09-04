//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

private class SocialServicesMock: LikesServiceProtocol, PinsServiceProtocol {
    
    var postLikeIsCalled = false
    var deleteLikeIsCalled = false
    var postPinIsCalled = false
    var deletePinIsCalled = false
    var error: FeedServiceError?
    
    func postLike(postHandle: PostHandle, completion: @escaping LikesServiceProtocol.CompletionHandler) {
        postLikeIsCalled = true
        completion(postHandle, error)
    }
    
    func deleteLike(postHandle: PostHandle, completion: @escaping LikesServiceProtocol.CompletionHandler) {
        deleteLikeIsCalled = true
        completion(postHandle, error)
    }
    
    func postPin(postHandle: PostHandle, completion: @escaping PinsServiceProtocol.CompletionHandler) {
        postPinIsCalled = true
        completion(postHandle, error)
    }
    
    func deletePin(postHandle: PostHandle, completion: @escaping PinsServiceProtocol.CompletionHandler) {
        deletePinIsCalled = true
        completion(postHandle, error)
    }
    
    func likeComment(commentHandle: String, completion: @escaping CommentCompletionHandler) {
        
    }
    
    func unlikeComment(commentHandle: String, completion: @escaping CompletionHandler) {
        
    }
    
}

private class FeedModulePresenterMock: FeedModuleInteractorOutput {
    
    var didPostAction: (post: PostHandle, action: PostSocialAction, error: Error?)?
    
    func didFetch(feed: PostsFeed) { }
    
    func didFetchMore(feed: PostsFeed) { }
    
    func didFail(error: FeedServiceError) { }
    
    func didStartFetching() { }
    
    func didFinishFetching() { }
    
    func didPostAction(post: PostHandle, action: PostSocialAction, error: Error?) {
        didPostAction = (post, action, error)
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
        sut.pinsService = service
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testPostLikeIsCalled() {
        // given
        let action = PostSocialAction.like
        let post = "handle"
        
        // when
        sut.postAction(post: post, action: action)
        
        // then
        XCTAssertTrue(service.postLikeIsCalled)
    }
    
    func testDeleteLikeIsCalled() {
        
        // given
        let action = PostSocialAction.unlike
        let post = "handle"
        
        // when
        sut.postAction(post: post, action: action)
        
        // then
        XCTAssertTrue(service.deleteLikeIsCalled)
    }
    
    func testPostPinIsCalled() {
        
        // given
        let action = PostSocialAction.pin
        let post = "handle"
        
        // when
        sut.postAction(post: post, action: action)
        
        // then
        XCTAssertTrue(service.postPinIsCalled)
    }
    
    func testDeletePinIsCalled() {
        
        // given
        let action = PostSocialAction.unpin
        let post = "handle"
        
        // when
        sut.postAction(post: post, action: action)
        
        // then
        XCTAssertTrue(service.deletePinIsCalled)

    }
    
    func testSocialActionErrorIsHandled() {
        
        // given
        let action = PostSocialAction.unpin
        let post = "handle"
        service.error = FeedServiceError.failedToUnPin(message: "Ooops")
        
        // when
        sut.postAction(post: post, action: action)
        
        // then
        XCTAssertTrue(presenter.didPostAction!.action == .unpin)
        XCTAssertTrue(presenter.didPostAction!.error != nil)
        XCTAssertTrue(presenter.didPostAction!.post == "handle")
    }

}
