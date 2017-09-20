//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial


fileprivate class MockTopicService: TopicService {
    
    var fetchPostCount = 0
    override func fetchPost(post: PostHandle, completion: @escaping FetchResultHandler) {
        fetchPostCount += 1
        var post = Post()
        post.topicHandle = "fsdf"
        var result = FeedFetchResult()
        result.posts = [post]
        completion(result)
    }
    
    var postTopicCount = 0
    override func postTopic(topic: PostTopicRequest, photo: Photo?, success: @escaping TopicPosted, failure: @escaping Failure) {
        postTopicCount += 1
        success(Post())
    }
    
    var updateTopicCount = 0
    override func updateTopic(topicHandle: String, request: PutTopicRequest, success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        updateTopicCount += 1
        success()
    }
}

class CreatePostInteractorTests: XCTestCase {

    let intercator = CreatePostInteractor()
    let presenter = MockCreatePostPresenter()
    var coreDataStack: CoreDataStack!
    var transactionsDatabase: MockTransactionsDatabaseFacade!
    var cache: CacheType!
    fileprivate var topicService: MockTopicService!
    
    
    override func setUp() {
        super.setUp()
        coreDataStack = CoreDataHelper.makeEmbeddedSocialInMemoryStack()
        transactionsDatabase = MockTransactionsDatabaseFacade(incomingRepo:  CoreDataRepository(context: coreDataStack.backgroundContext), outgoingRepo:  CoreDataRepository(context: coreDataStack.backgroundContext))
        cache = Cache(database: transactionsDatabase)
        topicService = MockTopicService()
        intercator.topicService = topicService
        intercator.output = presenter
    }
    
    override func tearDown() {
        super.tearDown()
        transactionsDatabase = nil
        coreDataStack = nil
        cache = nil
        topicService = nil
    }
    
    func testThatPostUpdating() {
        
        //when
        intercator.updateTopic(topicHandle: "handle", title: "title", body: "body")
        
        //then
        XCTAssertEqual(topicService.updateTopicCount, 1)
        XCTAssertEqual(presenter.postUpdatedCount, 1)
        
    }
    
    func testThatTopicPosted() {
        //when
        intercator.postTopic(photo: nil, title: "title", body: "body")
        
        //then
        XCTAssertEqual(topicService.postTopicCount, 1)
        XCTAssertEqual(presenter.postCreatedCalledCount, 1)
    }
    
    
//    func testThatDataPosting() {
//        let title = "title"
//        let body = "body"
//        let photo = Photo(uid: "id", url: "url", image: UIImage())
//        
//        intercator.postTopic(photo: photo, title: title, body: body)
//        
//        XCTAssert(presenter.postCreationFailed == false)
//        XCTAssertEqual(presenter.postCreatedCalledCount, 1)
//    }
    
}
