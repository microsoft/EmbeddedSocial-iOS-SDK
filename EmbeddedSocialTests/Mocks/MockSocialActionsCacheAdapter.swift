//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

class SocialActionsCacheAdapterProtocolMock: FeedCacheActionsAdapterProtocol {
    
    //MARK: - cache
    
    var cacheCalled = false
    var cacheReceivedRequest: FeedActionRequest?
    
    func cache(_ request: FeedActionRequest) {
        cacheCalled = true
        cacheReceivedRequest = request
    }
    
    //MARK: - getAllCachedActions
    
    var getAllCachedActionsCalled = false
    var getAllCachedActionsReturnValue: Set<FeedActionRequest>!
    
    func getAllCachedActions() -> Set<FeedActionRequest> {
        getAllCachedActionsCalled = true
        return getAllCachedActionsReturnValue
    }
    
    //MARK: - remove
    
    var removeCalled = false
    var removeReceivedRequest: FeedActionRequest?
    
    func remove(_ request: FeedActionRequest) {
        removeCalled = true
        removeReceivedRequest = request
    }
    
}
