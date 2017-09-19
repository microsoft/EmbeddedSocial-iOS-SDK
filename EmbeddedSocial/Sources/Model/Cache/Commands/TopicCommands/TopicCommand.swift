//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class TopicCommand: OutgoingCommand {
    let topic: Post
    
    required init?(json: [String: Any]) {
        guard let topicJSON = json["topic"] as? [String: Any],
            let topic = Post(json: topicJSON) else {
                return nil
        }
        
        self.topic = topic
        
        super.init(json: json)
    }
    
    required init(topic: Post) {
        self.topic = topic
        super.init(json: [:])!
    }
    
    func apply(to topic: inout Post) {
        
    }
    
    override func encodeToJSON() -> Any {
        return [
            "topic": topic.encodeToJSON(),
            "type": typeIdentifier
        ]
    }
    
    override func getHandle() -> String? {
        return topic.topicHandle
    }
}
