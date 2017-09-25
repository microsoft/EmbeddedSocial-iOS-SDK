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
    static func allImageCommands() -> NSPredicate
    
    static func createTopicCommands() -> NSPredicate
    
    static func createTopicCommand(topicHandle: String) -> NSPredicate
    
    static func createCommentCommand(commentHandle: String) -> NSPredicate
    
    static func commandsWithRelatedHandle(_ relatedHandle: String, ignoredTypeID: String) -> NSPredicate
    
    static func createCommentCommands() -> NSPredicate
    
    static func allTopicActionCommands() -> NSPredicate
    
    static func replyActionCommands() -> NSPredicate
    
    static func createReplyCommands() -> NSPredicate
}

protocol TopicServicePredicateBuilder {
    
}

struct PredicateBuilder: CachePredicateBuilder {
    
    static func predicate(typeID: String) -> NSPredicate {
        return NSPredicate(format: "typeid = %@", typeID)
    }
    
    static func allOutgoingCommandsPredicate() -> NSPredicate {
        let typeIDs = OutgoingCommand.allCommandTypes.map { $0.typeIdentifier }
        return NSPredicate(format: "typeid IN %@", typeIDs)
    }
    
    static func allUserCommands() -> NSPredicate {
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
    
    static func replyActionCommands(for replyHandle: String) -> NSPredicate {
        let replyCommands: [ReplyCommand.Type] = [
            UnlikeReplyCommand.self,
            LikeReplyCommand.self
        ]
        let typeIDs = replyCommands.map { $0.typeIdentifier }
        return NSPredicate(format: "typeid IN %@ AND handle = %@", typeIDs, replyHandle)
    }
    
    static func commentActionCommands(for commentHandle: String) -> NSPredicate {
        let commentCommands: [CommentCommand.Type] = [
            UnlikeCommentCommand.self,
            LikeCommentCommand.self
        ]
        let typeIDs = commentCommands.map { $0.typeIdentifier }
        return NSPredicate(format: "typeid IN %@ AND handle = %@", typeIDs, commentHandle)
    }
    
    static func allCreateCommentCommands() -> NSPredicate {
        return predicate(typeID: CreateCommentCommand.typeIdentifier)
    }
    
    static func allCreateReplyCommands() -> NSPredicate {
        return predicate(typeID: CreateReplyCommand.typeIdentifier)
    }
    
    static func allCreateTopicCommands() -> NSPredicate {
        return predicate(typeID: CreateTopicCommand.typeIdentifier)
    }
    
    static func createReplyCommand(replyHandle: String) -> NSPredicate {
        return NSPredicate(format: "typeid = %@ AND handle = %@", CreateReplyCommand.typeIdentifier, replyHandle)
    }
    
    static func userCommandsPredicate() -> NSPredicate {
        return predicate(typeID: OutgoingCommand.typeIdentifier)
    }
    
    static func predicate(typeID: String, handle: String) -> NSPredicate {
        return NSPredicate(format: "typeid = %@ AND handle = %@", typeID, handle)
    }
    
    static func predicate(for command: OutgoingCommand) -> NSPredicate {
        if let handle = command.getHandle() {
            return predicate(typeID: command.typeIdentifier, handle: handle)
        } else {
            return predicate(typeID: command.typeIdentifier)
        }
    }
    
    func predicate(handle: String) -> NSPredicate {
        return NSPredicate(format: "handle = %@", handle)
    }
    
    func predicate(typeID: String) -> NSPredicate {
        return PredicateBuilder.predicate(typeID: typeID)
    }
    
    func predicate(typeID: String, handle: String) -> NSPredicate {
        return PredicateBuilder.predicate(typeID: typeID, handle: handle)
    }
    
    func predicate(typeID: String, handle: String, relatedHandle: String) -> NSPredicate {
        return NSPredicate(format: "typeid = %@ AND handle = %@ AND relatedHandle = %@", typeID, handle, relatedHandle)
    }
    
    func predicate(typeID: String, relatedHandle: String) -> NSPredicate {
        return NSPredicate(format: "typeid = %@ AND relatedHandle = %@", typeID, relatedHandle)
    }
}

extension PredicateBuilder: OutgoingCommandsPredicateBuilder {
    
    static func allImageCommands() -> NSPredicate {
        let commands: [ImageCommand.Type] = [
            CreateTopicImageCommand.self,
            CreateCommentImageCommand.self,
            UpdateUserImageCommand.self
        ]
        let typeIDs = commands.map { $0.typeIdentifier }
        return NSPredicate(format: "typeid IN %@", typeIDs)
    }
    
    static func allTopicActionCommands() -> NSPredicate {
        let topicCommands: [TopicCommand.Type] = [
            UnlikeTopicCommand.self,
            LikeTopicCommand.self,
            PinTopicCommand.self,
            UnpinTopicCommand.self
        ]
        let typeIDs = topicCommands.map { $0.typeIdentifier }
        return NSPredicate(format: "typeid IN %@", typeIDs)
    }
    
    static func commentActionCommands() -> NSPredicate {
        let commands: [CommentCommand.Type] = [
            UnlikeCommentCommand.self,
            LikeCommentCommand.self
        ]
        let typeIDs = commands.map { $0.typeIdentifier }
        return NSPredicate(format: "typeid IN %@", typeIDs)
    }
    
    static func replyActionCommands() -> NSPredicate {
        let replyCommands: [ReplyCommand.Type] = [
            UnlikeReplyCommand.self,
            LikeReplyCommand.self
        ]
        let typeIDs = replyCommands.map { $0.typeIdentifier }
        return NSPredicate(format: "typeid IN %@", typeIDs)
    }
    
    static func createTopicCommand(topicHandle: String) -> NSPredicate {
        return NSPredicate(format: "typeid = %@ AND handle = %@", CreateTopicCommand.typeIdentifier, topicHandle)
    }
    
    static func createCommentCommand(commentHandle: String) -> NSPredicate {
        return NSPredicate(format: "typeid = %@ AND handle = %@", CreateCommentCommand.typeIdentifier, commentHandle)
    }
    
    static func commandsWithRelatedHandle(_ relatedHandle: String, ignoredTypeID: String) -> NSPredicate {
        return NSPredicate(format: "relatedHandle = %@ AND typeid != %@", relatedHandle, ignoredTypeID)
    }
    
    static func createTopicCommands() -> NSPredicate {
        return NSPredicate(format: "typeid = %@", CreateTopicCommand.typeIdentifier)
    }
    
    static func createCommentCommands() -> NSPredicate {
        return NSPredicate(format: "typeid = %@", CreateCommentCommand.typeIdentifier)
    }
    
    static func createReplyCommands() -> NSPredicate {
        return NSPredicate(format: "typeid = %@", CreateReplyCommand.typeIdentifier)
    }
}
