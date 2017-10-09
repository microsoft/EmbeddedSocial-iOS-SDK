//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

struct ReportCommentAPI: ReportAPI {
    private let reportingService: ReportingServiceType
    private let comment: Comment
    
    init(comment: Comment, reportingService: ReportingServiceType) {
        self.comment = comment
        self.reportingService = reportingService
    }
    
    func submitReport(with reason: ReportReason, completion: @escaping (Result<Void>) -> Void) {
        reportingService.report(comment: comment, reason: reason, completion: completion)
    }
}
