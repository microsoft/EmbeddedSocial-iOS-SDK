//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class CommentCellPresenterTests: XCTestCase, CommentCellModuleProtocol {
    
    let presenter = CommentCellPresenter()
    let interactor = MockCommentCellInteractor()
    let view = MockCommentCell()
    let router = MockCommentCellRouter()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
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
        router.openReplies(scrollType: .none, commentModulePresenter: self)

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
    
    //CommentCellModuleProtocol
    func mainComment() -> Comment {
        return presenter.comment
    }
    
    func cell() -> CommentCell {
        return view
    }
}
