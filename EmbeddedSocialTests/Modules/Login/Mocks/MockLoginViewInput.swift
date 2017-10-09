//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

final class MockLoginViewInput: LoginViewInput {
    var setupInitialStateCount = 0
    var showErrorCount = 0
    var isLoading: Bool?
    var addLeftNavigationCancelButtonCount = 0

    func setupInitialState() {
        setupInitialStateCount += 1
    }
    
    func showError(_ error: Error) {
        showErrorCount += 1
    }
    
    func setIsLoading(_ isLoading: Bool) {
        self.isLoading = isLoading
    }
    
    func addLeftNavigationCancelButton() {
        addLeftNavigationCancelButtonCount += 1
    }
}
