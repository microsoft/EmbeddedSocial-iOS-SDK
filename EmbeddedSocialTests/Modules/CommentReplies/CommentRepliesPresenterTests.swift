//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class CommentRepliesPresenterTests: XCTestCase {
    
    var presenter: CommentRepliesPresenter!
    let interactor = MockCommentRepliesIneractor()
    let view = MockCommentRepliesViewController()
    var myProfileHolder: MyProfileHolder!
    var router: MockCommentRepliesRouter!
    
    var commentView: CommentViewModel!
    
    override func setUp() {
        super.setUp()
        let comment = Comment()
        comment.commentHandle = "test"
        comment.firstName = "first name"
        comment.lastName = "last name"
        myProfileHolder = MyProfileHolder()
        presenter = CommentRepliesPresenter(myProfileHolder: myProfileHolder)
        presenter.comment = comment
        presenter.commentCell = CommentCell.nib.instantiate(withOwner: nil, options: nil).first as! CommentCell
        presenter.interactor = interactor
        presenter.view = view
        interactor.output = presenter
        router = MockCommentRepliesRouter()
        presenter.router = router
        view.output = presenter
        presenter.router = router
    }
    
    override func tearDown() {
        super.tearDown()
        commentView = nil
        presenter.comment = nil
        presenter.interactor = nil
        interactor.output = nil
        presenter.view = nil
        view.output = nil
        router = nil
        presenter = nil
    }
    
    func testThatReplyIsPosted() {
        
        //given
        let reply = Reply()
        reply.text = "Text"
        
        //when
        presenter.postReply(text: reply.text!)
        
        //then
        XCTAssertEqual(presenter.replies.count, 1)
        XCTAssertEqual(view.replyPostedCount, 1)
    }
    
    func testThatLoginIsOpenedWhenAnonymousUserAttemptsToReply() {
        
        //given
        let reply = Reply()
        reply.text = "Text"
        
        myProfileHolder.me = nil
        
        //when
        presenter.postReply(text: reply.text!)
        
        //then
        XCTAssertTrue(router.openLoginFromCalled)
    }
    
    func testThatNumberOfItemsIsCorrect() {
        
        //given
        presenter.replies = [Reply()]
        
        //when
        
        //then
        XCTAssertEqual(presenter.numberOfItems(), 1)
    }
    
    func testThatFetchedMore() {
        //given
        let reply = Reply()
        reply.replyHandle = "handle 1"
        reply.createdTime = Date()
        presenter.replies = [reply]
        presenter.cursor = nil
        
        //when
        presenter.fetchMore()
        
        //then
        XCTAssertEqual(presenter.loadMoreCellViewModel.cellHeight, LoadMoreCell.cellHeight)
        XCTAssertEqual(presenter.replies.count, 2)
        
        //when
        presenter.fetchMore()
        
        //then
        XCTAssertEqual(presenter.loadMoreCellViewModel.cellHeight, 0.1)
        XCTAssertEqual(presenter.replies.count, 2)
        
    }
    
    
}
