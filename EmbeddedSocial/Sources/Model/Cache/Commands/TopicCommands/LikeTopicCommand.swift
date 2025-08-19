//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class LikeTopicCommand: TopicCommand {
    
    override var inverseCommand: OutgoingCommand? {
        return UnlikeTopicCommand(topic: topic)
    }
    
    override func apply(to topic: inout Post) {
        topic.liked = true
        topic.totalLikes += 1
    }
}
