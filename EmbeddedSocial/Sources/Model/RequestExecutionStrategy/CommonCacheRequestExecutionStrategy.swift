//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class CommonCacheRequestExecutionStrategy<ResponseType, ResultType>:
CacheRequestExecutionStrategy<ResponseType, ResultType> where ResponseType: Cacheable {
    
    var responseProcessor: ResponseProcessor<ResponseType, ResultType>!
    
    override func execute(with builder: RequestBuilder<ResponseType>, completion: @escaping (Result<ResultType>) -> Void) {
        let cachedResponse = cache?.firstIncoming(ofType: ResponseType.self, handle: builder.URLString)
        if cachedResponse != nil {
            DispatchQueue.main.async {
                self.processResponse(cachedResponse!, isFromCache: true, error: nil, completion: completion)
            }
        }
        
        if let networkTracker = networkTracker, !networkTracker.isReachable {
            if cachedResponse == nil {
                processResponse(nil, isFromCache: false, error: nil, completion: completion)
            }
            return
        }
        
        builder.execute { [weak self] result, error in
            let response = result?.body
            response?.setHandle(builder.URLString)
            
            // Fix for server bug, clean cursor if there is zero data
            
            if let feedResult = response as? FeedResponseTopicView {
                if feedResult.data?.count == 0 {
                    feedResult.cursor = nil
                }
            }
            
            if let response = response {
                self?.cache?.cacheIncoming(response)
            }
            DispatchQueue.main.async {
                self?.processResponse(response, isFromCache: false, error: error, completion: completion)
            }
        }
    }
    
    private func processResponse(_ response: ResponseType?,
                                 isFromCache: Bool,
                                 error: Error?,
                                 completion: @escaping (Result<ResultType>) -> Void) {
        if error != nil {
            errorHandler?.handle(error: error, completion: completion)
        } else {
            responseProcessor.process(response, isFromCache: isFromCache, completion: completion)
        }
    }
}
