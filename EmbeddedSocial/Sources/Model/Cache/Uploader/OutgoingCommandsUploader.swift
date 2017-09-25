//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class OutgoingCommandsUploader: Daemon, NetworkStatusListener {
    
    private let networkTracker: NetworkStatusMulticast
    private let uploadStrategy: OutgoingCommandsUploadStrategyType
    
    init(networkTracker: NetworkStatusMulticast,
         uploadStrategy: OutgoingCommandsUploadStrategyType,
         jsonDecoderType: JSONDecoderProtocol.Type) {
        
        self.networkTracker = networkTracker
        self.uploadStrategy = uploadStrategy
        jsonDecoderType.setupDecoders()
    }
    
    func start() {
        networkTracker.addListener(self)
    }
    
    func stop() {
        networkTracker.removeListener(self)
        uploadStrategy.cancelSubmission()
    }
    
    func networkStatusDidChange(_ isReachable: Bool) {
        guard isReachable else { return }
        uploadStrategy.restartSubmission()
    }
}
