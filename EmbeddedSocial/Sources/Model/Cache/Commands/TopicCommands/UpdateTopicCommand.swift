//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class UpdateTopicCommand: TopicCommand {
    
    let request: PutTopicRequest
    
    init(topic: Post, request: PutTopicRequest) {
        self.request = request
        super.init(topic: topic)
    }
    
    required init(topic: Post) {
        self.request = PutTopicRequest()
        self.request.text = topic.text
        self.request.title = topic.title
        super.init(topic: topic)
    }
    
    required init?(json: [String: Any]) {
        guard let request = json["request"] as? [String: AnyObject] else {
            return nil
        }
        
        guard let decodedRequest = Decoders.decode(clazz: PutTopicRequest.self, source: request as AnyObject, instance: nil).value else {
            return nil
        }
        
        self.request = decodedRequest
        
        super.init(json: json)
    }
    
    override func encodeToJSON() -> Any {
        return [
            "topic": topic.encodeToJSON(),
            "type": typeIdentifier,
            "request": request.encodeToJSON()
        ]
    }
    
    
    override func apply(to topic: inout Post) {
        topic.text = self.topic.text
        topic.title = self.topic.title
    }
}
