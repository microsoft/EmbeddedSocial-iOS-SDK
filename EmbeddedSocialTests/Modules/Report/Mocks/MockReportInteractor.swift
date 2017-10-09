//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

class MockReportInteractor: ReportInteractorInput {
    
    //MARK: - reportReason
    
    var reportReason_forIndexPath_Called = false
    var reportReason_forIndexPath_ReceivedIndexPath: IndexPath?
    var reportReason_forIndexPath_ReturnValue: ReportReason?
    
    func reportReason(forIndexPath indexPath: IndexPath) -> ReportReason? {
        reportReason_forIndexPath_Called = true
        reportReason_forIndexPath_ReceivedIndexPath = indexPath
        return reportReason_forIndexPath_ReturnValue
    }
    
    //MARK: - report
    
    var submitReport_with_completion_Called = false
    var submitReport_with_completion_ReceivedReason: ReportReason?
    var submitReport_with_completion_ReturnValue: Result<Void>?
    
    func submitReport(with reason: ReportReason, completion: @escaping (Result<Void>) -> Void) {
        submitReport_with_completion_Called = true
        submitReport_with_completion_ReceivedReason = reason
        if let result = submitReport_with_completion_ReturnValue {
            completion(result)
        }
    }
    
}
