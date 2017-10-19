//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class ReportCommentOperation: CommentCommandOperation {
    let reportService: ReportingServiceType
    
    required init(command: ReportCommentCommand, reportService: ReportingServiceType) {
        self.reportService = reportService
        super.init(command: command)
    }
    
    override func main() {
        guard !isCancelled else {
            return
        }
        
        guard let command = command as? ReportCommentCommand else {
            completeOperation()
            return
        }
        
        reportService.report(comment: command.comment, reason: command.reportReason) { [weak self] result in
            self?.completeOperation(with: result.error)
        }
    }
}
