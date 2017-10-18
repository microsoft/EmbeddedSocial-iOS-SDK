//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Nimble
import XCTest
@testable import EmbeddedSocial

class CacheCleanupStrategyImplTests: XCTestCase {
    
    private var coreDataStack: CoreDataStack!
    private var sut: CacheCleanupStrategyImpl!
    private var cache: Cache!

    override func setUp() {
        super.setUp()
        coreDataStack = CoreDataHelper.makeEmbeddedSocialInMemoryStack()
        
        let db = TransactionsDatabaseFacade(incomingRepo: CoreDataRepository(context: coreDataStack.mainContext),
                                            outgoingRepo: CoreDataRepository(context: coreDataStack.mainContext))
        cache = Cache(database: db)
        sut = CacheCleanupStrategyImpl(cache: cache)
        
        Decoders.setupDecoders()
    }
    
    override func tearDown() {
        super.tearDown()
        coreDataStack.reset { [weak self] _ in
            self?.coreDataStack = nil
        }
        sut = nil
        cache = nil
    }
    
    func testCleanupTopicWithCommentAndReply() {
        let topic = Post(topicHandle: UUID().uuidString)
        
        let comment = Comment(commentHandle: UUID().uuidString)
        comment.topicHandle = topic.topicHandle
        
        let reply = Reply(replyHandle: UUID().uuidString)
        reply.commentHandle = comment.commentHandle
        
        let createComment = CreateCommentCommand(comment: comment)
        let createReply = CreateReplyCommand(reply: reply)
        let createTopic = CreateTopicCommand(topic: topic)
        
        cache(commands: [createComment, createReply, createTopic])
        
        expect(self.cachedOutgoingCommands().count).to(equal(3))

        sut.cleanupRelatedCommands(createTopic)
        
        expect(self.cachedOutgoingCommands()).to(beEmpty())
    }
    
    func testCleanupTopic() {
        let topic = Post(topicHandle: UUID().uuidString)
        
        let comment = Comment(commentHandle: UUID().uuidString)
        comment.topicHandle = topic.topicHandle

        cache(commands: [
            CreateTopicCommand(topic: topic),
            PinTopicCommand(topic: topic),
            LikeTopicCommand(topic: topic),
            UnpinTopicCommand(topic: topic),
            UnlikeTopicCommand(topic: topic),
            CreateCommentCommand(comment: comment),
            CreateTopicImageCommand(photo: Photo(), relatedHandle: topic.topicHandle),
            ]
        )
        
        expect(self.cachedOutgoingCommands().count).to(equal(7))
        
        sut.cleanupRelatedCommands(TopicCommand(topic: topic))
        
        expect(self.cachedOutgoingCommands()).to(beEmpty())
    }
    
    func testThatItDoesNotCleanupCommandsForUnrelatedTopic() {
        let topic = Post(topicHandle: UUID().uuidString)
        
        cache(commands: [
            CreateTopicCommand(topic: topic),
            PinTopicCommand(topic: Post(topicHandle: UUID().uuidString)),
            LikeTopicCommand(topic: topic),
            UnpinTopicCommand(topic: Post(topicHandle: UUID().uuidString)),
            UnlikeTopicCommand(topic: topic)
            ]
        )
        
        expect(self.cachedOutgoingCommands().count).to(equal(5))
        
        sut.cleanupRelatedCommands(TopicCommand(topic: topic))
        
        expect(self.cachedOutgoingCommands().count).to(equal(2))
    }
    
    func testCleanupComment() {
        let comment = Comment(commentHandle: UUID().uuidString)
        
        let reply = Reply(replyHandle: UUID().uuidString)
        reply.commentHandle = comment.commentHandle
        
        cache(commands: [
            LikeCommentCommand(comment: comment),
            UnlikeCommentCommand(comment: comment),
            CreateCommentImageCommand(photo: Photo(), relatedHandle: comment.commentHandle),
            CreateReplyCommand(reply: reply),
            ReportCommentCommand(comment: comment, reportReason: ._none)
            ]
        )
        
        expect(self.cachedOutgoingCommands().count).to(equal(5))
        
        sut.cleanupRelatedCommands(CommentCommand(comment: comment))
        
        expect(self.cachedOutgoingCommands()).to(beEmpty())
    }
    
    func testThatItDoesNotCleanupCommandsForUnrelatedComments() {
        let comment = Comment(commentHandle: UUID().uuidString)
        
        cache(commands: [
            LikeCommentCommand(comment: comment),
            UnlikeCommentCommand(comment: Comment(commentHandle: UUID().uuidString)),
            ReportCommentCommand(comment: Comment(commentHandle: UUID().uuidString), reportReason: ._none)
            ]
        )
        
        expect(self.cachedOutgoingCommands().count).to(equal(3))
        
        sut.cleanupRelatedCommands(CommentCommand(comment: comment))
        
        expect(self.cachedOutgoingCommands().count).to(equal(2))
    }
    
    func testCleanupReply() {
        let reply = Reply(replyHandle: UUID().uuidString)
        
        cache(commands: [
            LikeReplyCommand(reply: reply),
            UnlikeReplyCommand(reply: reply),
            ReportReplyCommand(reply: reply, reportReason: ._none)
            ]
        )
        
        expect(self.cachedOutgoingCommands().count).to(equal(3))
        
        sut.cleanupRelatedCommands(ReplyCommand(reply: reply))
        
        expect(self.cachedOutgoingCommands()).to(beEmpty())
    }
    
    func testThatItDoesNotCleanupCommandsForUnrelatedReplies() {
        let reply = Reply(replyHandle: UUID().uuidString)
        
        cache(commands: [
            LikeReplyCommand(reply: reply),
            UnlikeReplyCommand(reply: Reply(replyHandle: UUID().uuidString)),
            ReportReplyCommand(reply: reply, reportReason: ._none)
            ]
        )
        
        expect(self.cachedOutgoingCommands().count).to(equal(3))
        
        sut.cleanupRelatedCommands(ReplyCommand(reply: reply))
        
        expect(self.cachedOutgoingCommands().count).to(equal(1))
    }
    
    private func cache(commands: [OutgoingCommand]) {
        for command in commands {
            cache.cacheOutgoing(command)
        }
    }
    
    private func cachedOutgoingCommands() -> [OutgoingCommand] {
        let request = CacheFetchRequest(resultType: OutgoingCommand.self)
        return cache.fetchOutgoing(with: request)
    }
}
