//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class CommonCacheRequestExecutionStrategy<ResponseType, ResultType>:
CacheRequestExecutionStrategy<ResponseType, ResultType> where ResponseType: Cacheable {
    typealias Mapper = (ResponseType?) -> ResultType
    
    var mapper: Mapper?
    var cacheMapper: Mapper?
    
    override func execute(with builder: RequestBuilder<ResponseType>, completion: @escaping (Result<ResultType>) -> Void) {
        if let cachedResponse = cache?.firstIncoming(ofType: ResponseType.self, handle: builder.URLString) {
            processResponse(cachedResponse, isFromCache: true, error: nil, completion: completion)
        }
        
        builder.execute { [weak self] result, error in
            let response = result?.body
            response?.setHandle(builder.URLString)
            if let response = response {
                self?.cache?.cacheIncoming(response)
            }
            self?.processResponse(response, isFromCache: false, error: error, completion: completion)
        }
    }
    
    private func processResponse(_ response: ResponseType?,
                                 isFromCache: Bool,
                                 error: Error?,
                                 completion: @escaping (Result<ResultType>) -> Void) {
        
        guard let mapper = suitableMapper(isFromCache: isFromCache) else {
            DispatchQueue.main.async {
                completion(.failure(APIError.custom("CommonCacheRequestExecutionStrategy: mapper is missing")))
            }
            return
        }
        DispatchQueue.main.async {
            if error != nil {
                self.errorHandler?.handle(error: error, completion: completion)
            } else {
                self.postProcessResult(mapper(response), completion: completion)
            }
        }
    }
    
    func postProcessResult(_ result: ResultType, completion: @escaping (Result<ResultType>) -> Void) {
        DispatchQueue.main.async {
            completion(.success(result))
        }
    }
    
    private func suitableMapper(isFromCache: Bool) -> Mapper? {
        return isFromCache ? cacheMapper : mapper
    }
}
