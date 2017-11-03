//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class OutgoingCacheRequestExecutor<ResponseType, ResultType> {
    
    var cache: CacheType?
    var errorHandler: APIErrorHandler?
    
    func execute(command: OutgoingCommand,
                 builder: RequestBuilder<ResponseType>,
                 completion: @escaping (Result<Void>) -> Void) {
        fatalError("Abstract method")
    }
    
}
