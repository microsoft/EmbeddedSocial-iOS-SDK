//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class LikeTopicOperation: TopicCommandOperation {
    
    override func main() {
        guard !isCancelled else {
            return
        }
        
        likesService.postLike(postHandle: command.topic.topicHandle) { [weak self] _, error in
            self?.completeOperation(with: error)
        }
    }
}
