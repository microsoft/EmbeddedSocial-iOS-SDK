//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class UnlikeTopicOperation: TopicCommandOperation {
    
    override func main() {
        guard !isCancelled else {
            return
        }
        
        likesService.deleteLike(postHandle: command.topic.topicHandle) { [weak self] _, _ in
            self?.completeIfNotCancelled()
        }
    }
}
