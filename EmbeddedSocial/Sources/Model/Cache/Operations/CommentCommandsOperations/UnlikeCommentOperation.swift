//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class UnlikeCommentOperation: CommentCommandOperation {
    
    override func main() {
        guard !isCancelled else {
            return
        }
        
        likesService.unlikeComment(commentHandle: command.comment.commentHandle) { [weak self] _, error in
            self?.completeOperation(with: error)
        }
    }
}
