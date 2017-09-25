//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
@testable import EmbeddedSocial

class MockNetworkTracker: NetworkTrackerType {
    var isReachable = true
    
    //MARK: - startTracking
    
    var startTrackingCalled = false
    
    func startTracking() {
        startTrackingCalled = true
    }
    
    //MARK: - stopTracking
    
    var stopTrackingCalled = false
    
    func stopTracking() {
        stopTrackingCalled = true
    }
    
    //MARK: - addListener
    
    var addListenerCalled = false
    var addListenerReceivedListener: NetworkStatusListener?
    
    func addListener(_ listener: NetworkStatusListener) {
        addListenerCalled = true
        addListenerReceivedListener = listener
    }
    
    //MARK: - removeListener
    
    var removeListenerCalled = false
    var removeListenerReceivedListener: NetworkStatusListener?
    
    func removeListener(_ listener: NetworkStatusListener) {
        removeListenerCalled = true
        removeListenerReceivedListener = listener
    }
    
}
