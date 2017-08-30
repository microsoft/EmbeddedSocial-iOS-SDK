//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class BaseService {
    let errorHandler: APIErrorHandler
    let authorization: Authorization
    let cache: CacheType
    fileprivate(set) var isNetworkReachable: Bool
    private let networkStatusMulticast: NetworkStatusMulticast

    init(authorization: Authorization = SocialPlus.shared.authorization,
         cache: CacheType = SocialPlus.shared.cache,
         errorHandler: APIErrorHandler = UnauthorizedErrorHandler(),
         networkStatusMulticast: NetworkStatusMulticast = SocialPlus.shared.networkTracker) {
        
        self.authorization = authorization
        self.errorHandler = errorHandler
        self.cache = cache
        self.networkStatusMulticast = networkStatusMulticast
        isNetworkReachable = networkStatusMulticast.isReachable
        
        networkStatusMulticast.addListener(self)
    }
    
    deinit {
        networkStatusMulticast.removeListener(self)
    }
}

extension BaseService: NetworkStatusListener {
    
    func networkStatusDidChange(_ isReachable: Bool) {
        isNetworkReachable = isReachable
    }
}
