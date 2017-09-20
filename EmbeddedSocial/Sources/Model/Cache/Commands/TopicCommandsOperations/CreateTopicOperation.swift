//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class CreateTopicOperation: AsyncOperation {
    
    let command: TopicCommand
    private let topicsService: PostServiceProtocol
    
    init(command: TopicCommand, topicsService: PostServiceProtocol) {
        self.command = command
        self.topicsService = topicsService
    }
    
    override func main() {
        guard !isCancelled else {
            return
        }
        
        let request = PostTopicRequest(topic: command.topic)
        topicsService.postTopic(topic: request,
                                photo: command.topic.user?.photo,
                                success: { [weak self] _ in self?.completeIfNotCancelled() },
                                failure: { _ in () })
    }
}
