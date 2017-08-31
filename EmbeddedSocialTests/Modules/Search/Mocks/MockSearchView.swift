//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

final class MockSearchView: SearchViewInput {
    private(set) var pageInfo: SearchPageInfo?
    private(set) var setupInitialStateCount = 0
    
    func setupInitialState(_ pageInfo: SearchPageInfo) {
        self.pageInfo = pageInfo
        setupInitialStateCount += 1
    }
    
    private(set) var showErrorCount = 0
    private(set) var showReportInputError: Error?
    
    func showError(_ error: Error) {
        showErrorCount += 1
        showReportInputError = error
    }
}
