//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class DaemonsController: Daemon {
    
    private lazy var daemons: [Daemon] = { [unowned self] in
        return [self.factory.makeOutgoingCacheDaemon(), self.factory.makeHandleUpdaterDaemon()]
    }()
    
    private let factory: DaemonsFactory
    
    init(factory: DaemonsFactory) {
        self.factory = factory
    }
    
    func start() {
        daemons.forEach { $0.start() }
    }
    
    func stop() {
        daemons.forEach { $0.stop() }
    }
}
