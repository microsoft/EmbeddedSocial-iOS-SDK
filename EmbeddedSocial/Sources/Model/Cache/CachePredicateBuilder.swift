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

struct PredicateBuilder: CachePredicateBuilder {
    
    static func predicate(typeID: String) -> NSPredicate {
        return NSPredicate(format: "typeid = %@", typeID)
    }
    
    
    static func allOutgoingCommandsPredicate() -> NSPredicate {
        let typeIDs = OutgoingCommand.allCommandTypes.map { $0.typeIdentifier }
        return NSPredicate(format: "typeid IN %@", typeIDs)
    }
    
    static func allUserCommandsPredicate() -> NSPredicate {
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
    
    static func allTopicCommandsPredicate() -> NSPredicate {
        let topicCommands: [TopicCommand.Type] = [
            UnlikeTopicCommand.self,
            LikeTopicCommand.self,
            PinTopicCommand.self,
            UnpinTopicCommand.self,
        ]
        let typeIDs = topicCommands.map { $0.typeIdentifier }
        return NSPredicate(format: "typeid IN %@", typeIDs)
    }
    
    static func allReplyCommandsPredicate(for replyHandle: String) -> NSPredicate {
        let replyCommands: [ReplyCommand.Type] = [
            UnlikeReplyCommand.self,
            LikeReplyCommand.self
        ]
        let handles = replyCommands.map { "\($0.typeIdentifier)-\(replyHandle)" }
        return NSPredicate(format: "handle IN %@", handles)
    }
    
    static func allCommentCommandsPredicate(for commentHandle: String) -> NSPredicate {
        let commentCommands: [CommentCommand.Type] = [
            UnlikeCommentCommand.self,
            LikeCommentCommand.self
        ]
        let handles = commentCommands.map { "\($0.typeIdentifier)-\(commentHandle)" }
        return NSPredicate(format: "handle IN %@", handles)
    }
    
    static func userCommandsPredicate() -> NSPredicate {
        return predicate(typeID: OutgoingCommand.typeIdentifier)
    }
    
    static func predicate(typeID: String, handle: String) -> NSPredicate {
        return NSPredicate(format: "typeid = %@ AND handle = %@", typeID, handle)
    }
    
    static func predicate(for command: OutgoingCommand) -> NSPredicate {
        return predicate(typeID: command.typeIdentifier, handle: command.combinedHandle)
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
