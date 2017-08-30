//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

final class MockReportingService: ReportingServiceType {
    var reportCount = 0
    var reportInputParameters: (userID: String, reason: ReportReason)?
    var reportReturnValue: Result<Void>?
    
    func report(userID: String, reason: ReportReason, completion: @escaping (Result<Void>) -> Void) {
        reportCount += 1
        reportInputParameters = (userID, reason)
        if let result = reportReturnValue {
            completion(result)
        }
    }
}
