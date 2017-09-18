//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class PinTopicOperation: TopicCommandOperation {
    
    override func main() {
        guard !isCancelled else {
            return
        }
        
        likesService.postPin(postHandle: command.topicHandle) { [weak self] _, _ in
            guard let strongSelf = self, !strongSelf.isCancelled else {
                return
            }
            strongSelf.completeOperation()
        }
    }
}
