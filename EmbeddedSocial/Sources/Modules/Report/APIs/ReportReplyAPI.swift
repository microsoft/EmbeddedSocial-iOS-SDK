//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

struct ReportReplyAPI: ReportAPI {
    private let reportingService: ReportingServiceType
    private let reply: Reply
    
    init(reply: Reply, reportingService: ReportingServiceType) {
        self.reply = reply
        self.reportingService = reportingService
    }
    
    func submitReport(with reason: ReportReason, completion: @escaping (Result<Void>) -> Void) {
        reportingService.report(reply: reply, reason: reason, completion: completion)
    }
}
