//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

private class LikesServiceMock: LikesServiceProtocol {
    
    var postLikeIsCalled = false
    var deleteLikeIsCalled = false
    
    func postLike(postHandle: LikesServiceProtocol.PostHandle, completion: @escaping LikesServiceProtocol.CompletionHandler) {
        
        postLikeIsCalled = true
        completion(postHandle, nil)
    }
    
    func deleteLike(postHandle: LikesServiceProtocol.PostHandle, completion: @escaping LikesServiceProtocol.CompletionHandler) {
        deleteLikeIsCalled = true
        completion(postHandle, nil)
    }
}

private class PinsServiceMock: PinsServiceProtocol {
  
    var postPinIsCalled = false
    var deletePinIsCalled = false
    
    func postPin(postHandle: PinsServiceProtocol.PostHandle, completion: @escaping PinsServiceProtocol.CompletionHandler) {
        
        postPinIsCalled = true
        completion(postHandle, nil)
    }
    
    func deletePin(postHandle: PinsServiceProtocol.PostHandle, completion: @escaping PinsServiceProtocol.CompletionHandler) {
        
        deletePinIsCalled = true
        completion(postHandle, nil)
    }
}

class FeedModuleInteractor_SocialActions_Tests: XCTestCase {

    var sut: FeedModuleInteractor!
    var view: FeedModuleViewController!
    var presenter: FeedModulePresenter!
    
    private var likesServiceMock: LikesServiceMock!
    private var pinsServiceMock: PinsServiceMock!
    
    override func setUp() {
        super.setUp()
        
        sut = FeedModuleInteractor()
        
        view = FeedModuleViewController()
        presenter = FeedModulePresenter()
        presenter.view = view
        sut.output = presenter
        
        likesServiceMock = LikesServiceMock()
        sut.likesService = likesServiceMock
        
        pinsServiceMock = PinsServiceMock()
        sut.pinsService = pinsServiceMock
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
        XCTAssertTrue(likesServiceMock.postLikeIsCalled)
    }
    
    func testDeleteLikeIsCalled() {
        
        // given
        let action = PostSocialAction.unlike
        let post = "handle"
        
        // when
        sut.postAction(post: post, action: action)
        
        // then
        XCTAssertTrue(likesServiceMock.deleteLikeIsCalled)
    }
    
    func testPostPinIsCalled() {
        
        // given
        let action = PostSocialAction.pin
        let post = "handle"
        
        // when
        sut.postAction(post: post, action: action)
        
        // then
        XCTAssertTrue(pinsServiceMock.postPinIsCalled)
    }
    
    func testDeletePinIsCalled() {
        
        // given
        let action = PostSocialAction.unpin
        let post = "handle"
        
        // when
        sut.postAction(post: post, action: action)
        
        // then
        XCTAssertTrue(pinsServiceMock.deletePinIsCalled)

    }

}
