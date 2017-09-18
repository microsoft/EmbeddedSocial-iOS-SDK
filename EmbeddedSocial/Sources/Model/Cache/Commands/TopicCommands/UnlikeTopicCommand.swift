//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class UnlikeTopicCommand: TopicCommand {
    
    override var inverseCommand: OutgoingCommand? {
        return LikeTopicCommand(topicHandle: topicHandle)
    }
    
    override func apply(to topic: inout Post) {
        topic.liked = false
        topic.totalLikes = max(0, topic.totalLikes - 1)
    }
}
