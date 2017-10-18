//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class RemoveTopicCommand: TopicCommand {
    
    override func apply(to feed: inout FeedFetchResult) {
        var topics = feed.posts
        if let index = topics.index(where: { $0.topicHandle == self.topic.topicHandle }) {
            topics.remove(at: index)
        }
        feed.posts = topics
    }
}
