//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class ReportReplyOperation: ReplyCommandOperation {
    private let reportService: ReportingServiceType
    
    required init(command: ReportReplyCommand, reportService: ReportingServiceType) {
        self.reportService = reportService
        super.init(command: command)
    }
    
    override func main() {
        guard !isCancelled else {
            return
        }
        
        guard let command = command as? ReportReplyCommand else {
            completeOperation()
            return
        }
        
        reportService.report(reply: command.reply, reason: command.reportReason) { [weak self] result in
            self?.completeOperation(with: result.error)
        }
    }
}
