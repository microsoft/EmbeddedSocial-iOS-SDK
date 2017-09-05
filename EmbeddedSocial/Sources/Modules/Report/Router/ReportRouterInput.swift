//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol ReportRouterInput {
    func openReportSuccess(onDone: (() -> Void)?)
    
    func close()
    
    func openLogin()
}
