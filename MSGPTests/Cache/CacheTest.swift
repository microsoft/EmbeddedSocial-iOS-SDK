//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import MSGP

class CacheTests: XCTestCase {
    
    private var coreDataStack: CoreDataStack!
    private var transactionsDatabase: MockTransactionsDatabaseFacade!
    private var cache: Cachable!
    
    override func setUp() {
        super.setUp()
        coreDataStack = CoreDataHelper.makeMSGPInMemoryStack()
        transactionsDatabase = MockTransactionsDatabaseFacade(incomingRepo:  CoreDataRepository(context: coreDataStack.backgroundContext), outgoingRepo:  CoreDataRepository(context: coreDataStack.backgroundContext))
        cache = Cache(database: transactionsDatabase)
    }
    
    override func tearDown() {
        super.tearDown()
        coreDataStack = nil
        transactionsDatabase = nil
        cache = nil
    }
    
    func testThatIncomingCacheReturnsCorrectModel() {
        let postRequest = PostTopicRequest()
        postRequest.title = "Title"
        postRequest.text = "Text"
        
        let cachedModel = cache.cacheIncoming(object: postRequest)
        let cachedTitle = cachedModel.payload?["title"] as! String
        let cachedText = cachedModel.payload?["text"] as! String
        
        XCTAssertEqual(cachedTitle, postRequest.title)
        XCTAssertEqual(cachedText, postRequest.text)
        XCTAssertEqual(cachedModel.typeid, String(describing: PostTopicRequest.self))
        XCTAssertEqual(transactionsDatabase.saveIncomingCalled, 1)
    }
    
    func testThatOutgoingCacheReturnsCorrectModel() {
        let postRequest = PostTopicRequest()
        postRequest.title = "Title"
        postRequest.text = "Text"
        
        let cachedModel = cache.cacheOutgoing(object: postRequest)
        let cachedTitle = cachedModel.payload?["title"] as! String
        let cachedText = cachedModel.payload?["text"] as! String
        
        XCTAssertEqual(cachedTitle, postRequest.title)
        XCTAssertEqual(cachedText, postRequest.text)
        XCTAssertEqual(cachedModel.typeid, String(describing: PostTopicRequest.self))
        XCTAssertEqual(transactionsDatabase.saveOutgoingCalled, 1)
    }
    
    func testThatIncomingDataFetchedCorrect() {
        let expectation = self.expectation(description: "test")
        let feedResponse = FeedResponseTopicView()
        let topicView = TopicView()
        
        topicView.text = "Text"
        topicView.title = "Title"
        feedResponse.cursor = "cursor"
        
        feedResponse.data = [topicView]
        
        cache.cacheIncoming(object: feedResponse)
        
        self.cache.fetchIncoming(type: FeedResponseTopicView.self, sortDescriptors: nil, result: { (results) in
            XCTAssertEqual((results.first as! FeedResponseTopicView).data?.first?.text, feedResponse.data?.first?.text)
            XCTAssertEqual((results.first as! FeedResponseTopicView).data?.first?.title, feedResponse.data?.first?.title)
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testThatOutgoingDataFetchedCorrect() {
        let expectation = self.expectation(description: "test")
        
        let topic = PostTopicRequest()
        topic.text = "Text"
        topic.title = "Title"
        
        cache.cacheOutgoing(object: topic)
        
        self.cache.fetchOutgoing(type: PostTopicRequest.self, sortDescriptors: nil, result: { (results) in
            XCTAssertEqual((results.first as! PostTopicRequest).text , topic.text)
            XCTAssertEqual((results.first as! PostTopicRequest).title , topic.title)
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
}
