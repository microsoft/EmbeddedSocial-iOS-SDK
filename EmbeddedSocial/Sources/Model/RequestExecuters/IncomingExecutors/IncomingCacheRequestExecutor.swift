//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class IncomingCacheRequestExecutorImpl<ResponseType, ResultType>:
IncomingCacheRequestExecutor<ResponseType, ResultType> where ResponseType: Cacheable {
    
    var responseProcessor: ResponseProcessor<ResponseType, ResultType>!

    override func execute(with builder: RequestBuilder<ResponseType>, completion: @escaping (Result<ResultType>) -> Void) {
        let cachedResponse = cache?.firstIncoming(ofType: ResponseType.self, handle: builder.URLString)
        if cachedResponse != nil {
            DispatchQueue.main.async {
                self.processResponse(cachedResponse!, isFromCache: true, error: nil, completion: completion)
            }
        }
        
        builder.execute { [weak self] result, error in
            let response = result?.body
            response?.setHandle(builder.URLString)
            
            if let response = response {
                self?.cache?.cacheIncoming(response)
            }
            DispatchQueue.main.async {
                let error = (error == nil) ? nil : APIError(error: error)
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
