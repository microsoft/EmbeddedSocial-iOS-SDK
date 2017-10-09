//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class BaseService: NetworkStatusListener {
    let errorHandler: APIErrorHandler
    let cache: CacheType
    fileprivate(set) var isNetworkReachable: Bool
    fileprivate(set) var authorization: Authorization
    let networkStatusMulticast: NetworkStatusMulticast
    private let authorizationMulticast: AuthorizationMulticastType

    init(authorizationMulticast: AuthorizationMulticastType = SocialPlus.shared.authorizationMulticast,
         cache: CacheType = SocialPlus.shared.cache,
         errorHandler: APIErrorHandler = UnauthorizedErrorHandler(),
         networkStatusMulticast: NetworkStatusMulticast = SocialPlus.shared.networkTracker) {
        
        self.errorHandler = errorHandler
        self.cache = cache
        self.networkStatusMulticast = networkStatusMulticast
        self.authorizationMulticast = authorizationMulticast
        isNetworkReachable = networkStatusMulticast.isReachable
        authorization = authorizationMulticast.authorization
        
        networkStatusMulticast.addListener(self)
        authorizationMulticast.addListener(self)
    }
    
    func networkStatusDidChange(_ isReachable: Bool) {
        isNetworkReachable = isReachable
    }
    
    deinit {
        networkStatusMulticast.removeListener(self)
        authorizationMulticast.removeListener(self)
    }
}

extension BaseService: AuthorizationListener {
    
    func authorizationDidChange(_ authorization: Authorization) {
        self.authorization = authorization
    }
}
