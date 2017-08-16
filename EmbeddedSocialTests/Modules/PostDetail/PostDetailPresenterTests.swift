//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class PostDetailsPresenterTests: XCTestCase {
    
    let presentor = PostDetailPresenter()
    let interactor = MockPostDetailsInteractor()
    let view = MockPostDetailViewController()
    
    var post: Post!
    
    override func setUp() {
        super.setUp()
        post = Post(topicHandle: "topicHandle", createdTime: Date(), userHandle: "userHandle", userStatus: Post.UserStatus.none, firstName: "firstName", lastName: "lastName", photoHandle: "photoHandle", photoUrl: "photoUrl", title: "title", text: "text", imageUrl: "imageUrl", deepLink: "deepLink", totalLikes: 0, totalComments: 0, liked: true, pinned: true)
        presentor.interactor = interactor
        presentor.view = view
        presentor.post = post
        interactor.output = presentor
        view.output = presentor
    }
    
    override func tearDown() {
        super.tearDown()
        post = nil
        presentor.post = nil
        presentor.interactor = nil
        interactor.output = nil
        presentor.view = nil
        view.output = nil
    }
    
    func testThatCommentPosted() {
        
        //given
        let comment = Comment()
        comment.text = "Text"
        let photo = Photo(uid: "testid", url: "Url", image: UIImage())
        
        //when
        presentor.postComment(photo: photo, comment: comment.text!)
        
        //then
        XCTAssertEqual(presentor.comments.count, 1)
        XCTAssertEqual(view.commentPostFailed, 0)
        
        
    }
    
    func testThatNumberOfItemsCorrect() {
        
        //given
        presentor.comments = [Comment()]
        
        //when
        
        //then
        XCTAssertEqual(presentor.numberOfItems(), 1)
        
    }
    
    func testThatCommentLiked() {
        
        //given
        let comment = Comment()
        comment.text = "Text"
        
        //when
        presentor.likeComment(comment: comment)
        
        //then
        XCTAssertEqual(view.commentsLike, 1)
    }
    
    func testThatCommentUnliked() {
        
        //given
        let comment = Comment()
        comment.text = "Text"
        comment.totalLikes = 1
        
        //when
        presentor.likeComment(comment: comment)
        
        //then
        XCTAssertEqual(view.commentsLike, 0)
    }
    
    func testThatFetchMore() {
        
        //given
        //In interactor default fetching 1 element
        
        //when
        presentor.fetchMore()
        
        //then
        XCTAssertEqual(presentor.comments.count, 1)
    }
    
    
}
