//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial


private class MockTopicService: PostServiceProtocol {
    func fetchPost(post: PostHandle, completion: @escaping FetchResultHandler) {
        var result = PostFetchResult()
        result.posts = [Post()]
        completion(result)
    }
}

extension MockTopicService {
    
    func fetchHome(query: HomeFeedQuery, completion: @escaping FetchResultHandler) {}
    func fetchPopular(query: PopularFeedQuery, completion: @escaping FetchResultHandler) {}
    func fetchRecent(query: RecentFeedQuery, completion: @escaping FetchResultHandler) {}
    func fetchRecent(query: UserFeedQuery, completion: @escaping FetchResultHandler) {}
    func fetchPopular(query: UserFeedQuery, completion: @escaping FetchResultHandler) {}
    func fetchMyPosts(query: MyFeedQuery, completion: @escaping FetchResultHandler) {}
    func fetchMyPopular(query: MyFeedQuery, completion: @escaping FetchResultHandler) {}
    func deletePost(post: PostHandle, completion: @escaping ((Result<Void>) -> Void)) {}

}

class PostDetailsInteractorTests: XCTestCase {
    
     private let timeout: TimeInterval = 5
    
    var output = MockPostDetailPresenter()
    var interactor = PostDetailInteractor()
    
    var coreDataStack: CoreDataStack!
    var transactionsDatabase: MockTransactionsDatabaseFacade!
    var cache: CacheType!
    
    var commentsService: CommentServiceProtocol?
    var likeService: LikesServiceProtocol?
    var topicServer: PostServiceProtocol?
    var imageService: ImagesServiceType?
    
    override func setUp() {
        super.setUp()
        output.interactor = interactor
        interactor.output = output
        coreDataStack = CoreDataHelper.makeEmbeddedSocialInMemoryStack()
        transactionsDatabase = MockTransactionsDatabaseFacade(incomingRepo:  CoreDataRepository(context: coreDataStack.backgroundContext), outgoingRepo:  CoreDataRepository(context: coreDataStack.backgroundContext))
        cache = Cache(database: transactionsDatabase)
        imageService = ImagesService()
        commentsService = MockCommentService(imagesService: imageService!)
        topicServer = MockTopicService()
        interactor.commentsService = commentsService
        interactor.topicService = topicServer

    }
    
    override func tearDown() {
        super.tearDown()
        interactor.output = nil
        output.interactor = nil
        transactionsDatabase = nil
        coreDataStack = nil
        cache = nil
        commentsService = nil
        likeService = nil
        topicServer = nil
    }
    
    func testThatFetchedComments() {
        
        //given
        //default in MockCommentService fetching 1 item
        
        //when
        interactor.fetchComments(topicHandle: "test", cursor: "cursor", limit: 10)
        
        //then
        XCTAssertEqual(output.fetchedCommentsCount , 1)
    }
    
    func testThatFetchedMoreCommens() {
        
        //given
        //default in MockCommentService fetching 1 item
        
        
        //when
        interactor.fetchMoreComments(topicHandle: "test", cursor: "cursor", limit: 10)
        
        //then
        XCTAssertEqual(output.fetchedMoreCommentsCount , 1)
    }
    
    func testThatCommentPosted() {
        
        //given
        let comment = "Test"
        
        //when
        interactor.postComment(photo: nil, topicHandle: "test", comment: comment)
        
        //then
        XCTAssertEqual(output.postedComment?.text, comment)
    }


    
}
