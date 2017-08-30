//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol ReportingServiceType {
    func report(userID: String, reason: ReportReason, completion: @escaping (Result<Void>) -> Void)
}

final class ReportingService: BaseService, ReportingServiceType {
    
    func report(userID: String, reason: ReportReason, completion: @escaping (Result<Void>) -> Void) {
        let request = PostReportRequest()
        request.reason = PostReportRequest.Reason(rawValue: reason.rawValue)
        
        ReportingAPI.userReportsPostReport(
            userHandle: userID,
            postReportRequest: request,
            authorization: authorization) { response, error in
                if error == nil {
                    completion(.success())
                } else {
                    self.errorHandler.handle(error: error, completion: completion)
                }
        }
    }
}
