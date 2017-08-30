//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol ReportInteractorInput: class {
    func reportReason(forIndexPath indexPath: IndexPath) -> ReportReason?
    
    func report(userID: String, reason: ReportReason, completion: @escaping (Result<Void>) -> Void)
}
