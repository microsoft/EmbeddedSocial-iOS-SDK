//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class CreateReplyOperation: AsyncOperation {
    let command: ReplyCommand
    private let repliesService: RepliesServiceProtcol
    
    init(command: ReplyCommand, repliesService: RepliesServiceProtcol) {
        self.command = command
        self.repliesService = repliesService
    }
    
    override func main() {
        guard !isCancelled else {
            return
        }
        
        let request = PostReplyRequest()
        request.text = command.reply.text
        repliesService.postReply(commentHandle: command.reply.commentHandle,
                                 request: request,
                                 success: { [weak self] _ in self?.completeIfNotCancelled() },
                                 failure: {_ in () })
    }
}
