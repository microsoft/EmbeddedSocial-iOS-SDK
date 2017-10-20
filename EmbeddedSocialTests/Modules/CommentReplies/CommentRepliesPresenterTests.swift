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
        comment.user = MyProfileHolder().me
        myProfileHolder = MyProfileHolder()
        presenter = CommentRepliesPresenter(pageSize: 10, actionStrategy: MockAuthorizedActionStrategy())
        presenter.comment = comment
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
