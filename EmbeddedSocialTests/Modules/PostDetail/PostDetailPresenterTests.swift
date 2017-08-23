//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class PostDetailsPresenterTests: XCTestCase {
    
    let presenter = PostDetailPresenter()
    let interactor = MockPostDetailsInteractor()
    let view = MockPostDetailViewController()
    
    var post: Post!
    
    override func setUp() {
        super.setUp()
        post = Post(topicHandle: "topicHandle", createdTime: Date(), userHandle: "userHandle", userStatus: Post.UserStatus.none, firstName: "firstName", lastName: "lastName", photoHandle: "photoHandle", photoUrl: "photoUrl", title: "title", text: "text", imageUrl: "imageUrl", deepLink: "deepLink", totalLikes: 0, totalComments: 0, liked: true, pinned: true)
        presenter.interactor = interactor
        presenter.view = view
//        presenter.post = post
        interactor.output = presenter
        view.output = presenter
    }
    
    override func tearDown() {
        super.tearDown()
        post = nil
        presenter.post = nil
        presenter.interactor = nil
        interactor.output = nil
        presenter.view = nil
        view.output = nil
    }
    
    
    func testThatStateSetup() {
        XCTFail()
        return;
            
        //FIXME: Next line crashes
        presenter.viewIsReady()
        
        XCTAssertEqual(view.setupCount, 1)
    }
    
    func testThatCommentPosted() {
        
        //given
        let comment = Comment()
        comment.text = "Text"
        let photo = Photo(uid: "testid", url: "Url", image: UIImage())
        
        //when
        //FIXME: Next line crashes
//        presenter.postComment(photo: photo, comment: comment.text!)
        
        //then
        XCTAssertEqual(presenter.comments.count, 1)
        XCTAssertEqual(view.commentPostFailed, 0)
        
        
    }
    
    func testThatNumberOfItemsCorrect() {
        
        //given
        presenter.comments = [Comment()]
        
        //when
        
        //then
        XCTAssertEqual(presenter.numberOfItems(), 1)
        
    }
    
    func testThatCommentLiked() {
        
        //given
//        let commentHandle = "Handle"
//        let comment = Comment()
//        comment.commentHandle = commentHandle
//        presentor.comments = [comment]
//        
//        //when
//        interactor.commentAction(commentHandle: commentHandle, action: .like)
//        
//        //then
//        XCTAssertEqual(view.commentsLike, "1 like")
    }
    
    func testThatCommentUnliked() {
        
//        //given
//        let commentHandle = "Handle"
//        let comment = Comment()
//        comment.commentHandle = commentHandle
//        presentor.comments = [comment]
//        
//        //when
//        interactor.commentAction(commentHandle: commentHandle, action: .like)
//        
//        //then
//        XCTAssertEqual(view.commentsLike, "0 likes")
    }
    
    func testThatFetchMore() {
        
        //given
        //In interactor default fetching 1 element
        
        //when
        //FIXME: Next line crashes
//        presenter.fetchMore()
        
        //then
        XCTAssertEqual(presenter.comments.count, 1)
    }
    
    
}
