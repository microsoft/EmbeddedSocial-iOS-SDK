//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class TopicCommand: OutgoingCommand, TopicsFeedApplicableCommand {
    private(set) var topic: Post
    
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
    
    func setImageHandle(_ imageHandle: String?) {
        topic.imageHandle = imageHandle
    }
    
    func apply(to topic: inout Post) {
        
    }
    
    func apply(to feed: inout FeedFetchResult) {
        var topics = feed.posts
        
        for (index, var topic) in topics.enumerated() {
            if topic.topicHandle == self.topic.topicHandle {
                apply(to: &topic)
                topics[index] = topic
            }
        }
        
        feed.posts = topics
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
    
    override func getRelatedHandle() -> String? {
        return topic.topicHandle
    }
    
    override func setRelatedHandle(_ relatedHandle: String?) {
        if let relatedHandle = relatedHandle {
            topic.topicHandle = relatedHandle
        }
    }
    
    static var topicActionCommandTypes: [OutgoingCommand.Type] {
        return [
            UnlikeTopicCommand.self,
            LikeTopicCommand.self,
            PinTopicCommand.self,
            UnpinTopicCommand.self
        ]
    }
    
    static var allTopicCommandTypes: [OutgoingCommand.Type] {
        return [
            UnlikeTopicCommand.self,
            LikeTopicCommand.self,
            PinTopicCommand.self,
            UnpinTopicCommand.self,
            CreateTopicCommand.self
        ]
    }
}
