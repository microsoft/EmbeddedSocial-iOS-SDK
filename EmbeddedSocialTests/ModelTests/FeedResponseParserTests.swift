//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class FeedResponseParserTests: XCTestCase {
    
    var sut: FeedResponseParser!
    var postProcessor: MockFeedResponsePostProcessor!
    
    override func setUp() {
        super.setUp()
        postProcessor = MockFeedResponsePostProcessor()
        sut = FeedResponseParser(processor: postProcessor)
    }
    
    override func tearDown() {
        super.tearDown()
        postProcessor = nil
        sut = nil
    }
    
    func testThatItProcessesResponse() {
        // given
        let response = makeFeedResponseTopicView()
        var result = FeedFetchResult()
        
        // when
        sut.parse(response, isCached: true, into: &result)
        
        // then
        validateResponseParsed(response, into: result)
        
        XCTAssertTrue(postProcessor.processCalled)
        XCTAssertEqual(postProcessor.processReceivedFeed?.posts ?? [], result.posts)
        XCTAssertEqual(postProcessor.processReceivedFeed?.cursor, result.cursor)
    }
    
    func testThatItDoesNotPostProcessResponseIfItsNotCached() {
        // given
        let response = makeFeedResponseTopicView()
        var result = FeedFetchResult()
        
        // when
        sut.parse(response, isCached: false, into: &result)
        
        // then
        validateResponseParsed(response, into: result)
        
        XCTAssertFalse(postProcessor.processCalled)
    }
    
    private func validateResponseParsed(_ response: FeedResponseTopicView, into result: FeedFetchResult) {
        XCTAssertEqual(result.posts.count, response.data?.count ?? 0)
        XCTAssertEqual(result.cursor, response.cursor)
        
        for (index, post) in result.posts.enumerated() {
            XCTAssertEqual(post.topicHandle, response.data?[index].topicHandle)
        }
    }
    
    private func makeFeedResponseTopicView() -> FeedResponseTopicView {
        let topicView1 = makeTopicView(topicHandle: UUID().uuidString)
        let topicView2 = makeTopicView(topicHandle: UUID().uuidString)
        let topicView3 = makeTopicView(topicHandle: UUID().uuidString)
        
        let response = FeedResponseTopicView()
        response.cursor = UUID().uuidString
        response.data = [topicView1, topicView2, topicView3]
        
        return response
    }
    
    private func makeTopicView(topicHandle: String) -> TopicView {
        let topicView = TopicView()
        topicView.topicHandle = topicHandle
        return topicView
    }
}
