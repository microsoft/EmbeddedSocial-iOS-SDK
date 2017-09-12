//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

struct ReportReplyAPI: ReportAPI {
    private let reportingService: ReportingServiceType
    private let replyID: String
    
    init(replyID: String, reportingService: ReportingServiceType) {
        self.replyID = replyID
        self.reportingService = reportingService
    }
    
    func submitReport(with reason: ReportReason, completion: @escaping (Result<Void>) -> Void) {
        reportingService.reportReply(replyID: replyID, reason: reason, completion: completion)
    }
}
