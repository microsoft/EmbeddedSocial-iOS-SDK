//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

extension PostTopicRequest {
    
    convenience init(topic: Post) {
        self.init()
        text = topic.text
        title = topic.title
    }
}
