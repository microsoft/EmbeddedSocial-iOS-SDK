//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class UpdateTopicCommand: TopicCommand {
    
    override func apply(to topic: inout Post) {
        topic.text = self.topic.text
        topic.title = self.topic.title
    }
}
