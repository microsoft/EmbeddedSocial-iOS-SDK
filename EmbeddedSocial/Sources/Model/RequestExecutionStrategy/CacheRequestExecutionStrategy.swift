//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class CacheRequestExecutionStrategy<T, U>: RequestExecutionStrategy {
    typealias ResponseType = T
    typealias ResultType = U
    
    var cache: CacheType?
    var errorHandler: APIErrorHandler?
    var networkTracker: NetworkStatusMulticast?
    
    func execute(with builder: RequestBuilder<ResponseType>, completion: @escaping (Result<ResultType>) -> Void) {
        fatalError("Abstract method")
    }
}

