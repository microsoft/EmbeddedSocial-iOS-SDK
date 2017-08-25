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
    let router = MockPostDetailRouter()
    
    var post: PostViewModel!
    
    override func setUp() {
        super.setUp()
        post = PostViewModel(topicHandle: "topicHandle", userName: "username", title: "title", text: "text", isLiked: false, isPinned: false, likedBy: "", totalLikes: "0 likes", totalComments: "0 comments", timeCreated: "date", userImageUrl: "", postImageUrl: "", tag: 0, cellType: "PostCell", onAction: { action, path in
            print("asdsa")})
        presenter.interactor = interactor
        presenter.view = view
        presenter.post = post
        presenter.router = router
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
        presenter.router = nil
        view.output = nil
    }
    
    
    func testThatStateSetup() {
            
        presenter.viewIsReady()
        
        XCTAssertEqual(view.setupCount, 1)
    }
    
    func testThatCommentPosted() {
        
        //given
        let comment = Comment()
        comment.text = "Text"
        let photo = Photo(uid: "testid", url: "Url", image: UIImage())
        
        //when
        presenter.postComment(photo: photo, comment: comment.text!)
        
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
    
    func testThatCommentLikedAndUnliked() {
        
        //given
        let commentHandle = "Handle"
        let comment = Comment()
        comment.commentHandle = commentHandle
        comment.userHandle = "user"
        presenter.comments = [comment]
        
        //when like
        presenter.handle(action: .like, index: 0)
        
        //then
        XCTAssertEqual(view.commentsLike, "1 like")
        
        //when unlike
        presenter.handle(action: .like, index: 0)
        
        //then
        XCTAssertEqual(view.commentsLike, "0 likes")
    }
    
    func testThatRepliesOpen() {
        
        //given
        let commentHandle = "Handle"
        let comment = Comment()
        comment.commentHandle = commentHandle
        comment.userHandle = "user"
        presenter.comments = [comment]
        
        //when
        presenter.handle(action: .replies, index: 0)
        
        //then
        XCTAssertEqual(router.openRepliesCount, 1)
    }

    func testThatUserOpen() {
        
        //given
        let commentHandle = "Handle"
        let comment = Comment()
        comment.commentHandle = commentHandle
        comment.userHandle = "user"
        presenter.comments = [comment]
        
        //when
        presenter.handle(action: .profile, index: 0)
        
        //then
        XCTAssertEqual(router.openUserCount, 1)
    }
    
    func testThatPhotoOpen() {
        
        //given
        let commentHandle = "Handle"
        let comment = Comment()
        comment.commentHandle = commentHandle
        comment.userHandle = "user"
        comment.mediaUrl = "url"
        presenter.comments = [comment]
        
        //when
        presenter.handle(action: .photo, index: 0)
        
        //then
        XCTAssertEqual(router.openImageCount, 1)
    }
    
    func testThatFetchMore() {
        
        //given
//        In interactor default fetching 1 element
        
        //when
        presenter.fetchMore()
        
        //then
        XCTAssertEqual(presenter.comments.count, 1)
    }
    
    func testThatPostFetching() {
        
        //when
        presenter.refreshPost()
        
        //then
        XCTAssertEqual(interactor.loadPostCount, 1)
        XCTAssertEqual(view.postCellRefreshCount, 1)
        
    }
    
    
}
