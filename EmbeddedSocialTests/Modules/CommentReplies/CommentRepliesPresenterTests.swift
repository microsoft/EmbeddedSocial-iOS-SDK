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
        router = MockCommentRepliesRouter()
        myProfileHolder = MyProfileHolder()
        presenter = CommentRepliesPresenter(myProfileHolder: myProfileHolder)
        commentView  = CommentViewModel()
        let comment = Comment()
        commentView.comment = comment
        presenter.interactor = interactor
        presenter.view = view
        presenter.commentView = commentView
        interactor.output = presenter
        view.output = presenter
        presenter.router = router
    }
    
    override func tearDown() {
        super.tearDown()
        commentView = nil
        presenter.commentView = nil
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
        //In interactor default fetching 1 element
        
        //when
        presenter.fetchMore()
        
        //then
        XCTAssertEqual(presenter.replies.count, 1)
    }
    
    
}
