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
    private let errorHandler: APIErrorHandler
    
    init(errorHandler: APIErrorHandler = UnauthorizedErrorHandler()) {
        self.errorHandler = errorHandler
    }
    
    func postLike(postHandle: PostHandle, completion: @escaping CompletionHandler) {
        LikesAPI.topicLikesPostLike(topicHandle: postHandle, authorization: (SocialPlus.shared.sessionStore.user.credentials?.authHeader.values.first)!) { (object, error) in
            Logger.log(object, error)
            if self.errorHandler.canHandle(error) {
                self.errorHandler.handle(error)
            } else {
                completion(postHandle, error)
            }
        }
    }
    
    func deleteLike(postHandle: PostHandle, completion: @escaping CompletionHandler) {
        LikesAPI.topicLikesDeleteLike(topicHandle: postHandle, authorization: (SocialPlus.shared.sessionStore.user.credentials?.authHeader.values.first)!) { (object, error) in
            Logger.log(object, error)
            if self.errorHandler.canHandle(error) {
                self.errorHandler.handle(error)
            } else {
                completion(postHandle, error)
            }
        }
    }

}

