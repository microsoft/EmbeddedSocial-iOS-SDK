//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class ReplyCommand: OutgoingCommand {
    let replyHandle: String
    
    required init?(json: [String: Any]) {
        guard let replyHandle = json["replyHandle"] as? String else {
            return nil
        }
        
        self.replyHandle = replyHandle
        
        super.init(json: json)
    }
    
    required init(replyHandle: String) {
        self.replyHandle = replyHandle
        super.init(json: [:])!
    }
    
    func apply(to reply: inout Reply) {
        
    }
    
    override func encodeToJSON() -> Any {
        return [
            "replyHandle": replyHandle,
            "type": typeIdentifier
        ]
    }
    
    override func getHandle() -> String? {
        return replyHandle
    }
}
