//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

class MockOutgoingCommandsPredicateBuilder: OutgoingCommandsPredicateBuilder {
    
    //MARK: - allImageCommands
    
    var allImageCommandsCalled = false
    var allImageCommandsReturnValue: NSPredicate!
    
    func allImageCommands() -> NSPredicate {
        allImageCommandsCalled = true
        return allImageCommandsReturnValue
    }
    
    //MARK: - createTopicCommands
    
    var createTopicCommandsCalled = false
    var createTopicCommandsReturnValue: NSPredicate!
    
    func createTopicCommands() -> NSPredicate {
        createTopicCommandsCalled = true
        return createTopicCommandsReturnValue
    }
    
    //MARK: - createTopicCommand
    
    var createTopicCommandTopicHandleCalled = false
    var createTopicCommandTopicHandleReceivedTopicHandle: String?
    var createTopicCommandTopicHandleReturnValue: NSPredicate!
    
    func createTopicCommand(topicHandle: String) -> NSPredicate {
        createTopicCommandTopicHandleCalled = true
        createTopicCommandTopicHandleReceivedTopicHandle = topicHandle
        return createTopicCommandTopicHandleReturnValue
    }
    
    //MARK: - createCommentCommand
    
    var createCommentCommandCommentHandleCalled = false
    var createCommentCommandCommentHandleReceivedCommentHandle: String?
    var createCommentCommandCommentHandleReturnValue: NSPredicate!
    
    func createCommentCommand(commentHandle: String) -> NSPredicate {
        createCommentCommandCommentHandleCalled = true
        createCommentCommandCommentHandleReceivedCommentHandle = commentHandle
        return createCommentCommandCommentHandleReturnValue
    }
    
    //MARK: - commandsWithRelatedHandle
    
    var commandsWithRelatedHandleIgnoredTypeIDCalled = false
    var commandsWithRelatedHandleIgnoredTypeIDReceivedArguments: (relatedHandle: String, ignoredTypeID: String)?
    var commandsWithRelatedHandleIgnoredTypeIDReturnValue: NSPredicate!
    
    func commandsWithRelatedHandle(_ relatedHandle: String, ignoredTypeID: String) -> NSPredicate {
        commandsWithRelatedHandleIgnoredTypeIDCalled = true
        commandsWithRelatedHandleIgnoredTypeIDReceivedArguments = (relatedHandle: relatedHandle, ignoredTypeID: ignoredTypeID)
        return commandsWithRelatedHandleIgnoredTypeIDReturnValue
    }
    
    //MARK: - createCommentCommands
    
    var createCommentCommandsCalled = false
    var createCommentCommandsReturnValue: NSPredicate!
    
    func createCommentCommands() -> NSPredicate {
        createCommentCommandsCalled = true
        return createCommentCommandsReturnValue
    }
    
    //MARK: - allTopicActionCommands
    
    var allTopicActionCommandsCalled = false
    var allTopicActionCommandsReturnValue: NSPredicate!
    
    func allTopicActionCommands() -> NSPredicate {
        allTopicActionCommandsCalled = true
        return allTopicActionCommandsReturnValue
    }
    
    //MARK: - replyActionCommands
    
    var replyActionCommandsCalled = false
    var replyActionCommandsReturnValue: NSPredicate!
    
    func replyActionCommands() -> NSPredicate {
        replyActionCommandsCalled = true
        return replyActionCommandsReturnValue
    }
    
    //MARK: - createReplyCommands
    
    var createReplyCommandsCalled = false
    var createReplyCommandsReturnValue: NSPredicate!
    
    func createReplyCommands() -> NSPredicate {
        createReplyCommandsCalled = true
        return createReplyCommandsReturnValue
    }
    
    //MARK: - predicate
    
    var predicateForCalled = false
    var predicateForCalledInputCommand: OutgoingCommand?
    var predicateForReturnValue: NSPredicate!
    
    func predicate(for command: OutgoingCommand) -> NSPredicate {
        predicateForCalled = true
        predicateForCalledInputCommand = command
        return predicateForReturnValue
    }
    
    //MARK: - allUserCommands
    
    var allUserCommandsCalled = false
    var allUserCommandsReturnValue: NSPredicate!
    
    func allUserCommands() -> NSPredicate {
        allUserCommandsCalled = true
        return allUserCommandsReturnValue
    }
}
