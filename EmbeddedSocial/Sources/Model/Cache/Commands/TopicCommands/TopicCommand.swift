//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class TopicCommand: OutgoingCommand {
    let topicHandle: String
    
    override var combinedHandle: String {
        return "\(super.combinedHandle)-\(topicHandle)"
    }
    
    required init?(json: [String: Any]) {
        guard let topicHandle = json["topicHandle"] as? String else {
            return nil
        }
        
        self.topicHandle = topicHandle
        
        super.init(json: json)
    }
    
    required init(topicHandle: String) {
        self.topicHandle = topicHandle
        super.init(json: [:])!
    }
    
    func apply(to topic: inout Post) {
        
    }
    
    override func encodeToJSON() -> Any {
        return [
            "topicHandle": topicHandle,
            "type": String(describing: type(of: self))
        ]
    }
}
