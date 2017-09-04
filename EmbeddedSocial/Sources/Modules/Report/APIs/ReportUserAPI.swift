//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

struct ReportUserAPI: ReportAPI {
    private let reportingService: ReportingServiceType
    private let userID: String
    
    init(userID: String, reportingService: ReportingServiceType) {
        self.userID = userID
        self.reportingService = reportingService
    }
    
    func submitReport(with reason: ReportReason, completion: @escaping (Result<Void>) -> Void) {
        reportingService.reportUser(userID: userID, reason: reason, completion: completion)
    }
}
