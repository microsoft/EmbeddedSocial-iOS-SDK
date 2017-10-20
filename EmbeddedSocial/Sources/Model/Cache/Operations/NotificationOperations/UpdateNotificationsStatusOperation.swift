//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class UpdateNotificationsStatusOperation: OutgoingCommandOperation {
    let command: UpdateNotificationsStatusCommand
    let notificationsService: ActivityNotificationsServiceProtocol
    
    init(command: UpdateNotificationsStatusCommand, notificationsService: ActivityNotificationsServiceProtocol) {
        self.command = command
        self.notificationsService = notificationsService
        super.init()
    }
    
    override func main() {
        guard !isCancelled else {
            return
        }
        
        notificationsService.updateStatus(for: command.handle) { [weak self] result in
            self?.completeOperation(with: result.error)
        }
    }
}
