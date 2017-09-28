//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Nimble
import XCTest
@testable import EmbeddedSocial

class TopicsFeedResponseProcessorTests: XCTestCase {
    private var sut: TopicsFeedResponseProcessor!
    var cache: MockCache!
    var operationsBuilder: MockOutgoingCommandOperationsBuilder!
    var predicateBuilder: MockTopicServicePredicateBuilder!
    
    override func setUp() {
        super.setUp()
        cache = MockCache()
        operationsBuilder = MockOutgoingCommandOperationsBuilder()
        predicateBuilder = MockTopicServicePredicateBuilder()
        sut = TopicsFeedResponseProcessor(cache: cache, operationsBuilder: operationsBuilder, predicateBuilder: predicateBuilder)
    }
    
    override func tearDown() {
        super.tearDown()
        cache = nil
        operationsBuilder = nil
        predicateBuilder = nil
    }
    
    func testThatItProcessesFeedResponse() {
        // given
        let topicView1 = TopicView()
        topicView1.topicHandle = UUID().uuidString
        
        let topicView2 = TopicView()
        topicView2.topicHandle = UUID().uuidString
        
        let topicView3 = TopicView()
        topicView3.topicHandle = UUID().uuidString
        
        let response = FeedResponseTopicView()
        response.data = [topicView1, topicView2, topicView3]
        response.cursor = UUID().uuidString
        
        var result: Result<FeedFetchResult>?
        
        predicateBuilder.allTopicCommandsReturnValue = NSPredicate()
        
        let command = MockTopicCommand(topic: Post(topicHandle: topicView1.topicHandle!))
        
        let operation = MockFetchOutgoingCommandsOperation(cache: cache, predicate: NSPredicate())
        operation.setCommands([command])
        
        operationsBuilder.fetchCommandsOperationPredicateReturnValueMaker = { operation }
        
        // when
        sut.process(response, isFromCache: true) { result = $0 }
        
        // then
        expect(result).toEventuallyNot(beNil())
        expect(result?.value?.posts.count).toEventually(equal(response.data?.count))
        expect(result?.value?.cursor).toEventually(equal(response.cursor))

        let processesTopicIDs = result?.value?.posts.map { $0.topicHandle } ?? []
        let initialTopicIDs = response.data?.map { $0.topicHandle } ?? []
        expect(processesTopicIDs).toEventually(equal(initialTopicIDs))
        
        expect(operation.mainCalled).toEventually(beTrue())
        expect(command.applyToFeedCalled).toEventually(beTrue())
        
        expect(self.operationsBuilder.fetchCommandsOperationPredicateCalled).to(beTrue())
        expect(self.predicateBuilder.allTopicCommandsCalled).to(beTrue())
    }
    
    func testThatItIgnoresResultsFromAPI() {
        // given
        
        // when
        var result: Result<FeedFetchResult>?

        sut.process(FeedResponseTopicView(), isFromCache: false) { result = $0 }
        
        // then
        expect(result).toEventuallyNot(beNil())
        expect(result?.value?.cursor).toEventually(beNil())
        expect(result?.value?.posts).toEventually(beEmpty())
        
        expect(self.predicateBuilder.allTopicActionCommandsCalled).toEventually(beFalse())
        expect(self.operationsBuilder.fetchCommandsOperationPredicateCalled).toEventually(beFalse())
    }
    
    func testThatItAppliesLikesAndPinsToFeed() {
        // given
        let commands: [TopicCommand] = [
            PinTopicCommand(topic: Post(topicHandle: UUID().uuidString)),
            LikeTopicCommand(topic: Post(topicHandle: UUID().uuidString)),
            LikeTopicCommand(topic: Post(topicHandle: UUID().uuidString)),
            PinTopicCommand(topic: Post(topicHandle: UUID().uuidString))
        ]
        
        var topicIDsToBePinned: [String] = []
        for case let command as PinTopicCommand in commands {
            topicIDsToBePinned.append(command.topic.topicHandle)
        }
        
        var topicIDsToBeLiked: [String] = []
        for case let command as LikeTopicCommand in commands {
            topicIDsToBeLiked.append(command.topic.topicHandle)
        }
        
        let affectedTopics = commands.map { $0.topic }
        
        let notAffectedTopics = [Post(topicHandle: UUID().uuidString), Post(topicHandle: UUID().uuidString)]
        
        let feed = FeedFetchResult(posts: affectedTopics + notAffectedTopics, error: nil, cursor: nil)
        
        // when
        let processedFeed = sut.apply(commands: commands, to: feed)

        // then
        
        let processedIDs = processedFeed.posts.map { $0.topicHandle }
        let allInitialIDs = (affectedTopics + notAffectedTopics).map { $0.topicHandle }
        expect(processedIDs).to(equal(allInitialIDs))
        
        let topicsExpectedToBeLiked = processedFeed.posts.filter { topicIDsToBeLiked.contains($0.topicHandle) }
        for topic in topicsExpectedToBeLiked {
            expect(topic.liked).to(beTrue())
        }
        
        let topicsExpectedToBePinned = processedFeed.posts.filter { topicIDsToBePinned.contains($0.topicHandle) }
        for topic in topicsExpectedToBePinned {
            expect(topic.pinned).to(beTrue())
        }
        
        let topicsLeft = processedFeed.posts
            .filter { !topicIDsToBePinned.contains($0.topicHandle) && !topicIDsToBeLiked.contains($0.topicHandle) }
        
        for topic in topicsLeft {
            expect(topic.pinned).to(beFalse())
            expect(topic.liked).to(beFalse())
        }
    }
    
    func testThatItAddsCreatedTopicsToTheFeed() {
        // given
        let createdTopic = Post(topicHandle: UUID().uuidString)
        let commands = [CreateTopicCommand(topic: createdTopic)]
        let topics = [Post(topicHandle: UUID().uuidString), Post(topicHandle: UUID().uuidString)]
        let feed = FeedFetchResult(posts: topics, error: nil, cursor: nil)
        
        // when
        let processedFeed = sut.apply(commands: commands, to: feed)
        
        // then
        let processedIDs = processedFeed.posts.flatMap { $0.topicHandle }
        expect(processedIDs).to(contain(createdTopic.topicHandle))
        expect(processedIDs.count).to(equal(topics.count + 1))
    }
}
