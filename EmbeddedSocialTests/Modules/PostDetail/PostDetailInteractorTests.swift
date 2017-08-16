//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class PostDetailsInteractorTests: XCTestCase {
    
    var output = MockPostDetailPresenter()
    var interactor = PostDetailInteractor()
    
    var coreDataStack: CoreDataStack!
    var transactionsDatabase: MockTransactionsDatabaseFacade!
    var cache: Cachable!
    
    var commentsService: CommentServiceProtocol?
    var likeService: LikesServiceProtocol?
    
    override func setUp() {
        super.setUp()
        interactor.output = output
        coreDataStack = CoreDataHelper.makeEmbeddedSocialInMemoryStack()
        transactionsDatabase = MockTransactionsDatabaseFacade(incomingRepo:  CoreDataRepository(context: coreDataStack.backgroundContext), outgoingRepo:  CoreDataRepository(context: coreDataStack.backgroundContext))
        cache = Cache(database: transactionsDatabase)
        commentsService = MockCommentService(cache: cache)
        likeService = LikesService()

    }
    
    override func tearDown() {
        super.tearDown()
        interactor.output = nil
        transactionsDatabase = nil
        coreDataStack = nil
        cache = nil
        commentsService = nil
        likeService = nil
    }
    
    func testThatFetchedComments() {
        
        //given
        //default in MockCommentService fetching 1 item
        
        //when
        interactor.fetchComments(topicHandle: "test")
        
        //then
        XCTAssertEqual(output.fetchedMoreCommentsCount , 1)
        
    }
    
    func testThatFetchedMoreCommens() {
        
        //given
        //default in MockCommentService fetching 1 item
        
        //when
        interactor.fetchMoreComments(topicHandle: "test")
        
        //then
        XCTAssertEqual(output.fetchedCommentsCount , 1)
    }
    
    func testThatCommentPosted() {
        
        //given
        let comment = "Test"
        
        //when
        interactor.postComment(photo: nil, topicHandle: "test", comment: comment)
        
        //then
        XCTAssertEqual(output.postedComment?.text, comment)
    }
    
    func testThatCommentLiked() {
        //TODO: need LikeService mock object
    }
    
    func testThatCommentUnliked() {
        //TODO: need LikeService mock object
    }
    
}
