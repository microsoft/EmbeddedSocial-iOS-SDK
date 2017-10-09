//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class ReportInteractor: ReportInteractorInput {
    private let api: ReportAPI

    init(api: ReportAPI) {
        self.api = api
    }
    
    func reportReason(forIndexPath indexPath: IndexPath) -> ReportReason? {
        guard indexPath.row >= 0 && indexPath.row < ReportReason.orderedReasons.count else {
            return nil
        }
        return ReportReason.orderedReasons[indexPath.row]
    }
    
    func submitReport(with reason: ReportReason, completion: @escaping (Result<Void>) -> Void) {
        api.submitReport(with: reason, completion: completion)
    }
}
