//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class ReportReplyOperation: OutgoingCommandOperation {
    let reportService: ReportingServiceType
    let command: ReportReplyCommand
    
    required init(command: ReportReplyCommand, reportService: ReportingServiceType) {
        self.command = command
        self.reportService = reportService
    }
    
    override func main() {
        guard !isCancelled else {
            return
        }
        
        reportService.report(reply: command.reply, reason: command.reportReason) { (result) in
            self.completeOperation(with: result.error)
        }
    }
}
