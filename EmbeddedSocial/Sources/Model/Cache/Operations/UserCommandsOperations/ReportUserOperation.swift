//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class ReportUserOperation: OutgoingCommandOperation {
    
    let service: ReportingServiceType
    let command: ReportUserCommand
    
    init(command: ReportUserCommand, service: ReportingServiceType) {
        self.service = service
        self.command = command
        super.init()
    }
    
    override func main() {
        guard !isCancelled else {
            return
        }
        
        service.reportUser(userID: command.user.uid, reason: command.reason) { [weak self] result in
            self?.completeOperation(with: result.error)
        }
    }
}
