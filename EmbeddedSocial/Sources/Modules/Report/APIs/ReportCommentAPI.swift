//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

struct ReportCommentAPI: ReportAPI {
    private let reportingService: ReportingServiceType
    private let commentID: String
    
    init(commentID: String, reportingService: ReportingServiceType) {
        self.commentID = commentID
        self.reportingService = reportingService
    }
    
    func submitReport(with reason: ReportReason, completion: @escaping (Result<Void>) -> Void) {
        reportingService.reportComment(commentID: commentID, reason: reason, completion: completion)
    }
}
