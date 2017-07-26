//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit
@testable import MSGP

final class MockCreateAccountViewController: UIViewController, CreateAccountViewInput {
    private(set) var setupInitialStateCount = 0
    private(set) var setUserCount = 0
    private(set) var showErrorCount = 0
    private(set) var setCreateAccountButtonEnabledCount = 0
    private(set) var setIsLoadingCount = 0
    
    private(set) var lastSetupInitialStateUser: SocialUser?
    private(set) var lastSetUser: SocialUser?
    private(set) var lastShownError: Error?
    private(set) var isCreateAccountButtonEnabled: Bool?
    private(set) var isLoading: Bool?
    
    func setupInitialState(with user: SocialUser) {
        setupInitialStateCount += 1
        lastSetupInitialStateUser = user
    }
    
    func setUser(_ user: SocialUser) {
        setUserCount += 1
        lastSetUser = user
    }
    
    func showError(_ error: Error) {
        showErrorCount += 1
        lastShownError = error
    }
    
    func setCreateAccountButtonEnabled(_ isEnabled: Bool) {
        setCreateAccountButtonEnabledCount += 1
        isCreateAccountButtonEnabled = isEnabled
    }
    
    func setIsLoading(_ isLoading: Bool) {
        setIsLoadingCount += 1
        self.isLoading = isLoading
    }
}
