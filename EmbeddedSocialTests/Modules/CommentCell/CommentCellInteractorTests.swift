//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class CommentCellInteractorTests: XCTestCase {
    
    var output: MockCommentCellPresenter!
    var interactor: CommentCellInteractor!
    var actionStrategy: CommonAuthorizedActionStrategy!
    
    var likeService: MockLikesService!
    
    override func setUp() {
        super.setUp()
        actionStrategy = CommonAuthorizedActionStrategy(
            myProfileHolder: MyProfileHolder(),
            loginParent: UIViewController(),
            loginOpener: MockLoginModalOpener()
        )
        interactor = CommentCellInteractor()
        output = MockCommentCellPresenter(actionStrategy: actionStrategy)
        interactor.output = output
        likeService = MockLikesService()
        interactor.likeService = likeService
    }
    
    override func tearDown() {
        super.tearDown()
        output = nil
        actionStrategy = nil
        interactor = nil
    }
    
    func testThatCommentLiked() {

        //given
        let comment = Comment()
        comment.commentHandle = "handle"
        comment.text = "text"
        comment.totalLikes = 0
        comment.liked = false
        output.comment = comment
        
        likeService.likeCommentCommentHandleCompletionReturnValue = (comment.commentHandle!, nil)

        //when
        interactor.commentAction(commentHandle: comment.commentHandle!, action: .like)

        //then
        XCTAssertEqual(output.comment.totalLikes , 1)
        XCTAssertEqual(output.comment.liked , true)
    }
    
    func testThatCommentUnliked() {

        //given
        let comment = Comment()
        comment.commentHandle = "handle"
        comment.text = "text"
        comment.totalLikes = 1
        comment.liked = true
        output.comment = comment
        
        likeService.unlikeCommentCommentHandleCompletionReturnValue = (comment.commentHandle!, nil)

        //when
        interactor.commentAction(commentHandle: comment.commentHandle!, action: .unlike)

        //then
        XCTAssertEqual(output.comment.totalLikes , 0)
        XCTAssertEqual(output.comment.liked , false)
    }
    
}
