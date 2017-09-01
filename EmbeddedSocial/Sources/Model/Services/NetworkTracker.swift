//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
import Alamofire

extension Notification.Name {
    static let networkStatusDidChange = Notification.Name("networkStatusDidChange")
}

protocol NetworkStatusListener {
    func networkStatusDidChange(_ isReachable: Bool)
}

protocol NetworkStatusMulticast {
    var isReachable: Bool { get }
    
    func addListener(_ listener: NetworkStatusListener)
    
    func removeListener(_ listener: NetworkStatusListener)
}

protocol NetworkTrackerType: NetworkStatusMulticast {
    func startTracking()
    
    func stopTracking()
}

/**
 Subscribe via:
 1. addListener / removeListener
 2. Notification Notification.Name.networkStatusDidChange. User info contains isReachable value
 */
final class NetworkTracker: NetworkTrackerType {
    
    static let isReachableKey = "ReachabilityService.isReachable"
    
    private let listeners = MulticastDelegate<NetworkStatusListener>()
    
    var isReachable: Bool {
        return reachability?.isReachable ?? false
    }
    
    func addListener(_ listener: NetworkStatusListener) {
        listeners.add(listener)
    }
    
    func removeListener(_ listener: NetworkStatusListener) {
        listeners.remove(listener)
    }
    
    private lazy var reachability: NetworkReachabilityManager? = {
        let reachability = NetworkReachabilityManager(host: "www.apple.com")
        reachability?.listener = { [weak self] status in
            self?.notify(status: status)
        }
        return reachability
    }()
    
    func startTracking() {
        reachability?.startListening()
    }
    
    func stopTracking() {
        reachability?.stopListening()
    }
    
    private func notify(status: NetworkReachabilityManager.NetworkReachabilityStatus) {
        
        NotificationCenter.default.post(
            name: .networkStatusDidChange,
            object: nil,
            userInfo: [NetworkTracker.isReachableKey: NSNumber(booleanLiteral: self.isReachable)]
        )
        
        listeners.invoke { [weak self] listener in
            guard let strongSelf = self else { return }
            listener.networkStatusDidChange(strongSelf.isReachable)
        }
    }
    
    deinit {
        reachability?.stopListening()
    }
}
