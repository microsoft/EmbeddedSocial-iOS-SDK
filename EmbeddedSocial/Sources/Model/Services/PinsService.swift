//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol PinsServiceProtocol {

    typealias CompletionHandler = (_ postHandle: PostHandle, _ error: Error?) -> Void
    
    func postPin(postHandle: PostHandle, completion: @escaping CompletionHandler)
    func deletePin(postHandle: PostHandle, completion: @escaping CompletionHandler)
    
}

class PinsService: BaseService, PinsServiceProtocol {
    
    private lazy var socialActionsCache: SocialActionsCache = { [unowned self] in
        return SocialActionsCache(cache: self.cache)
        }()

    private func process(_ requestBuilder: RequestBuilder<Object>,
                         handle: PostHandle,
                         completion: @escaping CompletionHandler) {
        
        // If no connection, cache request
        guard isNetworkReachable == true else {
            
            let action = SocialActionRequestBuilder.build(
                method: requestBuilder.method,
                handle: handle,
                action: .pin)
            
            socialActionsCache.cache(action)
            completion(handle, nil)
            return
        }
        
        requestBuilder.execute { (response, error) in
            if self.errorHandler.canHandle(error) {
                self.errorHandler.handle(error)
            } else {
                completion(handle, error)
            }
        }
    }
    
    func postPin(postHandle: PostHandle, completion: @escaping CompletionHandler) {
        
        let request = PostPinRequest()
        request.topicHandle = postHandle
        let builder = PinsAPI.myPinsPostPinWithRequestBuilder(request: request, authorization: authorization)
        
        process(builder, handle: postHandle, completion: completion)
    }
    
    func deletePin(postHandle: PostHandle, completion: @escaping CompletionHandler) {
        
        let builder = PinsAPI.myPinsDeletePinWithRequestBuilder(topicHandle: postHandle, authorization: authorization)
        
        process(builder, handle: postHandle, completion: completion)
    }
    
}
