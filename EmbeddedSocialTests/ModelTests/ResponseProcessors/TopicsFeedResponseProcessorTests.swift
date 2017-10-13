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
        let response: FeedResponseTopicView = loadResponse(from: "topics&limit20")!
   
        var result: Result<FeedFetchResult>?
        
        predicateBuilder.topicActionCommandsAndAllCreatedCommentsReturnValue = NSPredicate()
        
        let postView = response.data!.first!
        let post = Post(data: postView)!
        let command = MockTopicCommand(topic: post)
        
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
        expect(self.predicateBuilder.topicActionCommandsAndAllCreatedCommentsCalled).to(beTrue())
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
            PinTopicCommand(topic: Post.mock(seed: 0)),
            LikeTopicCommand(topic: Post.mock(seed: 1)),
            LikeTopicCommand(topic: Post.mock(seed: 2)),
            PinTopicCommand(topic: Post.mock(seed: 3))
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
        
        let notAffectedTopics = [Post.mock(seed: 4), Post.mock(seed: 5)]
        
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
        let createdTopic = Post.mock(seed: 0)
        let commands = [CreateTopicCommand(topic: createdTopic)]
        let topics = [Post.mock(seed: 0), Post.mock(seed: 0)]
        let feed = FeedFetchResult(posts: topics, error: nil, cursor: nil)
        
        // when
        let processedFeed = sut.apply(commands: commands, to: feed)
        
        // then
        let processedIDs = processedFeed.posts.flatMap { $0.topicHandle }
        expect(processedIDs).to(contain(createdTopic.topicHandle))
        expect(processedIDs.count).to(equal(topics.count + 1))
    }
}
