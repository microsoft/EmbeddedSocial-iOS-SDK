//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class UnpinTopicCommand: TopicCommand {
    
    override var inverseCommand: OutgoingCommand? {
        return PinTopicCommand(topic: topic)
    }
    
    override func apply(to topic: inout Post) {
        topic.pinned = false
    }
}
