//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class ReportCommentOperation: OutgoingCommandOperation {
    let reportService: ReportingServiceType
    let command: ReportCommentCommand
    
    required init(command: ReportCommentCommand, reportService: ReportingServiceType) {
        self.command = command
        self.reportService = reportService
    }
    
    override func main() {
        guard !isCancelled else {
            return
        }
        
        reportService.report(comment: command.comment, reason: command.reportReason) { (result) in
            self.completeOperation(with: result.error)
        }
    }
}
