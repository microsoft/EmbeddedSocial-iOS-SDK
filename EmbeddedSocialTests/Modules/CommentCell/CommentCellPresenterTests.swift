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
    var actionStrategy: MockAuthorizedActionStrategy!
    
    override func setUp() {
        super.setUp()
        myProfileHolder = MyProfileHolder()
        interactor = MockCommentCellInteractor()
        view = MockCommentCellViewInput()
        router = MockCommentCellRouter()
        
        actionStrategy = MockAuthorizedActionStrategy()
        presenter = CommentCellPresenter(actionStrategy: actionStrategy)
        presenter.router = router
        presenter.view = view
        presenter.interactor = interactor
        
        let commentHandle = "Handle"
        let comment = Comment()
        comment.commentHandle = commentHandle
        comment.user = User(uid: "handle")
        presenter.comment = comment
    }
    
    override func tearDown() {
        super.tearDown()
        presenter.comment = nil
        presenter = nil
        interactor = nil
        view = nil
        router = nil
        myProfileHolder = nil
        actionStrategy = nil
    }
    
    func testThatCommentLikedAndUnliked() {

        //given


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


        //when
        presenter.toReplies(scrollType: .none)

        //then
        XCTAssertEqual(router.openRepliesCount, 1)
    }
    
    func testThatUserOpen() {

        //given

        //when
        presenter.avatarPressed()

        //then
        XCTAssertEqual(router.openUserCount, 1)
    }
    
    func testThatPhotoOpen() {

        //given
        presenter.comment.mediaUrl = "url"
        presenter.comment.mediaHandle = "handle"

        //when
        presenter.mediaPressed()
        
        //then
        XCTAssertEqual(router.openImageCount, 1)
    }
    
    func testThatLikesOpen() {
        //given
        
        //when
        presenter.likesPressed()
        
        //then
        XCTAssertEqual(router.openLikesCount, 1)
    }
    
    func testThatLoginIsOpenedWhenAnonymousUserAttemptsToLike() {
        // given
        myProfileHolder.me = nil
        
        // when
        presenter.like()
        
        // then
        XCTAssertTrue(actionStrategy.executeOrPromptLoginCalled)
    }
    
}
