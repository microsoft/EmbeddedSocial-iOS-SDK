//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol LikesServiceProtocol {
    
    typealias PostHandle = String
    typealias CompletionHandler = (_ postHandle: PostHandle, _ error: Error?) -> Void
    
    func postLike(postHandle: PostHandle, completion: @escaping CompletionHandler)
    func deleteLike(postHandle: PostHandle, completion: @escaping CompletionHandler)

}

class LikesService: LikesServiceProtocol {
    
    func postLike(postHandle: PostHandle, completion: @escaping CompletionHandler) {
        LikesAPI.topicLikesPostLike(topicHandle: postHandle) { (object, error) in
            Logger.log(object, error)
            completion(postHandle, error)
        }
    }
    
    func deleteLike(postHandle: PostHandle, completion: @escaping CompletionHandler) {
        LikesAPI.topicLikesDeleteLike(topicHandle: postHandle) { (object, error) in
            Logger.log(object, error)
            completion(postHandle, error)
        }
    }
    
    func likeComment(commentHandle: String) {
        LikesAPI.commentLikesPostLike(commentHandle: commentHandle) { (object, error) in
            
        }
    }
    
    func unlikeComment(commentHandle: String) {
        LikesAPI.commentLikesDeleteLike(commentHandle: commentHandle) { (object, error) in
            
        }
    }

}

