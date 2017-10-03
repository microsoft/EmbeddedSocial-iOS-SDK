//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
@testable import EmbeddedSocial

class MockTopicCommand: TopicCommand {
    var applyToTopicCalled = false
    var applyToTopicInputTopic: Post?
    
    override func apply(to topic: inout Post) {
        applyToTopicCalled = true
        applyToTopicInputTopic = topic
    }
    
    var applyToFeedCalled = false
    var applyToFeedInputFeed: FeedFetchResult?
    
    override func apply(to feed: inout FeedFetchResult) {
        super.apply(to: &feed)
        applyToFeedCalled = true
        applyToFeedInputFeed = feed
    }
}
