//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

class MockAuthorizationMulticast: AuthorizationMulticastType {
    var authorization: Authorization = ""
    
    //MARK: - addListener
    
    var addListenerCalled = false
    var addListenerReceivedListener: AuthorizationListener?
    
    func addListener(_ listener: AuthorizationListener) {
        addListenerCalled = true
        addListenerReceivedListener = listener
    }
    
    //MARK: - removeListener
    
    var removeListenerCalled = false
    var removeListenerReceivedListener: AuthorizationListener?
    
    func removeListener(_ listener: AuthorizationListener) {
        removeListenerCalled = true
        removeListenerReceivedListener = listener
    }
    
}
