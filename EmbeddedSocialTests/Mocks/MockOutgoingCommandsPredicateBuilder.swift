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
    
    //MARK: - predicate
    
    var predicateRelatedHandleCalled = false
    var predicateRelatedHandleReceivedRelatedHandle: String?
    var predicateRelatedHandleReturnValue: NSPredicate!
    
    func predicate(relatedHandle: String) -> NSPredicate {
        predicateRelatedHandleCalled = true
        predicateRelatedHandleReceivedRelatedHandle = relatedHandle
        return predicateRelatedHandleReturnValue
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
    
    //MARK: - createDeleteReplyCommands
    
    var createDeleteReplyCommandsCalled = false
    var createDeleteReplyCommandsReturnValue: NSPredicate!
    
    func createDeleteReplyCommands() -> NSPredicate {
        createDeleteReplyCommandsCalled = true
        return createDeleteReplyCommandsReturnValue
    }
    
    //MARK: - predicate
    
    var predicateForCalled = false
    var predicateForReceivedCommand: OutgoingCommand?
    var predicateForReturnValue: NSPredicate!
    
    func predicate(for command: OutgoingCommand) -> NSPredicate {
        predicateForCalled = true
        predicateForReceivedCommand = command
        return predicateForReturnValue
    }
    
    //MARK: - allUserCommands
    
    var allUserCommandsCalled = false
    var allUserCommandsReturnValue: NSPredicate!
    
    func allUserCommands() -> NSPredicate {
        allUserCommandsCalled = true
        return allUserCommandsReturnValue
    }
    
    //MARK: - predicate
    
    var predicateTypeIDRelatedHandleCalled = false
    var predicateTypeIDRelatedHandleReceivedArguments: (typeID: String, relatedHandle: String)?
    var predicateTypeIDRelatedHandleReturnValue: NSPredicate!
    
    func predicate(typeID: String, relatedHandle: String) -> NSPredicate {
        predicateTypeIDRelatedHandleCalled = true
        predicateTypeIDRelatedHandleReceivedArguments = (typeID: typeID, relatedHandle: relatedHandle)
        return predicateTypeIDRelatedHandleReturnValue
    }
    
    //MARK: - replyActionCommands
    
    var replyActionCommandsForCalled = false
    var replyActionCommandsForReceivedReplyHandle: String?
    var replyActionCommandsForReturnValue: NSPredicate!
    
    func replyActionCommands(for replyHandle: String) -> NSPredicate {
        replyActionCommandsForCalled = true
        replyActionCommandsForReceivedReplyHandle = replyHandle
        return replyActionCommandsForReturnValue
    }
    
    //MARK: - createTopicCommands
    
    var createTopicCommandsCalled = false
    var createTopicCommandsReturnValue: NSPredicate!
    
    func createTopicCommands() -> NSPredicate {
        createTopicCommandsCalled = true
        return createTopicCommandsReturnValue
    }
    
    //MARK: - removeTopicCommands
    
    var removeTopicCommandsCalled = false
    var removeTopicCommandsReturnValue: NSPredicate!
    
    func removeTopicCommands() -> NSPredicate {
        removeTopicCommandsCalled = true
        return removeTopicCommandsReturnValue
    }
    
    //MARK: - createDeleteCommentCommands
    
    var createDeleteCommentCommandsCalled = false
    var createDeleteCommentCommandsReturnValue: NSPredicate!
    
    func createDeleteCommentCommands() -> NSPredicate {
        createDeleteCommentCommandsCalled = true
        return createDeleteCommentCommandsReturnValue
    }
    
}
