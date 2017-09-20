//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class LikeCommentOperation: CommentCommandOperation {
    
    override func main() {
        guard !isCancelled else {
            return
        }
        
        likesService.likeComment(commentHandle: command.comment.commentHandle) { [weak self] _, _ in
            self?.completeIfNotCancelled()
        }
    }
}
