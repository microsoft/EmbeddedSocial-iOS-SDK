//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class ReportTopicOperation: OutgoingCommandOperation {
    let command: ReportTopicCommand
    let service: ReportingServiceType
    
    init(command: ReportTopicCommand, service: ReportingServiceType) {
        self.command = command
        self.service = service
        super.init()
    }
    
    override func main() {
        guard !isCancelled else {
            return
        }
        
        service.reportPost(postID: command.topic.topicHandle, reason: command.reason) { [weak self] result in
            self?.completeOperation(with: result.error)
        }
    }
}
