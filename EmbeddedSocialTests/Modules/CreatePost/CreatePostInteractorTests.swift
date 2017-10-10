//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class CreatePostInteractorTests: XCTestCase {

    var intercator: CreatePostInteractor!
    let presenter = MockCreatePostPresenter()
    var coreDataStack: CoreDataStack!
    var transactionsDatabase: MockTransactionsDatabaseFacade!
    var cache: CacheType!
    fileprivate var topicService: PostServiceMock!
    var userHolder: UserHolder!
    
    override func setUp() {
        super.setUp()
        userHolder = MyProfileHolder()
        intercator = CreatePostInteractor(userHolder: userHolder)
        coreDataStack = CoreDataHelper.makeEmbeddedSocialInMemoryStack()
        transactionsDatabase = MockTransactionsDatabaseFacade(incomingRepo:  CoreDataRepository(context: coreDataStack.backgroundContext), outgoingRepo:  CoreDataRepository(context: coreDataStack.backgroundContext))
        cache = Cache(database: transactionsDatabase)
        topicService = PostServiceMock()
        intercator.topicService = topicService
        intercator.output = presenter
    }
    
    override func tearDown() {
        super.tearDown()
        userHolder = nil
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
        let photo = Photo(image: UIImage())
        topicService.postTopicReturnTopic = Post.mock()
        intercator.postTopic(photo: photo, title: "title", body: "body")
        
        //then
        XCTAssertEqual(topicService.postTopicCalledReceivedTopic.title, "title")
        XCTAssertEqual(topicService.postTopicCalledReceivedPhoto, photo)
        
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
