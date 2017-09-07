//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

private class MockLikeSerivce: LikesServiceProtocol {
    func likeComment(commentHandle: String, completion: @escaping LikesServiceProtocol.CommentCompletionHandler) {
        completion("commentHandle", nil)
    }
    
    func unlikeComment(commentHandle: String, completion: @escaping LikesServiceProtocol.CompletionHandler) {
        completion("commentHandle", nil)
    }
    
    func deleteLike(postHandle: PostHandle, completion: @escaping LikesServiceProtocol.CompletionHandler) {
        
    }
    
    func postLike(postHandle: PostHandle, completion: @escaping LikesServiceProtocol.CompletionHandler) {
        
    }
    
    func likeReply(replyHandle: String, completion: @escaping LikesServiceProtocol.ReplyLikeCompletionHandler) {
        
    }
    
    func unlikeReply(replyHandle: String, completion: @escaping LikesServiceProtocol.ReplyLikeCompletionHandler) {
        
    }
    
    func postPin(postHandle: PostHandle, completion: @escaping CompletionHandler) { }
    func deletePin(postHandle: PostHandle, completion: @escaping CompletionHandler) { }
}

private class MockTopicService: PostServiceProtocol {
    func fetchPost(post: PostHandle, completion: @escaping FetchResultHandler) {
        var result = FeedFetchResult()
        result.posts = [Post()]
        completion(result)
    }
    
    func fetchMyPins(query: FeedQuery, completion: @escaping FetchResultHandler) {
        
    }
}

extension MockTopicService {
    
    func fetchHome(query: FeedQuery, completion: @escaping FetchResultHandler) {}
    func fetchPopular(query: PopularFeedQuery, completion: @escaping FetchResultHandler) {}
    func fetchRecent(query: FeedQuery, completion: @escaping FetchResultHandler) {}
    func fetchUserRecent(query: UserFeedQuery, completion: @escaping FetchResultHandler) {}
    func fetchUserPopular(query: UserFeedQuery, completion: @escaping FetchResultHandler) {}
    func fetchMyPosts(query: FeedQuery, completion: @escaping FetchResultHandler) {}
    func fetchMyPopular(query: FeedQuery, completion: @escaping FetchResultHandler) {}
    func deletePost(post: PostHandle, completion: @escaping ((Result<Void>) -> Void)) {}

}

class PostDetailsInteractorTests: XCTestCase {
    
    private let timeout: TimeInterval = 5
    var output: MockPostDetailPresenter!
    var interactor = PostDetailInteractor()
    
    var coreDataStack: CoreDataStack!
    var transactionsDatabase: MockTransactionsDatabaseFacade!
    var cache: CacheType!
    
    var commentsService: CommentServiceProtocol?
    var likeService: LikesServiceProtocol?
    var topicServer: PostServiceProtocol?
    var imageService: ImagesServiceType?
    var myProfileHolder: MyProfileHolder!
    
    override func setUp() {
        super.setUp()
        myProfileHolder = MyProfileHolder()
        output = MockPostDetailPresenter(myProfileHolder: myProfileHolder)
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
        myProfileHolder = nil
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
