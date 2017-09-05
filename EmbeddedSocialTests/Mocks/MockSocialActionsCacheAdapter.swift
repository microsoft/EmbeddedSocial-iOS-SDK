//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

class SocialActionsCacheAdapterProtocolMock: SocialActionsCacheAdapterProtocol {
    
    //MARK: - cache
    
    var cacheCalled = false
    var cacheReceivedRequest: SocialActionRequest?
    
    func cache(_ request: SocialActionRequest) {
        cacheCalled = true
        cacheReceivedRequest = request
    }
    
    //MARK: - getAllCachedActions
    
    var getAllCachedActionsCalled = false
    var getAllCachedActionsReturnValue: Set<SocialActionRequest>!
    
    func getAllCachedActions() -> Set<SocialActionRequest> {
        getAllCachedActionsCalled = true
        return getAllCachedActionsReturnValue
    }
    
    //MARK: - remove
    
    var removeCalled = false
    var removeReceivedRequest: SocialActionRequest?
    
    func remove(_ request: SocialActionRequest) {
        removeCalled = true
        removeReceivedRequest = request
    }
    
}
