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
    
    let post = Post(topicHandle: "handle", createdTime: Date(), userHandle: "userHandle", firstName: "FirstName", lastName: "LastName", photoHandle: "photoHandle", photoUrl: "photoUrl", title: "Title", text: "Text", imageUrl: "imageUrl", deepLink: nil, totalLikes: 5, totalComments: 5, liked: true, pinned: true)
    
    override func setUp() {
        super.setUp()
        presentor.interactor = interactor
        interactor.output = presentor
        view.output = presentor
        presentor.view = view
    }
    
    override func tearDown() {
        super.tearDown()
        presentor.interactor = nil
        interactor.output = nil
        presentor.view = nil
        view.output = nil
    }
    
    func testThatCommentPosted() {
        
        //given
        let comment = Comment()
        comment.text = "Text"
        let photo = Photo(image: UIImage())
        
        //when
        presentor.postComment(photo: photo, comment: comment.text!)
        
        //then
        XCTAssertEqual(view.commentPostedCount, 1)
        
        
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
