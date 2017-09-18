//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class CommentCommand: OutgoingCommand {
    let commentHandle: String
    
    override var combinedHandle: String {
        return "\(super.combinedHandle)-\(commentHandle)"
    }
    
    required init?(json: [String: Any]) {
        guard let commentHandle = json["commentHandle"] as? String else {
            return nil
        }
        
        self.commentHandle = commentHandle
        
        super.init(json: json)
    }
    
    required init(commentHandle: String) {
        self.commentHandle = commentHandle
        super.init(json: [:])!
    }
    
    func apply(to comment: inout Comment) {
        
    }
    
    override func encodeToJSON() -> Any {
        return [
            "commentHandle": commentHandle,
            "type": String(describing: type(of: self))
        ]
    }
}
