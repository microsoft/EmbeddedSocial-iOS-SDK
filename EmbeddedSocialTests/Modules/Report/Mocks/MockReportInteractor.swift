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
    
    var report_userID_reason_completion_Called = false
    var report_userID_reason_completion_ReceivedArguments: (userID: String, reason: ReportReason)?
    var report_userID_reason_completion_ReturnValue: Result<Void>?
    
    func report(userID: String, reason: ReportReason, completion: @escaping (Result<Void>) -> Void) {
        report_userID_reason_completion_Called = true
        report_userID_reason_completion_ReceivedArguments = (userID: userID, reason: reason)
        if let result = report_userID_reason_completion_ReturnValue {
            completion(result)
        }
    }
    
}
