//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class UpdateRelatedHandleOperation: OutgoingCommandOperation {
    let command: UpdateRelatedHandleCommand
    private let handleUpdater: HandleUpdater
    
    init(command: UpdateRelatedHandleCommand,
         handleUpdater: HandleUpdater = OutgoingCommandsHandleUpdater()) {
        self.command = command
        self.handleUpdater = handleUpdater
        super.init()
    }
    
    override func main() {
        guard !isCancelled else {
            return
        }
        
        let p = PredicateBuilder().predicate(handle: command.oldHandle)
        handleUpdater.updateHandle(to: command.newHandle, predicate: p)
        completeOperation()
    }
}
