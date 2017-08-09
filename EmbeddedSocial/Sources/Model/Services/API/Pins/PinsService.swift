//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol PinsServiceProtocol {
    
    typealias PostHandle = String
    typealias CompletionHandler = (_ postHandle: PostHandle, _ error: Error?) -> Void
    
    func postPin(postHandle: PostHandle, completion: @escaping CompletionHandler)
    func deletePin(postHandle: PostHandle, completion: @escaping CompletionHandler)
    
}

class PinsService: PinsServiceProtocol {
    
    func postPin(postHandle: PostHandle, completion: @escaping CompletionHandler) {
    
        let request = PostPinRequest()
        request.topicHandle = postHandle
        PinsAPI.myPinsPostPin(request: request, authorization: (SocialPlus.shared.sessionStore.user.credentials?.accessToken)!) { (object, error) in
            Logger.log(object, error)
            completion(postHandle, error)
        }
    }
    
    func deletePin(postHandle: PostHandle, completion: @escaping CompletionHandler) {
        
        PinsAPI.myPinsDeletePin(topicHandle: postHandle, authorization: (SocialPlus.shared.sessionStore.user.credentials?.accessToken)!) { (object, error) in
            Logger.log(object, error)
            completion(postHandle, error)
        }
    }
    
}
