//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class NonCachingCommentsService: CommentsService {
    
    override func execute(command: CreateCommentCommand,
                          resultHandler: @escaping CommentPostResultHandler,
                          failure: @escaping Failure) {
        
        CommentsAPI.topicCommentsPostComment(
            topicHandle: command.comment.topicHandle,
            request: PostCommentRequest(comment: command.comment),
            authorization: authorization
        ) { response, error in
            
            if let newHandle = response?.commentHandle {
                command.comment.commentHandle = newHandle
                resultHandler(command.comment)
            } else {
                if self.errorHandler.canHandle(error) {
                    self.errorHandler.handle(error)
                }
                failure(APIError(error: error))
            }
        }
    }
    
    override func delete(comment: Comment, completion: @escaping (Result<Void>) -> Void) {
        CommentsAPI.commentsDeleteComment(
            commentHandle: comment.commentHandle,
            authorization: authorization
        ) { response, error in
            
            if error == nil {
                completion(.success())
            } else {
                if self.errorHandler.canHandle(error) {
                    self.errorHandler.handle(error)
                }
                completion(.failure(APIError(error: error)))
            }
        }
    }
}
