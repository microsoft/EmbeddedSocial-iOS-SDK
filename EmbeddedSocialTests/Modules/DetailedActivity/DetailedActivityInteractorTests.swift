//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial



class DetailedActivityInteractorTests: XCTestCase {
    var output: MockDetailedActivityPresenter!
    var interactor = DetailedActivityInteractor()
    var repliesService: MockRepliesService!
    var commentService: MockCommentsService!
    
    
    override func setUp() {
        repliesService = MockRepliesService()
        commentService = MockCommentsService()
        
        output = MockDetailedActivityPresenter()
        
        interactor.replyService = repliesService
        interactor.commentService = commentService
        interactor.commentHandle = UUID().uuidString
        interactor.replyHandle = UUID().uuidString
    }
    
    override func tearDown() {
        repliesService = nil
        commentService = nil
        interactor.commentHandle = nil
        interactor.replyHandle = nil
        output = nil
        
    }
    
    func testThatCommentLoaded() {
        interactor.loadComment()
        
        XCTAssertEqual(output.loadedCommentCount, 1)
    }
    
    func testThatReplyLoaded() {
        interactor.loadReply()
        
        XCTAssertEqual(output.loadedReplyCount, 1)
    }
    
    
}
