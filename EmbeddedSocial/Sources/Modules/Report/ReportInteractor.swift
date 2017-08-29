//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class ReportInteractor: ReportInteractorInput {
    private let reportingService: ReportingServiceType
    
    init(reportingService: ReportingServiceType) {
        self.reportingService = reportingService
    }
    
    func reportReason(forIndexPath indexPath: IndexPath) -> ReportReason? {
        guard indexPath.row >= 0 && indexPath.row < ReportReason.orderedReasons.count else {
            return nil
        }
        return ReportReason.orderedReasons[indexPath.row]
    }
    
    func report(userID: String, reason: ReportReason, completion: @escaping (Result<Void>) -> Void) {
        reportingService.report(userID: userID, reason: reason, completion: completion)
    }
}
