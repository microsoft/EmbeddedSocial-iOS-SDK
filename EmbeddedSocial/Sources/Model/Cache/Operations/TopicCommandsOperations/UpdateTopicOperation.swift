//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class UpdateTopicOperation: TopicCommandOperation {
    private let topicsService: PostServiceProtocol

    init (command: UpdateTopicCommand, topicsService: PostServiceProtocol) {
        self.topicsService = topicsService
        super.init(command: command)
    }

    override func main() {
        guard !isCancelled else {
            return
        }
        
        let request = PutTopicRequest()
        request.title = command.topic.title
        request.text = command.topic.text
        
        topicsService.update(topic: command.topic, request: request , success: {
            self.completeOperation()
        }) { (error) in
            self.completeOperation(with: error)
        }

    }

}

