//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

struct ReportPostAPI: ReportAPI {
    private let reportingService: ReportingServiceType
    private let postID: String
    
    init(postID: String, reportingService: ReportingServiceType) {
        self.postID = postID
        self.reportingService = reportingService
    }
    
    func submitReport(with reason: ReportReason, completion: @escaping (Result<Void>) -> Void) {
        reportingService.reportPost(postID: postID, reason: reason, completion: completion)
    }
}
