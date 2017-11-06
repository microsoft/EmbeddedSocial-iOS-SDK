//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class UpdateRelatedHandleOperation: OutgoingCommandOperation {
    let command: UpdateRelatedHandleCommand
    private let handleUpdater: RelatedHandleUpdater
    
    init(command: UpdateRelatedHandleCommand,
         handleUpdater: RelatedHandleUpdater = OutgoingCommandsRelatedHandleUpdater()) {
        self.command = command
        self.handleUpdater = handleUpdater
        super.init()
    }
    
    override func main() {
        guard !isCancelled else {
            return
        }
        
        let p = PredicateBuilder().predicate(relatedHandle: handle)
        handleUpdater.updateRelatedHandle(from: nil, to: handle, predicate: p)
        completeOperation()
    }
}
