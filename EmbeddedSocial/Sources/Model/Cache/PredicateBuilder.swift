//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol CachePredicateBuilder {
    func predicate(handle: String) -> NSPredicate
    func predicate(typeID: String, handle: String) -> NSPredicate
    func predicate(typeID: String) -> NSPredicate
}

protocol OutgoingCommandsPredicateBuilder {
    func allImageCommands() -> NSPredicate
    
    func createTopicCommands() -> NSPredicate
    
    func createTopicCommand(topicHandle: String) -> NSPredicate
    
    func createCommentCommand(commentHandle: String) -> NSPredicate
    
    func commandsWithRelatedHandle(_ relatedHandle: String, ignoredTypeID: String) -> NSPredicate
    
    static func createDeleteCommentCommands() -> NSPredicate
    
    func allTopicActionCommands() -> NSPredicate
    
    func replyActionCommands() -> NSPredicate
    
    func createDeleteReplyCommands() -> NSPredicate
    
    func predicate(for command: OutgoingCommand) -> NSPredicate
}

struct PredicateBuilder: CachePredicateBuilder {
    
    func predicate(typeID: String) -> NSPredicate {
        return NSPredicate(format: "typeid = %@", typeID)
    }
    
    func allOutgoingCommandsPredicate() -> NSPredicate {
        let typeIDs = OutgoingCommand.allCommandTypes.map { $0.typeIdentifier }
        return NSPredicate(format: "typeid IN %@", typeIDs)
    }
    
    func allUserCommands() -> NSPredicate {
        let userCommands: [UserCommand.Type] = [
            FollowCommand.self,
            UnfollowCommand.self,
            BlockCommand.self,
            UnblockCommand.self,
            CancelPendingCommand.self
        ]
        let typeIDs = userCommands.map { $0.typeIdentifier }
        return NSPredicate(format: "typeid IN %@", typeIDs)
    }
    
    func replyActionCommands(for replyHandle: String) -> NSPredicate {
        let replyCommands: [ReplyCommand.Type] = [
            UnlikeReplyCommand.self,
            LikeReplyCommand.self
        ]
        let typeIDs = replyCommands.map { $0.typeIdentifier }
        return NSPredicate(format: "typeid IN %@ AND handle = %@", typeIDs, replyHandle)
    }
    
    func commentActionCommands(for commentHandle: String) -> NSPredicate {
        let commentCommands: [CommentCommand.Type] = [
            UnlikeCommentCommand.self,
            LikeCommentCommand.self
        ]
        let typeIDs = commentCommands.map { $0.typeIdentifier }
        return NSPredicate(format: "typeid IN %@ AND handle = %@", typeIDs, commentHandle)
    }
    
    func allCreateCommentCommands() -> NSPredicate {
        return predicate(typeID: CreateCommentCommand.typeIdentifier)
    }
    
    func allCreateReplyCommands() -> NSPredicate {
        return predicate(typeID: CreateReplyCommand.typeIdentifier)
    }
    
    func allCreateTopicCommands() -> NSPredicate {
        return predicate(typeID: CreateTopicCommand.typeIdentifier)
    }
    
    func createReplyCommand(replyHandle: String) -> NSPredicate {
        return NSPredicate(format: "typeid = %@ AND handle = %@", CreateReplyCommand.typeIdentifier, replyHandle)
    }
    
    func userCommandsPredicate() -> NSPredicate {
        return predicate(typeID: OutgoingCommand.typeIdentifier)
    }
    
    func predicate(typeID: String, handle: String) -> NSPredicate {
        return NSPredicate(format: "typeid = %@ AND handle = %@", typeID, handle)
    }
    
    func predicate(for command: OutgoingCommand) -> NSPredicate {
        if let handle = command.getHandle() {
            return predicate(typeID: command.typeIdentifier, handle: handle)
        } else {
            return predicate(typeID: command.typeIdentifier)
        }
    }
    
    func predicate(handle: String) -> NSPredicate {
        return NSPredicate(format: "handle = %@", handle)
    }
    
    func predicate(typeID: String, handle: String, relatedHandle: String) -> NSPredicate {
        return NSPredicate(format: "typeid = %@ AND handle = %@ AND relatedHandle = %@", typeID, handle, relatedHandle)
    }
    
    func predicate(typeID: String, relatedHandle: String) -> NSPredicate {
        return NSPredicate(format: "typeid = %@ AND relatedHandle = %@", typeID, relatedHandle)
    }
}

extension PredicateBuilder: OutgoingCommandsPredicateBuilder {
    
    func allImageCommands() -> NSPredicate {
        let commands: [ImageCommand.Type] = [
            CreateTopicImageCommand.self,
            CreateCommentImageCommand.self,
            UpdateUserImageCommand.self
        ]
        let typeIDs = commands.map { $0.typeIdentifier }
        return NSPredicate(format: "typeid IN %@", typeIDs)
    }
    
    func allTopicActionCommands() -> NSPredicate {
        let topicCommands: [TopicCommand.Type] = [
            UnlikeTopicCommand.self,
            LikeTopicCommand.self,
            PinTopicCommand.self,
            UnpinTopicCommand.self
        ]
        let typeIDs = topicCommands.map { $0.typeIdentifier }
        return NSPredicate(format: "typeid IN %@", typeIDs)
    }
    
    func commentActionCommands() -> NSPredicate {
        let commands: [CommentCommand.Type] = [
            UnlikeCommentCommand.self,
            LikeCommentCommand.self,
            ReportCommentCommand.self
        ]
        let typeIDs = commands.map { $0.typeIdentifier }
        return NSPredicate(format: "typeid IN %@", typeIDs)
    }
    
    func replyActionCommands() -> NSPredicate {
        let replyCommands: [ReplyCommand.Type] = [
            UnlikeReplyCommand.self,
            LikeReplyCommand.self
        ]
        let typeIDs = replyCommands.map { $0.typeIdentifier }
        return NSPredicate(format: "typeid IN %@", typeIDs)
    }
    
    func createTopicCommand(topicHandle: String) -> NSPredicate {
        return NSPredicate(format: "typeid = %@ AND handle = %@", CreateTopicCommand.typeIdentifier, topicHandle)
    }
    
    func createCommentCommand(commentHandle: String) -> NSPredicate {
        return NSPredicate(format: "typeid = %@ AND handle = %@", CreateCommentCommand.typeIdentifier, commentHandle)
    }
    
    func commandsWithRelatedHandle(_ relatedHandle: String, ignoredTypeID: String) -> NSPredicate {
        return NSPredicate(format: "relatedHandle = %@ AND typeid != %@", relatedHandle, ignoredTypeID)
    }
    
    func createTopicCommands() -> NSPredicate {
        return NSPredicate(format: "typeid = %@", CreateTopicCommand.typeIdentifier)
    }
    
    static func createDeleteCommentCommands() -> NSPredicate {
        let commands: [CommentCommand.Type] = [
            CreateCommentCommand.self,
            RemoveCommentCommand.self
        ]
        let typeIDs = commands.map { $0.typeIdentifier }
        return NSPredicate(format: "typeid IN %@", typeIDs)
    }
    
    func createDeleteReplyCommands() -> NSPredicate {
        let commands: [ReplyCommand.Type] = [
            CreateReplyCommand.self,
            RemoveReplyCommand.self
        ]
        let typeIDs = commands.map { $0.typeIdentifier }
        return NSPredicate(format: "typeid IN %@", typeIDs)
    }
}
