//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class OutgoingCommand: Cacheable {
    
    var inverseCommand: OutgoingCommand? {
        return nil
    }

    required init?(json: [String: Any]) {
        
    }
    
    static func command(from json: [String: Any]) -> OutgoingCommand? {
        guard let typeName = json["type"] as? String else {
            return nil
        }
        
        var typeNames: [String: OutgoingCommand.Type] = [:]
        
        for type in allCommandTypes {
            typeNames[type.typeIdentifier] = type
        }
        
        guard let matchingType = typeNames[typeName] else {
            return nil
        }
        
        return matchingType.init(json: json)
    }
    
    static var allCommandTypes: [OutgoingCommand.Type] = [
        // User Commands
        FollowCommand.self,
        UnfollowCommand.self,
        CancelPendingCommand.self,
        BlockCommand.self,
        UnblockCommand.self,
        
        // Topic Commands
        UnlikeTopicCommand.self,
        LikeTopicCommand.self,
        PinTopicCommand.self,
        UnpinTopicCommand.self,
        CreateTopicCommand.self,
        
        // Reply Commands
        LikeReplyCommand.self,
        UnlikeReplyCommand.self,
        CreateReplyCommand.self,
        RemoveReplyCommand.self,
        ReportReplyCommand.self,
        
        // Comment Commands
        LikeCommentCommand.self,
        UnlikeCommentCommand.self,
        CreateCommentCommand.self,
        RemoveCommentCommand.self,
        ReportCommentCommand.self,
        
        // Image Commands
        CreateTopicImageCommand.self,
        CreateCommentImageCommand.self,
        UpdateUserImageCommand.self,
    ]
    
    //MARK: Cacheable
    
    func encodeToJSON() -> Any {
        return [
            "type": String(describing: type(of: self))
        ]
    }
    
    func setHandle(_ handle: String?) {
        // nothing
    }
    
    func getHandle() -> String? {
        return nil
    }
    
    func getRelatedHandle() -> String? {
        return nil
    }
    
    func setRelatedHandle(_ relatedHandle: String?) {
        // nothing
    }
}
