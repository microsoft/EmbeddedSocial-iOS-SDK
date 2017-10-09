//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

class MockReportView: ReportViewInput {
    
    //MARK: - setSubmitButtonEnabled
    
    var setSubmitButtonEnabled_Called = false
    var setSubmitButtonEnabled_ReceivedIsEnabled: Bool?
    
    func setSubmitButtonEnabled(_ isEnabled: Bool) {
        setSubmitButtonEnabled_Called = true
        setSubmitButtonEnabled_ReceivedIsEnabled = isEnabled
    }
    
    //MARK: - showError
    
    var showError_Called = false
    var showError_ReceivedError: Error?
    
    func showError(_ error: Error) {
        showError_Called = true
        showError_ReceivedError = error
    }
    
    //MARK: - setIsLoading
    
    var setIsLoading_Called = false
    var setIsLoading_ReceivedIsLoading: Bool?
    
    func setIsLoading(_ isLoading: Bool) {
        setIsLoading_Called = true
        setIsLoading_ReceivedIsLoading = isLoading
    }
    
    //MARK: - selectCheckmark
    
    var selectCheckmark_at_Called = false
    var selectCheckmark_at_ReceivedIndexPath: IndexPath?
    
    func selectCheckmark(at indexPath: IndexPath) {
        selectCheckmark_at_Called = true
        selectCheckmark_at_ReceivedIndexPath = indexPath
    }
    
    //MARK: - deselectCheckmark
    
    var deselectCheckmark_at_Called = false
    var deselectCheckmark_at_ReceivedIndexPath: IndexPath?
    
    func deselectCheckmark(at indexPath: IndexPath) {
        deselectCheckmark_at_Called = true
        deselectCheckmark_at_ReceivedIndexPath = indexPath
    }
    
}

