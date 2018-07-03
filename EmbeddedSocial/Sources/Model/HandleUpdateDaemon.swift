//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class HandleUpdateDaemon: Daemon, Subscriber {
    
    private let multicast: HandleChangesMulticast
    private let predicateBuilder = PredicateBuilder()
    private let handleUpdater: HandleUpdater
    
    init(handleChangesMulticast: HandleChangesMulticast = HandleChangesMulticast.shared,
         handleUpdater: HandleUpdater = OutgoingCommandsHandleUpdater()) {
        
        multicast = handleChangesMulticast
        self.handleUpdater = handleUpdater
    }
    
    func start() {
        multicast.subscribe(self)
    }
    
    func stop() { }
    
    func update(_ hint: Hint) {
        guard let hint = hint as? HandleUpdateHint else { return }
        let p = predicateBuilder.predicate(handle: hint.oldHandle)
        handleUpdater.updateHandle(to: hint.newHandle, predicate: p)
    }
}
