//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class ReplyCommand: OutgoingCommand {
    private(set) var reply: Reply
    
    required init?(json: [String: Any]) {
        guard let replyJSON = json["reply"] as? [String: Any],
            let reply = Reply(json: replyJSON) else {
                return nil
        }
        
        self.reply = reply
        
        super.init(json: json)
    }
    
    required init(reply: Reply) {
        self.reply = reply
        super.init(json: [:])!
    }
    
    func apply(to reply: inout Reply) {
        
    }
    
    override func encodeToJSON() -> Any {
        return [
            "reply": reply.encodeToJSON(),
            "type": typeIdentifier
        ]
    }
    
    override func getHandle() -> String? {
        return reply.replyHandle
    }
    
    override func getRelatedHandle() -> String? {
        return reply.replyHandle
    }
    
    override func setRelatedHandle(_ relatedHandle: String?) {
        reply.replyHandle = relatedHandle
    }
    
    static var allReplyCommandTypes: [OutgoingCommand.Type] {
        return [
            LikeReplyCommand.self,
            UnlikeReplyCommand.self,
            CreateReplyCommand.self,
        ]
    }
    
    static var replyActionCommandTypes: [OutgoingCommand.Type] {
        return [
            LikeReplyCommand.self,
            UnlikeReplyCommand.self,
        ]
    }
}
