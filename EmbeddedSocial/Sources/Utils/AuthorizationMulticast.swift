//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol AuthorizationMulticastType {
    var authorization: Authorization { get set }
    
    func addListener(_ listener: AuthorizationListener)
    
    func removeListener(_ listener: AuthorizationListener)
}

protocol AuthorizationListener {
    func authorizationDidChange(_ authorization: Authorization)
}

class AuthorizationMulticast: AuthorizationMulticastType {
    
    var authorization: Authorization {
        didSet {
            listeners.invoke { [weak self] listener in
                guard let strongSelf = self else { return }
                listener.authorizationDidChange(strongSelf.authorization)
            }
        }
    }
    
    private let listeners = MulticastDelegate<AuthorizationListener>()

    init(authorization: Authorization) {
        self.authorization = authorization
    }
    
    func addListener(_ listener: AuthorizationListener) {
        listeners.add(listener)
    }
    
    func removeListener(_ listener: AuthorizationListener) {
        listeners.remove(listener)
    }
}
