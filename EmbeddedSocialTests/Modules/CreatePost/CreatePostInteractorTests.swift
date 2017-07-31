//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class CreatePostInteractorTests: XCTestCase {
    
    let intercator = CreatePostInteractor()
    let presenter = MockCreatePostPresenter()
    var coreDataStack: CoreDataStack!
    var transactionsDatabase: MockTransactionsDatabaseFacade!
    var cache: Cachable!
    var topicService: TopicService!
    
    
    override func setUp() {
        super.setUp()
        coreDataStack = CoreDataHelper.makeEmbeddedSocialInMemoryStack()
        transactionsDatabase = MockTransactionsDatabaseFacade(incomingRepo:  CoreDataRepository(context: coreDataStack.backgroundContext), outgoingRepo:  CoreDataRepository(context: coreDataStack.backgroundContext))
        cache = Cache(database: transactionsDatabase)
        topicService = TopicService(cache: cache)
        
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
