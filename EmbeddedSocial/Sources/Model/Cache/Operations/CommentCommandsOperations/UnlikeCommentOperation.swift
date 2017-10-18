//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class UnlikeCommentOperation: CommentCommandOperation {
    private let likesService: LikesServiceProtocol
    
    init(command: CommentCommand, likesService: LikesServiceProtocol) {
        self.likesService = likesService
        super.init(command: command)
    }
    
    override func main() {
        guard !isCancelled else {
            return
        }
        
        likesService.unlikeComment(commentHandle: command.comment.commentHandle) { [weak self] _, error in
            self?.completeOperation(with: error)
        }
    }
}
