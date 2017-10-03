//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

class MockReportRouter: ReportRouterInput {
    
    //MARK: - openReportSuccess
    
    var openReportSuccess_onDone_Called = false
    var openReportSuccess_onDone_ReceivedOnDone: (() -> Void)?
    
    func openReportSuccess(onDone: (() -> Void)?) {
        openReportSuccess_onDone_Called = true
        openReportSuccess_onDone_ReceivedOnDone = onDone
    }
    
    //MARK: - close
    
    var close_Called = false
    
    func close() {
        close_Called = true
    }
    
    //MARK: - openLoginPopup

    var openLogin_Called = false

    func openLogin() {
        openLogin_Called = true
    }
}
