//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class CommentCellPresenterTests: XCTestCase {
    
    var presenter: CommentCellPresenter!
    var interactor: MockCommentCellInteractor!
    var view: MockCommentCellViewInput!
    var router: MockCommentCellRouter!
    var myProfileHolder: MyProfileHolder!
    
    override func setUp() {
        super.setUp()
        myProfileHolder = MyProfileHolder()
        interactor = MockCommentCellInteractor()
        view = MockCommentCellViewInput()
        router = MockCommentCellRouter()
        
        presenter = CommentCellPresenter()
        presenter.myProfileHolder = myProfileHolder
        presenter.router = router
        presenter.view = view
        presenter.interactor = interactor
    }
    
    override func tearDown() {
        super.tearDown()
        presenter = nil
        interactor = nil
        view = nil
        router = nil
        myProfileHolder = nil
    }
    
    func testThatCommentLikedAndUnliked() {

        //given
        let commentHandle = "Handle"
        let comment = Comment()
        comment.commentHandle = commentHandle
        comment.userHandle = "user"
        presenter.comment = comment

        //when like
        presenter.like()

        //then
        XCTAssertEqual(presenter.comment.liked, true)

        //when unlike
        presenter.like()

        //then
        XCTAssertEqual(presenter.comment.liked, false)
    }

    func testThatRepliesOpen() {
    
        //given
        let commentHandle = "Handle"
        let comment = Comment()
        comment.commentHandle = commentHandle
        comment.userHandle = "user"
        presenter.comment = comment

        //when
        router.openReplies(scrollType: .none, commentModulePresenter: presenter)

        //then
        XCTAssertEqual(router.openRepliesCount, 1)
    }
    
    func testThatUserOpen() {

        //given
        let commentHandle = "Handle"
        let comment = Comment()
        comment.commentHandle = commentHandle
        comment.userHandle = "user"
        presenter.comment = comment

        //when
        router.openUser(userHandle: comment.userHandle!)

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
        presenter.comment = comment

        //when
        router.openImage(imageUrl: comment.mediaUrl!)
        
        //then
        XCTAssertEqual(router.openImageCount, 1)
    }
    
    func testThatLikesOpen() {
        //given
        let commentHandle = "Handle"
        
        //when
        router.openLikes(commentHandle: commentHandle)
        
        //then
        XCTAssertEqual(router.openLikesCount, 1)
    }
    
    func testThatLoginIsOpenedWhenAnonymousUserAttemptsToLike() {
        // given
        myProfileHolder.me = nil
        
        // when
        presenter.like()
        
        // then
        XCTAssertEqual(router.openLoginCount, 1)
    }
}
