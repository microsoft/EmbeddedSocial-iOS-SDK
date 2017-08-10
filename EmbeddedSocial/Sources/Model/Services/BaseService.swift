//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class BaseService {
    let errorHandler: APIErrorHandler
    let authorization: Authorization
    let cache: CacheType
    
    init(authorization: Authorization = SocialPlus.shared.authorization,
         cache: CacheType = SocialPlus.shared.cache,
         errorHandler: APIErrorHandler = UnauthorizedErrorHandler()) {
        self.authorization = authorization
        self.errorHandler = errorHandler
        self.cache = cache
    }
}
