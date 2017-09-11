//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class CommonCacheRequestExecutionStrategy<ResponseType, ResultType>:
CacheRequestExecutionStrategy<ResponseType, ResultType> where ResponseType: Cacheable {
    
    var mapper: ((ResponseType?) -> ResultType)?
    
    override func execute(with builder: RequestBuilder<ResponseType>, completion: @escaping (Result<ResultType>) -> Void) {
        if let cachedResponse = cache?.firstIncoming(ofType: ResponseType.self, handle: builder.URLString) {
            processResponse(cachedResponse, error: nil, completion: completion)
        }
        
        builder.execute { [weak self] result, error in
            let response = result?.body
            response?.setHandle(builder.URLString)
            if let response = response {
                self?.cache?.cacheIncoming(response)
            }
            self?.processResponse(response, error: error, completion: completion)
        }
    }
    
    private func processResponse(_ response: ResponseType?,
                                 error: Error?,
                                 completion: @escaping (Result<ResultType>) -> Void) {
        
        guard let mapper = mapper else {
            completion(.failure(APIError.custom("CommonCacheRequestExecutionStrategy: mapper is missing")))
            return
        }
        
        if error != nil {
            errorHandler?.handle(error: error, completion: completion)
        } else {
            postProcessResult(mapper(response), completion: completion)
        }
    }
    
    func postProcessResult(_ result: ResultType, completion: @escaping (Result<ResultType>) -> Void) {
        completion(.success(result))
    }
}
