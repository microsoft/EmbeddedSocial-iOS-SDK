//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

class MockOutgoingCommandsPredicateBuilder: OutgoingCommandsPredicateBuilder {
    
    //MARK: - allImageCommands
    
    static var allImageCommandsCalled = false
    static var allImageCommandsReturnValue: NSPredicate!
    
    static func allImageCommands() -> NSPredicate {
        allImageCommandsCalled = true
        return allImageCommandsReturnValue
    }
    
    //MARK: - createTopicCommands
    
    static var createTopicCommandsCalled = false
    static var createTopicCommandsReturnValue: NSPredicate!
    
    static func createTopicCommands() -> NSPredicate {
        createTopicCommandsCalled = true
        return createTopicCommandsReturnValue
    }
    
    //MARK: - createTopicCommand
    
    static var createTopicCommandTopicHandleCalled = false
    static var createTopicCommandTopicHandleReceivedTopicHandle: String?
    static var createTopicCommandTopicHandleReturnValue: NSPredicate!
    
    static func createTopicCommand(topicHandle: String) -> NSPredicate {
        createTopicCommandTopicHandleCalled = true
        createTopicCommandTopicHandleReceivedTopicHandle = topicHandle
        return createTopicCommandTopicHandleReturnValue
    }
    
    //MARK: - createCommentCommand
    
    static var createCommentCommandCommentHandleCalled = false
    static var createCommentCommandCommentHandleReceivedCommentHandle: String?
    static var createCommentCommandCommentHandleReturnValue: NSPredicate!
    
    static func createCommentCommand(commentHandle: String) -> NSPredicate {
        createCommentCommandCommentHandleCalled = true
        createCommentCommandCommentHandleReceivedCommentHandle = commentHandle
        return createCommentCommandCommentHandleReturnValue
    }
    
    //MARK: - commandsWithRelatedHandle
    
    static var commandsWithRelatedHandleIgnoredTypeIDCalled = false
    static var commandsWithRelatedHandleIgnoredTypeIDReceivedArguments: (relatedHandle: String, ignoredTypeID: String)?
    static var commandsWithRelatedHandleIgnoredTypeIDReturnValue: NSPredicate!
    
    static func commandsWithRelatedHandle(_ relatedHandle: String, ignoredTypeID: String) -> NSPredicate {
        commandsWithRelatedHandleIgnoredTypeIDCalled = true
        commandsWithRelatedHandleIgnoredTypeIDReceivedArguments = (relatedHandle: relatedHandle, ignoredTypeID: ignoredTypeID)
        return commandsWithRelatedHandleIgnoredTypeIDReturnValue
    }
    
    //MARK: - createCommentCommands
    
    static var createCommentCommandsCalled = false
    static var createCommentCommandsReturnValue: NSPredicate!
    
    static func createCommentCommands() -> NSPredicate {
        createCommentCommandsCalled = true
        return createCommentCommandsReturnValue
    }
    
    //MARK: - allTopicActionCommands
    
    static var allTopicActionCommandsCalled = false
    static var allTopicActionCommandsReturnValue: NSPredicate!
    
    static func allTopicActionCommands() -> NSPredicate {
        allTopicActionCommandsCalled = true
        return allTopicActionCommandsReturnValue
    }
    
    //MARK: - replyActionCommands
    
    static var replyActionCommandsCalled = false
    static var replyActionCommandsReturnValue: NSPredicate!
    
    static func replyActionCommands() -> NSPredicate {
        replyActionCommandsCalled = true
        return replyActionCommandsReturnValue
    }
    
    //MARK: - createReplyCommands
    
    static var createReplyCommandsCalled = false
    static var createReplyCommandsReturnValue: NSPredicate!
    
    static func createReplyCommands() -> NSPredicate {
        createReplyCommandsCalled = true
        return createReplyCommandsReturnValue
    }
    
}
