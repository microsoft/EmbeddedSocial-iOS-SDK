//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

final class MockReportAPI: ReportAPI {
    private(set) var submitReportCount = 0
    var submitReportReceivedReason: ReportReason?
    var submitReportReturnValue: Result<Void>?
    
    func submitReport(with reason: ReportReason, completion: @escaping (Result<Void>) -> Void) {
        submitReportCount += 1
        submitReportReceivedReason = reason
        if let result = submitReportReturnValue {
            completion(result)
        }
    }
}
