//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class CreateTopicCommand: TopicCommand {
    
    override func apply(to feed: inout FeedFetchResult) {
        var topics = feed.posts
        topics.insert(topic, at: 0)
        feed.posts = topics
    }
}
